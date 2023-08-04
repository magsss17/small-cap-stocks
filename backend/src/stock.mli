module Stock : sig
  type t =
    { symbol : string
    ; mutable name : string
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

  val create_stock
    :  symbol:string
    -> name:string
    -> price:float
    -> growth:float
    -> ?sector:string
    -> ?industry:string
    -> ?summary:string
    -> ?headlines:string list
    -> ?profit_margin:float
    -> ?gross_profit:string
    -> ?diluted_eps:float
    -> unit
    -> t

  val update_name : t -> name:string -> unit
  val update_growth : t -> growth:float -> unit
  val update_price : t -> price:float -> unit
  val update_summary : t -> summary:string -> unit
  val update_headlines : t -> headlines:string list -> unit
  val update_industry : t -> industry:string -> unit
  val update_sector : t -> sector:string -> unit
  val update_profit_margin : t -> profit_margin:float -> unit
  val update_gross_profit : t -> gross_profit:string -> unit
  val update_diluted_eps : t -> diluted_eps:float -> unit
  val get_price : t -> float
  val get_growth : t -> float
  val get_industry : t -> string
  val get_sector : t -> string
end
