open Async
open Portfolio

type t = Portfolio.t [@@deriving sexp]

val load_data : unit -> t Deferred.t
val save_data : t -> unit Deferred.t
val maybe_init_db : unit -> unit Deferred.t
