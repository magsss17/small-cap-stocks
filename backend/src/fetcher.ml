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

let fetch_stock (company : Stock.t) : Stock.t Deferred.t =
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

let fetch_small_cap_list () =
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
          let symbol_option, name_option, price_option, growth_option =
            ( List.nth stock 0
            , List.nth stock 1
            , List.nth stock 2
            , List.nth stock 4 )
          in
          match symbol_option, name_option, price_option, growth_option with
          | Some symbol, Some name, Some price_string, Some growth_string ->
            let price = Float.of_string price_string in
            let growth =
              Float.of_string
                (String.sub
                   growth_string
                   ~pos:1
                   ~len:(String.length growth_string - 2))
            in
            Some (Stock.create_stock ~symbol ~name ~price ~growth ())
          | _ -> None))
;;

let tup_stock =
  Stock.create_stock ~symbol:"TUP" ~name:"" ~price:0.0 ~growth:0.0 ()
;;

let non_existent_stock =
  Stock.create_stock ~symbol:"" ~name:"" ~price:0.0 ~growth:0.0 ()
;;

(* Below fetch test should expect Stock.t  list 
   but is omitted as a different Stock.t list would be fetched
   at almost every request when market is open.
  *)
let%expect_test "fetch small cap stocks" =
  let%bind _ = fetch_small_cap_list () in
  (* print_s [%sexp (stocks : Stock.t list)]; *)
  return ()
;;

let%expect_test "fetch tupperware stock" =
  let%bind updated_tup_stock = fetch_stock tup_stock in
  print_s [%sexp (updated_tup_stock : Stock.t)];
  [%expect
    {|
    ((symbol TUP) (name "Tupperware Brands Corporation (TUP)") (price 0)
     (growth 0) (sector "Consumer Cyclical") (industry "Packaging & Containers")
     (summary
      "Tupperware Brands Corporation operates as a consumer products company worldwide. The company manufactures, markets, and sells design-centric preparation, storage, and serving solutions for the kitchen and home, as well as a line of cookware, knives, microwave products, microfiber textiles, water-filtration related items, and an array of products for on-the-go consumers under the Tupperware brand name. It distributes its products to approximately 70 countries primarily through independent sales force members, including independent distributors, directors, managers, and dealers. The company was formerly known as Tupperware Corporation and changed its name to Tupperware Brands Corporation in December 2005. Tupperware Brands Corporation was founded in 1946 and is headquartered in Orlando, Florida.")
     (headlines ("")) (profit_margin 0) (gross_profit "") (diluted_eps 0)) |}];
  return ()
;;

let%expect_test "fetch tupperware stock financials" =
  let%bind updated_tup_stock = fetch_stock_financials tup_stock in
  print_s [%sexp (updated_tup_stock : Stock.t)];
  [%expect
    {|
    ((symbol TUP) (name "Tupperware Brands Corporation (TUP)") (price 0)
     (growth 0) (sector "Consumer Cyclical") (industry "Packaging & Containers")
     (summary
      "Tupperware Brands Corporation operates as a consumer products company worldwide. The company manufactures, markets, and sells design-centric preparation, storage, and serving solutions for the kitchen and home, as well as a line of cookware, knives, microwave products, microfiber textiles, water-filtration related items, and an array of products for on-the-go consumers under the Tupperware brand name. It distributes its products to approximately 70 countries primarily through independent sales force members, including independent distributors, directors, managers, and dealers. The company was formerly known as Tupperware Corporation and changed its name to Tupperware Brands Corporation in December 2005. Tupperware Brands Corporation was founded in 1946 and is headquartered in Orlando, Florida.")
     (headlines ("")) (profit_margin -1) (gross_profit 836.4M)
     (diluted_eps -0.52)) |}];
  return ()
;;

let%expect_test "fetch non-existent stock" =
  let%bind updated_non_existent_stock = fetch_stock non_existent_stock in
  print_s [%sexp (updated_non_existent_stock : Stock.t)];
  [%expect
    {|
    ((symbol "") (name "") (price 0) (growth 0) (sector "") (industry "")
     (summary "") (headlines ("")) (profit_margin 0) (gross_profit "")
     (diluted_eps 0)) |}];
  return ()
;;

let%expect_test "fetch non-existent stock financials" =
  let%bind updated_non_existent_stock_financials =
    fetch_stock non_existent_stock
  in
  print_s [%sexp (updated_non_existent_stock_financials : Stock.t)];
  [%expect
    {|
    ((symbol "") (name "") (price 0) (growth 0) (sector "") (industry "")
     (summary "") (headlines ("")) (profit_margin 0) (gross_profit "")
     (diluted_eps 0)) |}];
  return ()
;;
