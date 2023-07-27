module Stock : sig
  type exchange [@@deriving sexp, yojson]
  type t =
    { symbol : string
    ; name : string
    ; exchange : exchange [@compare.ignore]
    ; mutable price : float [@hash.ignore]
    ; mutable growth : float [@hash.ignore]
    ; mutable sector : string [@hash.ignore]
    ; mutable industry : string [@hash.ignore]
    ; mutable summary : string [@hash.ignore]
    ; mutable headlines : string list [@hash.ignore]
    }
  [@@deriving sexp, fields, compare, hash, yojson]

  val create_stock
    :  symbol:string
    -> name:string
    -> exchange:string
    -> price:float
    -> growth:float
    -> ?sector:string
    -> ?industry:string
    -> ?summary:string
    -> ?headlines:string list
    -> unit
    -> t

  val update_growth : t -> growth:float -> unit
  val update_price : t -> price:float -> unit
  val update_summary : t -> summary:string -> unit
  val update_headlines : t -> headlines:string list -> unit
  val update_industry : t -> industry:string -> unit
  val update_sector : t -> sector:string -> unit
  val get_price : t -> float
  val get_growth : t -> float
  val get_industry : t -> string
  val get_sector : t -> string
end
