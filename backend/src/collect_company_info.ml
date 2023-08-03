open Core
open Async
open Stock
open Soup

let fetch_stock_financials (company : Stock.t) =
  let%map contents =
    Web_scraper.fetch_exn
      ~url:
        ("https://finance.yahoo.com/quote/"
         ^ company.symbol
         ^ "/key-statistics?p="
         ^ company.symbol)
  in
  let profit_margin_option, gross_profit_option, diluted_eps_option =
    parse contents
    $$ "td[class]"
    |> to_list
    |> List.filter_map ~f:(fun td ->
         match R.attribute "class" td with
         | "Fw(500) Ta(end) Pstart(10px) Miw(60px)" ->
           Some (texts td |> String.concat ~sep:"" |> String.strip)
         | _ -> None)
    |> fun data -> List.nth data 31, List.nth data 38, List.nth data 41
  in
  (match profit_margin_option with
   | Some profit_margin ->
     Stock.update_profit_margin
       company
       ~profit_margin:
         (Float.of_string
            (String.sub
               profit_margin
               ~pos:0
               ~len:(String.length profit_margin - 2)))
   | None -> ());
  (match gross_profit_option with
   | Some gross_profit -> Stock.update_gross_profit company ~gross_profit
   | None -> ());
  (match diluted_eps_option with
   | Some diluted_eps ->
     Stock.update_diluted_eps
       company
       ~diluted_eps:(Float.of_string diluted_eps)
   | None -> ());
  company
;;

let fetch_stock_descriptions (company : Stock.t) : Stock.t Deferred.t =
  let%map contents =
    Web_scraper.fetch_exn
      ~url:
        ("https://finance.yahoo.com/quote/"
         ^ company.symbol
         ^ "/profile?p="
         ^ company.symbol)
  in
  let name_option =
    parse contents
    $$ "h1[class]"
    |> to_list
    |> List.filter_map ~f:(fun p ->
         match R.attribute "class" p with
         | "D(ib) Fz(18px)" ->
           Some (texts p |> String.concat ~sep:"" |> String.strip)
         | _ -> None)
    |> List.hd
  in
  (match name_option with
   | Some name -> Stock.update_name company ~name
   | None -> ());
  let price_option, growth_option =
    parse contents
    $$ "span[class]"
    |> to_list
    |> List.filter_map ~f:(fun span ->
         match R.attribute "class" span with
         | "e3b14781" ->
           Some (texts span |> String.concat ~sep:"" |> String.strip)
         | _ -> None)
    |> fun elements -> List.nth elements 0, List.nth elements 2
  in
  (match price_option, growth_option with
   | Some price, Some growth ->
     Stock.update_price company ~price:(Float.of_string price);
     Stock.update_growth
       company
       ~growth:
         (Float.of_string
            (String.sub growth ~pos:2 ~len:(String.length growth - 3)))
   | Some price, None ->
     Stock.update_price company ~price:(Float.of_string price)
   | None, Some growth ->
     Stock.update_growth
       company
       ~growth:
         (Float.of_string
            (String.sub growth ~pos:2 ~len:(String.length growth - 3)))
   | None, None -> ());
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
    |> List.filter_map ~f:(fun p ->
         match R.attribute "class" p with
         | "Mt(15px) Lh(1.6)" ->
           Some (texts p |> String.concat ~sep:"" |> String.strip)
         | _ -> None)
    |> List.hd
  in
  (match summary_option with
   | Some summary -> Stock.update_summary company ~summary
   | None -> ());
  company
;;
