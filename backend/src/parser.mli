open Stock
open Async

val parse_stock : Stock.t -> Stock.t Deferred.t
val parse_stock_financials : Stock.t -> Stock.t Deferred.t
val parse_small_cap_list : unit -> Stock.t list Deferred.t