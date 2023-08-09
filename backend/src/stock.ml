open Core
open Sexplib.Std

module Stock = struct
  module T = struct
    type t =
      { symbol : string
      ; mutable name : string [@hash.ignore]
      ; mutable price : float [@hash.ignore]
      ; mutable growth : float [@hash.ignore]
      ; mutable sector : string [@hash.ignore]
      ; mutable industry : string [@hash.ignore]
      ; mutable summary : string [@hash.ignore]
      ; mutable headlines : string list [@hash.ignore]
      ; mutable profit_margin : float [@hash.ignore]
      ; mutable gross_profit : string [@hash.ignore]
      ; mutable diluted_eps : float [@hash.ignore]
      }
    [@@deriving sexp, fields, compare, hash, yojson]
  end

  include Hashable.Make_plain_and_derive_hash_fold_t (T)
  include T

  let create_stock
    ~symbol
    ~name
    ~price
    ~growth
    ?(sector = "")
    ?(industry = "")
    ?(summary = "")
    ?(headlines = [ "" ])
    ?(profit_margin = 0.0)
    ?(gross_profit = "")
    ?(diluted_eps = 0.0)
    ()
    =
    { symbol
    ; name
    ; price
    ; growth
    ; sector
    ; industry
    ; summary
    ; headlines
    ; profit_margin
    ; gross_profit
    ; diluted_eps
    }
  ;;

  let stock =
    create_stock
      ~symbol:"AAPL"
      ~name:"Apple Inc."
      ~price:150.0
      ~growth:1.0
      ~sector:"Technology"
      ~industry:"Software"
      ~summary:"Apple makes computers"
      ~headlines:
        [ "Apple announces a new Vision Pro Goggle"
        ; "Apple shares are tanking"
        ]
      ~profit_margin:10.0
      ~gross_profit:"466M"
      ~diluted_eps:35.0
      ()
  ;;

  let%expect_test "create stock" = print_s [%sexp (stock : t)];
    [%expect {|
      ((symbol AAPL) (name "Apple Inc.") (price 150) (growth 1) (sector Technology)
       (industry Software) (summary "Apple makes computers")
       (headlines
        ("Apple announces a new Vision Pro Goggle" "Apple shares are tanking"))
       (profit_margin 10) (gross_profit 466M) (diluted_eps 35)) |}]

  let%expect_test "create empty stock" =
    let stock = create_stock ~symbol:"" ~name:"" ~price:0.0 ~growth:0.0 () in
    print_s [%sexp (stock : t)];
    [%expect {|
      ((symbol "") (name "") (price 0) (growth 0) (sector "") (industry "")
       (summary "") (headlines ("")) (profit_margin 0) (gross_profit "")
       (diluted_eps 0)) |}]
  ;;

  let update_name t ~name = t.name <- name

  let%expect_test "update name" =
    let _ = update_name stock ~name:"BANA" in
    print_s [%sexp (stock : t)];
    [%expect {|
      ((symbol AAPL) (name BANA) (price 150) (growth 1) (sector Technology)
       (industry Software) (summary "Apple makes computers")
       (headlines
        ("Apple announces a new Vision Pro Goggle" "Apple shares are tanking"))
       (profit_margin 10) (gross_profit 466M) (diluted_eps 35)) |}]
  ;;

  let update_growth t ~growth = t.growth <- growth

  let%expect_test "update growth" =
    let _ = update_growth stock ~growth: 10.0 in
    print_s [%sexp (stock : t)];
    [%expect {|
      ((symbol AAPL) (name BANA) (price 150) (growth 10) (sector Technology)
       (industry Software) (summary "Apple makes computers")
       (headlines
        ("Apple announces a new Vision Pro Goggle" "Apple shares are tanking"))
       (profit_margin 10) (gross_profit 466M) (diluted_eps 35)) |}]
  ;;

  let update_price t ~price = t.price <- price

  let%expect_test "update price" =
    let _ = update_price stock ~price:100.0 in
    print_s [%sexp (stock : t)];
    [%expect {|
      ((symbol AAPL) (name BANA) (price 100) (growth 10) (sector Technology)
       (industry Software) (summary "Apple makes computers")
       (headlines
        ("Apple announces a new Vision Pro Goggle" "Apple shares are tanking"))
       (profit_margin 10) (gross_profit 466M) (diluted_eps 35)) |}]
  ;;

  let update_summary t ~summary = t.summary <- summary

  let%expect_test "update summary" =
    let _ = update_summary stock ~summary: "Apple makes iPhones, iPads and computers." in
    print_s [%sexp (stock : t)];
    [%expect {|
      ((symbol AAPL) (name BANA) (price 100) (growth 10) (sector Technology)
       (industry Software) (summary "Apple makes iPhones, iPads and computers.")
       (headlines
        ("Apple announces a new Vision Pro Goggle" "Apple shares are tanking"))
       (profit_margin 10) (gross_profit 466M) (diluted_eps 35)) |}]
  ;;

  let update_headlines t ~headlines = t.headlines <- headlines

  let%expect_test "update headlines" =
    let _ = update_headlines stock ~headlines: ["Apple is now back on the rise"] in
    print_s [%sexp (stock : t)];
    [%expect {|
      ((symbol AAPL) (name BANA) (price 100) (growth 10) (sector Technology)
       (industry Software) (summary "Apple makes iPhones, iPads and computers.")
       (headlines ("Apple is now back on the rise")) (profit_margin 10)
       (gross_profit 466M) (diluted_eps 35)) |}]
  ;;

  let update_industry t ~industry = t.industry <- industry

  let%expect_test "update industry" =
    let _ = update_industry stock ~industry: "Supermarket" in
    print_s [%sexp (stock : t)];
    [%expect {|
      ((symbol AAPL) (name BANA) (price 100) (growth 10) (sector Technology)
       (industry Supermarket) (summary "Apple makes iPhones, iPads and computers.")
       (headlines ("Apple is now back on the rise")) (profit_margin 10)
       (gross_profit 466M) (diluted_eps 35)) |}]
  ;;

  let update_sector t ~sector = t.sector <- sector

  let%expect_test "update sector" =
    let _ = update_sector stock ~sector: "Finance" in
    print_s [%sexp (stock : t)];
    [%expect {|
      ((symbol AAPL) (name BANA) (price 100) (growth 10) (sector Finance)
       (industry Supermarket) (summary "Apple makes iPhones, iPads and computers.")
       (headlines ("Apple is now back on the rise")) (profit_margin 10)
       (gross_profit 466M) (diluted_eps 35)) |}]
  ;;

  let update_profit_margin t ~profit_margin =
    t.profit_margin <- profit_margin
  ;;

  let%expect_test "update profit margin" =
    let _ = update_profit_margin stock ~profit_margin: 1.0 in
    print_s [%sexp (stock : t)];
    [%expect {|
      ((symbol AAPL) (name BANA) (price 100) (growth 10) (sector Finance)
       (industry Supermarket) (summary "Apple makes iPhones, iPads and computers.")
       (headlines ("Apple is now back on the rise")) (profit_margin 1)
       (gross_profit 466M) (diluted_eps 35)) |}]
  ;;

  let update_gross_profit t ~gross_profit = t.gross_profit <- gross_profit

  let%expect_test "update gross profit" =
    let _ = update_gross_profit stock ~gross_profit: "388M" in
    print_s [%sexp (stock : t)];
    [%expect {|
      ((symbol AAPL) (name BANA) (price 100) (growth 10) (sector Finance)
       (industry Supermarket) (summary "Apple makes iPhones, iPads and computers.")
       (headlines ("Apple is now back on the rise")) (profit_margin 1)
       (gross_profit 388M) (diluted_eps 35)) |}]
  ;;

  let update_diluted_eps t ~diluted_eps = t.diluted_eps <- diluted_eps

  let%expect_test "update diluted eps" =
    let _ = update_diluted_eps stock ~diluted_eps: 3.0 in
    print_s [%sexp (stock : t)];
    [%expect {|
      ((symbol AAPL) (name BANA) (price 100) (growth 10) (sector Finance)
       (industry Supermarket) (summary "Apple makes iPhones, iPads and computers.")
       (headlines ("Apple is now back on the rise")) (profit_margin 1)
       (gross_profit 388M) (diluted_eps 3)) |}]
  ;;

  let get_price t = t.price
  let get_growth t = t.growth
  let get_industry t = t.industry
  let get_sector t = t.sector
end
