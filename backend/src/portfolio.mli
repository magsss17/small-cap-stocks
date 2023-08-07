open Stock

(* Stores list of stocks scraped off web *)

module Portfolio : sig
  type t = { mutable stocks : Stock.t list } [@@deriving sexp, fields, yojson]

  val get_stock : t -> string -> Stock.t option

  val update_portfolio : t -> Stock.t -> unit

  (* list to t *)
  val of_list : Stock.t list -> t

  (* sort stocks by name *)
  val sort_by_name : t -> Stock.t list

  (* sort stocks by symbol/ticker *)
  val sort_by_symbol : t -> Stock.t list

  (* sort stocks by growth *)
  val sort_by_growth : t -> Stock.t list
  val sort_by_price : t -> Stock.t list
  val sort_by_sector : t -> Stock.t list
  val sort_by_industry : t -> Stock.t list
end
