open Async
module Server = Cohttp_async.Server

val handler
  :  body:'a
  -> 'b
  -> Cohttp.Request.t
  -> Server.response Async_kernel.Deferred.t

val start_server : int -> unit -> 'a Async_kernel.Deferred.t
val stock_data : unit -> Portfolio.Portfolio.t Deferred.t
val command : Command.t
