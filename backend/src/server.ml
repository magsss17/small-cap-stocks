open Core
open Async_kernel
module Server = Cohttp_async.Server

let stock_data () =
  let%bind contents =
    Web_scraper.fetch_exn
      ~url:
        "https://finance.yahoo.com/screener/predefined/aggressive_small_caps/"
  in
  let%bind updated_stocks =
    Parse_to_stock.parse_to_stock contents
    |> Deferred.List.map ~how:`Parallel ~f:(fun stock ->
         Core.print_s [%message "started" (stock : Stock.Stock.t)];
         let%bind response =
           Core.print_s [%message "started" (stock : Stock.Stock.t)];
           Collect_company_info.update_stock_info stock
         in
         Core.print_s [%message "finished" (stock : Stock.Stock.t)];
         return response)
  in
  return (Portfolio.Portfolio.of_list updated_stocks)
;;

let handler ~body:_ _sock req =
  let uri = Cohttp.Request.uri req in
  let headers = Cohttp.Header.init_with "Access-Control-Allow-Origin" "*" in
  let%bind portfolio = stock_data () in
  let data =
    match Uri.path uri with
    | "/stock-filter-name" ->
      Core.print_s [%message ("stock-filter-name" : string)];
      Yojson.Safe.to_string
        ([%to_yojson: Stock.Stock.t list]
           (Portfolio.Portfolio.sort_by_name portfolio))
    | "/stock-filter-growth" ->
      Core.print_s [%message ("stock-filter-growth" : string)];
      Yojson.Safe.to_string
        ([%to_yojson: Stock.Stock.t list]
           (Portfolio.Portfolio.sort_by_growth portfolio))
    | "/stock-filter-price" ->
      Core.print_s [%message ("stock-filter-price" : string)];
      Yojson.Safe.to_string
        ([%to_yojson: Stock.Stock.t list]
           (Portfolio.Portfolio.sort_by_price portfolio))
    | "/stock-filter-sector" ->
      Core.print_s [%message ("stock-filter-sector" : string)];
      Yojson.Safe.to_string
        ([%to_yojson: Stock.Stock.t list]
           (Portfolio.Portfolio.sort_by_sector portfolio))
    | "/stock-filter-industry" ->
      Core.print_s [%message ("stock-filter-industry" : string)];
      Yojson.Safe.to_string
        ([%to_yojson: Stock.Stock.t list]
           (Portfolio.Portfolio.sort_by_industry portfolio))
    | "/stock-filter-symbol" ->
      Core.print_s [%message ("stock-filter-symbol" : string)];
      Yojson.Safe.to_string
        ([%to_yojson: Stock.Stock.t list]
           (Portfolio.Portfolio.sort_by_symbol portfolio))
    | _ -> "Route not found"
  in
  Server.respond_string ~headers data
;;

let start_server port () =
  Stdlib.Printf.eprintf "Listening for HTTP on port %d\n" port;
  Stdlib.Printf.eprintf " http://localhost:%d " port;
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
