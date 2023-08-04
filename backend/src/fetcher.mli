open Stock
open Async

val fetch_stock : Stock.t -> Stock.t Deferred.t
val fetch_stock_financials : Stock.t -> Stock.t Deferred.t
val fetch_small_cap_list : unit -> Stock.t list Deferred.t
