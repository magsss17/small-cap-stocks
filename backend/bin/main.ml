open! Core
open Small_cap_stocks

let () =
  let module Command = Async_command in
  Command.async
    ~summary:"Start a small_cap_prototype server"
    (let%map_open.Command port =
       flag
         "-p"
         (optional_with_default 8080 int)
         ~doc:"int Source port to listen on"
     in
     Server.start_server port)
  |> Command_unix.run
;;