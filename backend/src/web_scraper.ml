open! Core
open Async
open! Cohttp_async
(* Wrapper around the ocurl library (https://github.com/ygrek/ocurl) *)

module Web_scraper = struct
  let get_exn ~url =
    let uri = Uri.of_string url in
    let%bind _, body = Cohttp_async.Client.get uri in
    let%bind string = Cohttp_async.Body.to_string body in
    return string
  ;;
end

(* module Curl = struct
  let writer accum data =
    Buffer.add_string accum data;
    String.length data
  ;;

  let get_exn url =
    let error_buffer = ref "" in
    let result = Buffer.create 16384 in
    let fail error = failwithf "Curl failed on %s: %s" url error () in
    try
      let connection = Curl.init () in
      Curl.set_errorbuffer connection error_buffer;
      Curl.set_writefunction connection (writer result);
      Curl.set_followlocation connection true;
      Curl.set_url connection url;
      Curl.perform connection;
      let result = Buffer.contents result in
      Curl.cleanup connection;
      result
    with
    | Curl.CurlException (_reason, _code, _str) -> fail !error_buffer
    | Failure s -> fail s
  ;;
end *)

let fetch_exn ~url = Web_scraper.get_exn ~url
