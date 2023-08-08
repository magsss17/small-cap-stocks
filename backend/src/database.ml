open Async
open Portfolio

type t = Portfolio.t [@@deriving sexp]

let db_path = "database.sexp"
let load_data () = Reader.load_sexp_exn db_path t_of_sexp
let save_data data = Writer.save_sexp db_path (sexp_of_t data)

let maybe_init_db () =
  match Sys_unix.file_exists db_path with
  | `Yes -> return ()
  | _ -> save_data { Portfolio.stocks = [] }
;;
