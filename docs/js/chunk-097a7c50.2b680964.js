(window["webpackJsonp"]=window["webpackJsonp"]||[]).push([["chunk-097a7c50","chunk-15b57efd","chunk-18007d04","chunk-c659a290"],{"0d4e":function(e,t,a){"use strict";a("73b0")},"23c3":function(e,t,a){},3643:function(e,t,a){"use strict";a.r(t);var n=function(){var e=this,t=e.$createElement,a=e._self._c||t;return a("div",[a("b-label",{attrs:{"is-required":!0},scopedSlots:e._u([{key:"label",fn:function(){return[e._v("電力会社")]},proxy:!0}])}),a("b-select",{attrs:{disabled:0===e.companyOptions.length,options:e.companyOptions},model:{value:e.simulationData.company,callback:function(t){e.$set(e.simulationData,"company",t)},expression:"simulationData.company"}}),e.isOtherCompany?a("b-error-message",{scopedSlots:e._u([{key:"message",fn:function(){return[e._v("シミュレーション対象外です。")]},proxy:!0}],null,!1,629696893)}):e._e()],1)},s=[],l=a("9ab4"),c=a("1b40"),i=a("7ebe"),r=a("43d0"),o=a("8ee2"),u=a("f264"),p=a("ebe2"),b=a("8324");let d=class extends c["c"]{constructor(){super(...arguments),this.companyOptions=[]}get isOtherCompany(){return this.simulationData.company===p["b"].OTHER}setCompanyOption(){const e=Object(u["a"])(this.simulationData.firstZipCode,this.simulationData.secondZipCode);this.companyOptions=Object(b["b"])(e)}};Object(l["a"])([Object(c["b"])({type:Object})],d.prototype,"simulationData",void 0),Object(l["a"])([Object(c["d"])("simulationData.firstZipCode"),Object(c["d"])("simulationData.secondZipCode")],d.prototype,"setCompanyOption",null),d=Object(l["a"])([Object(c["a"])({components:{BLabel:i["default"],BSelect:r["default"],BErrorMessage:o["default"]}})],d);var f=d,O=f,m=a("2877"),v=Object(m["a"])(O,n,s,!1,null,null,null);t["default"]=v.exports},"43d0":function(e,t,a){"use strict";a.r(t);var n=function(){var e=this,t=e.$createElement,a=e._self._c||t;return a("div",{staticClass:"base-select",class:{disabled:e.disabled},style:e.styleVariables},[e._m(0),a("select",{directives:[{name:"model",rawName:"v-model",value:e.selectValue,expression:"selectValue"}],attrs:{disabled:e.disabled},on:{change:function(t){var a=Array.prototype.filter.call(t.target.options,(function(e){return e.selected})).map((function(e){var t="_value"in e?e._value:e.value;return t}));e.selectValue=t.target.multiple?a:a[0]}}},e._l(e.options,(function(t,n){return a("option",{key:n,domProps:{value:t.value,selected:t.selected}},[e._v(" "+e._s(t.label)+" ")])})),0)])},s=[function(){var e=this,t=e.$createElement,a=e._self._c||t;return a("div",{staticClass:"base-select_icon"},[a("i",{staticClass:"fas fa-chevron-down fa-2x"})])}],l=a("9ab4"),c=a("1b40");let i=class extends c["c"]{get selectValue(){return this.value}set selectValue(e){this.$emit("input",e)}get styleVariables(){return{"--border-radius":this.explain?"0.4rem 0.4rem 0 0":"0.4rem"}}renewOptions(){this.options.length>0?this.$emit("input",this.options[0].value):this.$emit("input","")}};Object(l["a"])([Object(c["b"])({type:String,required:!0})],i.prototype,"value",void 0),Object(l["a"])([Object(c["b"])({type:Boolean,default:!1})],i.prototype,"disabled",void 0),Object(l["a"])([Object(c["b"])({type:Array,default:()=>[]})],i.prototype,"options",void 0),Object(l["a"])([Object(c["b"])({type:String,default:""})],i.prototype,"explain",void 0),Object(l["a"])([Object(c["d"])("options")],i.prototype,"renewOptions",null),i=Object(l["a"])([c["a"]],i);var r=i,o=r,u=(a("44ae"),a("2877")),p=Object(u["a"])(o,n,s,!1,null,"26e56857",null);t["default"]=p.exports},"44ae":function(e,t,a){"use strict";a("f6e3")},"48ca":function(e,t,a){"use strict";a("23c3")},"73b0":function(e,t,a){},"7ebe":function(e,t,a){"use strict";a.r(t);var n=function(){var e=this,t=e.$createElement,a=e._self._c||t;return a("span",{staticClass:"label",class:{required:e.isRequired}},[e._t("label")],2)},s=[],l=a("9ab4"),c=a("1b40");let i=class extends c["c"]{};Object(l["a"])([Object(c["b"])({type:Boolean,default:!1})],i.prototype,"isRequired",void 0),i=Object(l["a"])([c["a"]],i);var r=i,o=r,u=(a("0d4e"),a("2877")),p=Object(u["a"])(o,n,s,!1,null,"78e45f4f",null);t["default"]=p.exports},8324:function(e,t,a){"use strict";a.d(t,"b",(function(){return s})),a.d(t,"c",(function(){return l})),a.d(t,"a",(function(){return c}));var n=a("ebe2");function s(e){const t=[];return e===n["a"].OTHER||(e===n["a"].TOKYO?t.push({value:n["b"].TOKYO_DENRYOKU,label:n["b"].TOKYO_DENRYOKU,selected:!0}):e===n["a"].KANSAI&&t.push({value:n["b"].KANSAI_DENRYOKU,label:n["b"].KANSAI_DENRYOKU,selected:!0}),t.push({value:n["b"].OTHER,label:n["b"].OTHER})),t}function l(e){const t=[];return e===n["b"].TOKYO_DENRYOKU?(t.push({value:n["c"].PLAN_B,label:n["c"].PLAN_B,explain:n["c"].PLAN_B+"の説明",selected:!0}),t.push({value:n["c"].PLAN_C,label:n["c"].PLAN_C,explain:n["c"].PLAN_C+"の説明"})):e===n["b"].KANSAI_DENRYOKU&&(t.push({value:n["c"].PLAN_A,label:n["c"].PLAN_A,explain:n["c"].PLAN_A+"の説明",selected:!0}),t.push({value:n["c"].PLAN_B,label:n["c"].PLAN_B,explain:n["c"].PLAN_B+"の説明"})),t}function c(e){if(e.company===n["b"].TOKYO_DENRYOKU){if(e.plan===n["c"].PLAN_B)return["10A","15A","20A","30A","40A","50A","60A"].map((e,t)=>({value:e,label:e,selected:0===t}));if(e.plan===n["c"].PLAN_C)return[...Array(40)].map((e,t)=>({value:t+6+"kVA",label:t+6+"kVA",selected:0===t}))}else if(e.company===n["b"].KANSAI_DENRYOKU&&e.plan===n["c"].PLAN_B)return[...Array(40)].map((e,t)=>({value:t+6+"kVA",label:t+6+"kVA",selected:0===t}));return[]}},"8ee2":function(e,t,a){"use strict";a.r(t);var n=function(){var e=this,t=e.$createElement,a=e._self._c||t;return a("div",{staticClass:"error_message"},[e._m(0),a("p",[e._t("message")],2)])},s=[function(){var e=this,t=e.$createElement,a=e._self._c||t;return a("div",{staticClass:"error_message_icon"},[a("i",{staticClass:"fas fa-exclamation-triangle"})])}],l=a("9ab4"),c=a("1b40");let i=class extends c["c"]{};Object(l["a"])([Object(c["b"])({type:Boolean,default:!1})],i.prototype,"isRequired",void 0),i=Object(l["a"])([c["a"]],i);var r=i,o=r,u=(a("48ca"),a("2877")),p=Object(u["a"])(o,n,s,!1,null,"59beb295",null);t["default"]=p.exports},f6e3:function(e,t,a){}}]);
//# sourceMappingURL=chunk-097a7c50.2b680964.js.map