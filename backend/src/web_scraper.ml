open! Core
open Async
open! Cohttp_async

module Curl = struct
  let writer accum data =
    Buffer.add_string accum data;
    String.length data
  ;;

  let get_exn ~url =
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
      return result
    with
    | Curl.CurlException (_reason, _code, _str) -> fail !error_buffer
    | Failure s -> fail s
  ;;
end

let fetch_exn ~url = Curl.get_exn ~url

let%expect_test "Fetch exn" =
let%bind result = fetch_exn ~url: "https://www.wikipedia.org/" in 
  print_s [%sexp (result: string)];
  [%expect {|
     "<!DOCTYPE html>\
    \n<html lang=\"en\" class=\"no-js\">\
    \n<head>\
    \n<meta charset=\"utf-8\">\
    \n<title>Wikipedia</title>\
    \n<meta name=\"description\" content=\"Wikipedia is a free online encyclopedia, created and edited by volunteers around the world and hosted by the Wikimedia Foundation.\">\
    \n<script>\
    \ndocument.documentElement.className = document.documentElement.className.replace( /(^|\\s)no-js(\\s|$)/, \"$1js-enabled$2\" );\
    \n</script>\
    \n<meta name=\"viewport\" content=\"initial-scale=1,user-scalable=yes\">\
    \n<link rel=\"apple-touch-icon\" href=\"/static/apple-touch/wikipedia.png\">\
    \n<link rel=\"shortcut icon\" href=\"/static/favicon/wikipedia.ico\">\
    \n<link rel=\"license\" href=\"//creativecommons.org/licenses/by-sa/4.0/\">\
    \n<style>\
    \n.sprite{background-image:linear-gradient(transparent,transparent),url(portal/wikipedia.org/assets/img/sprite-e99844f6.svg);background-repeat:no-repeat;display:inline-block;vertical-align:middle}.svg-Commons-logo_sister{background-position:0 0;width:47px;height:47px}.svg-MediaWiki-logo_sister{background-position:0 -47px;width:42px;height:42px}.svg-Meta-Wiki-logo_sister{background-position:0 -89px;width:37px;height:37px}.svg-Wikibooks-logo_sister{background-position:0 -126px;width:37px;height:37px}.svg-Wikidata-logo_sister{background-position:0 -163px;width:49px;height:49px}.svg-Wikimedia-logo_black{background-position:0 -212px;width:42px;height:42px}.svg-Wikipedia_wordmark{background-position:0 -254px;width:176px;height:32px}.svg-Wikiquote-logo_sister{background-position:0 -286px;width:42px;height:42px}.svg-Wikisource-logo_sister{background-position:0 -328px;width:39px;height:39px}.svg-Wikispecies-logo_sister{background-position:0 -367px;width:42px;height:42px}.svg-Wikiversity-logo_sister{background-position:0 -409px;width:43px;height:37px}.svg-Wikivoyage-logo_sister{background-position:0 -446px;width:36px;height:36px}.svg-Wiktionary-logo_sister{background-position:0 -482px;width:37px;height:37px}.svg-arrow-down{background-position:0 -519px;width:12px;height:8px}.svg-arrow-down-blue{background-position:0 -527px;width:14px;height:14px}.svg-badge_google_play_store{background-position:0 -541px;width:124px;height:38px}.svg-badge_ios_app_store{background-position:0 -579px;width:110px;height:38px}.svg-language-icon{background-position:0 -617px;width:22px;height:22px}.svg-noimage{background-position:0 -639px;width:58px;height:58px}.svg-search-icon{background-position:0 -697px;width:22px;height:22px}.svg-wikipedia_app_tile{background-position:0 -719px;width:42px;height:42px}\
    \n</style>\
    \n<style>\
    \nhtml{font-family:sans-serif;-ms-text-size-adjust:100%;-webkit-text-size-adjust:100%;font-size:62.5%}body{margin:0}article,aside,details,figcaption,figure,footer,header,hgroup,main,menu,nav,section,summary{display:block}audio,canvas,progress,video{display:inline-block;vertical-align:baseline}audio:not([controls]){display:none;height:0}[hidden],template{display:none}a{background-color:transparent}a:active,a:hover{outline:0}abbr[title]{border-bottom:1px dotted}b,strong{font-weight:700}dfn{font-style:italic}h1{font-size:32px;font-size:3.2rem;margin:1.2rem 0}mark{background:#edab00;color:#000}small{font-size:13px;font-size:1.3rem}sub,sup{font-size:75%;line-height:0;position:relative;vertical-align:baseline}sup{top:-.5em}sub{bottom:-.25em}svg:not(:root){overflow:hidden}figure{margin:1.6rem 4rem}hr{-webkit-box-sizing:content-box;-moz-box-sizing:content-box;box-sizing:content-box}pre{overflow:auto}code,kbd,pre,samp{font-family:monospace,monospace;font-size:14px;font-size:1.4rem}button,input,optgroup,select,textarea{color:inherit;font:inherit;margin:0}button{overflow:visible}button,select{text-transform:none}button,html input[type=button],input[type=reset],input[type=submit]{-webkit-appearance:button;cursor:pointer}button[disabled],html input[disabled]{cursor:default}button::-moz-focus-inner,input::-moz-focus-inner{border:0;padding:0}input{line-height:normal}input[type=checkbox],input[type=radio]{-webkit-box-sizing:border-box;-moz-box-sizing:border-box;box-sizing:border-box;padding:0}input[type=number]::-webkit-inner-spin-button,input[type=number]::-webkit-outer-spin-button{height:auto}input[type=search]{-webkit-appearance:none;-webkit-box-sizing:content-box;-moz-box-sizing:content-box;box-sizing:content-box}input[type=search]::-webkit-search-cancel-button,input[type=search]::-webkit-search-decoration{-webkit-appearance:none}input[type=search]:focus{outline-offset:-2px}fieldset{border:1px solid #a2a9b1;margin:0 .2rem;padding:.6rem 1rem 1.2rem}legend{border:0;padding:0}textarea{overflow:auto}optgroup{font-weight:700}table{border-collapse:collapse;border-spacing:0}td,th{padding:0}.hidden,[hidden]{display:none!important}.screen-reader-text{display:block;position:absolute!important;clip:rect(1px,1px,1px,1px);width:1px;height:1px;margin:-1px;border:0;padding:0;overflow:hidden}body{background-color:#fff;font-family:-apple-system,BlinkMacSystemFont,Segoe UI,Roboto,Inter,Helvetica,Arial,sans-serif;font-size:14px;font-size:1.4rem;line-height:1.5;margin:.4rem 0 1.6rem}a{-ms-touch-action:manipulation;touch-action:manipulation}a,a:active,a:focus{unicode-bidi:embed;outline:0;color:#36c;text-decoration:none}a:focus{outline:1px solid #36c}a:hover{text-decoration:underline}img{vertical-align:middle}hr,img{border:0}hr{clear:both;height:0;border-bottom:1px solid #c8ccd1;margin:.26rem 1.3rem}.pure-button{display:inline-block;zoom:1;line-height:normal;white-space:nowrap;text-align:center;cursor:pointer;-webkit-user-drag:none;-webkit-user-select:none;-moz-user-select:none;-ms-user-select:none;user-select:none;-webkit-box-sizing:border-box;-moz-box-sizing:border-box;box-sizing:border-box;background-color:#f8f9fa;color:#202122;position:relative;min-height:19.2px;min-height:1.92rem;min-width:16px;min-width:1.6rem;margin:.16rem 0;border:1px solid #a2a9b1;-moz-border-radius:2px;border-radius:2px;padding:.8rem 1.6rem;font-family:inherit;font-size:inherit;font-weight:700;text-decoration:none;vertical-align:top;-webkit-transition:background .1s ease,color .1s ease,border-color .1s ease,-webkit-box-shadow .1s ease;transition:background .1s ease,color .1s ease,border-color .1s ease,-webkit-box-shadow .1s ease;-o-transition:background .1s ease,color .1s ease,border-color .1s ease,box-shadow .1s ease;-moz-transition:background .1s ease,color .1s ease,border-color .1s ease,box-shadow .1s ease,-moz-box-shadow .1s ease;transition:background .1s ease,color .1s ease,border-color .1s ease,box-shadow .1s ease;transition:background .1s ease,color .1s ease,border-color .1s ease,box-shadow .1s ease,-webkit-box-shadow .1s ease,-moz-box-shadow .1s ease}.pure-button::-moz-focus-inner{padding:0;border:0}.pure-button-hover,.pure-button:hover{background-color:#fff;border-color:#a2a9b1;color:#404244}.pure-button-active,.pure-button:active{background-color:#eaecf0;border-color:#72777d;color:#000}.pure-button:focus{outline:0;border-color:#36c;-webkit-box-shadow:inset 0 0 0 1px #36c;-moz-box-shadow:inset 0 0 0 1px #36c;box-shadow:inset 0 0 0 1px #36c}.pure-button-primary-progressive{background-color:#36c;border-color:#36c;color:#fff}.pure-button-primary-progressive:hover{background:#447ff5;border-color:#447ff5}.pure-button-primary-progressive:active{background-color:#2a4b8d;border-color:#2a4b8d;-webkit-box-shadow:none;-moz-box-shadow:none;box-shadow:none;color:#fff}.pure-button-primary-progressive:focus{-webkit-box-shadow:inset 0 0 0 1px #36c,inset 0 0 0 2px #fff;-moz-box-shadow:inset 0 0 0 1px #36c,inset 0 0 0 2px #fff;box-shadow:inset 0 0 0 1px #36c,inset 0 0 0 2px #fff;border-color:#36c}.pure-form input[type=search]{background-color:#fff;display:inline-block;-webkit-box-sizing:border-box;-moz-box-sizing:border-box;box-sizing:border-box;border:1px solid #a2a9b1;-moz-border-radius:2px;border-radius:2px;padding:.8rem;-webkit-box-shadow:inset 0 0 0 1px #fff;-moz-box-shadow:inset 0 0 0 1px #fff;box-shadow:inset 0 0 0 1px #fff;vertical-align:middle}.pure-form input:focus:invalid{color:#b32424;border-color:#d33}.pure-form fieldset{margin:0;padding:.56rem 0 1.2rem;border:0}@media only screen and (max-width:480px){.pure-form input[type=search]{display:block}}.central-textlogo-wrapper{display:inline-block;vertical-align:bottom}.central-textlogo{position:relative;margin:4rem auto .5rem;width:270px;font-family:Linux Libertine,Hoefler Text,Georgia,Times New Roman,Times,serif;font-size:30px;font-size:3rem;font-weight:400;line-height:33px;line-height:3.3rem;text-align:center;-moz-font-feature-settings:\"ss05=1\";-moz-font-feature-settings:\"ss05\";-webkit-font-feature-settings:\"ss05\";-ms-font-feature-settings:\"ss05\";font-feature-settings:\"ss05\"}.localized-slogan{display:block;font-family:Linux Libertine,Georgia,Times,\"Source Serif Pro\",serif;font-size:15px;font-size:1.5rem;font-weight:400}.central-textlogo__image{color:transparent;display:inline-block;overflow:hidden;text-indent:-10000px}.central-featured-logo{position:absolute;top:158px;left:35px}@media (max-width:480px){.central-textlogo{position:relative;height:70px;width:auto;margin:2rem 0 0;text-align:center;line-height:25px;line-height:2.5rem;text-indent:-10px;text-indent:-1rem;font-size:1em}.central-textlogo-wrapper{position:relative;top:12px;text-indent:2px;text-indent:.2rem}.svg-Wikipedia_wordmark{width:150px;height:25px;background-position:0 -218px;-webkit-background-size:100% 100%;-moz-background-size:100%;background-size:100%}.localized-slogan{font-size:14px;font-size:1.4rem}.central-featured-logo{position:relative;display:inline-block;width:57px;height:auto;left:0;top:0}}@media (max-width:240px){.central-textlogo__image{height:auto}}.central-featured{position:relative;height:325px;height:32.5rem;width:546px;width:54.6rem;max-width:100%;margin:0 auto;text-align:center;vertical-align:middle}.central-featured-lang{position:absolute;width:156px;width:15.6rem}.central-featured-lang .link-box{display:block;padding:0;text-decoration:none;white-space:normal}.central-featured-lang .link-box:hover strong{text-decoration:underline}.central-featured-lang :hover{background-color:#eaecf0}.central-featured-lang strong{display:block;font-size:16px;font-size:1.6rem}.central-featured-lang small{color:#54595d;display:inline-block;font-size:13px;font-size:1.3rem;line-height:1.6}.central-featured-lang em{font-style:italic}.central-featured-lang .emNonItalicLang{font-style:normal}.lang1{top:0;right:60%}.lang2{top:0;left:60%}.lang3{top:20%;right:70%}.lang4{top:20%;left:70%}.lang5{top:40%;right:72%}.lang6{top:40%;left:72%}.lang7{top:60%;right:70%}.lang8{top:60%;left:70%}.lang9{top:80%;right:60%}.lang10{top:80%;left:60%}@media (max-width:480px){.central-featured{width:auto;height:auto;margin-top:8rem;font-size:13px;font-size:1.3rem;text-align:left}.central-featured:after{content:\" \";display:block;visibility:hidden;clear:both;height:0;font-size:0}.central-featured-lang{display:block;float:left;position:relative;top:auto;left:auto;right:auto;-webkit-box-sizing:border-box;-moz-box-sizing:border-box;box-sizing:border-box;height:64px;height:6.4rem;width:33%;margin:0 0 16px;padding:0 1.6rem;font-size:14px;font-size:1.4rem;text-align:center}.central-featured-lang strong{font-size:14px;font-size:1.4rem;margin-bottom:4px}.central-featured-lang small{line-height:1.4}}@media (max-width:375px){.central-featured-lang{font-size:13px;font-size:1.3rem}}@media (max-width:240px){.central-featured-lang{width:100%}}.search-container{float:none;max-width:95%;width:540px;margin:.4rem auto 1.95rem;text-align:center;vertical-align:middle}.search-container fieldset{word-spacing:-4px}.search-container button{min-height:44px;min-height:4.4rem;margin:0;-moz-border-radius:0 2px 2px 0;border-radius:0 2px 2px 0;padding:.8rem 1.6rem;font-size:16px;font-size:1.6rem;z-index:2}.search-container button .svg-search-icon{text-indent:-9999px}.search-container input[type=search]::-webkit-search-results-button,.search-container input[type=search]::-webkit-search-results-decoration{-webkit-appearance:none}.search-container input::-webkit-calendar-picker-indicator{display:none}.search-container .sprite.svg-arrow-down{position:absolute;top:8px;top:.8rem;right:6px;right:.6rem}#searchInput{-webkit-appearance:none;width:100%;height:44px;height:4.4rem;border-width:1px 0 1px 1px;-moz-border-radius:2px 0 0 2px;border-radius:2px 0 0 2px;padding:.8rem 9.6rem .8rem 1.2rem;font-size:16px;font-size:1.6rem;line-height:1.6;-webkit-transition:background .1s ease,border-color .1s ease,-webkit-box-shadow .1s ease;transition:background .1s ease,border-color .1s ease,-webkit-box-shadow .1s ease;-o-transition:background .1s ease,border-color .1s ease,box-shadow .1s ease;-moz-transition:background .1s ease,border-color .1s ease,box-shadow .1s ease,-moz-box-shadow .1s ease;transition:background .1s ease,border-color .1s ease,box-shadow .1s ease;transition:background .1s ease,border-color .1s ease,box-shadow .1s ease,-webkit-box-shadow .1s ease,-moz-box-shadow .1s ease}#searchInput:hover{border-color:#72777d}#searchInput:focus{border-color:#36c;-webkit-box-shadow:inset 0 0 0 1px #36c;-moz-box-shadow:inset 0 0 0 1px #36c;box-shadow:inset 0 0 0 1px #36c;outline:0}.search-container .search-input{display:inline-block;position:relative;width:73%;vertical-align:top}@media only screen and (max-width:480px){.search-container .pure-form fieldset{margin-left:1rem;margin-right:6.6rem}.search-container .search-input{width:100%;margin-right:-6.6rem}.search-container .pure-form button{float:right;right:-56px;right:-5.6rem}}.suggestions-dropdown{background-color:#fff;display:inline-block;position:absolute;left:0;z-index:2;margin:0;padding:0;border:1px solid #a2a9b1;border-top:0;-webkit-box-shadow:0 2px 2px 0 rgba(0,0,0,.25);-moz-box-shadow:0 2px 2px 0 rgba(0,0,0,.25);box-shadow:0 2px 2px 0 rgba(0,0,0,.25);list-style-type:none;word-spacing:normal}.suggestion-link,.suggestions-dropdown{-webkit-box-sizing:border-box;-moz-box-sizing:border-box;box-sizing:border-box;width:100%;text-align:left}.suggestion-link{display:block;position:relative;min-height:70px;min-height:7rem;padding:1rem 1rem 1rem 8.5rem;border-bottom:1px solid #eaecf0;color:inherit;text-decoration:none;text-align:initial;white-space:normal}.suggestion-link.active{background-color:#eaf3ff}a.suggestion-link:hover{text-decoration:none}a.suggestion-link:active,a.suggestion-link:focus{outline:0;white-space:normal}.suggestion-thumbnail{background-color:#eaecf0;background-image:url(portal/wikipedia.org/assets/img/noimage.png);background-image:-webkit-linear-gradient(transparent,transparent),url(\"data:image/svg+xml;charset=utf-8,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 56 56'%3E%3Cpath fill='%23eee' d='M0 0h56v56H0z'/%3E%3Cpath fill='%23999' d='M36.4 13.5H17.8v24.9c0 1.4.9 2.3 2.3 2.3h18.7v-25c.1-1.4-1-2.2-2.4-2.2zM30.2 17h5.1v6.4h-5.1V17zm-8.8 0h6v1.8h-6V17zm0 4.6h6v1.8h-6v-1.8zm0 15.5v-1.8h13.8v1.8H21.4zm13.8-4.5H21.4v-1.8h13.8v1.8zm0-4.7H21.4v-1.8h13.8v1.8z'/%3E%3C/svg%3E\");background-image:-webkit-linear-gradient(transparent,transparent),url(portal/wikipedia.org/assets/img/noimage.svg) !ie;background-image:-webkit-gradient(linear,left top,left bottom,from(transparent),to(transparent)),url(\"data:image/svg+xml;charset=utf-8,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 56 56'%3E%3Cpath fill='%23eee' d='M0 0h56v56H0z'/%3E%3Cpath fill='%23999' d='M36.4 13.5H17.8v24.9c0 1.4.9 2.3 2.3 2.3h18.7v-25c.1-1.4-1-2.2-2.4-2.2zM30.2 17h5.1v6.4h-5.1V17zm-8.8 0h6v1.8h-6V17zm0 4.6h6v1.8h-6v-1.8zm0 15.5v-1.8h13.8v1.8H21.4zm13.8-4.5H21.4v-1.8h13.8v1.8zm0-4.7H21.4v-1.8h13.8v1.8z'/%3E%3C/svg%3E\");background-image:-moz- oldlinear-gradient(transparent,transparent),url(\"data:image/svg+xml;charset=utf-8,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 56 56'%3E%3Cpath fill='%23eee' d='M0 0h56v56H0z'/%3E%3Cpath fill='%23999' d='M36.4 13.5H17.8v24.9c0 1.4.9 2.3 2.3 2.3h18.7v-25c.1-1.4-1-2.2-2.4-2.2zM30.2 17h5.1v6.4h-5.1V17zm-8.8 0h6v1.8h-6V17zm0 4.6h6v1.8h-6v-1.8zm0 15.5v-1.8h13.8v1.8H21.4zm13.8-4.5H21.4v-1.8h13.8v1.8zm0-4.7H21.4v-1.8h13.8v1.8z'/%3E%3C/svg%3E\");background-image:-o-linear-gradient(transparent,transparent),url(\"data:image/svg+xml;charset=utf-8,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 56 56'%3E%3Cpath fill='%23eee' d='M0 0h56v56H0z'/%3E%3Cpath fill='%23999' d='M36.4 13.5H17.8v24.9c0 1.4.9 2.3 2.3 2.3h18.7v-25c.1-1.4-1-2.2-2.4-2.2zM30.2 17h5.1v6.4h-5.1V17zm-8.8 0h6v1.8h-6V17zm0 4.6h6v1.8h-6v-1.8zm0 15.5v-1.8h13.8v1.8H21.4zm13.8-4.5H21.4v-1.8h13.8v1.8zm0-4.7H21.4v-1.8h13.8v1.8z'/%3E%3C/svg%3E\");background-image:linear-gradient(transparent,transparent),url(\"data:image/svg+xml;charset=utf-8,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 56 56'%3E%3Cpath fill='%23eee' d='M0 0h56v56H0z'/%3E%3Cpath fill='%23999' d='M36.4 13.5H17.8v24.9c0 1.4.9 2.3 2.3 2.3h18.7v-25c.1-1.4-1-2.2-2.4-2.2zM30.2 17h5.1v6.4h-5.1V17zm-8.8 0h6v1.8h-6V17zm0 4.6h6v1.8h-6v-1.8zm0 15.5v-1.8h13.8v1.8H21.4zm13.8-4.5H21.4v-1.8h13.8v1.8zm0-4.7H21.4v-1.8h13.8v1.8z'/%3E%3C/svg%3E\");background-image:-webkit-gradient(linear,left top,left bottom,from(transparent),to(transparent)),url(portal/wikipedia.org/assets/img/noimage.svg) !ie;background-image:-moz- oldlinear-gradient(transparent,transparent),url(portal/wikipedia.org/assets/img/noimage.svg) !ie;background-image:-o-linear-gradient(transparent,transparent),url(portal/wikipedia.org/assets/img/noimage.svg) !ie;background-image:linear-gradient(transparent,transparent),url(portal/wikipedia.org/assets/img/noimage.svg) !ie;background-image:-o-linear-gradient(transparent,transparent),url(portal/wikipedia.org/assets/img/noimage.png);background-position:50%;background-repeat:no-repeat;-webkit-background-size:100% auto;-moz-background-size:100% auto;background-size:100% auto;-webkit-background-size:cover;-moz-background-size:cover;background-size:cover;height:100%;width:70px;width:7rem;position:absolute;top:0;left:0}.suggestion-title{margin:0 0 .78rem;color:#54595d;font-size:16px;font-size:1.6rem;line-height:18.72px;line-height:1.872rem}.suggestion-link.active .suggestion-title{color:#36c}.suggestion-highlight{font-style:normal;text-decoration:underline}.suggestion-description{color:#72777d;margin:0;font-size:13px;font-size:1.3rem;line-height:14.299px;line-height:1.43rem}.styled-select{display:none;position:absolute;top:10px;top:1rem;bottom:12px;bottom:1.2rem;right:12px;right:1.2rem;max-width:95px;max-width:9.5rem;height:24px;height:2.4rem;-moz-border-radius:2px;border-radius:2px}.styled-select:hover{background-color:#f8f9fa}.styled-select .hide-arrow{right:32px;right:3.2rem;max-width:68px;max-width:6.8rem;height:24px;height:2.4rem;overflow:hidden;text-align:right}.styled-select select{background:transparent;display:inline;overflow:hidden;height:24px;height:2.4rem;min-width:110px;min-width:11rem;max-width:110px;max-width:11rem;width:110px;width:11rem;outline:0;-webkit-box-sizing:border-box;-moz-box-sizing:border-box;box-sizing:border-box;border:0;line-height:24px;line-height:2.4rem;-webkit-appearance:none;-moz-appearance:window;text-indent:.01px;-o-text-overflow:\"\";text-overflow:\"\";opacity:0;-moz-appearance:none;appearance:none;cursor:pointer}.styled-select.no-js{width:95px;width:9.5rem}.styled-select.no-js select{opacity:1;margin:0;padding:0 2.4rem 0 .8rem;color:#54595d}.styled-select.no-js .hide-arrow{width:68px;width:6.8rem}.search-container .styled-select.no-js .js-langpicker-label{display:none}.styled-select.js-enabled .hide-arrow{padding:0 2.4rem 0 .8rem}.styled-select.js-enabled select{background:transparent;position:absolute;top:0;left:0;height:100%;z-index:1;width:100%;border:0;margin:0;padding:0 2.4rem;color:transparent;color:hsla(0,0%,100%,0)}.styled-select.js-enabled select option{color:#54595d}.styled-select.js-enabled select:hover{background-color:transparent}.styled-select-active-helper{display:none}.styled-select.js-enabled select:focus+.styled-select-active-helper{display:block;position:absolute;top:0;left:0;z-index:0;width:100%;height:100%;outline:1px solid #36c}.search-container .js-langpicker-label{display:inline-block;margin:0;color:#54595d;font-size:13px;font-size:1.3rem;line-height:24px;line-height:2.4rem;text-transform:uppercase}.styled-select select:hover{background-color:#f8f9fa}.styled-select select::-ms-expand{display:none}.styled-select select:focus{outline:0;-webkit-box-shadow:none;-moz-box-shadow:none;box-shadow:none}@-moz-document url-prefix(){.styled-select select{width:110%}}.other-projects{display:inline-block;width:65%}.other-project{float:left;position:relative;width:33%;height:90px;height:9rem}.other-project-link{display:inline-block;min-height:50px;width:90%;padding:1em;white-space:nowrap}.other-project-link:hover{background-color:#eaecf0}a.other-project-link{text-decoration:none}.other-project-icon{display:inline-block;width:50px;text-align:center}.svg-Wikinews-logo_sister{background-image:url(portal/wikipedia.org/assets/img/Wikinews-logo_sister.png);background-position:0 0;-webkit-background-size:47px 26px;-moz-background-size:47px 26px;background-size:47px 26px;width:47px;height:26px}@media (-o-min-device-pixel-ratio:5/4),(-webkit-min-device-pixel-ratio:1.25),(min-resolution:120dpi){.svg-Wikinews-logo_sister{background-image:url(portal/wikipedia.org/assets/img/Wikinews-logo_sister@2x.png)}}.other-project-text,.other-project .sprite-project-logos{display:inline-block}.other-project-text{max-width:65%;font-size:14px;font-size:1.4rem;vertical-align:middle;white-space:normal}.other-project-tagline,.other-project-title{display:block}.other-project-tagline{color:#54595d;font-size:13px;font-size:1.3rem}@media screen and (max-width:768px){.other-projects{width:100%}.other-project{width:33%}}@media screen and (max-width:480px){.other-project{width:50%}.other-project-tagline{-webkit-hyphens:auto;-moz-hyphens:auto;-ms-hyphens:auto;hyphens:auto}}@media screen and (max-width:320px){.other-project-text{margin-right:5px;font-size:13px;font-size:1.3rem}}.lang-list-container{background-color:#f8f9fa;overflow:hidden;position:relative;-webkit-box-sizing:border-box;-moz-box-sizing:border-box;box-sizing:border-box;max-height:0;width:80%;margin:-1.6rem auto 4.8rem;-webkit-transition:max-height .5s ease-out .16s,visibility .5s ease-in 1s;-o-transition:max-height .5s ease-out .16s,visibility .5s ease-in 1s;-moz-transition:max-height .5s ease-out .16s,visibility .5s ease-in 1s;transition:max-height .5s ease-out .16s,visibility .5s ease-in 1s}.js-enabled .lang-list-container{visibility:hidden}.lang-list-active .lang-list-container,.no-js .lang-list-container{visibility:visible;max-height:10000px;-webkit-transition:max-height 1s ease-in .2s,visibility 1000s ease-in 0ms;-o-transition:max-height 1s ease-in .2s,visibility 1000s ease-in 0ms;-moz-transition:max-height 1s ease-in .2s,visibility 1000s ease-in 0ms;transition:max-height 1s ease-in .2s,visibility 1000s ease-in 0ms}.no-js .lang-list-button{display:none}.lang-list-button-wrapper{text-align:center}.lang-list-button{background-color:#f8f9fa;display:inline;position:relative;z-index:1;margin:0 auto;padding:.6rem 1.2rem;outline:16px solid #fff;outline:1.6rem solid #fff;border:1px solid #a2a9b1;-moz-border-radius:2px;border-radius:2px;color:#36c;font-size:14px;font-size:1.4rem;font-weight:700;line-height:1;-webkit-transition:outline-width .1s ease-in .5s;-o-transition:outline-width .1s ease-in .5s;-moz-transition:outline-width .1s ease-in .5s;transition:outline-width .1s ease-in .5s}.lang-list-button:hover{background-color:#fff;border-color:#a2a9b1}.lang-list-button:focus{border-color:#36c;-webkit-box-shadow:inset 0 0 0 1px #36c;-moz-box-shadow:inset 0 0 0 1px #36c;box-shadow:inset 0 0 0 1px #36c}.lang-list-active .lang-list-button{background-color:#fff;outline:1px solid #fff;border-color:#72777d;-webkit-transition-delay:0s;-moz-transition-delay:0s;-o-transition-delay:0s;transition-delay:0s}.lang-list-button-text{padding:0 .64rem;vertical-align:middle}.lang-list-button i{display:inline-block;vertical-align:middle}.no-js .lang-list-border,.no-js .lang-list-button{display:none}.lang-list-border{background-color:#c8ccd1;display:block;position:relative;max-width:460px;width:80%;margin:-1.6rem auto 1.6rem;height:1px;-webkit-transition:max-width .2s ease-out .4s;-o-transition:max-width .2s ease-out .4s;-moz-transition:max-width .2s ease-out .4s;transition:max-width .2s ease-out .4s}.lang-list-active .lang-list-border{max-width:85%;-webkit-transition-delay:0s;-moz-transition-delay:0s;-o-transition-delay:0s;transition-delay:0s}.no-js .lang-list-content{padding:0}.lang-list-content{position:relative;-webkit-box-sizing:border-box;-moz-box-sizing:border-box;box-sizing:border-box;width:100%;padding:1.6rem 1.6rem 0}.svg-arrow-down-blue{-webkit-transition:-webkit-transform .2s ease-out;transition:-webkit-transform .2s ease-out;-o-transition:transform .2s ease-out;-moz-transition:transform .2s ease-out,-moz-transform .2s ease-out;transition:transform .2s ease-out;transition:transform .2s ease-out,-webkit-transform .2s ease-out,-moz-transform .2s ease-out}.lang-list-active .svg-arrow-down-blue{-webkit-transform:rotate(180deg);-moz-transform:rotate(180deg);-ms-transform:rotate(180deg);transform:rotate(180deg)}.langlist{width:auto;margin:1.6rem 0;text-align:left}.langlist-others{font-weight:700;text-align:center}.hlist ul{margin:0;padding:0}.hlist li,.hlist ul ul{display:inline}.hlist li:before{content:\" \194\183 \";font-weight:700}.hlist li:first-child:before{content:none}.hlist li>ul:before{content:\"\\00a0(\"}.hlist li>ul:after{content:\") \"}.langlist>ul{-webkit-column-width:11.2rem;-moz-column-width:11.2rem;column-width:11.2rem}.langlist>ul>li{display:block;line-height:1.7;-webkit-column-break-inside:avoid;page-break-inside:avoid;break-inside:avoid}.no-js .langlist>ul{text-align:center;list-style-type:circle}.no-js .langlist>ul>li{display:inline-block;padding:0 .8rem}.langlist>ul>li:before{content:none}.langlist>ul>li a{white-space:normal}@media (max-width:480px){.langlist{font-size:inherit}.langlist a{word-wrap:break-word;white-space:normal}.lang-list-container{width:auto;margin-left:.8rem;margin-right:.8rem}.bookshelf{overflow:visible}}.bookshelf{display:block;border-top:1px solid #c8ccd1;-webkit-box-shadow:0 -1px 0 #fff;-moz-box-shadow:0 -1px 0 #fff;box-shadow:0 -1px 0 #fff;text-align:center;white-space:nowrap}.bookshelf .text{background-color:#f8f9fa;position:relative;top:-11.2px;top:-1.12rem;font-weight:400;padding:0 .8rem}.bookshelf-container{display:block;overflow:visible;width:100%;height:1px;margin:2.4rem 0 1.6rem;font-size:13px;font-size:1.3rem;font-weight:700;line-height:1.5}@media (max-width:480px){.bookshelf{width:auto;left:auto}.bookshelf-container{text-align:left;width:auto}}.app-badges .footer-sidebar-content{background-color:#f8f9fa}.app-badges .footer-sidebar-text{padding-top:.8rem;padding-bottom:.8rem}.app-badges .sprite.footer-sidebar-icon{top:8px;top:.8rem}.app-badges ul{margin:0;padding:0;list-style-type:none}.app-badge{display:inline-block}.app-badge a{color:transparent}@media screen and (max-width:768px){.app-badges .footer-sidebar-content{text-align:center}.app-badges .sprite.footer-sidebar-icon{display:inline-block;position:relative;margin:0;top:-3px;left:0;vertical-align:middle;-webkit-transform:scale(.7);-moz-transform:scale(.7);-ms-transform:scale(.7);transform:scale(.7)}}.footer{overflow:hidden;max-width:100%;margin:0 auto;padding:4.16rem 1.28rem 1.28rem;font-size:13px;font-size:1.3rem}.footer:after,.footer:before{content:\" \";display:table}.footer:after{clear:both}.footer-sidebar{width:35%;float:left;clear:left;margin-bottom:3.2rem;vertical-align:top}.footer-sidebar-content{position:relative;max-width:350px;margin:0 auto}.sprite.footer-sidebar-icon{position:absolute;top:0;left:8px;left:.8rem}.footer-sidebar-text{position:relative;margin:0;padding-left:6rem;padding-right:2rem;color:#54595d}.site-license{color:#54595d;text-align:center}.site-license small:after{content:\"\\2022\";display:inline-block;font-size:13px;font-size:1.3rem;line-height:inherit;margin-left:.8rem;margin-right:.5rem}.site-license small:last-child:after{display:none}@media screen and (max-width:768px){.footer{display:-webkit-box;display:-webkit-flex;display:-moz-box;display:-ms-flexbox;display:flex;-webkit-box-orient:vertical;-webkit-box-direction:normal;-webkit-flex-direction:column;-moz-box-orient:vertical;-moz-box-direction:normal;-ms-flex-direction:column;flex-direction:column;padding-top:1.28rem}.footer .footer-sidebar{-webkit-box-ordinal-group:1;-moz-box-ordinal-group:1;-webkit-order:1;-ms-flex-order:1;order:1}.footer .other-projects{-webkit-box-ordinal-group:2;-moz-box-ordinal-group:2;-webkit-order:2;-ms-flex-order:2;order:2}.footer .app-badges{-webkit-box-ordinal-group:3;-moz-box-ordinal-group:3;-webkit-order:3;-ms-flex-order:3;order:3}.footer-sidebar{width:100%}.sprite.footer-sidebar-icon{display:block;position:relative;left:0;margin:0 auto 1.28rem}.footer-sidebar-content{max-width:none}.footer-sidebar-text{margin:0;padding:0;text-align:center}}@media screen and (max-width:480px){.footer{padding:.96rem .64rem 1.28rem}}@media (max-width:480px){.search-container{margin-top:0;height:78px;height:7.8rem;position:absolute;top:96px;top:9.6rem;left:0;right:0;max-width:100%;width:auto;padding:0;text-align:left}.search-container label{display:none}.search-form #searchInput{max-width:40%;vertical-align:middle}.search-form .formBtn{max-width:25%;vertical-align:middle}form fieldset{margin:0;border-left:0;border-right:0}hr{margin-top:.65rem}}@media (-o-min-device-pixel-ratio:2/1),(-webkit-min-device-pixel-ratio:2),(min--moz-device-pixel-ratio:2),(min-resolution:2dppx),(min-resolution:192dpi){hr{border-bottom-width:.5px}}@supports (-webkit-marquee-style:slide){hr{border-bottom-width:1px}}.js-enabled .central-featured,.js-enabled .jsl10n{visibility:hidden}.jsl10n-visible .central-featured,.jsl10n-visible .jsl10n{visibility:visible}@media print{body{background-color:transparent}a{color:#000!important;background:none!important;padding:0!important}a:link,a:visited{color:#520;background:transparent}img{border:0}}\
    \n</style>\
    \n<link rel=\"preconnect\" href=\"//upload.wikimedia.org\">\
    \n<link rel=\"me\" href=\"https://wikis.world/@wikipedia\">\
    \n<meta property=\"og:url\" content>\
    \n<meta property=\"og:title\" content=\"Wikipedia, the free encyclopedia\">\
    \n<meta property=\"og:type\" content=\"website\">\
    \n<meta property=\"og:description\" content=\"Wikipedia is a free online encyclopedia, created and edited by volunteers around the world and hosted by the Wikimedia Foundation.\">\
    \n<meta property=\"og:image\" content=\"https://upload.wikimedia.org/wikipedia/en/thumb/8/80/Wikipedia-logo-v2.svg/2244px-Wikipedia-logo-v2.svg.png\">\
    \n</head>\
    \n<body id=\"www-wikipedia-org\">\
    \n<div class=\"central-textlogo\">\
    \n<img class=\"central-featured-logo\" src=\"portal/wikipedia.org/assets/img/Wikipedia-logo-v2.png\" srcset=\"portal/wikipedia.org/assets/img/Wikipedia-logo-v2@1.5x.png 1.5x, portal/wikipedia.org/assets/img/Wikipedia-logo-v2@2x.png 2x\" width=\"200\" height=\"183\" alt=\"Wikipedia\">\
    \n<h1 class=\"central-textlogo-wrapper\">\
    \n<span class=\"central-textlogo__image sprite svg-Wikipedia_wordmark\">\
    \nWikipedia\
    \n</span>\
    \n<strong class=\"jsl10n localized-slogan\" data-jsl10n=\"portal.slogan\">The Free Encyclopedia</strong>\
    \n</h1>\
    \n</div>\
    \n<div class=\"central-featured\" data-el-section=\"primary links\">\
    \n<!-- #1. en.wikipedia.org - 1 824 460 000 views/day -->\
    \n<div class=\"central-featured-lang lang1\" lang=\"en\" dir=\"ltr\">\
    \n<a id=\"js-link-box-en\" href=\"//en.wikipedia.org/\" title=\"English \226\128\148 Wikipedia \226\128\148 The Free Encyclopedia\" class=\"link-box\" data-slogan=\"The Free Encyclopedia\">\
    \n<strong>English</strong>\
    \n<small><bdi dir=\"ltr\">6&nbsp;691&nbsp;000+</bdi> <span>articles</span></small>\
    \n</a>\
    \n</div>\
    \n<!-- #2. ja.wikipedia.org - 209 850 000 views/day -->\
    \n<div class=\"central-featured-lang lang2\" lang=\"ja\" dir=\"ltr\">\
    \n<a id=\"js-link-box-ja\" href=\"//ja.wikipedia.org/\" title=\"Nihongo \226\128\148 \227\130\166\227\130\163\227\130\173\227\131\154\227\131\135\227\130\163\227\130\162 \226\128\148 \227\131\149\227\131\170\227\131\188\231\153\190\231\167\145\228\186\139\229\133\184\" class=\"link-box\" data-slogan=\"\227\131\149\227\131\170\227\131\188\231\153\190\231\167\145\228\186\139\229\133\184\">\
    \n<strong>\230\151\165\230\156\172\232\170\158</strong>\
    \n<small><bdi dir=\"ltr\">1&nbsp;382&nbsp;000+</bdi> <span>\232\168\152\228\186\139</span></small>\
    \n</a>\
    \n</div>\
    \n<!-- #3. es.wikipedia.org - 196 185 000 views/day -->\
    \n<div class=\"central-featured-lang lang3\" lang=\"es\" dir=\"ltr\">\
    \n<a id=\"js-link-box-es\" href=\"//es.wikipedia.org/\" title=\"Espa\195\177ol \226\128\148 Wikipedia \226\128\148 La enciclopedia libre\" class=\"link-box\" data-slogan=\"La enciclopedia libre\">\
    \n<strong>Espa\195\177ol</strong>\
    \n<small><bdi dir=\"ltr\">1&nbsp;881&nbsp;000+</bdi> <span>art\195\173culos</span></small>\
    \n</a>\
    \n</div>\
    \n<!-- #4. ru.wikipedia.org - 195 195 000 views/day -->\
    \n<div class=\"central-featured-lang lang4\" lang=\"ru\" dir=\"ltr\">\
    \n<a id=\"js-link-box-ru\" href=\"//ru.wikipedia.org/\" title=\"Russkiy \226\128\148 \208\146\208\184\208\186\208\184\208\191\208\181\208\180\208\184\209\143 \226\128\148 \208\161\208\178\208\190\208\177\208\190\208\180\208\189\208\176\209\143 \209\141\208\189\209\134\208\184\208\186\208\187\208\190\208\191\208\181\208\180\208\184\209\143\" class=\"link-box\" data-slogan=\"\208\161\208\178\208\190\208\177\208\190\208\180\208\189\208\176\209\143 \209\141\208\189\209\134\208\184\208\186\208\187\208\190\208\191\208\181\208\180\208\184\209\143\">\
    \n<strong>\208\160\209\131\209\129\209\129\208\186\208\184\208\185</strong>\
    \n<small><bdi dir=\"ltr\">1&nbsp;930&nbsp;000+</bdi> <span>\209\129\209\130\208\176\209\130\208\181\208\185</span></small>\
    \n</a>\
    \n</div>\
    \n<!-- #5. de.wikipedia.org - 191 606 000 views/day -->\
    \n<div class=\"central-featured-lang lang5\" lang=\"de\" dir=\"ltr\">\
    \n<a id=\"js-link-box-de\" href=\"//de.wikipedia.org/\" title=\"Deutsch \226\128\148 Wikipedia \226\128\148 Die freie Enzyklop\195\164die\" class=\"link-box\" data-slogan=\"Die freie Enzyklop\195\164die\">\
    \n<strong>Deutsch</strong>\
    \n<small><bdi dir=\"ltr\">2&nbsp;822&nbsp;000+</bdi> <span>Artikel</span></small>\
    \n</a>\
    \n</div>\
    \n<!-- #6. fr.wikipedia.org - 163 303 000 views/day -->\
    \n<div class=\"central-featured-lang lang6\" lang=\"fr\" dir=\"ltr\">\
    \n<a id=\"js-link-box-fr\" href=\"//fr.wikipedia.org/\" title=\"fran\195\167ais \226\128\148 Wikip\195\169dia \226\128\148 L\226\128\153encyclop\195\169die libre\" class=\"link-box\" data-slogan=\"L\226\128\153encyclop\195\169die libre\">\
    \n<strong>Fran\195\167ais</strong>\
    \n<small><bdi dir=\"ltr\">2&nbsp;540&nbsp;000+</bdi> <span>articles</span></small>\
    \n</a>\
    \n</div>\
    \n<!-- #7. it.wikipedia.org - 102 958 000 views/day -->\
    \n<div class=\"central-featured-lang lang7\" lang=\"it\" dir=\"ltr\">\
    \n<a id=\"js-link-box-it\" href=\"//it.wikipedia.org/\" title=\"Italiano \226\128\148 Wikipedia \226\128\148 L&#x27;enciclopedia libera\" class=\"link-box\" data-slogan=\"L&#x27;enciclopedia libera\">\
    \n<strong>Italiano</strong>\
    \n<small><bdi dir=\"ltr\">1&nbsp;820&nbsp;000+</bdi> <span>voci</span></small>\
    \n</a>\
    \n</div>\
    \n<!-- #8. zh.wikipedia.org - 94 607 000 views/day -->\
    \n<div class=\"central-featured-lang lang8\" lang=\"zh\" dir=\"ltr\">\
    \n<a id=\"js-link-box-zh\" href=\"//zh.wikipedia.org/\" title=\"Zh\197\141ngw\195\169n \226\128\148 \231\187\180\229\159\186\231\153\190\231\167\145 / \231\182\173\229\159\186\231\153\190\231\167\145 \226\128\148 \232\135\170\231\148\177\231\154\132\231\153\190\231\167\145\229\133\168\228\185\166 / \232\135\170\231\148\177\231\154\132\231\153\190\231\167\145\229\133\168\230\155\184\" class=\"link-box jscnconv\" data-title-hans=\"Zh\197\141ngw\195\169n \226\128\148 \231\187\180\229\159\186\231\153\190\231\167\145 \226\128\148 \232\135\170\231\148\177\231\154\132\231\153\190\231\167\145\229\133\168\228\185\166\" data-title-hant=\"Zh\197\141ngw\195\169n \226\128\148 \231\182\173\229\159\186\231\153\190\231\167\145 \226\128\148 \232\135\170\231\148\177\231\154\132\231\153\190\231\167\145\229\133\168\230\155\184\" data-slogan=\"\232\135\170\231\148\177\231\154\132\231\153\190\231\167\145\229\133\168\228\185\166 / \232\135\170\231\148\177\231\154\132\231\153\190\231\167\145\229\133\168\230\155\184\">\
    \n<strong>\228\184\173\230\150\135</strong>\
    \n<small><bdi dir=\"ltr\">1&nbsp;369&nbsp;000+</bdi> <span data-hans=\"\230\157\161\231\155\174\" data-hant=\"\230\162\157\231\155\174\" class=\"jscnconv\">\230\157\161\231\155\174 / \230\162\157\231\155\174</span></small>\
    \n</a>\
    \n</div>\
    \n<!-- #9. pt.wikipedia.org - 53 961 000 views/day -->\
    \n<div class=\"central-featured-lang lang9\" lang=\"pt\" dir=\"ltr\">\
    \n<a id=\"js-link-box-pt\" href=\"//pt.wikipedia.org/\" title=\"Portugu\195\170s \226\128\148 Wikip\195\169dia \226\128\148 A enciclop\195\169dia livre\" class=\"link-box\" data-slogan=\"A enciclop\195\169dia livre\">\
    \n<strong>Portugu\195\170s</strong>\
    \n<small><bdi dir=\"ltr\">1&nbsp;105&nbsp;000+</bdi> <span>artigos</span></small>\
    \n</a>\
    \n</div>\
    \n<!-- #10. fa.wikipedia.org - 53 530 000 views/day -->\
    \n<div class=\"central-featured-lang lang10\" lang=\"fa\" dir=\"rtl\">\
    \n<a id=\"js-link-box-fa\" href=\"//fa.wikipedia.org/\" title=\"F\196\129rsi \226\128\148 \217\136\219\140\218\169\219\140\226\128\140\217\190\216\175\219\140\216\167 \226\128\148 \216\175\216\167\217\134\216\180\217\134\216\167\217\133\217\135\217\148 \216\162\216\178\216\167\216\175\" class=\"link-box\" data-slogan=\"\216\175\216\167\217\134\216\180\217\134\216\167\217\133\217\135\217\148 \216\162\216\178\216\167\216\175\">\
    \n<strong><bdi dir=\"rtl\">\217\129\216\167\216\177\216\179\219\140</bdi></strong>\
    \n<small><bdi dir=\"ltr\">969&nbsp;000+</bdi> <span>\217\133\217\130\216\167\217\132\217\135</span></small>\
    \n</a>\
    \n</div>\
    \n</div>\
    \n<div class=\"search-container\">\
    \n<form class=\"pure-form\" id=\"search-form\" action=\"//www.wikipedia.org/search-redirect.php\" data-el-section=\"search\">\
    \n<fieldset>\
    \n<input type=\"hidden\" name=\"family\" value=\"Wikipedia\">\
    \n<input type=\"hidden\" id=\"hiddenLanguageInput\" name=\"language\" value=\"en\">\
    \n<div class=\"search-input\" id=\"search-input\">\
    \n<label for=\"searchInput\" class=\"screen-reader-text\" data-jsl10n=\"portal.search-input-label\">Search Wikipedia</label>\
    \n<input id=\"searchInput\" name=\"search\" type=\"search\" size=\"20\" autofocus=\"autofocus\" accesskey=\"F\" dir=\"auto\" autocomplete=\"off\">\
    \n<div class=\"styled-select no-js\">\
    \n<div class=\"hide-arrow\">\
    \n<select id=\"searchLanguage\" name=\"language\">\
    \n<option value=\"af\" lang=\"af\">Afrikaans</option>\
    \n<option value=\"pl\" lang=\"pl\">Polski</option>\
    \n<option value=\"ar\" lang=\"ar\">\216\167\217\132\216\185\216\177\216\168\217\138\216\169</option><!-- Al-\202\191Arab\196\171yah -->\
    \n<option value=\"ast\" lang=\"ast\">Asturianu</option>\
    \n<option value=\"az\" lang=\"az\">Az\201\153rbaycanca</option>\
    \n<option value=\"bg\" lang=\"bg\">\208\145\209\138\208\187\208\179\208\176\209\128\209\129\208\186\208\184</option><!-- B\199\142lgarski -->\
    \n<option value=\"nan\" lang=\"nan\">B\195\162n-l\195\162m-g\195\186 / H\197\141-l\195\179-o\196\147</option>\
    \n<option value=\"bn\" lang=\"bn\">\224\166\172\224\166\190\224\166\130\224\166\178\224\166\190</option><!-- Bangla -->\
    \n<option value=\"be\" lang=\"be\">\208\145\208\181\208\187\208\176\209\128\209\131\209\129\208\186\208\176\209\143</option><!-- Belaruskaya -->\
    \n<option value=\"ca\" lang=\"ca\">Catal\195\160</option>\
    \n<option value=\"cs\" lang=\"cs\">\196\140e\197\161tina</option><!-- \196\141e\197\161tina -->\
    \n<option value=\"cy\" lang=\"cy\">Cymraeg</option><!-- Cymraeg -->\
    \n<option value=\"da\" lang=\"da\">Dansk</option>\
    \n<option value=\"de\" lang=\"de\">Deutsch</option>\
    \n<option value=\"et\" lang=\"et\">Eesti</option>\
    \n<option value=\"el\" lang=\"el\">\206\149\206\187\206\187\206\183\206\189\206\185\206\186\206\172</option><!-- Ell\196\171nik\195\161 -->\
    \n<option value=\"en\" lang=\"en\" selected=selected>English</option><!-- English -->\
    \n<option value=\"es\" lang=\"es\">Espa\195\177ol</option>\
    \n<option value=\"eo\" lang=\"eo\">Esperanto</option>\
    \n<option value=\"eu\" lang=\"eu\">Euskara</option>\
    \n<option value=\"fa\" lang=\"fa\">\217\129\216\167\216\177\216\179\219\140</option><!-- F\196\129rsi -->\
    \n<option value=\"fr\" lang=\"fr\">Fran\195\167ais</option><!-- fran\195\167ais -->\
    \n<option value=\"gl\" lang=\"gl\">Galego</option>\
    \n<option value=\"ko\" lang=\"ko\">\237\149\156\234\181\173\236\150\180</option><!-- Hangugeo -->\
    \n<option value=\"hi\" lang=\"hi\">\224\164\185\224\164\191\224\164\168\224\165\141\224\164\166\224\165\128</option><!-- Hind\196\171 -->\
    \n<option value=\"hr\" lang=\"hr\">Hrvatski</option>\
    \n<option value=\"id\" lang=\"id\">Bahasa Indonesia</option>\
    \n<option value=\"it\" lang=\"it\">Italiano</option>\
    \n<option value=\"he\" lang=\"he\">\215\162\215\145\215\168\215\153\215\170</option><!-- Ivrit -->\
    \n<option value=\"ka\" lang=\"ka\">\225\131\165\225\131\144\225\131\160\225\131\151\225\131\163\225\131\154\225\131\152</option><!-- Kartuli -->\
    \n<option value=\"la\" lang=\"la\">Latina</option>\
    \n<option value=\"lv\" lang=\"lv\">Latvie\197\161u</option>\
    \n<option value=\"lt\" lang=\"lt\">Lietuvi\197\179</option>\
    \n<option value=\"hu\" lang=\"hu\">Magyar</option>\
    \n<option value=\"mk\" lang=\"mk\">\208\156\208\176\208\186\208\181\208\180\208\190\208\189\209\129\208\186\208\184</option><!-- Makedonski -->\
    \n<option value=\"arz\" lang=\"arz\">\217\133\216\181\216\177\217\137</option><!-- Ma\225\185\163r\196\171 -->\
    \n<option value=\"ms\" lang=\"ms\">Bahasa Melayu</option>\
    \n<option value=\"min\" lang=\"min\">Bahaso Minangkabau</option>\
    \n<option value=\"nl\" lang=\"nl\">Nederlands</option>\
    \n<option value=\"ja\" lang=\"ja\">\230\151\165\230\156\172\232\170\158</option><!-- Nihongo -->\
    \n<option value=\"no\" lang=\"nb\">Norsk (bokm\195\165l)</option>\
    \n<option value=\"nn\" lang=\"nn\">Norsk (nynorsk)</option>\
    \n<option value=\"ce\" lang=\"ce\">\208\157\208\190\209\133\209\135\208\184\208\185\208\189</option><!-- Nox\195\167iyn -->\
    \n<option value=\"uz\" lang=\"uz\">O\202\187zbekcha / \208\142\208\183\208\177\208\181\208\186\209\135\208\176</option><!-- O\202\187zbekcha -->\
    \n<option value=\"pt\" lang=\"pt\">Portugu\195\170s</option>\
    \n<option value=\"kk\" lang=\"kk\">\210\154\208\176\208\183\208\176\210\155\209\136\208\176 / Qazaq\197\159a / \217\130\216\167\216\178\216\167\217\130\216\180\216\167</option>\
    \n<option value=\"ro\" lang=\"ro\">Rom\195\162n\196\131</option><!-- Rom\195\162n\196\131 -->\
    \n<option value=\"simple\" lang=\"en\">Simple English</option>\
    \n<option value=\"ceb\" lang=\"ceb\">Sinugboanong Binisaya</option>\
    \n<option value=\"sk\" lang=\"sk\">Sloven\196\141ina</option>\
    \n<option value=\"sl\" lang=\"sl\">Sloven\197\161\196\141ina</option><!-- sloven\197\161\196\141ina -->\
    \n<option value=\"sr\" lang=\"sr\">\208\161\209\128\208\191\209\129\208\186\208\184 / Srpski</option>\
    \n<option value=\"sh\" lang=\"sh\">Srpskohrvatski / \208\161\209\128\208\191\209\129\208\186\208\190\209\133\209\128\208\178\208\176\209\130\209\129\208\186\208\184</option>\
    \n<option value=\"fi\" lang=\"fi\">Suomi</option><!-- suomi -->\
    \n<option value=\"sv\" lang=\"sv\">Svenska</option>\
    \n<option value=\"ta\" lang=\"ta\">\224\174\164\224\174\174\224\174\191\224\174\180\224\175\141</option><!-- Tami\225\184\187 -->\
    \n<option value=\"tt\" lang=\"tt\">\208\162\208\176\209\130\208\176\209\128\209\135\208\176 / Tatar\195\167a</option>\
    \n<option value=\"th\" lang=\"th\">\224\184\160\224\184\178\224\184\169\224\184\178\224\185\132\224\184\151\224\184\162</option><!-- Phasa Thai -->\
    \n<option value=\"tg\" lang=\"tg\">\208\162\208\190\210\183\208\184\208\186\211\163</option><!-- Tojik\196\171 -->\
    \n<option value=\"azb\" lang=\"azb\">\216\170\219\134\216\177\218\169\216\172\217\135</option><!-- T\195\188rkce -->\
    \n<option value=\"tr\" lang=\"tr\">T\195\188rk\195\167e</option><!-- T\195\188rk\195\167e -->\
    \n<option value=\"uk\" lang=\"uk\">\208\163\208\186\209\128\208\176\209\151\208\189\209\129\209\140\208\186\208\176</option><!-- Ukrayins\226\128\153ka -->\
    \n<option value=\"ur\" lang=\"ur\">\216\167\216\177\216\175\217\136</option><!-- Urdu -->\
    \n<option value=\"vi\" lang=\"vi\">Ti\225\186\191ng Vi\225\187\135t</option>\
    \n<option value=\"war\" lang=\"war\">Winaray</option>\
    \n<option value=\"zh-yue\" lang=\"yue\">\231\178\181\232\170\158</option><!-- Yuht Y\195\186h / Jyut6 jyu5 -->\
    \n<option value=\"zh\" lang=\"zh\">\228\184\173\230\150\135</option><!-- Zh\197\141ngw\195\169n -->\
    \n<option value=\"ru\" lang=\"ru\">\208\160\209\131\209\129\209\129\208\186\208\184\208\185</option><!-- Russkiy -->\
    \n<option value=\"hy\" lang=\"hy\">\213\128\213\161\213\181\213\165\214\128\213\165\213\182</option><!-- Hayeren -->\
    \n<option value=\"my\" lang=\"my\">\225\128\153\225\128\188\225\128\148\225\128\186\225\128\153\225\128\172\225\128\152\225\128\172\225\128\158\225\128\172</option><!-- Myanmarsar -->\
    \n</select>\
    \n<div class=\"styled-select-active-helper\"></div>\
    \n</div>\
    \n<i class=\"sprite svg-arrow-down\"></i>\
    \n</div>\
    \n</div>\
    \n<button class=\"pure-button pure-button-primary-progressive\" type=\"submit\">\
    \n<i class=\"sprite svg-search-icon\" data-jsl10n=\"search-input-button\">Search</i>\
    \n</button>\
    \n<input type=\"hidden\" value=\"Go\" name=\"go\">\
    \n</fieldset>\
    \n</form>\
    \n</div>\
    \n<div class=\"lang-list-button-wrapper\">\
    \n<button id=\"js-lang-list-button\" class=\"lang-list-button\">\
    \n<i class=\"sprite svg-language-icon\"></i>\
    \n<span class=\"lang-list-button-text jsl10n\" data-jsl10n=\"portal.language-button-text\">Read Wikipedia in your language </span>\
    \n<i class=\"sprite svg-arrow-down-blue\"></i>\
    \n</button>\
    \n</div>\
    \n<div class=\"lang-list-border\"></div>\
    \n<div class=\"lang-list-container\">\
    \n<div id=\"js-lang-lists\" class=\"lang-list-content\">\
    \n<h2 class=\"bookshelf-container\">\
    \n<span class=\"bookshelf\">\
    \n<span class=\"text\">\
    \n<bdi dir=\"ltr\">\
    \n1&nbsp;000&nbsp;000+\
    \n</bdi>\
    \n<span class=\"jsl10n\" data-jsl10n=\"entries\">\
    \narticles\
    \n</span>\
    \n</span>\
    \n</span>\
    \n</h2>\
    \n<div class=\"langlist langlist-large hlist\" data-el-section=\"secondary links\">\
    \n<ul>\
    \n<li><a href=\"//pl.wikipedia.org/\" lang=\"pl\">Polski</a></li>\
    \n<li><a href=\"//ar.wikipedia.org/\" lang=\"ar\" title=\"Al-\202\191Arab\196\171yah\"><bdi dir=\"rtl\">\216\167\217\132\216\185\216\177\216\168\217\138\216\169</bdi></a></li>\
    \n<li><a href=\"//de.wikipedia.org/\" lang=\"de\">Deutsch</a></li>\
    \n<li><a href=\"//en.wikipedia.org/\" lang=\"en\" title=\"English\">English</a></li>\
    \n<li><a href=\"//es.wikipedia.org/\" lang=\"es\">Espa\195\177ol</a></li>\
    \n<li><a href=\"//fr.wikipedia.org/\" lang=\"fr\" title=\"fran\195\167ais\">Fran\195\167ais</a></li>\
    \n<li><a href=\"//it.wikipedia.org/\" lang=\"it\">Italiano</a></li>\
    \n<li><a href=\"//arz.wikipedia.org/\" lang=\"arz\" title=\"Ma\225\185\163r\196\171\"><bdi dir=\"rtl\">\217\133\216\181\216\177\217\137</bdi></a></li>\
    \n<li><a href=\"//nl.wikipedia.org/\" lang=\"nl\">Nederlands</a></li>\
    \n<li><a href=\"//ja.wikipedia.org/\" lang=\"ja\" title=\"Nihongo\">\230\151\165\230\156\172\232\170\158</a></li>\
    \n<li><a href=\"//pt.wikipedia.org/\" lang=\"pt\">Portugu\195\170s</a></li>\
    \n<li><a href=\"//ceb.wikipedia.org/\" lang=\"ceb\">Sinugboanong Binisaya</a></li>\
    \n<li><a href=\"//sv.wikipedia.org/\" lang=\"sv\">Svenska</a></li>\
    \n<li><a href=\"//uk.wikipedia.org/\" lang=\"uk\" title=\"Ukrayins\226\128\153ka\">\208\163\208\186\209\128\208\176\209\151\208\189\209\129\209\140\208\186\208\176</a></li>\
    \n<li><a href=\"//vi.wikipedia.org/\" lang=\"vi\">Ti\225\186\191ng Vi\225\187\135t</a></li>\
    \n<li><a href=\"//war.wikipedia.org/\" lang=\"war\">Winaray</a></li>\
    \n<li><a href=\"//zh.wikipedia.org/\" lang=\"zh\" title=\"Zh\197\141ngw\195\169n\">\228\184\173\230\150\135</a></li>\
    \n<li><a href=\"//ru.wikipedia.org/\" lang=\"ru\" title=\"Russkiy\">\208\160\209\131\209\129\209\129\208\186\208\184\208\185</a></li>\
    \n</ul>\
    \n</div>\
    \n<h2 class=\"bookshelf-container\">\
    \n<span class=\"bookshelf\">\
    \n<span class=\"text\">\
    \n<bdi dir=\"ltr\">\
    \n100&nbsp;000+\
    \n</bdi>\
    \n<span class=\"jsl10n\" data-jsl10n=\"portal.entries\">\
    \narticles\
    \n</span>\
    \n</span>\
    \n</span>\
    \n</h2>\
    \n<div class=\"langlist langlist-large hlist\" data-el-section=\"secondary links\">\
    \n<ul>\
    \n<li><a href=\"//af.wikipedia.org/\" lang=\"af\">Afrikaans</a></li>\
    \n<li><a href=\"//ast.wikipedia.org/\" lang=\"ast\">Asturianu</a></li>\
    \n<li><a href=\"//az.wikipedia.org/\" lang=\"az\">Az\201\153rbaycanca</a></li>\
    \n<li><a href=\"//bg.wikipedia.org/\" lang=\"bg\" title=\"B\199\142lgarski\">\208\145\209\138\208\187\208\179\208\176\209\128\209\129\208\186\208\184</a></li>\
    \n<li><a href=\"//zh-min-nan.wikipedia.org/\" lang=\"nan\">B\195\162n-l\195\162m-g\195\186 / H\197\141-l\195\179-o\196\147</a></li>\
    \n<li><a href=\"//bn.wikipedia.org/\" lang=\"bn\" title=\"Bangla\">\224\166\172\224\166\190\224\166\130\224\166\178\224\166\190</a></li>\
    \n<li><a href=\"//be.wikipedia.org/\" lang=\"be\" title=\"Belaruskaya\">\208\145\208\181\208\187\208\176\209\128\209\131\209\129\208\186\208\176\209\143</a></li>\
    \n<li><a href=\"//ca.wikipedia.org/\" lang=\"ca\">Catal\195\160</a></li>\
    \n<li><a href=\"//cs.wikipedia.org/\" lang=\"cs\" title=\"\196\141e\197\161tina\">\196\140e\197\161tina</a></li>\
    \n<li><a href=\"//cy.wikipedia.org/\" lang=\"cy\" title=\"Cymraeg\">Cymraeg</a></li>\
    \n<li><a href=\"//da.wikipedia.org/\" lang=\"da\">Dansk</a></li>\
    \n<li><a href=\"//et.wikipedia.org/\" lang=\"et\">Eesti</a></li>\
    \n<li><a href=\"//el.wikipedia.org/\" lang=\"el\" title=\"Ell\196\171nik\195\161\">\206\149\206\187\206\187\206\183\206\189\206\185\206\186\206\172</a></li>\
    \n<li><a href=\"//eo.wikipedia.org/\" lang=\"eo\">Esperanto</a></li>\
    \n<li><a href=\"//eu.wikipedia.org/\" lang=\"eu\">Euskara</a></li>\
    \n<li><a href=\"//fa.wikipedia.org/\" lang=\"fa\" title=\"F\196\129rsi\"><bdi dir=\"rtl\">\217\129\216\167\216\177\216\179\219\140</bdi></a></li>\
    \n<li><a href=\"//gl.wikipedia.org/\" lang=\"gl\">Galego</a></li>\
    \n<li><a href=\"//ko.wikipedia.org/\" lang=\"ko\" title=\"Hangugeo\">\237\149\156\234\181\173\236\150\180</a></li>\
    \n<li><a href=\"//hi.wikipedia.org/\" lang=\"hi\" title=\"Hind\196\171\">\224\164\185\224\164\191\224\164\168\224\165\141\224\164\166\224\165\128</a></li>\
    \n<li><a href=\"//hr.wikipedia.org/\" lang=\"hr\">Hrvatski</a></li>\
    \n<li><a href=\"//id.wikipedia.org/\" lang=\"id\">Bahasa Indonesia</a></li>\
    \n<li><a href=\"//he.wikipedia.org/\" lang=\"he\" title=\"Ivrit\"><bdi dir=\"rtl\">\215\162\215\145\215\168\215\153\215\170</bdi></a></li>\
    \n<li><a href=\"//ka.wikipedia.org/\" lang=\"ka\" title=\"Kartuli\">\225\131\165\225\131\144\225\131\160\225\131\151\225\131\163\225\131\154\225\131\152</a></li>\
    \n<li><a href=\"//la.wikipedia.org/\" lang=\"la\">Latina</a></li>\
    \n<li><a href=\"//lv.wikipedia.org/\" lang=\"lv\">Latvie\197\161u</a></li>\
    \n<li><a href=\"//lt.wikipedia.org/\" lang=\"lt\">Lietuvi\197\179</a></li>\
    \n<li><a href=\"//hu.wikipedia.org/\" lang=\"hu\">Magyar</a></li>\
    \n<li><a href=\"//mk.wikipedia.org/\" lang=\"mk\" title=\"Makedonski\">\208\156\208\176\208\186\208\181\208\180\208\190\208\189\209\129\208\186\208\184</a></li>\
    \n<li><a href=\"//ms.wikipedia.org/\" lang=\"ms\">Bahasa Melayu</a></li>\
    \n<li><a href=\"//min.wikipedia.org/\" lang=\"min\">Bahaso Minangkabau</a></li>\
    \n<li lang=\"no\">Norsk<ul><li><a href=\"//no.wikipedia.org/\" lang=\"nb\">bokm\195\165l</a></li><li><a href=\"//nn.wikipedia.org/\" lang=\"nn\">nynorsk</a></li></ul></li>\
    \n<li><a href=\"//ce.wikipedia.org/\" lang=\"ce\" title=\"Nox\195\167iyn\">\208\157\208\190\209\133\209\135\208\184\208\185\208\189</a></li>\
    \n<li><a href=\"//uz.wikipedia.org/\" lang=\"uz\" title=\"O\202\187zbekcha\">O\202\187zbekcha / \208\142\208\183\208\177\208\181\208\186\209\135\208\176</a></li>\
    \n<li><a href=\"//kk.wikipedia.org/\" lang=\"kk\"><span lang=\"kk-Cyrl\">\210\154\208\176\208\183\208\176\210\155\209\136\208\176</span> / <span lang=\"kk-Latn\">Qazaq\197\159a</span> / <bdi lang=\"kk-Arab\" dir=\"rtl\">\217\130\216\167\216\178\216\167\217\130\216\180\216\167</bdi></a></li>\
    \n<li><a href=\"//ro.wikipedia.org/\" lang=\"ro\" title=\"Rom\195\162n\196\131\">Rom\195\162n\196\131</a></li>\
    \n<li><a href=\"//simple.wikipedia.org/\" lang=\"en\">Simple English</a></li>\
    \n<li><a href=\"//sk.wikipedia.org/\" lang=\"sk\">Sloven\196\141ina</a></li>\
    \n<li><a href=\"//sl.wikipedia.org/\" lang=\"sl\" title=\"sloven\197\161\196\141ina\">Sloven\197\161\196\141ina</a></li>\
    \n<li><a href=\"//sr.wikipedia.org/\" lang=\"sr\">\208\161\209\128\208\191\209\129\208\186\208\184 / Srpski</a></li>\
    \n<li><a href=\"//sh.wikipedia.org/\" lang=\"sh\">Srpskohrvatski / \208\161\209\128\208\191\209\129\208\186\208\190\209\133\209\128\208\178\208\176\209\130\209\129\208\186\208\184</a></li>\
    \n<li><a href=\"//fi.wikipedia.org/\" lang=\"fi\" title=\"suomi\">Suomi</a></li>\
    \n<li><a href=\"//ta.wikipedia.org/\" lang=\"ta\" title=\"Tami\225\184\187\">\224\174\164\224\174\174\224\174\191\224\174\180\224\175\141</a></li>\
    \n<li><a href=\"//tt.wikipedia.org/\" lang=\"tt\">\208\162\208\176\209\130\208\176\209\128\209\135\208\176 / Tatar\195\167a</a></li>\
    \n<li><a href=\"//th.wikipedia.org/\" lang=\"th\" title=\"Phasa Thai\">\224\184\160\224\184\178\224\184\169\224\184\178\224\185\132\224\184\151\224\184\162</a></li>\
    \n<li><a href=\"//tg.wikipedia.org/\" lang=\"tg\" title=\"Tojik\196\171\">\208\162\208\190\210\183\208\184\208\186\211\163</a></li>\
    \n<li><a href=\"//azb.wikipedia.org/\" lang=\"azb\" title=\"T\195\188rkce\"><bdi dir=\"rtl\">\216\170\219\134\216\177\218\169\216\172\217\135</bdi></a></li>\
    \n<li><a href=\"//tr.wikipedia.org/\" lang=\"tr\" title=\"T\195\188rk\195\167e\">T\195\188rk\195\167e</a></li>\
    \n<li><a href=\"//ur.wikipedia.org/\" lang=\"ur\" title=\"Urdu\"><bdi dir=\"rtl\">\216\167\216\177\216\175\217\136</bdi></a></li>\
    \n<li><a href=\"//zh-yue.wikipedia.org/\" lang=\"yue\" title=\"Yuht Y\195\186h / Jyut6 jyu5\">\231\178\181\232\170\158</a></li>\
    \n<li><a href=\"//hy.wikipedia.org/\" lang=\"hy\" title=\"Hayeren\">\213\128\213\161\213\181\213\165\214\128\213\165\213\182</a></li>\
    \n<li><a href=\"//my.wikipedia.org/\" lang=\"my\" title=\"Myanmarsar\">\225\128\153\225\128\188\225\128\148\225\128\186\225\128\153\225\128\172\225\128\152\225\128\172\225\128\158\225\128\172</a></li>\
    \n</ul>\
    \n</div>\
    \n<h2 class=\"bookshelf-container\">\
    \n<span class=\"bookshelf\">\
    \n<span class=\"text\">\
    \n<bdi dir=\"ltr\">\
    \n10&nbsp;000+\
    \n</bdi>\
    \n<span class=\"jsl10n\" data-jsl10n=\"portal.entries\">\
    \narticles\
    \n</span>\
    \n</span>\
    \n</span>\
    \n</h2>\
    \n<div class=\"langlist hlist\" data-el-section=\"secondary links\">\
    \n<ul>\
    \n<li><a href=\"//ace.wikipedia.org/\" lang=\"ace\">Bahsa Ac\195\168h</a></li>\
    \n<li><a href=\"//als.wikipedia.org/\" lang=\"gsw\">Alemannisch</a></li>\
    \n<li><a href=\"//am.wikipedia.org/\" lang=\"am\" title=\"\196\128mari\195\177\195\177\196\129\">\225\138\160\225\136\155\225\136\173\225\138\155</a></li>\
    \n<li><a href=\"//an.wikipedia.org/\" lang=\"an\">Aragon\195\169s</a></li>\
    \n<li><a href=\"//hyw.wikipedia.org/\" lang=\"hyw\" title=\"Arevmdahayeren\">\212\177\214\128\213\165\214\130\213\180\213\191\213\161\213\176\213\161\213\181\213\165\214\128\213\167\213\182</a></li>\
    \n<li><a href=\"//ban.wikipedia.org/\" lang=\"ban\" title=\"Basa Bali\">Basa Bali</a></li>\
    \n<li><a href=\"//bjn.wikipedia.org/\" lang=\"bjn\">Bahasa Banjar</a></li>\
    \n<li><a href=\"//map-bms.wikipedia.org/\" lang=\"map-x-bms\">Basa Banyumasan</a></li>\
    \n<li><a href=\"//ba.wikipedia.org/\" lang=\"ba\" title=\"Ba\197\159qortsa\">\208\145\208\176\209\136\210\161\208\190\209\128\209\130\209\129\208\176</a></li>\
    \n<li><a href=\"//be-tarask.wikipedia.org/\" lang=\"be\" title=\"Belaruskaya (Tara\197\161kievica)\">\208\145\208\181\208\187\208\176\209\128\209\131\209\129\208\186\208\176\209\143 (\208\162\208\176\209\128\208\176\209\136\208\186\208\181\208\178\209\150\209\134\208\176)</a></li>\
    \n<li><a href=\"//bcl.wikipedia.org/\" lang=\"bcl\">Bikol Central</a></li>\
    \n<li><a href=\"//bpy.wikipedia.org/\" lang=\"bpy\" title=\"Bishnupriya Manipuri\">\224\166\172\224\166\191\224\166\183\224\167\141\224\166\163\224\167\129\224\166\170\224\167\141\224\166\176\224\166\191\224\166\175\224\166\188\224\166\190 \224\166\174\224\166\163\224\166\191\224\166\170\224\167\129\224\166\176\224\167\128</a></li>\
    \n<li><a href=\"//bar.wikipedia.org/\" lang=\"bar\">Boarisch</a></li>\
    \n<li><a href=\"//bs.wikipedia.org/\" lang=\"bs\">Bosanski</a></li>\
    \n<li><a href=\"//br.wikipedia.org/\" lang=\"br\">Brezhoneg</a></li>\
    \n<li><a href=\"//cv.wikipedia.org/\" lang=\"cv\" title=\"\196\140\196\131va\197\161la\">\208\167\211\145\208\178\208\176\209\136\208\187\208\176</a></li>\
    \n<li><a href=\"//nv.wikipedia.org/\" lang=\"nv\">Din\195\169 Bizaad</a></li>\
    \n<li><a href=\"//eml.wikipedia.org/\" lang=\"roa-x-eml\">Emigli\195\160n\226\128\147Rumagn\195\178l</a></li>\
    \n<li><a href=\"//hif.wikipedia.org/\" lang=\"hif\">Fiji Hindi</a></li>\
    \n<li><a href=\"//fo.wikipedia.org/\" lang=\"fo\">F\195\184royskt</a></li>\
    \n<li><a href=\"//fy.wikipedia.org/\" lang=\"fy\">Frysk</a></li>\
    \n<li><a href=\"//ga.wikipedia.org/\" lang=\"ga\">Gaeilge</a></li>\
    \n<li><a href=\"//gd.wikipedia.org/\" lang=\"gd\">G\195\160idhlig</a></li>\
    \n<li><a href=\"//gu.wikipedia.org/\" lang=\"gu\" title=\"Gujarati\">\224\170\151\224\171\129\224\170\156\224\170\176\224\170\190\224\170\164\224\171\128</a></li>\
    \n<li><a href=\"//hak.wikipedia.org/\" lang=\"hak\">Hak-k\195\162-ng\195\174 / \229\174\162\229\174\182\232\170\158</a></li>\
    \n<li><a href=\"//ha.wikipedia.org/\" lang=\"ha\" title=\"Hausa\">Hausa</a></li>\
    \n<li><a href=\"//hsb.wikipedia.org/\" lang=\"hsb\">Hornjoserbsce</a></li>\
    \n<li><a href=\"//io.wikipedia.org/\" lang=\"io\" title=\"Ido\">Ido</a></li>\
    \n<li><a href=\"//ig.wikipedia.org/\" lang=\"ig\">Igbo</a></li>\
    \n<li><a href=\"//ilo.wikipedia.org/\" lang=\"ilo\">Ilokano</a></li>\
    \n<li><a href=\"//ia.wikipedia.org/\" lang=\"ia\">Interlingua</a></li>\
    \n<li><a href=\"//ie.wikipedia.org/\" lang=\"ie\">Interlingue</a></li>\
    \n<li><a href=\"//os.wikipedia.org/\" lang=\"os\" title=\"Iron\">\208\152\209\128\208\190\208\189</a></li>\
    \n<li><a href=\"//is.wikipedia.org/\" lang=\"is\">\195\141slenska</a></li>\
    \n<li><a href=\"//jv.wikipedia.org/\" lang=\"jv\" title=\"Jawa\">Jawa</a></li>\
    \n<li><a href=\"//kn.wikipedia.org/\" lang=\"kn\" title=\"Kannada\">\224\178\149\224\178\168\224\179\141\224\178\168\224\178\161</a></li>\
    \n<li><a href=\"//km.wikipedia.org/\" lang=\"km\" title=\"Ph\195\169asa Khm\195\169r\">\225\158\151\225\158\182\225\158\159\225\158\182\225\158\129\225\159\146\225\158\152\225\159\130\225\158\154</a></li>\
    \n<li><a href=\"//ht.wikipedia.org/\" lang=\"ht\">Krey\195\178l Ayisyen</a></li>\
    \n<li><a href=\"//ku.wikipedia.org/\" lang=\"ku\"><span lang=\"ku-Latn\">Kurd\195\174</span> / <bdi lang=\"ku-Arab\" dir=\"rtl\">\217\131\217\136\216\177\216\175\219\140</bdi></a></li>\
    \n<li><a href=\"//ckb.wikipedia.org/\" lang=\"ckb\" title=\"Kurd\195\174y Nawend\195\174\"><bdi dir=\"rtl\">\218\169\217\136\216\177\216\175\219\140\219\140 \217\134\216\167\217\136\219\149\217\134\216\175\219\140</bdi></a></li>\
    \n<li><a href=\"//ky.wikipedia.org/\" lang=\"ky\" title=\"Kyrgyz\196\141a\">\208\154\209\139\209\128\208\179\209\139\208\183\209\135\208\176</a></li>\
    \n<li><a href=\"//mrj.wikipedia.org/\" lang=\"mjr\" title=\"Kyryk Mary\">\208\154\209\139\209\128\209\139\208\186 \208\188\208\176\209\128\209\139</a></li>\
    \n<li><a href=\"//lb.wikipedia.org/\" lang=\"lb\">L\195\171tzebuergesch</a></li>\
    \n<li><a href=\"//lij.wikipedia.org/\" lang=\"lij\">L\195\172gure</a></li>\
    \n<li><a href=\"//li.wikipedia.org/\" lang=\"li\">Limburgs</a></li>\
    \n<li><a href=\"//lmo.wikipedia.org/\" lang=\"lmo\">Lombard</a></li>\
    \n<li><a href=\"//mai.wikipedia.org/\" lang=\"mai\" title=\"Maithil\196\171\">\224\164\174\224\165\136\224\164\165\224\164\191\224\164\178\224\165\128</a></li>\
    \n<li><a href=\"//mg.wikipedia.org/\" lang=\"mg\">Malagasy</a></li>\
    \n<li><a href=\"//ml.wikipedia.org/\" lang=\"ml\" title=\"Malayalam\">\224\180\174\224\180\178\224\180\175\224\180\190\224\180\179\224\180\130</a></li>\
    \n<li><a href=\"//zh-classical.wikipedia.org/\" lang=\"lzh\" title=\"Man4jin4 / W\195\169ny\195\161n\">\230\150\135\232\168\128</a></li>\
    \n<li><a href=\"//mr.wikipedia.org/\" lang=\"mr\" title=\"Marathi\">\224\164\174\224\164\176\224\164\190\224\164\160\224\165\128</a></li>\
    \n<li><a href=\"//xmf.wikipedia.org/\" lang=\"xmf\" title=\"Margaluri\">\225\131\155\225\131\144\225\131\160\225\131\146\225\131\144\225\131\154\225\131\163\225\131\160\225\131\152</a></li>\
    \n<li><a href=\"//mzn.wikipedia.org/\" lang=\"mzn\" title=\"M\195\164zeruni\"><bdi dir=\"rtl\">\217\133\216\167\216\178\217\144\216\177\217\136\217\134\219\140</bdi></a></li>\
    \n<li><a href=\"//cdo.wikipedia.org/\" lang=\"cdo\" title=\"Ming-deng-ngu\">M\195\172ng-d\196\149\204\164ng-ng\225\185\179\204\132 / \233\150\169\230\157\177\232\170\158</a></li>\
    \n<li><a href=\"//mn.wikipedia.org/\" lang=\"mn\" title=\"Mongol\">\208\156\208\190\208\189\208\179\208\190\208\187</a></li>\
    \n<li><a href=\"//nap.wikipedia.org/\" lang=\"nap\">Napulitano</a></li>\
    \n<li><a href=\"//new.wikipedia.org/\" lang=\"new\" title=\"Nepal Bhasa\">\224\164\168\224\165\135\224\164\170\224\164\190\224\164\178 \224\164\173\224\164\190\224\164\183\224\164\190</a></li>\
    \n<li><a href=\"//ne.wikipedia.org/\" lang=\"ne\" title=\"Nep\196\129l\196\171\">\224\164\168\224\165\135\224\164\170\224\164\190\224\164\178\224\165\128</a></li>\
    \n<li><a href=\"//frr.wikipedia.org/\" lang=\"frr\">Nordfriisk</a></li>\
    \n<li><a href=\"//oc.wikipedia.org/\" lang=\"oc\">Occitan</a></li>\
    \n<li><a href=\"//mhr.wikipedia.org/\" lang=\"mhr\" title=\"Olyk Marij\">\208\158\208\187\209\139\208\186 \208\188\208\176\209\128\208\184\208\185</a></li>\
    \n<li><a href=\"//or.wikipedia.org/\" lang=\"or\" title=\"O\225\185\155i\196\129\">\224\172\147\224\172\161\224\172\191\224\172\188\224\172\134</a></li>\
    \n<li><a href=\"//as.wikipedia.org/\" lang=\"as\" title=\"\195\148x\195\180miya\">\224\166\133\224\166\184\224\166\174\224\167\128\224\166\175\224\166\190\224\166\188</a></li>\
    \n<li><a href=\"//pa.wikipedia.org/\" lang=\"pa\" title=\"Pa\195\177j\196\129b\196\171 (Gurmukh\196\171)\">\224\168\170\224\169\176\224\168\156\224\168\190\224\168\172\224\169\128 (\224\168\151\224\169\129\224\168\176\224\168\174\224\169\129\224\168\150\224\169\128)</a></li>\
    \n<li><a href=\"//pnb.wikipedia.org/\" lang=\"pnb\" title=\"Pa\195\177j\196\129b\196\171 (Sh\196\129hmukh\196\171)\"><bdi dir=\"rtl\">\217\190\217\134\216\172\216\167\216\168\219\140 (\216\180\216\167\219\129 \217\133\218\169\218\190\219\140)</bdi></a></li>\
    \n<li><a href=\"//ps.wikipedia.org/\" lang=\"ps\" title=\"Pa\202\130to\"><bdi dir=\"rtl\">\217\190\218\154\216\170\217\136</bdi></a></li>\
    \n<li><a href=\"//pms.wikipedia.org/\" lang=\"pms\">Piemont\195\168is</a></li>\
    \n<li><a href=\"//nds.wikipedia.org/\" lang=\"nds\">Plattd\195\188\195\188tsch</a></li>\
    \n<li><a href=\"//crh.wikipedia.org/\" lang=\"crh\">Q\196\177r\196\177mtatarca</a></li>\
    \n<li><a href=\"//qu.wikipedia.org/\" lang=\"qu\">Runa Simi</a></li>\
    \n<li><a href=\"//sa.wikipedia.org/\" lang=\"sa\" title=\"Sa\225\185\131sk\225\185\155tam\">\224\164\184\224\164\130\224\164\184\224\165\141\224\164\149\224\165\131\224\164\164\224\164\174\224\165\141</a></li>\
    \n<li><a href=\"//sah.wikipedia.org/\" lang=\"sah\" title=\"Saxa Tyla\">\208\161\208\176\209\133\208\176 \208\162\209\139\208\187\208\176</a></li>\
    \n<li><a href=\"//sco.wikipedia.org/\" lang=\"sco\">Scots</a></li>\
    \n<li><a href=\"//sn.wikipedia.org/\" lang=\"sn\">ChiShona</a></li>\
    \n<li><a href=\"//sq.wikipedia.org/\" lang=\"sq\">Shqip</a></li>\
    \n<li><a href=\"//scn.wikipedia.org/\" lang=\"scn\">Sicilianu</a></li>\
    \n<li><a href=\"//si.wikipedia.org/\" lang=\"si\" title=\"Si\225\185\131hala\">\224\183\131\224\183\146\224\182\130\224\183\132\224\182\189</a></li>\
    \n<li><a href=\"//sd.wikipedia.org/\" lang=\"sd\" title=\"Sindh\196\171\"><bdi dir=\"rtl\">\216\179\217\134\218\140\217\138</bdi></a></li>\
    \n<li><a href=\"//szl.wikipedia.org/\" lang=\"szl\">\197\154l\197\175nski</a></li>\
    \n<li><a href=\"//su.wikipedia.org/\" lang=\"su\">Basa Sunda</a></li>\
    \n<li><a href=\"//sw.wikipedia.org/\" lang=\"sw\">Kiswahili</a></li>\
    \n<li><a href=\"//tl.wikipedia.org/\" lang=\"tl\">Tagalog</a></li>\
    \n<li><a href=\"//shn.wikipedia.org/\" lang=\"shn\">\225\129\189\225\130\131\225\130\135\225\128\158\225\130\131\225\130\135\225\128\144\225\130\134\225\128\184</a></li>\
    \n<li><a href=\"//te.wikipedia.org/\" lang=\"te\" title=\"Telugu\">\224\176\164\224\177\134\224\176\178\224\177\129\224\176\151\224\177\129</a></li>\
    \n<li><a href=\"//tum.wikipedia.org/\" lang=\"tum\">chiTumbuka</a></li>\
    \n<li><a href=\"//bug.wikipedia.org/\" lang=\"bug\">Basa Ugi</a></li>\
    \n<li><a href=\"//vec.wikipedia.org/\" lang=\"vec\">V\195\168neto</a></li>\
    \n<li><a href=\"//vo.wikipedia.org/\" lang=\"vo\">Volap\195\188k</a></li>\
    \n<li><a href=\"//wa.wikipedia.org/\" lang=\"wa\">Walon</a></li>\
    \n<li><a href=\"//wuu.wikipedia.org/\" lang=\"wuu\" title=\"W\195\186y\199\148\">\229\144\180\232\175\173</a></li>\
    \n<li><a href=\"//yi.wikipedia.org/\" lang=\"yi\" title=\"Yidi\197\161\"><bdi dir=\"rtl\">\215\153\215\153\214\180\215\147\215\153\215\169</bdi></a></li>\
    \n<li><a href=\"//yo.wikipedia.org/\" lang=\"yo\">Yor\195\185b\195\161</a></li>\
    \n<li><a href=\"//diq.wikipedia.org/\" lang=\"diq\" title=\"Zazaki\">Zazaki</a></li>\
    \n<li><a href=\"//bat-smg.wikipedia.org/\" lang=\"sgs\">\197\189emait\196\151\197\161ka</a></li>\
    \n<li><a href=\"//zu.wikipedia.org/\" lang=\"zu\">isiZulu</a></li>\
    \n</ul>\
    \n</div>\
    \n<h2 class=\"bookshelf-container\">\
    \n<span class=\"bookshelf\">\
    \n<span class=\"text\">\
    \n<bdi dir=\"ltr\">\
    \n1&nbsp;000+\
    \n</bdi>\
    \n<span class=\"jsl10n\" data-jsl10n=\"portal.entries\">\
    \narticles\
    \n</span>\
    \n</span>\
    \n</span>\
    \n</h2>\
    \n<div class=\"langlist hlist\" data-el-section=\"secondary links\">\
    \n<ul>\
    \n<li><a href=\"//lad.wikipedia.org/\" lang=\"lad\"><span lang=\"lad-Latn\">Dzhudezmo</span> / <bdi lang=\"lad-Hebr\" dir=\"rtl\">\215\156\215\144\215\147\215\153\215\160\215\149</bdi></a></li>\
    \n<li><a href=\"//kbd.wikipedia.org/\" lang=\"kbd\" title=\"Adighabze\">\208\144\208\180\209\139\208\179\209\141\208\177\208\183\209\141</a></li>\
    \n<li><a href=\"//ang.wikipedia.org/\" lang=\"ang\">\195\134nglisc</a></li>\
    \n<li><a href=\"//smn.wikipedia.org/\" lang=\"smn\" title=\"anar\195\162\197\161kiel\195\162\">Anar\195\162\197\161kiel\195\162</a></li>\
    \n<li><a href=\"//anp.wikipedia.org/\" lang=\"anp\" title=\"Angika\">\224\164\133\224\164\130\224\164\151\224\164\191\224\164\149\224\164\190</a></li>\
    \n<li><a href=\"//ab.wikipedia.org/\" lang=\"ab\" title=\"a\225\185\151sshwa\">\208\176\212\165\209\129\209\136\211\153\208\176</a></li>\
    \n<li><a href=\"//roa-rup.wikipedia.org/\" lang=\"roa-rup\">Arm\195\163neashce</a></li>\
    \n<li><a href=\"//frp.wikipedia.org/\" lang=\"frp\">Arpitan</a></li>\
    \n<li><a href=\"//arc.wikipedia.org/\" lang=\"arc\" title=\"\196\128t\195\187r\196\129y\195\162\"><bdi dir=\"rtl\">\220\144\220\172\220\152\220\170\220\157\220\144</bdi></a></li>\
    \n<li><a href=\"//gn.wikipedia.org/\" lang=\"gn\">Ava\195\177e\226\128\153\225\186\189</a></li>\
    \n<li><a href=\"//av.wikipedia.org/\" lang=\"av\" title=\"Avar\">\208\144\208\178\208\176\209\128</a></li>\
    \n<li><a href=\"//ay.wikipedia.org/\" lang=\"ay\">Aymar</a></li>\
    \n<li><a href=\"//bh.wikipedia.org/\" lang=\"bh\" title=\"Bh\197\141japur\196\171\">\224\164\173\224\165\139\224\164\156\224\164\170\224\165\129\224\164\176\224\165\128</a></li>\
    \n<li><a href=\"//bi.wikipedia.org/\" lang=\"bi\">Bislama</a></li>\
    \n<li><a href=\"//bo.wikipedia.org/\" lang=\"bo\" title=\"Bod Skad\">\224\189\150\224\189\188\224\189\145\224\188\139\224\189\161\224\189\178\224\189\130</a></li>\
    \n<li><a href=\"//bxr.wikipedia.org/\" lang=\"bxr\" title=\"Buryad\">\208\145\209\131\209\128\209\143\208\176\208\180</a></li>\
    \n<li><a href=\"//cbk-zam.wikipedia.org/\" lang=\"cbk-x-zam\">Chavacano de Zamboanga</a></li>\
    \n<li><a href=\"//ny.wikipedia.org/\" lang=\"ny\">Chichewa</a></li>\
    \n<li><a href=\"//co.wikipedia.org/\" lang=\"co\">Corsu</a></li>\
    \n<li><a href=\"//za.wikipedia.org/\" lang=\"za\">Vahcuengh / \232\169\177\229\131\174</a></li>\
    \n<li><a href=\"//dag.wikipedia.org/\" lang=\"dag\">Dagbanli</a></li>\
    \n<li><a href=\"//ary.wikipedia.org/\" lang=\"ary\" title=\"Darija\"><bdi dir=\"rtl\">\216\167\217\132\216\175\216\167\216\177\216\172\216\169</bdi></a></li>\
    \n<li><a href=\"//se.wikipedia.org/\" lang=\"se\" title=\"davvis\195\161megiella\">Davvis\195\161megiella</a></li>\
    \n<li><a href=\"//pdc.wikipedia.org/\" lang=\"pdc\">Deitsch</a></li>\
    \n<li><a href=\"//dv.wikipedia.org/\" lang=\"dv\" title=\"Divehi\"><bdi dir=\"rtl\">\222\139\222\168\222\136\222\172\222\128\222\168\222\132\222\166\222\144\222\176</bdi></a></li>\
    \n<li><a href=\"//dsb.wikipedia.org/\" lang=\"dsb\">Dolnoserbski</a></li>\
    \n<li><a href=\"//myv.wikipedia.org/\" lang=\"myv\" title=\"Erzjanj\">\208\173\209\128\208\183\209\143\208\189\209\140</a></li>\
    \n<li><a href=\"//ext.wikipedia.org/\" lang=\"ext\">Estreme\195\177u</a></li>\
    \n<li><a href=\"//ff.wikipedia.org/\" lang=\"ff\">Fulfulde</a></li>\
    \n<li><a href=\"//fur.wikipedia.org/\" lang=\"fur\">Furlan</a></li>\
    \n<li><a href=\"//gv.wikipedia.org/\" lang=\"gv\">Gaelg</a></li>\
    \n<li><a href=\"//gag.wikipedia.org/\" lang=\"gag\">Gagauz</a></li>\
    \n<li><a href=\"//inh.wikipedia.org/\" lang=\"inh\" title=\"Ghalghai\">\208\147\211\128\208\176\208\187\208\179\211\128\208\176\208\185</a></li>\
    \n<li><a href=\"//ki.wikipedia.org/\" lang=\"ki\">G\196\169k\197\169y\197\169</a></li>\
    \n<li><a href=\"//glk.wikipedia.org/\" lang=\"glk\" title=\"Gil\201\153ki\"><bdi dir=\"rtl\">\218\175\219\140\217\132\218\169\219\140</bdi></a></li>\
    \n<li><a href=\"//gan.wikipedia.org/\" lang=\"gan\" title=\"Gon ua\" data-hans=\"\232\181\163\232\175\173\" data-hant=\"\232\180\155\232\170\158\" class=\"jscnconv\">\232\181\163\232\175\173 / \232\180\155\232\170\158</a></li>\
    \n<li><a href=\"//guw.wikipedia.org/\" lang=\"guw\">Gungbe</a></li>\
    \n<li><a href=\"//xal.wikipedia.org/\" lang=\"xal\" title=\"Hal\202\185mg\">\208\165\208\176\208\187\209\140\208\188\208\179</a></li>\
    \n<li><a href=\"//haw.wikipedia.org/\" lang=\"haw\">\202\187\197\140lelo Hawai\202\187i</a></li>\
    \n<li><a href=\"//rw.wikipedia.org/\" lang=\"rw\">Ikinyarwanda</a></li>\
    \n<li><a href=\"//kbp.wikipedia.org/\" lang=\"kbp\">Kab\201\169y\201\155</a></li>\
    \n<li><a href=\"//pam.wikipedia.org/\" lang=\"pam\">Kapampangan</a></li>\
    \n<li><a href=\"//csb.wikipedia.org/\" lang=\"csb\">Kasz\195\171bsczi</a></li>\
    \n<li><a href=\"//kw.wikipedia.org/\" lang=\"kw\">Kernewek</a></li>\
    \n<li><a href=\"//kv.wikipedia.org/\" lang=\"kv\" title=\"Komi\">\208\154\208\190\208\188\208\184</a></li>\
    \n<li><a href=\"//koi.wikipedia.org/\" lang=\"koi\" title=\"Perem Komi\">\208\159\208\181\209\128\208\181\208\188 \208\186\208\190\208\188\208\184</a></li>\
    \n<li><a href=\"//kg.wikipedia.org/\" lang=\"kg\">Kongo</a></li>\
    \n<li><a href=\"//gom.wikipedia.org/\" lang=\"gom\">\224\164\149\224\165\139\224\164\130\224\164\149\224\164\163\224\165\128 / Konknni</a></li>\
    \n<li><a href=\"//ks.wikipedia.org/\" lang=\"ks\" title=\"Koshur\"><bdi dir=\"rtl\">\217\131\217\178\216\180\217\143\216\177</bdi></a></li>\
    \n<li><a href=\"//gcr.wikipedia.org/\" lang=\"gcr\" title=\"Kriy\195\178l Gwiyannen\">Kriy\195\178l Gwiyannen</a></li>\
    \n<li><a href=\"//lo.wikipedia.org/\" lang=\"lo\" title=\"Phaasaa Laao\">\224\186\158\224\186\178\224\186\170\224\186\178\224\186\165\224\186\178\224\186\167</a></li>\
    \n<li><a href=\"//lbe.wikipedia.org/\" lang=\"lbe\" title=\"Lakku\">\208\155\208\176\208\186\208\186\209\131</a></li>\
    \n<li><a href=\"//ltg.wikipedia.org/\" lang=\"ltg\">Latga\196\188u</a></li>\
    \n<li><a href=\"//lez.wikipedia.org/\" lang=\"lez\" title=\"Lezgi\">\208\155\208\181\208\183\208\179\208\184</a></li>\
    \n<li><a href=\"//nia.wikipedia.org/\" lang=\"nia\">Li Niha</a></li>\
    \n<li><a href=\"//ln.wikipedia.org/\" lang=\"ln\">Ling\195\161la</a></li>\
    \n<li><a href=\"//jbo.wikipedia.org/\" lang=\"jbo\">lojban</a></li>\
    \n<li><a href=\"//lg.wikipedia.org/\" lang=\"lg\">Luganda</a></li>\
    \n<li><a href=\"//mad.wikipedia.org/\" lang=\"mad\">Madhur\195\162</a></li>\
    \n<li><a href=\"//mt.wikipedia.org/\" lang=\"mt\">Malti</a></li>\
    \n<li><a href=\"//mi.wikipedia.org/\" lang=\"mi\">M\196\129ori</a></li>\
    \n<li><a href=\"//tw.wikipedia.org/\" lang=\"tw\" title=\"Mfantse\">Twi</a></li>\
    \n<li><a href=\"//mwl.wikipedia.org/\" lang=\"mwl\">Mirand\195\169s</a></li>\
    \n<li><a href=\"//mdf.wikipedia.org/\" lang=\"mdf\" title=\"Mok\197\161enj\">\208\156\208\190\208\186\209\136\208\181\208\189\209\140</a></li>\
    \n<li><a href=\"//mnw.wikipedia.org/\" lang=\"mnw\">\225\128\152\225\128\172\225\128\158\225\128\172 \225\128\153\225\128\148\225\128\186</a></li>\
    \n<li><a href=\"//nqo.wikipedia.org/\" lang=\"nqo\" title=\"N&#x27;Ko\">\223\146\223\158\223\143</a></li>\
    \n<li><a href=\"//fj.wikipedia.org/\" lang=\"fj\">Na Vosa Vaka-Viti</a></li>\
    \n<li><a href=\"//nah.wikipedia.org/\" lang=\"nah\">N\196\129huatlaht\197\141lli</a></li>\
    \n<li><a href=\"//nds-nl.wikipedia.org/\" lang=\"nds-nl\">Nedersaksisch</a></li>\
    \n<li><a href=\"//nrm.wikipedia.org/\" lang=\"roa-x-nrm\">Nouormand / Normaund</a></li>\
    \n<li><a href=\"//nov.wikipedia.org/\" lang=\"nov\">Novial</a></li>\
    \n<li><a href=\"//om.wikipedia.org/\" lang=\"om\" title=\"Ingiliffaa\">Afaan Oromoo</a></li>\
    \n<li><a href=\"//blk.wikipedia.org/\" lang=\"blk\">\225\128\149\225\128\161\225\128\173\225\128\175\225\128\157\225\128\186\225\130\143\225\128\152\225\128\172\225\130\143\225\128\158\225\128\172\225\130\143</a></li>\
    \n<li><a href=\"//pi.wikipedia.org/\" lang=\"pi\" title=\"P\196\129\225\184\183i\">\224\164\170\224\164\190\224\164\178\224\164\191</a></li>\
    \n<li><a href=\"//pag.wikipedia.org/\" lang=\"pag\">Pangasin\195\161n</a></li>\
    \n<li><a href=\"//ami.wikipedia.org/\" lang=\"ami\">Pangcah</a></li>\
    \n<li><a href=\"//pap.wikipedia.org/\" lang=\"pap\">Papiamentu</a></li>\
    \n<li><a href=\"//pfl.wikipedia.org/\" lang=\"pfl\">Pf\195\164lzisch</a></li>\
    \n<li><a href=\"//pcd.wikipedia.org/\" lang=\"pcd\">Picard</a></li>\
    \n<li><a href=\"//krc.wikipedia.org/\" lang=\"krc\" title=\"Qara\195\167ay\226\128\147Malqar\">\208\154\209\138\208\176\209\128\208\176\209\135\208\176\208\185\226\128\147\208\188\208\176\208\187\208\186\209\138\208\176\209\128</a></li>\
    \n<li><a href=\"//kaa.wikipedia.org/\" lang=\"kaa\" title=\"Qaraqalpaqsha\">Qaraqalpaqsha</a></li>\
    \n<li><a href=\"//ksh.wikipedia.org/\" lang=\"ksh\">Ripoarisch</a></li>\
    \n<li><a href=\"//rm.wikipedia.org/\" lang=\"rm\">Rumantsch</a></li>\
    \n<li><a href=\"//rue.wikipedia.org/\" lang=\"rue\" title=\"Rusin\226\128\153skyj\">\208\160\209\131\209\129\208\184\208\189\209\140\209\129\208\186\209\139\208\185</a></li>\
    \n<li><a href=\"//sm.wikipedia.org/\" lang=\"sm\">Gagana S\196\129moa</a></li>\
    \n<li><a href=\"//sat.wikipedia.org/\" lang=\"sat\" title=\"Santali\">\225\177\165\225\177\159\225\177\177\225\177\155\225\177\159\225\177\178\225\177\164</a></li>\
    \n<li><a href=\"//skr.wikipedia.org/\" lang=\"skr\" title=\"Saraiki\">\216\179\216\177\216\167\216\166\219\140\218\169\219\140</a></li>\
    \n<li><a href=\"//sc.wikipedia.org/\" lang=\"sc\" title=\"Sardu\">Sardu</a></li>\
    \n<li><a href=\"//trv.wikipedia.org/\" lang=\"trv\">Seediq</a></li>\
    \n<li><a href=\"//stq.wikipedia.org/\" lang=\"stq\">Seeltersk</a></li>\
    \n<li><a href=\"//nso.wikipedia.org/\" lang=\"nso\">Sesotho sa Leboa</a></li>\
    \n<li><a href=\"//tn.wikipedia.org/\" lang=\"tn\">Setswana</a></li>\
    \n<li><a href=\"//cu.wikipedia.org/\" lang=\"cu\" title=\"Slov\196\155n\196\173sk\197\173\">\208\161\208\187\208\190\208\178\209\163\204\129\208\189\209\140\209\129\208\186\209\138 / \226\176\148\226\176\142\226\176\145\226\176\130\226\176\161\226\176\144\226\176\160\226\176\148\226\176\141\226\176\159</a></li>\
    \n<li><a href=\"//so.wikipedia.org/\" lang=\"so\">Soomaaliga</a></li>\
    \n<li><a href=\"//srn.wikipedia.org/\" lang=\"srn\">Sranantongo</a></li>\
    \n<li><a href=\"//kab.wikipedia.org/\" lang=\"kab\" title=\"Taqbaylit\">Taqbaylit</a></li>\
    \n<li><a href=\"//roa-tara.wikipedia.org/\" lang=\"roa\">Tarand\195\173ne</a></li>\
    \n<li><a href=\"//tet.wikipedia.org/\" lang=\"tet\">Tetun</a></li>\
    \n<li><a href=\"//tpi.wikipedia.org/\" lang=\"tpi\">Tok Pisin</a></li>\
    \n<li><a href=\"//to.wikipedia.org/\" lang=\"to\">faka Tonga</a></li>\
    \n<li><a href=\"//chr.wikipedia.org/\" lang=\"chr\" title=\"Tsalagi\">\225\143\163\225\142\179\225\142\169</a></li>\
    \n<li><a href=\"//tk.wikipedia.org/\" lang=\"tk\">T\195\188rkmen\195\167e</a></li>\
    \n<li><a href=\"//tyv.wikipedia.org/\" lang=\"tyv\" title=\"Tyva dyl\">\208\162\209\139\208\178\208\176 \208\180\209\139\208\187</a></li>\
    \n<li><a href=\"//udm.wikipedia.org/\" lang=\"udm\" title=\"Udmurt\">\208\163\208\180\208\188\209\131\209\128\209\130</a></li>\
    \n<li><a href=\"//ug.wikipedia.org/\" lang=\"ug\"><bdi dir=\"rtl\">\216\166\219\135\217\138\216\186\219\135\216\177\218\134\217\135</bdi></a></li>\
    \n<li><a href=\"//vep.wikipedia.org/\" lang=\"vep\">Veps\195\164n</a></li>\
    \n<li><a href=\"//fiu-vro.wikipedia.org/\" lang=\"fiu-vro\">V\195\181ro</a></li>\
    \n<li><a href=\"//vls.wikipedia.org/\" lang=\"vls\">West-Vlams</a></li>\
    \n<li><a href=\"//wo.wikipedia.org/\" lang=\"wo\">Wolof</a></li>\
    \n<li><a href=\"//xh.wikipedia.org/\" lang=\"xh\">isiXhosa</a></li>\
    \n<li><a href=\"//zea.wikipedia.org/\" lang=\"zea\">Ze\195\170uws</a></li>\
    \n<li><a href=\"//ty.wikipedia.org/\" lang=\"ty\">Reo tahiti</a></li>\
    \n</ul>\
    \n</div>\
    \n<h2 class=\"bookshelf-container\">\
    \n<span class=\"bookshelf\">\
    \n<span class=\"text\">\
    \n<bdi dir=\"ltr\">\
    \n100+\
    \n</bdi>\
    \n<span class=\"jsl10n\" data-jsl10n=\"portal.entries\">\
    \narticles\
    \n</span>\
    \n</span>\
    \n</span>\
    \n</h2>\
    \n<div class=\"langlist langlist-tiny hlist\" data-el-section=\"secondary links\">\
    \n<ul>\
    \n<li><a href=\"//bm.wikipedia.org/\" lang=\"bm\">Bamanankan</a></li>\
    \n<li><a href=\"//ch.wikipedia.org/\" lang=\"ch\">Chamoru</a></li>\
    \n<li><a href=\"//ee.wikipedia.org/\" lang=\"ee\">E\202\139egbe</a></li>\
    \n<li><a href=\"//gur.wikipedia.org/\" lang=\"gur\">Farefare</a></li>\
    \n<li><a href=\"//got.wikipedia.org/\" lang=\"got\" title=\"Gutisk\">\240\144\140\178\240\144\140\191\240\144\141\132\240\144\140\185\240\144\141\131\240\144\140\186</a></li>\
    \n<li><a href=\"//iu.wikipedia.org/\" lang=\"iu\">\225\144\131\225\147\132\225\146\131\225\145\142\225\145\144\225\145\166 / Inuktitut</a></li>\
    \n<li><a href=\"//ik.wikipedia.org/\" lang=\"ik\">I\195\177upiak</a></li>\
    \n<li><a href=\"//kl.wikipedia.org/\" lang=\"kl\">Kalaallisut</a></li>\
    \n<li><a href=\"//fat.wikipedia.org/\" lang=\"fat\">Mfantse</a></li>\
    \n<li><a href=\"//cr.wikipedia.org/\" lang=\"cr\">N\196\147hiyaw\196\147win / \225\147\128\225\144\166\225\144\131\225\148\173\225\144\141\225\144\143\225\144\163</a></li>\
    \n<li><a href=\"//pih.wikipedia.org/\" lang=\"pih\">Norfuk / Pitkern</a></li>\
    \n<li><a href=\"//pwn.wikipedia.org/\" lang=\"pwn\">pinayuanan</a></li>\
    \n<li><a href=\"//pnt.wikipedia.org/\" lang=\"pnt\" title=\"Pontiak\195\161\">\206\160\206\191\206\189\207\132\206\185\206\177\206\186\206\172</a></li>\
    \n<li><a href=\"//dz.wikipedia.org/\" lang=\"dz\" title=\"Rdzong-Kha\">\224\189\162\224\190\171\224\189\188\224\189\132\224\188\139\224\189\129</a></li>\
    \n<li><a href=\"//rmy.wikipedia.org/\" lang=\"rmy\">romani \196\141hib</a></li>\
    \n<li><a href=\"//rn.wikipedia.org/\" lang=\"rn\">Ikirundi</a></li>\
    \n<li><a href=\"//sg.wikipedia.org/\" lang=\"sg\">S\195\164ng\195\182</a></li>\
    \n<li><a href=\"//st.wikipedia.org/\" lang=\"st\">Sesotho</a></li>\
    \n<li><a href=\"//ss.wikipedia.org/\" lang=\"ss\">SiSwati</a></li>\
    \n<li><a href=\"//ti.wikipedia.org/\" lang=\"ti\" title=\"T\201\153g\201\153r\201\153\195\177a\">\225\137\181\225\140\141\225\136\173\225\138\155</a></li>\
    \n<li><a href=\"//din.wikipedia.org/\" lang=\"din\">Thu\201\148\197\139j\195\164\197\139</a></li>\
    \n<li><a href=\"//chy.wikipedia.org/\" lang=\"chy\">Ts\196\151hesen\196\151stsestotse</a></li>\
    \n<li><a href=\"//ts.wikipedia.org/\" lang=\"ts\">Xitsonga</a></li>\
    \n<li><a href=\"//kcg.wikipedia.org/\" lang=\"kcg\">Tyap</a></li>\
    \n<li><a href=\"//ve.wikipedia.org/\" lang=\"ve\">Tshiven\225\184\147a</a></li>\
    \n<li><a href=\"//guc.wikipedia.org/\" lang=\"guc\">Wayuunaiki</a></li>\
    \n</ul>\
    \n</div>\
    \n<div class=\"langlist langlist-others hlist\" data-el-section=\"other languages\">\
    \n<a class=\"jsl10n\" href=\"https://meta.wikimedia.org/wiki/Special:MyLanguage/List_of_Wikipedias\" lang data-jsl10n=\"other-languages-label\">Other languages</a>\
    \n</div></div>\
    \n</div>\
    \n<hr>\
    \n<div class=\"footer\" data-el-section=\"other projects\">\
    \n<div class=\"footer-sidebar\">\
    \n<div class=\"footer-sidebar-content\">\
    \n<div class=\"footer-sidebar-icon sprite svg-Wikimedia-logo_black\">\
    \n</div>\
    \n<div class=\"footer-sidebar-text jsl10n\" data-jsl10n=\"portal.footer-description\">\
    \nWikipedia is hosted by the Wikimedia Foundation, a non-profit organization that also hosts a range of other projects.\
    \n</div>\
    \n<div class=\"footer-sidebar-text\">\
    \n<a href=\"https://donate.wikimedia.org/?utm_medium=portal&utm_campaign=portalFooter&utm_source=portalFooter\" target=\"_blank\">\
    \n<span class=\"jsl10n\" data-jsl10n=\"footer-donate\">You can support our work with a donation.</span>\
    \n</a>\
    \n</div>\
    \n</div>\
    \n</div>\
    \n<div class=\"footer-sidebar app-badges\">\
    \n<div class=\"footer-sidebar-content\">\
    \n<div class=\"footer-sidebar-text\">\
    \n<div class=\"footer-sidebar-icon sprite svg-wikipedia_app_tile\"></div>\
    \n<strong class=\"jsl10n\" data-jsl10n=\"portal.app-links.title\">\
    \n<a class=\"jsl10n\" data-jsl10n=\"portal.app-links.url\" href=\"https://en.wikipedia.org/wiki/List_of_Wikipedia_mobile_applications\">\
    \nDownload Wikipedia for Android or iOS\
    \n</a>\
    \n</strong>\
    \n<p class=\"jsl10n\" data-jsl10n=\"portal.app-links.description\">\
    \nSave your favorite articles to read offline, sync your reading lists across devices and customize your reading experience with the official Wikipedia app.\
    \n</p>\
    \n<ul>\
    \n<li class=\"app-badge app-badge-android\">\
    \n<a target=\"_blank\" rel=\"noreferrer\" href=\"https://play.google.com/store/apps/details?id=org.wikipedia&referrer=utm_source%3Dportal%26utm_medium%3Dbutton%26anid%3Dadmob\">\
    \n<span class=\"jsl10n sprite svg-badge_google_play_store\" data-jsl10n=\"portal.app-links.google-store\">Google Play Store</span>\
    \n</a>\
    \n</li>\
    \n<li class=\"app-badge app-badge-ios\">\
    \n<a target=\"_blank\" rel=\"noreferrer\" href=\"https://itunes.apple.com/app/apple-store/id324715238?pt=208305&ct=portal&mt=8\">\
    \n<span class=\"jsl10n sprite svg-badge_ios_app_store\" data-jsl10n=\"portal.app-links.apple-store\">Apple App Store</span>\
    \n</a>\
    \n</li>\
    \n</ul>\
    \n</div>\
    \n</div>\
    \n</div>\
    \n<div class=\"other-projects\">\
    \n<div class=\"other-project\">\
    \n<a class=\"other-project-link\" href=\"//commons.wikimedia.org/\">\
    \n<div class=\"other-project-icon\">\
    \n<div class=\"sprite svg-Commons-logo_sister\"></div>\
    \n</div>\
    \n<div class=\"other-project-text\">\
    \n<span class=\"other-project-title jsl10n\" data-jsl10n=\"commons.name\">Commons</span>\
    \n<span class=\"other-project-tagline jsl10n\" data-jsl10n=\"commons.slogan\">Freely usable photos &amp; more</span>\
    \n</div>\
    \n</a>\
    \n</div>\
    \n<div class=\"other-project\">\
    \n<a class=\"other-project-link\" href=\"//www.wikivoyage.org/\">\
    \n<div class=\"other-project-icon\">\
    \n<div class=\"sprite svg-Wikivoyage-logo_sister\"></div>\
    \n</div>\
    \n<div class=\"other-project-text\">\
    \n<span class=\"other-project-title jsl10n\" data-jsl10n=\"wikivoyage.name\">Wikivoyage</span>\
    \n<span class=\"other-project-tagline jsl10n\" data-jsl10n=\"wikivoyage.slogan\">Free travel guide</span>\
    \n</div>\
    \n</a>\
    \n</div>\
    \n<div class=\"other-project\">\
    \n<a class=\"other-project-link\" href=\"//www.wiktionary.org/\">\
    \n<div class=\"other-project-icon\">\
    \n<div class=\"sprite svg-Wiktionary-logo_sister\"></div>\
    \n</div>\
    \n<div class=\"other-project-text\">\
    \n<span class=\"other-project-title jsl10n\" data-jsl10n=\"wiktionary.name\">Wiktionary</span>\
    \n<span class=\"other-project-tagline jsl10n\" data-jsl10n=\"wiktionary.slogan\">Free dictionary</span>\
    \n</div>\
    \n</a>\
    \n</div>\
    \n<div class=\"other-project\">\
    \n<a class=\"other-project-link\" href=\"//www.wikibooks.org/\">\
    \n<div class=\"other-project-icon\">\
    \n<div class=\"sprite svg-Wikibooks-logo_sister\"></div>\
    \n</div>\
    \n<div class=\"other-project-text\">\
    \n<span class=\"other-project-title jsl10n\" data-jsl10n=\"wikibooks.name\">Wikibooks</span>\
    \n<span class=\"other-project-tagline jsl10n\" data-jsl10n=\"wikibooks.slogan\">Free textbooks</span>\
    \n</div>\
    \n</a>\
    \n</div>\
    \n<div class=\"other-project\">\
    \n<a class=\"other-project-link\" href=\"//www.wikinews.org/\">\
    \n<div class=\"other-project-icon\">\
    \n<div class=\"sprite svg-Wikinews-logo_sister\"></div>\
    \n</div>\
    \n<div class=\"other-project-text\">\
    \n<span class=\"other-project-title jsl10n\" data-jsl10n=\"wikinews.name\">Wikinews</span>\
    \n<span class=\"other-project-tagline jsl10n\" data-jsl10n=\"wikinews.slogan\">Free news source</span>\
    \n</div>\
    \n</a>\
    \n</div>\
    \n<div class=\"other-project\">\
    \n<a class=\"other-project-link\" href=\"//www.wikidata.org/\">\
    \n<div class=\"other-project-icon\">\
    \n<div class=\"sprite svg-Wikidata-logo_sister\"></div>\
    \n</div>\
    \n<div class=\"other-project-text\">\
    \n<span class=\"other-project-title jsl10n\" data-jsl10n=\"wikidata.name\">Wikidata</span>\
    \n<span class=\"other-project-tagline jsl10n\" data-jsl10n=\"wikidata.slogan\">Free knowledge base</span>\
    \n</div>\
    \n</a>\
    \n</div>\
    \n<div class=\"other-project\">\
    \n<a class=\"other-project-link\" href=\"//www.wikiversity.org/\">\
    \n<div class=\"other-project-icon\">\
    \n<div class=\"sprite svg-Wikiversity-logo_sister\"></div>\
    \n</div>\
    \n<div class=\"other-project-text\">\
    \n<span class=\"other-project-title jsl10n\" data-jsl10n=\"wikiversity.name\">Wikiversity</span>\
    \n<span class=\"other-project-tagline jsl10n\" data-jsl10n=\"wikiversity.slogan\">Free course materials</span>\
    \n</div>\
    \n</a>\
    \n</div>\
    \n<div class=\"other-project\">\
    \n<a class=\"other-project-link\" href=\"//www.wikiquote.org/\">\
    \n<div class=\"other-project-icon\">\
    \n<div class=\"sprite svg-Wikiquote-logo_sister\"></div>\
    \n</div>\
    \n<div class=\"other-project-text\">\
    \n<span class=\"other-project-title jsl10n\" data-jsl10n=\"wikiquote.name\">Wikiquote</span>\
    \n<span class=\"other-project-tagline jsl10n\" data-jsl10n=\"wikiquote.slogan\">Free quote compendium</span>\
    \n</div>\
    \n</a>\
    \n</div>\
    \n<div class=\"other-project\">\
    \n<a class=\"other-project-link\" href=\"//www.mediawiki.org/\">\
    \n<div class=\"other-project-icon\">\
    \n<div class=\"sprite svg-MediaWiki-logo_sister\"></div>\
    \n</div>\
    \n<div class=\"other-project-text\">\
    \n<span class=\"other-project-title jsl10n\" data-jsl10n=\"mediawiki.name\">MediaWiki</span>\
    \n<span class=\"other-project-tagline jsl10n\" data-jsl10n=\"mediawiki.slogan\">Free &amp; open wiki application</span>\
    \n</div>\
    \n</a>\
    \n</div>\
    \n<div class=\"other-project\">\
    \n<a class=\"other-project-link\" href=\"//www.wikisource.org/\">\
    \n<div class=\"other-project-icon\">\
    \n<div class=\"sprite svg-Wikisource-logo_sister\"></div>\
    \n</div>\
    \n<div class=\"other-project-text\">\
    \n<span class=\"other-project-title jsl10n\" data-jsl10n=\"wikisource.name\">Wikisource</span>\
    \n<span class=\"other-project-tagline jsl10n\" data-jsl10n=\"wikisource.slogan\">Free library</span>\
    \n</div>\
    \n</a>\
    \n</div>\
    \n<div class=\"other-project\">\
    \n<a class=\"other-project-link\" href=\"//species.wikimedia.org/\">\
    \n<div class=\"other-project-icon\">\
    \n<div class=\"sprite svg-Wikispecies-logo_sister\"></div>\
    \n</div>\
    \n<div class=\"other-project-text\">\
    \n<span class=\"other-project-title jsl10n\" data-jsl10n=\"wikispecies.name\">Wikispecies</span>\
    \n<span class=\"other-project-tagline jsl10n\" data-jsl10n=\"wikispecies.slogan\">Free species directory</span>\
    \n</div>\
    \n</a>\
    \n</div>\
    \n<div class=\"other-project\">\
    \n<a class=\"other-project-link\" href=\"//meta.wikimedia.org/\">\
    \n<div class=\"other-project-icon\">\
    \n<div class=\"sprite svg-Meta-Wiki-logo_sister\"></div>\
    \n</div>\
    \n<div class=\"other-project-text\">\
    \n<span class=\"other-project-title jsl10n\" data-jsl10n=\"metawiki.name\">Meta-Wiki</span>\
    \n<span class=\"other-project-tagline jsl10n\" data-jsl10n=\"metawiki.slogan\">Community coordination &amp; documentation</span>\
    \n</div>\
    \n</a>\
    \n</div>\
    \n</div>\
    \n</div>\
    \n<hr>\
    \n<p class=\"site-license\">\
    \n<small class=\"jsl10n\" data-jsl10n=\"license\">This page is available under the <a href=\"https://creativecommons.org/licenses/by-sa/4.0/\">Creative Commons Attribution-ShareAlike License</a></small>\
    \n<small class=\"jsl10n\" data-jsl10n=\"terms\"><a href=\"https://meta.wikimedia.org/wiki/Terms_of_use\">Terms of Use</a></small>\
    \n<small class=\"jsl10n\" data-jsl10n=\"privacy-policy\"><a href=\"https://meta.wikimedia.org/wiki/Privacy_policy\">Privacy Policy</a></small>\
    \n</p>\
    \n<script>\
    \nvar rtlLangs = ['ar','arc','ary','arz','bcc','bgn','bqi','ckb','dv','fa','glk','he','kk-cn','kk-arab','khw','ks','ku-arab','lki','luz','mzn','nqo','pnb','ps','sd','sdh','skr','ug','ur','yi'],\
    \n    translationsHash = '8ea901ad',\
    \n    /**\
    \n     * This variable is used to convert the generic \"portal\" keyword in the data-jsl10n attributes\
    \n     * e.g. 'data-jsl10n=\"portal.footer-description\"' into a portal-specific key, e.g. \"wiki\"\
    \n     * for the Wikipedia portal.\
    \n     */\
    \n    translationsPortalKey = 'wiki';\
    \n    /**\
    \n     * The wm-typeahead.js feature is used for search,and it uses domain name for searching. We want domain\
    \n     * name to be portal Specific (different for every portal).So by declaring variable 'portalSearchDomain'\
    \n     * in index.handlebars we will make this portal Specific.\
    \n    **/\
    \n    portalSearchDomain = 'wikipedia.org'\
    \n    /*\
    \n     This object is used by l10n scripts (page-localized.js, topten-localized.js)\
    \n     to reveal the page content after l10n json is loaded.\
    \n     A timer is also set to prevent JS from hiding page content indefinitelty.\
    \n     This script is inlined to safeguard againt script loading errors and placed\
    \n     at the top of the page to safeguard against any HTML loading/parsing errors.\
    \n    */\
    \n    wmL10nVisible = {\
    \n        ready: false,\
    \n        makeVisible: function(){\
    \n            if ( !wmL10nVisible.ready ) {\
    \n                wmL10nVisible.ready = true;\
    \n                document.body.className += ' jsl10n-visible';\
    \n            }\
    \n        }\
    \n    };\
    \n    window.setTimeout( wmL10nVisible.makeVisible, 1000 )\
    \n</script>\
    \n<script src=\"portal/wikipedia.org/assets/js/index-86c7e2579d.js\"></script>\
    \n<!--[if gt IE 9]><!-->\
    \n<script src=\"portal/wikipedia.org/assets/js/gt-ie9-ce3fe8e88d.js\"></script>\
    \n<!--<![endif]-->\
    \n<!--[if lte IE 9]><!-->\
    \n<style>\
    \n.styled-select {\
    \n        display: block;\
    \n    }\
    \n</style>\
    \n<!--<![endif]-->\
    \n<!--[if lte IE 9]>\
    \n<style>\
    \n    .langlist > ul {\
    \n        text-align: center;\
    \n    }\
    \n    .langlist > ul > li {\
    \n        display: inline;\
    \n        padding: 0 0.5em;\
    \n    }\
    \n</style>\
    \n<![endif]-->\
    \n</body>\
    \n</html>\
    \n" |}];
    return ()
