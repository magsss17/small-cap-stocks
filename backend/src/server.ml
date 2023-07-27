open Core
open Async_kernel
module Server = Cohttp_async.Server

let stock_data () =
  Web_scraper.fetch_exn
    ~url:
      "https://ca.finance.yahoo.com/screener/predefined/small_cap_gainers/?count=100"
  |> Parse_to_stock.parse_to_stock
  |> List.map ~f:(fun stock -> Collect_company_info.update_stock_info stock)
  |> Portfolio.Portfolio.of_list
;;

(* given filename: hello_world.ml compile with: $ corebuild
   hello_world.native -pkg cohttp.async *)

let handler ~body:_ _sock req =
  let uri = Cohttp.Request.uri req in
  let portfolio = stock_data () in
  match Uri.path uri with
  | "/stock-filter-symbol" ->
    let data =
      Portfolio.Portfolio.sort_by_symbol portfolio
      |> [%to_yojson: Stock.Stock.t list]
      |> Yojson.Safe.to_string
    in
    Server.respond_string data
  (* | "/test" -> Uri.get_query_param uri "hello" |> Option.map ~f:(fun v ->
     "hello " ^ v) |> Option.value ~default:"No param hello supplied" |>
     Server.respond_string *)
  | "/stock-filter-growth" ->
    let data =
      Portfolio.Portfolio.sort_by_growth portfolio
      |> [%to_yojson: Stock.Stock.t list]
      |> Yojson.Safe.to_string
    in
    Server.respond_string data
  | "/stock-filter-name" ->
    let data =
      Portfolio.Portfolio.sort_by_name portfolio
      |> [%to_yojson: Stock.Stock.t list]
      |> Yojson.Safe.to_string
    in
    Server.respond_string data
  | "/stock-filter-sector" ->
    let data =
      Portfolio.Portfolio.sort_by_sector portfolio
      |> [%to_yojson: Stock.Stock.t list]
      |> Yojson.Safe.to_string
    in
    Server.respond_string data
  | "/stock-filter-price" ->
    let data =
      Portfolio.Portfolio.sort_by_price portfolio
      |> [%to_yojson: Stock.Stock.t list]
      |> Yojson.Safe.to_string
    in
    Server.respond_string data
  | _ -> Server.respond_string ~status:`Not_found "Route not found"
;;

let start_server port () =
  Stdlib.Printf.eprintf "Listening for HTTP on port %d\n" port;
  Stdlib.Printf.eprintf "http://localhost:%d" port;
  Server.create
    ~on_handler_error:`Raise
    (Async.Tcp.Where_to_listen.of_port port)
    handler
  >>= fun _ ->
  Deferred.forever () (fun () ->
    after Time_ns.Span.(of_sec 0.5) >>| fun () -> ());
  Deferred.never ()
;;

let _ =
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
