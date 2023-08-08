open Core
open Async_kernel
module Server = Cohttp_async.Server

let portfolio : Database.t option ref = ref None

let fetch_small_cap_stocks () =
  Core.print_endline "Fetched small cap stocks";
  let%bind stocks = Fetcher.fetch_small_cap_list () in
  match !portfolio with
  | None -> return (Portfolio.Portfolio.of_list stocks)
  | Some portfolio ->
  List.iter stocks ~f: (fun stock -> Portfolio.Portfolio.update_portfolio portfolio stock);
  return portfolio
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
  let%bind data =
    match Uri.path uri with
    | "/stock" ->
      Core.print_endline "( /stock )";
      Uri.get_query_param uri "symbol"
      |> Option.value_map
           ~default:(return "Symbol not found")
           ~f:(fun symbol ->
           match !portfolio with
           | None -> return "Portfolio not found"
           | Some portfolio ->
             Portfolio.Portfolio.get_stock portfolio symbol
             |> Option.value_map
                  ~default:(
                    let stock = Stock.Stock.create_stock
                    ~symbol
                    ~name:""
                    ~price:0.0
                    ~growth:0.0
                    () in
                    let%bind stock = Fetcher.fetch_stock stock in 
                    let%bind stock = Fetcher.fetch_stock_financials stock in
                    return
                      (Yojson.Safe.to_string
                         ([%to_yojson: Stock.Stock.t] stock))
                  )
                  ~f:(fun stock ->
                  if String.equal (Stock.Stock.get_industry stock) ""
                  then (
                    let%bind updated_stock = Fetcher.fetch_stock stock in
                    let%bind updated_stock =
                      Fetcher.fetch_stock_financials updated_stock
                    in
                    Portfolio.Portfolio.update_portfolio
                      portfolio
                      updated_stock;
                    let%bind _ = Database.save_data portfolio in
                    return
                      (Yojson.Safe.to_string
                         ([%to_yojson: Stock.Stock.t] updated_stock)))
                  else
                    return
                      (Yojson.Safe.to_string
                         ([%to_yojson: Stock.Stock.t] stock))))
    | "/stocks" ->
      Core.print_endline "( /stocks )";
      (match !portfolio with
       | None -> return "Portfolio not found"
       | Some portfolio ->
         let update_option = Uri.get_query_param uri "update-prices" in
         (match update_option with
          | Some "true" ->
            Core.print_endline "Updating stock prices";
            let%bind portfolio = fetch_small_cap_stocks () in
            let%bind _ = Database.save_data portfolio in
            return
              (Yojson.Safe.to_string
                 ([%to_yojson: Stock.Stock.t list]
                    (Portfolio.Portfolio.sort_by_growth portfolio)))
          | _ ->
            let%bind _ = Database.save_data portfolio in
            return
              (Yojson.Safe.to_string
                 ([%to_yojson: Stock.Stock.t list]
                    (Portfolio.Portfolio.sort_by_growth portfolio)))))
    | "/" | _ -> return "Route not found"
  in
  Server.respond_string ~headers data
;;

let start_server port () =
  Stdlib.Printf.eprintf "Listening for HTTP on port %d\n" port;
  let%bind temp_portfolio = fetch_portfolio () in
  portfolio := Some temp_portfolio;
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
