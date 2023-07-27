open Core
open Sexplib.Std

module Stock = struct
  module T = struct
    type t =
      { symbol : string
      ; name : string
      ; mutable price : float [@hash.ignore]
      ; mutable growth : float [@hash.ignore]
      ; mutable sector : string [@hash.ignore]
      ; mutable industry : string [@hash.ignore]
      ; mutable summary : string [@hash.ignore]
      ; mutable headlines : string list [@hash.ignore]
      }
    [@@deriving sexp, fields, compare, hash, yojson]
  end

  include Hashable.Make_plain_and_derive_hash_fold_t (T)
  include T

  let create_stock
    ~symbol
    ~name
    ~price
    ~growth
    ?(sector = "")
    ?(industry = "")
    ?(summary = "")
    ?(headlines = [ "" ])
    ()
    =
    { symbol; name; price; growth; sector; industry; summary; headlines }
  ;;

  let update_growth t ~growth = t.growth <- growth
  let update_price t ~price = t.price <- price
  let update_summary t ~summary = t.summary <- summary
  let update_headlines t ~headlines = t.headlines <- headlines
  let update_industry t ~industry = t.industry <- industry
  let update_sector t ~sector = t.sector <- sector
  let get_price t = t.price
  let get_growth t = t.growth
  let get_industry t = t.industry
  let get_sector t = t.sector
end
