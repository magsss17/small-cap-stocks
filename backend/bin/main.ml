open! Core
open Small_cap_stocks

(* let () = Web_scraper.fetch_exn ~url:
   "https://finance.yahoo.com/screener/predefined/aggressive_small_caps/" |>
   Parse_to_stock.parse_to_stock |> List.map ~f:(fun stock ->
   Collect_company_info.update_stock_info stock) |> List.iter ~f:(fun stock
   -> Core.print_s [%message (stock : Stock.Stock.t)]) ;; *)

let () =
  let module Command = Async_command in
  Command.async
    ~summary:"Start a small_cap_prototype server"
    (let%map_open.Command port =
       flag
         "-p"
         (optional_with_default 8080 int)
         ~doc:"int Source port to listen on"
     in
     Server.start_server port)
  |> Command_unix.run
;;
