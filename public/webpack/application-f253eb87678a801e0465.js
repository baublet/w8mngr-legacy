!function(e){function t(n){if(o[n])return o[n].exports;var r=o[n]={exports:{},id:n,loaded:!1};return e[n].call(r.exports,r,r.exports,t),r.loaded=!0,r.exports}var n=window.webpackJsonp;window.webpackJsonp=function(o,i){for(var s,c,a=0,u=[];a<o.length;a++)c=o[a],r[c]&&u.push.apply(u,r[c]),r[c]=0;for(s in i)e[s]=i[s];for(n&&n(o,i);u.length;)u.shift().call(null,t)};var o={},r={2:0};return t.e=function(e,n){if(0===r[e])return n.call(null,t);if(void 0!==r[e])r[e].push(n);else{r[e]=[n];var o=document.getElementsByTagName("head")[0],i=document.createElement("script");i.type="text/javascript",i.charset="utf-8",i.async=!0,i.src=t.p+""+e+"."+({0:"dashboard-chunk",1:"food-entries-chunk"}[e]||e)+"-"+{0:"4d2e0f1b028f91e877fb",1:"3122bb79067966c784ac"}[e]+".js",o.appendChild(i)}},t.m=e,t.c=o,t.p="/webpack/",t(0)}({0:function(e,t,n){"use strict";"function"!=typeof Array.prototype.forEach&&(Array.prototype.forEach=function(e,t){for(var n=0;n<this.length;n++)e.apply(t,[this[n],n,this])});var o=n(5);n(152),n(151),n(150),n(149),o.init.run()},5:function(e,t,n){"use strict";var o=o||{};o.cookies=n(153),o.loading={},o.init=n(154),o.config=n(146),e.exports=o},16:function(e,t){"use strict";e.exports=function(e,t,n){function o(e,t,n){e.addEventListener?e.addEventListener(t,n):e.attachEvent("on"+t,function(){n.call(e)})}if(Array.isArray(t))for(var r=t.length,i=0;r>i;i++)o(e,t[i],n);else o(e,t,n)}},146:function(e,t){"use strict";e.exports={regex:{foodlog_day:/foodlog\/(\d{8})/},resources:{base:"/",search_foods:function(e,t){return t=t?t:1,"/search/foods/?per_page=10&q="+e+"&p="+t},foods:{pull:function(e){return"/foods/pull/"+e},show:function(e){return"/foods/"+e}},faturday:function(e){return e="undefined"==typeof e?"":parseInt(e,10),"/faturday/"+e},current_user:"/user",edit_profile:function(e){return"/users/"+e+"/edit"},food_entries:{index:"/food_entries/",add:"/food_entries/","delete":function(e){return"/food_entries/"+e},from_day:function(e){return"/foodlog/"+e},update:function(e){return"/food_entries/"+e}},measurements:{increment_popularty:function(e){return"/measurements/"+e+"/chosen"}},food_log_day:function(e){return"/foodlog/"+e},dashboard:{week_in_review:"/dashboard",quarter_calories:"/data/food_entries/calories/week/52",quarter_weights:"/data/weight_entries/week/52"}}}},147:function(e,t){"use strict";e.exports=function(e,t){return e.classList?e.classList.contains(t):new RegExp("(^| )"+t+"( |$)","gi").test(e.className)}},148:function(e,t,n){"use strict";var o=n(147);e.exports=function(e,t){o(e,t)&&(e.classList?e.classList.remove(t):e.className=e.className.replace(new RegExp("(^|\\b)"+t.split(" ").join("|")+"(\\b|$)","gi")," "))}},149:function(e,t,n){"use strict";var o=n(5);o.init.addIf("dashboard-app",function(){n.e(0,function(e){var t=n(6);t.use(n(9)),o.dashboard=new t(n(222))})})},150:function(e,t,n){"use strict";var o=n(5);o.init.addIf("food-entries-app",function(){n.e(1,function(e){var t=n(6);t.use(n(9)),o.foodEntries=new t(n(11)),console.log(o.foodEntries)})})},151:function(e,t,n){"use strict";var o=n(5),r=n(16);o.init.add(function(){null===o.cookies.getItem("nav_position")&&o.cookies.setItem("nav_position","#app-menu-dashboard");var e=(o.cookies.getItem("nav_position"),document.querySelectorAll(o.cookies.getItem("nav_position")));if("undefined"!=typeof e[0]){e[0].checked=!0;var t=document.querySelectorAll(".app-menu-top-option");t.forEach(function(e){r(e,"click",function(){})})}})},152:function(e,t,n){"use strict";var o=n(5),r=n(148);o.init.add(function(){r(document.querySelector("body"),"nojs")})},153:function(e,t){"use strict";e.exports={getItem:function(e){return e?decodeURIComponent(document.cookie.replace(new RegExp("(?:(?:^|.*;)\\s*"+encodeURIComponent(e).replace(/[\-\.\+\*]/g,"\\$&")+"\\s*\\=\\s*([^;]*).*$)|^.*$"),"$1"))||null:null},setItem:function(e,t,n,o,r,i){if(!e||/^(?:expires|max\-age|path|domain|secure)$/i.test(e))return!1;var s="";if(n)switch(n.constructor){case Number:s=n===1/0?"; expires=Fri, 31 Dec 9999 23:59:59 GMT":"; max-age="+n;break;case String:s="; expires="+n;break;case Date:s="; expires="+n.toUTCString()}return document.cookie=encodeURIComponent(e)+"="+encodeURIComponent(t)+s+(r?"; domain="+r:"")+(o?"; path="+o:"")+(i?"; secure":""),!0},removeItem:function(e,t,n){return this.hasItem(e)?(document.cookie=encodeURIComponent(e)+"=; expires=Thu, 01 Jan 1970 00:00:00 GMT"+(n?"; domain="+n:"")+(t?"; path="+t:""),!0):!1},hasItem:function(e){return e?new RegExp("(?:^|;\\s*)"+encodeURIComponent(e).replace(/[\-\.\+\*]/g,"\\$&")+"\\s*\\=").test(document.cookie):!1},keys:function(){for(var e=document.cookie.replace(/((?:^|\s*;)[^\=]+)(?=;|$)|^\s*|\s*(?:\=[^;]*)?(?:\1|$)/g,"").split(/\s*(?:\=[^;]*)?;\s*/),t=e.length,n=0;t>n;n++)e[n]=decodeURIComponent(e[n]);return e}}},154:function(e,t){"use strict";e.exports={_toInit:[],add:function(e){e instanceof Function&&(this._toInit=this._toInit.concat(e))},run:function(){this._toInit.forEach(function(e){e()})},addIf:function(e,t){this.add(function(){null!==document.getElementById(e)&&t()})}}}});