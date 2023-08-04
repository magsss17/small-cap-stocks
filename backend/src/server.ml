open Core
open Async_kernel
module Server = Cohttp_async.Server

let fetch_small_cap_stocks () =
  let%bind stocks = Fetcher.fetch_small_cap_list () in
  let%bind _ = Database.save_data (Portfolio.Portfolio.of_list stocks) in
  Core.print_endline "Fetched small cap stocks";
  return (Portfolio.Portfolio.of_list stocks)
;;

let fetch_portfolio () =
  let%bind () = Database.maybe_init_db () in 
  let%bind portfolio = Database.load_data () in
  if List.length portfolio.stocks > 0
  then return portfolio
  else fetch_small_cap_stocks ()
;;

let handler ~body:_ _sock req =
  let uri = Cohttp.Request.uri req in
  let headers = Cohttp.Header.init_with "Access-Control-Allow-Origin" "*" in
  let%bind portfolio = fetch_portfolio () in
  let%bind data =
    match Uri.path uri with
    | "/stock" ->
      Core.print_endline "( /stock )";
      Uri.get_query_param uri "symbol"
      |> Option.value_map
           ~default:(return "Stock not found")
           ~f:(fun symbol ->
           Core.print_s [%message (symbol : string)];
           Portfolio.Portfolio.get_stock portfolio symbol
           |> Option.value_map
                ~default:(return "Stock not found")
                ~f:(fun stock ->
                let%bind updated_stock = Fetcher.fetch_stock stock in
                let%bind updated_stock =
                  Fetcher.fetch_stock_financials updated_stock
                in
                return
                  (Yojson.Safe.to_string
                     ([%to_yojson: Stock.Stock.t] updated_stock))))
    | "/stocks" ->
      Core.print_endline "( /stocks )";
      return
        (Yojson.Safe.to_string
           ([%to_yojson: Stock.Stock.t list]
              (Portfolio.Portfolio.sort_by_growth portfolio)))
    | _ -> return "Route not found"
  in
  Server.respond_string ~headers data
;;

let start_server port () =
  Stdlib.Printf.eprintf "Listening for HTTP on port %d\n" port;
  Server.create
    ~on_handler_error:`Raise
    (Async.Tcp.Where_to_listen.of_port port)
    handler
  >>= fun _ ->
  Deferred.forever () (fun () ->
    after Time_ns.Span.(of_sec 0.5) >>| fun () -> ());
  Deferred.never ()
;;

let command =
  let module Command = Async_command in
  Command.async_spec
    ~summary:"Start a small_cap_prototype server"
    Command.Spec.(
      empty
      +> flag
           "-p"
           (optional_with_default 8080 int)
           ~doc:"int Source port to listen on")
    start_server
;;
