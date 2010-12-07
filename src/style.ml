open Cow

(* XXX: some of the following code can be factored out *)

let linkbar = <:css<
  position: absolute;
  bottom: 0;
  right: 0;
  vertical-align: bottom;

  ul {
    list-style-type: none;
  }

  li {
    display: block;
    float: left;
  }

  li a {
    color: #222;
    display: block;
    float: left;
    font-size: 1.4em;
    height: 23px;
    padding: 8px 20px 0px 20px;
    text-decoration: none;
  }

  li a:hover {
    border-bottom: 5px solid #222;
    color: #222;
    height: 23px;
    padding: 8px 20px 0px 20px;
  }
    
  li a.current_page {
    border-bottom: 5px solid #222;
    color: #222;
    height: 23px;
    padding: 8px 20px 0px 20px;
  }
>>

let content = <:css<
  margin: 0 auto;
  position: relative;
  width: 960px;
  padding-top: 10px;
  padding-bottom: 10px;
  
  code {
    font-size: 110%;
  }

  h2 {
    color: #222;
    font-family: "Helvetica Neue", "Helvetica", "Arial", sans-serif;
    font-size: 2.0em;
    font-weight: normal;
    margin: 0px 0px 0px 0px;
    padding: 1px 0px 0px 5px;
  }

  p {
    color: #222;
    font-size: 1.3em;
    padding: 5px 10px 3px 2px;
    line-height: 130%;
    text-align: justify;
  }

  ul {
    padding-left: 2em;
    list-style-type: square;
  }

  blockquote {
    background-color: #f2f2f2;
    border-left: 2px solid #aaa;
    font-size: 1.2em;
    padding: 11px 20px 10px 20px;
    margin: 10px 0px 8px 20px;
  }

  blockquote p {
    font-size: 1.0em;
  }

  table {
    border: 1px solid #aaa;
    color: #222;
    margin: 10px 0px 10px 0px;
    min-width: 450px;
    text-align: left;
    width: 100%;
  }

  th {
    font-size: 1.3em;
    font-weight: bold;
    padding: 2px 0px 2px 5px;
  }

  tr.even_row {
    background-color: #e5e5e5;
  }

  td {
    font-size: 1.2em;
    padding: 2px 0px 2px 5px;
  }
   
  a {
    text-decoration: none;
    border-bottom: 1px dotted #ccc;
    color: #000055;
  }
    
  a:hover {
    border-bottom: 1px solid #aaa;
  }

  $Pages.column_css$;
  $Blog.entries_css$;
>>

let wrapper = <:css<
  border-top: 1px solid #ccc;
  margin: 0 auto;
  width: 100%;

  #header {

    height: 77px;
    margin: 0 auto;
    position: relative;
    width: 960px;
    border-bottom: 1px solid #999999;

    #header_logo {
      float: left;
      position: relative;
      width: 465px;
      height: 77px;
      margin: 0px 0px 0px 0px;

      a#logo img {
        background: transparent;
        border: 0;
        margin: 0px 0px 0px 0px;
      }
    }

    #info_bar {
      height: 67px;
      width: 450px;
      margin: 0 auto;
      float: right;

      #linkbar { $linkbar$; }
    }
  }

  #content { $content$; }
>>
    
let footer = <:css<
  border-top: 1px solid #888;
  height: 30px;
  margin: 0 auto;
  padding: 5px 0px 0px 0px;
  position: relative;
  top: 10px;
  width: 960px;

  h4 {
    color: #222;
    float: left;
    font-size: 1.2em;
    font-weight: normal;
  }

  ul {
    float: right;
    list-style-type: none;
  }

  li {
    float: left;
  }

  a {
    color: #222;
    display: block;
    float: left;
    font-size: 1.2em;
    margin: 0px 0px 0px 20px;
    text-decoration: none;
  }

  a:hover {
    text-decoration: underline;
  }
>>

let t = Css.to_string <:css<
  $Css.reset_padding$;

  $Code.ocaml_css$;

  body {
    background-image: url('../graphics/cloud-bg.png');
    background-repeat: repeat-x;
    font: 65.0%/1.6 "helvetica neue", "helvetica", "arial", sans-serif;
  }

  a { outline: none; }

  #wrapper { $wrapper$; }

  #footer { $footer$; }

  .clear_div {
    clear: both;
  }

  .impl_red    { background-color: #FE9696; }
  .impl_orange { background-color: #FDC086; }
  .impl_green  { background-color: #B0ECB0; }
>>
