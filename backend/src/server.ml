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
         (* Core.print_s [%message "started" (stock : Stock.Stock.t)]; *)
         let%bind response =
           (* Core.print_s [%message "started" (stock : Stock.Stock.t)]; *)
           Collect_company_info.update_stock_info stock
         in
         (* Core.print_s [%message "finished" (stock : Stock.Stock.t)]; *)
         return response)
  in
  return
    (Yojson.Safe.to_string ([%to_yojson: Stock.Stock.t list] updated_stocks))
;;

let handler ~body:_ _sock req =
  let uri = Cohttp.Request.uri req in
  match Uri.path uri with
  | "/stock-data" ->
    Core.print_s [%message ("stock-data-fetch": string)];
    let%bind stock_data = stock_data () in
    let headers = Cohttp.Header.init_with "Access-Control-Allow-Origin" "*" in
    Server.respond_string ~headers stock_data
  (* | "/test" -> Uri.get_query_param uri "hello" |> Option.map ~f:(fun v ->
     "hello " ^ v) |> Option.value ~default:"No param hello supplied" |>
     Server.respond_string *)
  | _ -> Server.respond_string ~status:`Not_found "Route not found"
;;


let start_server port () =
  Stdlib.Printf.eprintf "Listening for HTTP on port %d\n" port;
  Stdlib.Printf.eprintf
    "Try 'curl http://localhost:%d/test?hello=xyz'\n%!"
    port;
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
