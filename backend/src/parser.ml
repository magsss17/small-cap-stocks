open Core
open Async
open Stock
open Soup

let parse_stock_financials (company : Stock.t) =
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
  Option.iter profit_margin_option ~f:(fun profit_margin_string ->
    let profit_margin =
      Float.of_string
        (String.sub
           profit_margin_string
           ~pos:0
           ~len:(String.length profit_margin_string - 2))
    in
    Stock.update_profit_margin company ~profit_margin);
  Option.iter gross_profit_option ~f:(fun gross_profit ->
    Stock.update_gross_profit company ~gross_profit);
  Option.iter diluted_eps_option ~f:(fun diluted_eps_string ->
    let diluted_eps = Float.of_string diluted_eps_string in
    Stock.update_diluted_eps company ~diluted_eps);
  company
;;

let parse_stock (company : Stock.t) : Stock.t Deferred.t =
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
  Option.iter name_option ~f:(fun name -> Stock.update_name company ~name);
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
  Option.iter price_option ~f:(fun price_string ->
    let price = Float.of_string price_string in
    Stock.update_price company ~price);
  Option.iter growth_option ~f:(fun growth_string ->
    let growth =
      Float.of_string
        (String.sub
           growth_string
           ~pos:2
           ~len:(String.length growth_string - 3))
    in
    Stock.update_growth company ~growth);
  let sector_option, industry_option =
    parse contents
    $$ "p[class] > span"
    |> to_list
    |> List.concat_map ~f:(fun span -> texts span)
    |> fun data -> List.nth data 1, List.nth data 3
  in
  Option.iter sector_option ~f:(fun sector ->
    Stock.update_sector company ~sector);
  Option.iter industry_option ~f:(fun industry ->
    Stock.update_industry company ~industry);
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
  Option.iter summary_option ~f:(fun summary ->
    Stock.update_summary company ~summary);
  company
;;

let parse_small_cap_list () =
  let%bind contents =
    Web_scraper.fetch_exn
      ~url:
        "https://finance.yahoo.com/screener/predefined/small_cap_gainers?offset=0&count=100"
  in
  return
    (parse contents
     $$ "tr[class]"
     |> to_list
     |> List.map ~f:(fun data -> texts data)
     |> List.tl_exn
     |> List.filter_map ~f:(fun stock ->
          let symbol, name, price, growth =
            ( List.nth stock 0
            , List.nth stock 1
            , List.nth stock 2
            , List.nth stock 4 )
          in
          match symbol, name, price, growth with
          | Some symbol', Some name', Some price', Some growth' ->
            Some
              (Stock.create_stock
                 ~symbol:symbol'
                 ~name:name'
                 ~price:(Float.of_string price')
                 ~growth:
                   (Float.of_string
                      (String.sub
                         growth'
                         ~pos:1
                         ~len:(String.length growth' - 2)))
                 ())
          | _ -> None))
;;
