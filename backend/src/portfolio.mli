open Stock

module Portfolio : sig
  type t = { stocks : Stock.t list } [@@deriving sexp, fields]

  val sort_by_name : t -> Stock.t list
  val sort_by_symbol : t -> Stock.t list
  val sort_by_growth : t -> Stock.t list
  val sort_by_price : t -> Stock.t list
end
