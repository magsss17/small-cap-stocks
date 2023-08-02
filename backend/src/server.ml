open Core
open Async_kernel
module Server = Cohttp_async.Server

let fetch_stock_data () =
  let%bind contents =
    Web_scraper.fetch_exn
      ~url:
        "https://finance.yahoo.com/screener/predefined/small_cap_gainers?offset=0&count=100"
  in
  let%bind updated_stocks =
    return (Parse_to_stock.parse_to_stock contents)
  in
  return (Portfolio.Portfolio.of_list updated_stocks)
;;

let fetch_stock_details stock = Collect_company_info.update_stock_info stock

let handler ~body:_ _sock req =
  let uri = Cohttp.Request.uri req in
  let headers = Cohttp.Header.init_with "Access-Control-Allow-Origin" "*" in
  let%bind portfolio = fetch_stock_data () in
  let%bind data =
    match Uri.path uri with
    | "/stock" ->
      Core.print_s [%message ("stock": string)];
      Uri.get_query_param uri "symbol"
      |> fun s -> (match s with | None -> "TUP" | Some stock -> stock)
      |> fun s -> Core.print_endline s; s
      |> Portfolio.Portfolio.get_stock portfolio
      |> fun s -> Core.print_s [%message (s: Stock.Stock.t option)]; s
      |> fun s -> (match s with | None -> List.nth_exn (Portfolio.Portfolio.stocks portfolio) 0 | Some stock -> stock)
      |> fun stock -> 
      return (Yojson.Safe.to_string
        ([%to_yojson: Stock.Stock.t] stock))
    | "/stock-filter-name" ->
      Core.print_s [%message ("stock-filter-name" : string)];
      return (Yojson.Safe.to_string
        ([%to_yojson: Stock.Stock.t list]
           (Portfolio.Portfolio.sort_by_name portfolio)))
    | "/stock-filter-growth" ->
      Core.print_s [%message ("stock-filter-growth" : string)];
      return (Yojson.Safe.to_string
        ([%to_yojson: Stock.Stock.t list]
           (Portfolio.Portfolio.sort_by_growth portfolio)))
    | "/stock-filter-price" ->
      Core.print_s [%message ("stock-filter-price" : string)];
      return (Yojson.Safe.to_string
        ([%to_yojson: Stock.Stock.t list]
           (Portfolio.Portfolio.sort_by_price portfolio)))
    | "/stock-filter-sector" ->
      Core.print_s [%message ("stock-filter-sector" : string)];
      return (Yojson.Safe.to_string
        ([%to_yojson: Stock.Stock.t list]
           (Portfolio.Portfolio.sort_by_sector portfolio)))
    | "/stock-filter-industry" ->
      Core.print_s [%message ("stock-filter-industry" : string)];
      return (Yojson.Safe.to_string
        ([%to_yojson: Stock.Stock.t list]
           (Portfolio.Portfolio.sort_by_industry portfolio)))
    | "/stock-filter-symbol" ->
      Core.print_s [%message ("stock-filter-symbol" : string)];
      return (Yojson.Safe.to_string
        ([%to_yojson: Stock.Stock.t list]
           (Portfolio.Portfolio.sort_by_symbol portfolio)))
    | "/stock-details" ->
      Core.print_s [%message ("stock-details" : string)];
      Uri.get_query_param uri "symbol"
      |> fun s -> (match s with | None -> "TUP" | Some stock -> stock)
      |> Portfolio.Portfolio.get_stock portfolio
      |> fun s -> (match s with | None -> List.nth_exn (Portfolio.Portfolio.stocks portfolio) 0 | Some stock -> stock)
      |> fun stock ->
      let%bind updated_stock = fetch_stock_details stock in
      return (Yojson.Safe.to_string ([%to_yojson: Stock.Stock.t] updated_stock))
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
