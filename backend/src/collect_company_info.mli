open Stock
open Async
val fetch_stock_descriptions : Stock.t -> Stock.t Deferred.t
val fetch_stock_financials : Stock.t -> Stock.t Deferred.t