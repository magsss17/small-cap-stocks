open Core
open Stock

module User = struct
  type range =
    | Day
    | Week
    | Month
    | ThreeMonth
    | SixMonth
    | Year
  [@@deriving sexp]

  type filter =
    | Name
    | Price
    | Growth
  [@@deriving sexp]

  type t =
    { mutable num_companies : int
    ; mutable time_range : range
    ; mutable filter : filter
    ; mutable pinned : Stock.t String.Table.t
    }
  [@@deriving sexp, fields]

  let get_range t = t.time_range
  let get_num_companies t = t.num_companies
  let get_filter t = t.filter
  let get_pinned t = Hash_set.of_list (module Stock) (Hashtbl.data t.pinned)

  let set_filter t ~filter =
    match filter with
    | "Price" -> t.filter <- Price
    | "Growth" -> t.filter <- Growth
    | _ -> t.filter <- Name
  ;;

  let set_range t ~range =
    match range with
    | "Week" -> t.time_range <- Week
    | "Month" -> t.time_range <- Month
    | "Three Months" -> t.time_range <- ThreeMonth
    | "Six Months" -> t.time_range <- SixMonth
    | "Year" -> t.time_range <- Year
    | _ -> t.time_range <- Day
  ;;

  let set_num_companies t ~num_companies = t.num_companies <- num_companies

  let add_pinned t ~company =
    Hashtbl.add_exn t.pinned ~key:(Stock.name company) ~data:company
  ;;

  let remove_pinned t ~company = Hashtbl.remove t.pinned (Stock.name company)
end
