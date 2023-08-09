open Async
open Portfolio

type t = Portfolio.t [@@deriving sexp]

let db_path = "database.sexp"
let load_data () = Reader.load_sexp_exn db_path t_of_sexp

let%expect_test "Load from database" = 
  let%bind portfolio = load_data () in 
  print_s [%sexp (portfolio: t)];
  return ()
[@@expect.uncaught_exn {|
  (* CR expect_test_collector: This test expectation appears to contain a backtrace.
     This is strongly discouraged as backtraces are fragile.
     Please change this test to not include a backtrace. *)

  (monitor.ml.Error
    (Unix.Unix_error "No such file or directory" open
      "((filename database.sexp) (mode (O_RDONLY O_CLOEXEC)) (perm 0o0))")
    ("Raised at Base__Result.ok_exn in file \"src/result.ml\", line 289, characters 17-26"
      "Called from Async_kernel__Deferred1.M.map.(fun) in file \"src/deferred1.ml\", line 17, characters 44-49"
      "Called from Async_kernel__Job_queue.run_jobs in file \"src/job_queue.ml\", line 180, characters 6-47"
      "Re-raised at Async_unix__Reader0.gen_load_exn.load.(fun) in file \"src/reader0.ml\", line 1408, characters 14-23"
      "Caught by monitor block_on_async"))
  Raised at Base__Result.ok_exn in file "src/result.ml" (inlined), line 289, characters 17-26
  Called from Async_unix__Thread_safe.block_on_async_exn in file "src/thread_safe.ml", line 168, characters 29-63
  Called from Expect_test_collector.Make.Instance_io.exec in file "collector/expect_test_collector.ml", line 234, characters 12-19 |}]

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
