open Core
open Stock

module User : sig
  type range [@@deriving sexp]
  type filter [@@deriving sexp]

  type t =
    { mutable num_companies : int
    ; mutable time_range : range
    ; mutable filter : filter
    ; mutable pinned : Stock.t String.Table.t
    }
  [@@deriving sexp, fields]

  (* get time range set by user *)
  val get_range : t -> range

  (* get number of companies to display set by user *)
  val get_num_companies : t -> int

  (* get filter set by user *)
  val get_filter : t -> filter

  (* get pinned companies *)
  val get_pinned : t -> Stock.t Hash_set.t

  (* set filter, default is Name *)
  val set_filter : t -> filter:string -> unit

  (* set time range, default is Day *)
  val set_range : t -> range:string -> unit

  (* set number of companies to display *)
  val set_num_companies : t -> num_companies:int -> unit

  (* add pinned company *)
  val add_pinned : t -> company:Stock.t -> unit

  (* remove pinned company *)
  val remove_pinned : t -> company:Stock.t -> unit
end
