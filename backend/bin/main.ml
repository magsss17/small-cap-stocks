open! Core
open Small_cap_prototype

(* let () = Web_scraper.fetch_exn ~url:
   "https://finance.yahoo.com/screener/predefined/aggressive_small_caps/" |>
   Parse_to_stock.parse_to_stock |> List.map ~f:(fun stock ->
   Collect_company_info.update_stock_info stock) |> List.iter ~f:(fun stock
   -> Core.print_s [%message (stock : Stock.Stock.t)]) ;; *)

let () = let _ = Server.start_server 8080 () in ();
