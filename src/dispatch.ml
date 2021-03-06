open Mirage_types.V1
open Lwt
open Printf

module Main (C:CONSOLE) (FS:KV_RO) (TMPL:KV_RO) (Server:Cohttp_lwt.Server) = struct

  let start c fs tmpl http =

    let read_tmpl name =
      TMPL.size tmpl name
      >>= function
      | `Error (TMPL.Unknown_key _) -> fail (Failure ("read " ^ name))
      | `Ok size ->
        TMPL.read tmpl name 0 (Int64.to_int size)
        >>= function
        | `Error (TMPL.Unknown_key _) -> fail (Failure ("read " ^ name))
        | `Ok bufs -> return (Cstruct.copyv bufs)
    in

    let read_fs name =
      FS.size fs name
      >>= function
      | `Error (FS.Unknown_key _) -> fail (Failure ("read " ^ name))
      | `Ok size ->
        FS.read fs name 0 (Int64.to_int size)
        >>= function
        | `Error (FS.Unknown_key _) -> fail (Failure ("read " ^ name))
        | `Ok bufs -> return (Cstruct.copyv bufs)
    in

    (* dynamic response *)
    let dyn ?(headers=[]) req body =
      printf "Dispatch: dynamic URL %s\n%!" (Uri.path (Server.Request.uri req));
      body >>= fun body ->
      let status = `OK in
      let headers = Cohttp.Header.of_list headers in
      Server.respond_string ~headers ~status ~body ()
    in

    let dyn_xhtml = dyn ~headers:["content-type","text/html"] in

    let blog_entries = Pages.Blog.init read_tmpl in
    let wiki_entries = Pages.Wiki.init read_tmpl in
    let wiki_lt1     = Pages.Wiki.init_lt1 read_tmpl in
    let wiki_lt2     = Pages.Wiki.init_lt2 read_tmpl in

    (* dispatch non-file URLs *)
    let dispatch req =
      function
      | [] | [""] | [""; "index.html"] ->
        dyn_xhtml req (Pages.Index.t read_tmpl)
      | [""; "styles";"index.css"] ->
        dyn ~headers:Style.content_type_css req Style.t
      | [""; "resources"] ->
        dyn_xhtml req (Pages.Resources.t read_tmpl)
      | [""; "about"] ->
        dyn_xhtml req (Pages.About.t read_tmpl)
      | "" :: "blog" :: tl ->
        let headers, t = Pages.Blog.t blog_entries read_tmpl tl in
        dyn ~headers req t
      | "" :: "wiki" :: "tag" :: tl ->
        dyn_xhtml req (Pages.Wiki.tag wiki_entries wiki_lt1 wiki_lt2 read_tmpl tl)
      | "" :: "wiki" :: page ->
        let headers, t = Pages.Wiki.t wiki_entries wiki_lt1 wiki_lt2 read_tmpl page in
        dyn ~headers req t
      | x -> Server.respond_not_found ~uri:(Server.Request.uri req) ()
    in

    (* HTTP callback *)
    let callback conn_id ?body req =
      let path = Uri.path (Server.Request.uri req) in
      let rec remove_empty_tail = function
        | [] | [""] -> []
        | hd::tl -> hd :: remove_empty_tail tl in
      let path_elem = remove_empty_tail
          (Re_str.(split_delim (regexp_string "/") path)) in
      C.log_s c (Printf.sprintf "URL: %s" path)
      >>= fun () ->
      try_lwt
        read_fs path
        >>= fun body ->
        Server.respond_string ~status:`OK ~body ()
      with exn ->
        dispatch req path_elem
    in
    let spec = {
      Server.callback;
      conn_closed = fun _ () -> ();
    } in
    http spec

end
