(window["webpackJsonp"]=window["webpackJsonp"]||[]).push([["chunk-6be38fa4"],{"0553":function(t,e,n){"use strict";n("479c")},"1b40":function(t,e,n){"use strict";n.d(e,"a",(function(){return E})),n.d(e,"c",(function(){return r["a"]})),n.d(e,"b",(function(){return A})),n.d(e,"d",(function(){return D}));var r=n("2b0e");
/**
  * vue-class-component v7.2.6
  * (c) 2015-present Evan You
  * @license MIT
  */function o(t){return o="function"===typeof Symbol&&"symbol"===typeof Symbol.iterator?function(t){return typeof t}:function(t){return t&&"function"===typeof Symbol&&t.constructor===Symbol&&t!==Symbol.prototype?"symbol":typeof t},o(t)}function a(t,e,n){return e in t?Object.defineProperty(t,e,{value:n,enumerable:!0,configurable:!0,writable:!0}):t[e]=n,t}function i(t){return c(t)||u(t)||f()}function c(t){if(Array.isArray(t)){for(var e=0,n=new Array(t.length);e<t.length;e++)n[e]=t[e];return n}}function u(t){if(Symbol.iterator in Object(t)||"[object Arguments]"===Object.prototype.toString.call(t))return Array.from(t)}function f(){throw new TypeError("Invalid attempt to spread non-iterable instance")}function s(){return"undefined"!==typeof Reflect&&Reflect.defineMetadata&&Reflect.getOwnMetadataKeys}function p(t,e){d(t,e),Object.getOwnPropertyNames(e.prototype).forEach((function(n){d(t.prototype,e.prototype,n)})),Object.getOwnPropertyNames(e).forEach((function(n){d(t,e,n)}))}function d(t,e,n){var r=n?Reflect.getOwnMetadataKeys(e,n):Reflect.getOwnMetadataKeys(e);r.forEach((function(r){var o=n?Reflect.getOwnMetadata(r,e,n):Reflect.getOwnMetadata(r,e);n?Reflect.defineMetadata(r,o,t,n):Reflect.defineMetadata(r,o,t)}))}var l={__proto__:[]},b=l instanceof Array;function y(t){return function(e,n,r){var o="function"===typeof e?e:e.constructor;o.__decorators__||(o.__decorators__=[]),"number"!==typeof r&&(r=void 0),o.__decorators__.push((function(e){return t(e,n,r)}))}}function m(t){var e=o(t);return null==t||"object"!==e&&"function"!==e}function O(t,e){var n=e.prototype._init;e.prototype._init=function(){var e=this,n=Object.getOwnPropertyNames(t);if(t.$options.props)for(var r in t.$options.props)t.hasOwnProperty(r)||n.push(r);n.forEach((function(n){Object.defineProperty(e,n,{get:function(){return t[n]},set:function(e){t[n]=e},configurable:!0})}))};var r=new e;e.prototype._init=n;var o={};return Object.keys(r).forEach((function(t){void 0!==r[t]&&(o[t]=r[t])})),o}var v=["data","beforeCreate","created","beforeMount","mounted","beforeDestroy","destroyed","beforeUpdate","updated","activated","deactivated","render","errorCaptured","serverPrefetch"];function h(t){var e=arguments.length>1&&void 0!==arguments[1]?arguments[1]:{};e.name=e.name||t._componentTag||t.name;var n=t.prototype;Object.getOwnPropertyNames(n).forEach((function(t){if("constructor"!==t)if(v.indexOf(t)>-1)e[t]=n[t];else{var r=Object.getOwnPropertyDescriptor(n,t);void 0!==r.value?"function"===typeof r.value?(e.methods||(e.methods={}))[t]=r.value:(e.mixins||(e.mixins=[])).push({data:function(){return a({},t,r.value)}}):(r.get||r.set)&&((e.computed||(e.computed={}))[t]={get:r.get,set:r.set})}})),(e.mixins||(e.mixins=[])).push({data:function(){return O(this,t)}});var o=t.__decorators__;o&&(o.forEach((function(t){return t(e)})),delete t.__decorators__);var i=Object.getPrototypeOf(t.prototype),c=i instanceof r["a"]?i.constructor:r["a"],u=c.extend(e);return _(u,t,c),s()&&p(u,t),u}var j={prototype:!0,arguments:!0,callee:!0,caller:!0};function _(t,e,n){Object.getOwnPropertyNames(e).forEach((function(r){if(!j[r]){var o=Object.getOwnPropertyDescriptor(t,r);if(!o||o.configurable){var a=Object.getOwnPropertyDescriptor(e,r);if(!b){if("cid"===r)return;var i=Object.getOwnPropertyDescriptor(n,r);if(!m(a.value)&&i&&i.value===a.value)return}0,Object.defineProperty(t,r,a)}}}))}function g(t){return"function"===typeof t?h(t):function(e){return h(e,t)}}g.registerHooks=function(t){v.push.apply(v,i(t))};var E=g;var w="undefined"!==typeof Reflect&&"undefined"!==typeof Reflect.getMetadata;function N(t,e,n){if(w&&!Array.isArray(t)&&"function"!==typeof t&&!t.hasOwnProperty("type")&&"undefined"===typeof t.type){var r=Reflect.getMetadata("design:type",e,n);r!==Object&&(t.type=r)}}function A(t){return void 0===t&&(t={}),function(e,n){N(t,e,n),y((function(e,n){(e.props||(e.props={}))[n]=t}))(e,n)}}function D(t,e){void 0===e&&(e={});var n=e.deep,r=void 0!==n&&n,o=e.immediate,a=void 0!==o&&o;return y((function(e,n){"object"!==typeof e.watch&&(e.watch=Object.create(null));var o=e.watch;"object"!==typeof o[t]||Array.isArray(o[t])?"undefined"===typeof o[t]&&(o[t]=[]):o[t]=[o[t]],o[t].push({handler:n,deep:r,immediate:a})}))}},"2c8b":function(t,e,n){"use strict";n.d(e,"b",(function(){return o})),n.d(e,"a",(function(){return a})),n.d(e,"c",(function(){return i}));var r=n("c94e");function o(t){return Object(r["f"])(t.firstZipCode,t.secondZipCode)&&Object(r["b"])(t.company)&&Object(r["e"])(t.plan)&&Object(r["a"])(t)}function a(t){return o(t)&&Object(r["d"])(t.pay)}function i(t){return a(t)&&Object(r["c"])(t.email)}},"479c":function(t,e,n){},"9ab4":function(t,e,n){"use strict";n.d(e,"b",(function(){return o})),n.d(e,"a",(function(){return a})),n.d(e,"c",(function(){return i}));
/*! *****************************************************************************
Copyright (c) Microsoft Corporation.

Permission to use, copy, modify, and/or distribute this software for any
purpose with or without fee is hereby granted.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH
REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY
AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT,
INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM
LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
PERFORMANCE OF THIS SOFTWARE.
***************************************************************************** */
var r=function(t,e){return r=Object.setPrototypeOf||{__proto__:[]}instanceof Array&&function(t,e){t.__proto__=e}||function(t,e){for(var n in e)Object.prototype.hasOwnProperty.call(e,n)&&(t[n]=e[n])},r(t,e)};function o(t,e){if("function"!==typeof e&&null!==e)throw new TypeError("Class extends value "+String(e)+" is not a constructor or null");function n(){this.constructor=t}r(t,e),t.prototype=null===e?Object.create(e):(n.prototype=e.prototype,new n)}function a(t,e,n,r){var o,a=arguments.length,i=a<3?e:null===r?r=Object.getOwnPropertyDescriptor(e,n):r;if("object"===typeof Reflect&&"function"===typeof Reflect.decorate)i=Reflect.decorate(t,e,n,r);else for(var c=t.length-1;c>=0;c--)(o=t[c])&&(i=(a<3?o(i):a>3?o(e,n,i):o(e,n))||i);return a>3&&i&&Object.defineProperty(e,n,i),i}Object.create;function i(){for(var t=0,e=0,n=arguments.length;e<n;e++)t+=arguments[e].length;var r=Array(t),o=0;for(e=0;e<n;e++)for(var a=arguments[e],i=0,c=a.length;i<c;i++,o++)r[o]=a[i];return r}Object.create},bfdb:function(t,e,n){"use strict";n.r(e);var r=function(){var t=this,e=t.$createElement,n=t._self._c||e;return n("div",[n("the-header"),n("div",{staticClass:"simulation-box"},[n("zip-code-box",{attrs:{simulationData:t.simulationData}})],1),n("div",{staticClass:"simulation-box"},[n("status-box",{attrs:{simulationData:t.simulationData}})],1),n("div",{staticClass:"simulation-box"},[n("pay-box",{attrs:{simulationData:t.simulationData}})],1),n("div",{staticClass:"simulation-box"},[n("email-box",{attrs:{simulationData:t.simulationData}})],1),n("the-footer",{attrs:{send:t.send,disabled:!t.isEnabledSendButton}})],1)},o=[],a=n("9ab4"),i=n("1b40"),c=n("ebe2"),u=n("f264"),f=n("2c8b"),s=function(t){function e(){var e=null!==t&&t.apply(this,arguments)||this;return e.simulationData={firstZipCode:"",secondZipCode:"",company:c["b"].UNSELECTED,plan:c["c"].UNSELECTED,amps:"",pay:"",email:""},e}return Object(a["b"])(e,t),Object.defineProperty(e.prototype,"isEnabledSendButton",{get:function(){return Object(f["c"])(this.simulationData)},enumerable:!1,configurable:!0}),e.prototype.send=function(){Object(u["b"])(this.simulationData)},e=Object(a["a"])([Object(i["a"])({components:{TheHeader:function(){return n.e("chunk-39f66610").then(n.bind(null,"cb3d"))},ZipCodeBox:function(){return n.e("chunk-2d229265").then(n.bind(null,"dbe6"))},StatusBox:function(){return n.e("chunk-2d2311d5").then(n.bind(null,"eeba"))},PayBox:function(){return n.e("chunk-2d0aa764").then(n.bind(null,"10b1"))},EmailBox:function(){return n.e("chunk-2d0b1650").then(n.bind(null,"2051"))},TheFooter:function(){return n.e("chunk-42cc059d").then(n.bind(null,"a09f"))}}})],e),e}(i["c"]),p=s,d=p,l=(n("0553"),n("2877")),b=Object(l["a"])(d,r,o,!1,null,"0fe092e5",null);e["default"]=b.exports},c94e:function(t,e,n){"use strict";n.d(e,"f",(function(){return o})),n.d(e,"b",(function(){return a})),n.d(e,"e",(function(){return i})),n.d(e,"a",(function(){return c})),n.d(e,"d",(function(){return f})),n.d(e,"c",(function(){return p}));var r=n("ebe2");function o(t,e){return!isNaN(Number(t))&&!isNaN(Number(e))&&3===t.length&&("1"===t.slice(0,1)||"5"===t.slice(0,1))&&4===e.length}function a(t){return t!==r["b"].UNSELECTED&&t!==r["b"].OTHER&&Object.values(r["b"]).includes(t)}function i(t){return t!==r["c"].UNSELECTED&&Object.values(r["c"]).includes(t)}function c(t){return t.company===r["b"].KANSAI_DENRYOKU&&t.plan===r["c"].PLAN_A||!!t.amps}var u=1e3;function f(t){return"string"===typeof t&&!isNaN(Number(t))&&Number(t)>=u||"number"===typeof t&&t>=u}var s=/^([*+!.&#$|\'%/0-9a-zA-Z^_{}=?~:-]+)@(([0-9a-zA-Z-]+\.)+[0-9a-zA-Z]{2,})$/i;function p(t){return!!t.match(s)}},ebe2:function(t,e,n){"use strict";var r,o,a;n.d(e,"a",(function(){return r})),n.d(e,"b",(function(){return o})),n.d(e,"c",(function(){return a})),function(t){t["TOKYO"]="東京エリア",t["KANSAI"]="関西エリア",t["OTHER"]="対象外エリア"}(r||(r={})),function(t){t["TOKYO_DENRYOKU"]="東京電力",t["KANSAI_DENRYOKU"]="関西電力",t["OTHER"]="その他",t["UNSELECTED"]=""}(o||(o={})),function(t){t["PLAN_A"]="従量電灯A",t["PLAN_B"]="従量電灯B",t["PLAN_C"]="従量電灯C",t["UNSELECTED"]=""}(a||(a={}))},f264:function(t,e,n){"use strict";n.d(e,"b",(function(){return a})),n.d(e,"a",(function(){return i}));var r=n("ebe2"),o=n("c94e");function a(t){var e={zipCode:t.firstZipCode+t.secondZipCode,company:t.company,plan:t.plan,amps:t.amps,pay:Number(t.pay),email:t.email};alert("【結果を見る(入力値の確認)】\n郵便番号："+e.zipCode+"\n会社："+e.company+"\nプラン："+e.plan+"\n契約容量："+e.amps+"\n支払金額："+e.pay+"\nメールアドレス："+e.email)}function i(t,e){var n=c(t,e);return n}function c(t,e){return Object(o["f"])(t,e)?"1"===t.slice(0,1)?r["a"].TOKYO:"5"===t.slice(0,1)?r["a"].KANSAI:r["a"].OTHER:r["a"].OTHER}}}]);
//# sourceMappingURL=chunk-6be38fa4.a0108847.js.map