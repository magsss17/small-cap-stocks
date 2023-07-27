open Core
open Stock

module Portfolio = struct
  type t = { stocks : Stock.t list } [@@deriving sexp, fields]

  let sort_by_name t = List.sort t.stocks ~compare: (fun stock1 stock2 -> String.compare stock1.name stock2.name)
  let sort_by_symbol t = List.sort t.stocks ~compare: (fun stock1 stock2 -> String.compare stock1.symbol stock2.symbol)
  let sort_by_growth t = List.sort t.stocks ~compare: (fun stock1 stock2 -> Float.compare stock1.growth stock2.growth)
  let sort_by_price t = List.sort t.stocks ~compare: (fun stock1 stock2 -> Float.compare stock1.price stock2.price)
end
