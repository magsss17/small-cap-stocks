open Async
open Portfolio

type t = Portfolio.t [@@deriving sexp]

let db_path = "database.sexp"
let load_data () = Reader.load_sexp_exn db_path t_of_sexp

let save_data data =
  Writer.with_file db_path ~f:(fun writer ->
    Writer.write_sexp writer (sexp_of_t data) |> return)
;;

let maybe_init_db () =
  match Sys_unix.file_exists db_path with
  | `Yes -> return ()
  | _ -> save_data { Portfolio.stocks = [] }
;;
