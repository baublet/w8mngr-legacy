!function(e){function o(n){if(t[n])return t[n].exports;var i=t[n]={exports:{},id:n,loaded:!1};return e[n].call(i.exports,i,i.exports,o),i.loaded=!0,i.exports}var n=window.webpackJsonp;window.webpackJsonp=function(t,s){for(var c,r,a=0,u=[];a<t.length;a++)r=t[a],i[r]&&u.push.apply(u,i[r]),i[r]=0;for(c in s)e[c]=s[c];for(n&&n(t,s);u.length;)u.shift().call(null,o)};var t={},i={1:0};return o.e=function(e,n){if(0===i[e])return n.call(null,o);if(void 0!==i[e])i[e].push(n);else{i[e]=[n];var t=document.getElementsByTagName("head")[0],s=document.createElement("script");s.type="text/javascript",s.charset="utf-8",s.async=!0,s.src=o.p+""+e+"."+({0:"food-entries-chunk"}[e]||e)+"-"+{0:"52f2571ad145389566ec"}[e]+".js",t.appendChild(s)}},o.m=e,o.c=t,o.p="/webpack/",o(0)}([function(e,o,n){var t=n(1);console.log("w8mngr configuration loaded..."),console.log("Loading initialization files..."),n(30),n(29),n(28),console.log("Initializing w8mngr..."),t.init.run()},function(e,o,n){var t=t||{};t.cookies=n(31),t.loading={},t.init=n(32),t.config=n(20),e.exports=t},function(e,o){e.exports=function(e,o){for(var n=0;n<e.length;n++)o(e[n],n)}},,,,function(e,o){e.exports=function(e,o,n){function t(e,o,n){e.addEventListener?e.addEventListener(o,n):e.attachEvent("on"+o,function(){n.call(e)})}if(Array.isArray(o))for(var i=o.length,s=0;i>s;s++)t(e,o[s],n);else t(e,o,n)}},,,,,,,,,,,,,,function(e,o){e.exports={regex:{foodlog_day:/foodlog\/(\d{8})/},resources:{base:"/",search_foods:function(e){return"/search/foods/?q="+e},foods:{pull:function(e){return"/foods/pull/"+e},show:function(e){return"/foods/"+e}},food_entries:{index:"/food_entries/",add:"/food_entries/","delete":function(e){return"/food_entries/"+e},from_day:function(e){return"/foodlog/"+e},update:function(e){return"/food_entries/"+e}}}}},,function(e,o){e.exports=function(e,o){return e.classList?e.classList.contains(o):new RegExp("(^| )"+o+"( |$)","gi").test(e.className)}},,,function(e,o,n){var t=n(22);e.exports=function(e,o){t(e,o)&&(e.classList?e.classList.remove(o):e.className=e.className.replace(new RegExp("(^|\\b)"+o.split(" ").join("|")+"(\\b|$)","gi")," "))}},,,function(e,o,n){var t=n(1);t.init.addIf("food-entries-app",function(){console.log("Loading food-entries-app dependencies..."),n.e(0,function(e){console.log("Mounting food-entries-app...");var o=n(5);o.use(n(8)),t.foodEntries=new o(n(4)),console.log("Vue instance for FoodEntries:"),console.log(t.foodEntries)})})},function(e,o,n){var t=n(1),i=n(2),s=n(6);t.init.add(function(){console.log("Loading the navigation..."),null===t.cookies.getItem("nav_position")&&t.cookies.setItem("nav_position","#app-menu-dashboard"),console.log("Current item set at: "+t.cookies.getItem("nav_position"));var e=document.querySelectorAll(t.cookies.getItem("nav_position"));if("undefined"!=typeof e[0]){e[0].checked=!0;var o=document.querySelectorAll(".app-menu-top-option");i(o,function(e){s(e,"click",function(){console.log("Navigation item changed to: "+this.getAttribute("id")+". Updating cookie."),t.cookies.removeItem("nav_position"),t.cookies.setItem("nav_position","#"+this.getAttribute("id")),console.log("Current item set at: "+t.cookies.getItem("nav_position"))})})}})},function(e,o,n){var t=n(1),i=n(25);t.init.add(function(){console.log("Removing the nojs class from the body..."),i(document.querySelector("body"),"nojs")})},function(e,o){e.exports={getItem:function(e){return e?decodeURIComponent(document.cookie.replace(new RegExp("(?:(?:^|.*;)\\s*"+encodeURIComponent(e).replace(/[\-\.\+\*]/g,"\\$&")+"\\s*\\=\\s*([^;]*).*$)|^.*$"),"$1"))||null:null},setItem:function(e,o,n,t,i,s){if(!e||/^(?:expires|max\-age|path|domain|secure)$/i.test(e))return!1;var c="";if(n)switch(n.constructor){case Number:c=n===1/0?"; expires=Fri, 31 Dec 9999 23:59:59 GMT":"; max-age="+n;break;case String:c="; expires="+n;break;case Date:c="; expires="+n.toUTCString()}return document.cookie=encodeURIComponent(e)+"="+encodeURIComponent(o)+c+(i?"; domain="+i:"")+(t?"; path="+t:"")+(s?"; secure":""),!0},removeItem:function(e,o,n){return this.hasItem(e)?(document.cookie=encodeURIComponent(e)+"=; expires=Thu, 01 Jan 1970 00:00:00 GMT"+(n?"; domain="+n:"")+(o?"; path="+o:""),!0):!1},hasItem:function(e){return e?new RegExp("(?:^|;\\s*)"+encodeURIComponent(e).replace(/[\-\.\+\*]/g,"\\$&")+"\\s*\\=").test(document.cookie):!1},keys:function(){for(var e=document.cookie.replace(/((?:^|\s*;)[^\=]+)(?=;|$)|^\s*|\s*(?:\=[^;]*)?(?:\1|$)/g,"").split(/\s*(?:\=[^;]*)?;\s*/),o=e.length,n=0;o>n;n++)e[n]=decodeURIComponent(e[n]);return e}}},function(e,o,n){var t=n(2);e.exports={_toInit:[],add:function(e){e instanceof Function&&(this._toInit=this._toInit.concat(e))},run:function(){t(this._toInit,function(e){e()})},addIf:function(e,o){this.add(function(){null!==document.getElementById(e)&&o()})}}}]);