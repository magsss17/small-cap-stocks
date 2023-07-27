open Core
open Stock

let parse_to_stock contents =
  let open Soup in
  parse contents
  $$ "tr[class]"
  |> to_list
  |> List.map ~f:(fun data -> texts data)
  |> List.tl_exn
  |> List.filter_map ~f:(fun stock ->
       let symbol, name, price, growth =
         ( List.nth stock 0
         , List.nth stock 1
         , List.nth stock 2
         , List.nth stock 3 )
       in
       match symbol, name, price, growth with
       | Some symbol', Some name', Some price', Some growth' ->
         Some
           (Stock.create_stock
              ~symbol:symbol'
              ~name:name'
              ~exchange:"NASDAQ"
              ~price:(Float.of_string price')
              ~growth:(Float.of_string growth')
              ())
       | _ -> None)
;;
