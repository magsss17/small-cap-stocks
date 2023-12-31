open Core
open Stock

module Portfolio = struct
  type t = { mutable stocks : Stock.t list } [@@deriving sexp, fields, yojson]

  let get_stock t (symbol : string) : Stock.t option =
    List.find t.stocks ~f:(fun stock -> String.equal stock.symbol symbol)
  ;;

  let of_list (stocks : Stock.t list) = { stocks }

  let update_portfolio t stock = 
    let outdated_stock_option = List.find t.stocks ~f: (fun old_stock -> String.equal (Stock.symbol old_stock) (Stock.symbol stock)) in
    match outdated_stock_option with | None -> (
      t.stocks <- t.stocks @ [stock]
    ) | Some outdated_stock -> (
      if String.length outdated_stock.industry <> 0 then Stock.update_industry stock ~industry: outdated_stock.industry;
      if String.length outdated_stock.sector <> 0 then Stock.update_sector stock ~sector: outdated_stock.sector;
      if String.length outdated_stock.summary <> 0 then Stock.update_summary stock ~summary: outdated_stock.summary;
      if String.length outdated_stock.gross_profit <> 0 then Stock.update_gross_profit stock ~gross_profit: outdated_stock.gross_profit;
      if Float.equal stock.diluted_eps 0.0 then Stock.update_diluted_eps stock ~diluted_eps: outdated_stock.diluted_eps; 
      if Float.equal stock.growth 0.0 then Stock.update_growth stock ~growth: outdated_stock.growth;
      if Float.equal stock.profit_margin 0.0 then Stock.update_profit_margin stock ~profit_margin: outdated_stock.profit_margin;
    );
    t.stocks <- List.map t.stocks ~f: (fun tstock -> (
      if String.equal (Stock.symbol stock) (Stock.symbol tstock) then stock else tstock
    ));
  ;;

  let sort_by_name t =
    List.sort t.stocks ~compare:(fun stock1 stock2 ->
      String.compare
        (String.capitalize stock1.name)
        (String.capitalize stock2.name))
  ;;

  let sort_by_symbol t =
    List.sort t.stocks ~compare:(fun stock1 stock2 ->
      String.compare
        (String.capitalize stock1.symbol)
        (String.capitalize stock2.symbol))
  ;;

  let sort_by_growth t =
    List.sort t.stocks ~compare:(fun stock1 stock2 ->
      -1 * Float.compare stock1.growth stock2.growth)
  ;;

  let sort_by_price t =
    List.sort t.stocks ~compare:(fun stock1 stock2 ->
      -1 * Float.compare stock1.price stock2.price)
  ;;

  let sort_by_sector t =
    List.sort t.stocks ~compare:(fun stock1 stock2 ->
      String.compare stock1.sector stock2.sector)
  ;;

  let sort_by_industry t =
    List.sort t.stocks ~compare:(fun stock1 stock2 ->
      String.compare stock1.industry stock2.industry)
  ;;

  (* TESTING *)
  let stock1 =
    Stock.create_stock
      ~symbol:"STK1"
      ~name:"c stock 1"
      ~price:5.68
      ~growth:3.2
      ~sector:"sector1"
      ~industry:"industry1"
      ()
  ;;

  let stock2 =
    Stock.create_stock
      ~symbol:"STK2"
      ~name:"b stock 2"
      ~price:4.39
      ~growth:6.3
      ~sector:"sector1"
      ~industry:"industry1"
      ()
  ;;

  let stock3 =
    Stock.create_stock
      ~symbol:"STK3"
      ~name:"a stock 3"
      ~price:1.34
      ~growth:9.3
      ~sector:"sector2"
      ~industry:"industry2"
      ()
  ;;

  (* testing sort by name *)
  let%expect_test "sort by name" =
    let sorted_stocks = sort_by_name (of_list [ stock1; stock2; stock3 ]) in
    print_s [%sexp (sorted_stocks : Stock.t list)];
    [%expect
      {|
      (((symbol STK3) (name "a stock 3") (price 1.34) (growth 9.3) (sector sector2)
        (industry industry2) (summary "") (headlines ("")))
       ((symbol STK2) (name "b stock 2") (price 4.39) (growth 6.3) (sector sector1)
        (industry industry1) (summary "") (headlines ("")))
       ((symbol STK1) (name "c stock 1") (price 5.68) (growth 3.2) (sector sector1)
        (industry industry1) (summary "") (headlines ("")))) |}]
  ;;

  let%expect_test "sort by symbol" =
    let sorted_stocks =
      sort_by_symbol (of_list [ stock1; stock2; stock3 ])
    in
    print_s [%sexp (sorted_stocks : Stock.t list)];
    [%expect
      {|
      (((symbol STK1) (name "c stock 1") (price 5.68) (growth 3.2) (sector sector1)
        (industry industry1) (summary "") (headlines ("")))
       ((symbol STK2) (name "b stock 2") (price 4.39) (growth 6.3) (sector sector1)
        (industry industry1) (summary "") (headlines ("")))
       ((symbol STK3) (name "a stock 3") (price 1.34) (growth 9.3) (sector sector2)
        (industry industry2) (summary "") (headlines ("")))) |}]
  ;;

  let%expect_test "sort by growth" =
    let sorted_stocks =
      sort_by_growth (of_list [ stock1; stock2; stock3 ])
    in
    print_s [%sexp (sorted_stocks : Stock.t list)];
    [%expect
      {|
      (((symbol STK3) (name "a stock 3") (price 1.34) (growth 9.3) (sector sector2)
        (industry industry2) (summary "") (headlines ("")))
       ((symbol STK2) (name "b stock 2") (price 4.39) (growth 6.3) (sector sector1)
        (industry industry1) (summary "") (headlines ("")))
       ((symbol STK1) (name "c stock 1") (price 5.68) (growth 3.2) (sector sector1)
        (industry industry1) (summary "") (headlines (""))))
      |}]
  ;;

  let%expect_test "sort by price" =
    let sorted_stocks = sort_by_price (of_list [ stock1; stock2; stock3 ]) in
    print_s [%sexp (sorted_stocks : Stock.t list)];
    [%expect
      {|
      (((symbol STK1) (name "c stock 1") (price 5.68) (growth 3.2) (sector sector1)
        (industry industry1) (summary "") (headlines ("")))
       ((symbol STK2) (name "b stock 2") (price 4.39) (growth 6.3) (sector sector1)
        (industry industry1) (summary "") (headlines ("")))
       ((symbol STK3) (name "a stock 3") (price 1.34) (growth 9.3) (sector sector2)
        (industry industry2) (summary "") (headlines (""))))
  |}]
  ;;

  let%expect_test "sort by price" =
    let sorted_stocks =
      sort_by_sector (of_list [ stock1; stock2; stock3 ])
    in
    print_s [%sexp (sorted_stocks : Stock.t list)];
    [%expect
      {|
      (((symbol STK1) (name "c stock 1") (price 5.68) (growth 3.2) (sector sector1)
        (industry industry1) (summary "") (headlines ("")))
       ((symbol STK2) (name "b stock 2") (price 4.39) (growth 6.3) (sector sector1)
        (industry industry1) (summary "") (headlines ("")))
       ((symbol STK3) (name "a stock 3") (price 1.34) (growth 9.3) (sector sector2)
        (industry industry2) (summary "") (headlines (""))))
  |}]
  ;;

  let%expect_test "sort by price" =
    let sorted_stocks =
      sort_by_industry (of_list [ stock1; stock2; stock3 ])
    in
    print_s [%sexp (sorted_stocks : Stock.t list)];
    [%expect
      {|
      (((symbol STK1) (name "c stock 1") (price 5.68) (growth 3.2) (sector sector1)
        (industry industry1) (summary "") (headlines ("")))
       ((symbol STK2) (name "b stock 2") (price 4.39) (growth 6.3) (sector sector1)
        (industry industry1) (summary "") (headlines ("")))
       ((symbol STK3) (name "a stock 3") (price 1.34) (growth 9.3) (sector sector2)
        (industry industry2) (summary "") (headlines (""))))
  |}]
  ;;
end
