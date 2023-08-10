open Async
open Portfolio

type t = Portfolio.t [@@deriving sexp]

let db_path = "database.sexp"
let load_data () = Reader.load_sexp_exn db_path t_of_sexp
let save_data data = Writer.save_sexp db_path (sexp_of_t data)

(* Below expect test is commented because we don't want
   to overwrite the database that contains all small cap
   stocks collected recently.
*)
(* let%expect_test "Save to database" =
  let portfolio = Portfolio.of_list [] in 
  let%bind _ = save_data portfolio in
  let%bind portfolio = load_data () in
  print_s [%sexp (portfolio: t)];
  return () *)

let maybe_init_db () =
  match Sys_unix.file_exists db_path with
  | `Yes -> return ()
  | _ -> save_data { Portfolio.stocks = [] }
;;
