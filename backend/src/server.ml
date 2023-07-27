open Core
open Async_kernel
module Server = Cohttp_async.Server

let stock_data () =
  Web_scraper.fetch_exn
    ~url:
      "https://finance.yahoo.com/screener/predefined/aggressive_small_caps/"
  |> Parse_to_stock.parse_to_stock
  |> List.map ~f:(fun stock -> Collect_company_info.update_stock_info stock)
  |> [%to_yojson: Stock.Stock.t list]
  |> Yojson.Safe.to_string
;;

(* given filename: hello_world.ml compile with: $ corebuild
   hello_world.native -pkg cohttp.async *)

let handler ~body:_ _sock req =
  let uri = Cohttp.Request.uri req in
  match Uri.path uri with
  | "/stock-data" -> Server.respond_string (stock_data ())
  (* | "/test" -> Uri.get_query_param uri "hello" |> Option.map ~f:(fun v ->
     "hello " ^ v) |> Option.value ~default:"No param hello supplied" |>
     Server.respond_string *)
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

(* let () = let module Command = Async_command in Command.async_spec
   ~summary:"Start a small_cap_prototype server" Command.Spec.( empty +> flag
   "-p" (optional_with_default 8080 int) ~doc:"int Source port to listen on")
   start_server |> Command_unix.run ;; *)
