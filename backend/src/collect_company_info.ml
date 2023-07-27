open Core
open Stock

let update_stock_info (company : Stock.t) : Stock.t =
  let contents =
    Web_scraper.fetch_exn
      ~url:
        ("https://finance.yahoo.com/quote/"
         ^ company.symbol
         ^ "/profile?p="
         ^ company.symbol)
  in
  let open Soup in
  let sector_option, industry_option =
    parse contents
    $$ "p[class] > span"
    |> to_list
    |> List.concat_map ~f:(fun span -> texts span)
    |> fun data -> List.nth data 1, List.nth data 3
  in
  (match sector_option, industry_option with
   | Some sector, Some industry ->
     Stock.update_sector company ~sector;
     Stock.update_industry company ~industry
   | Some sector, None -> Stock.update_sector company ~sector
   | None, Some industry -> Stock.update_industry company ~industry
   | None, None -> ());
  let summary_option =
    parse contents
    $$ "p[class]"
    |> to_list
    |> List.filter ~f:(fun p ->
         String.equal (R.attribute "class" p) "Mt(15px) Lh(1.6)")
    |> List.map ~f:(fun p ->
         texts p |> String.concat ~sep:"" |> String.strip)
    |> List.hd
  in
  (match summary_option with
   | Some summary -> Stock.update_summary company ~summary
   | None -> ());
  company
;;
