/*
yahoo-dom-event.js
Copyright (c) 2011, Yahoo! Inc. All rights reserved.
Code licensed under the BSD License:
http://developer.yahoo.com/yui/license.html
version: 2.9.0
*/
if(typeof YAHOO=="undefined"||!YAHOO){var YAHOO={};}YAHOO.namespace=function(){var b=arguments,g=null,e,c,f;for(e=0;e<b.length;e=e+1){f=(""+b[e]).split(".");g=YAHOO;for(c=(f[0]=="YAHOO")?1:0;c<f.length;c=c+1){g[f[c]]=g[f[c]]||{};g=g[f[c]];}}return g;};YAHOO.log=function(d,a,c){var b=YAHOO.widget.Logger;if(b&&b.log){return b.log(d,a,c);}else{return false;}};YAHOO.register=function(a,f,e){var k=YAHOO.env.modules,c,j,h,g,d;if(!k[a]){k[a]={versions:[],builds:[]};}c=k[a];j=e.version;h=e.build;g=YAHOO.env.listeners;c.name=a;c.version=j;c.build=h;c.versions.push(j);c.builds.push(h);c.mainClass=f;for(d=0;d<g.length;d=d+1){g[d](c);}if(f){f.VERSION=j;f.BUILD=h;}else{YAHOO.log("mainClass is undefined for module "+a,"warn");}};YAHOO.env=YAHOO.env||{modules:[],listeners:[]};YAHOO.env.getVersion=function(a){return YAHOO.env.modules[a]||null;};YAHOO.env.parseUA=function(d){var e=function(i){var j=0;return parseFloat(i.replace(/\./g,function(){return(j++==1)?"":".";}));},h=navigator,g={ie:0,opera:0,gecko:0,webkit:0,chrome:0,mobile:null,air:0,ipad:0,iphone:0,ipod:0,ios:null,android:0,webos:0,caja:h&&h.cajaVersion,secure:false,os:null},c=d||(navigator&&navigator.userAgent),f=window&&window.location,b=f&&f.href,a;g.secure=b&&(b.toLowerCase().indexOf("https")===0);if(c){if((/windows|win32/i).test(c)){g.os="windows";}else{if((/macintosh/i).test(c)){g.os="macintosh";}else{if((/rhino/i).test(c)){g.os="rhino";}}}if((/KHTML/).test(c)){g.webkit=1;}a=c.match(/AppleWebKit\/([^\s]*)/);if(a&&a[1]){g.webkit=e(a[1]);if(/ Mobile\//.test(c)){g.mobile="Apple";a=c.match(/OS ([^\s]*)/);if(a&&a[1]){a=e(a[1].replace("_","."));}g.ios=a;g.ipad=g.ipod=g.iphone=0;a=c.match(/iPad|iPod|iPhone/);if(a&&a[0]){g[a[0].toLowerCase()]=g.ios;}}else{a=c.match(/NokiaN[^\/]*|Android \d\.\d|webOS\/\d\.\d/);if(a){g.mobile=a[0];}if(/webOS/.test(c)){g.mobile="WebOS";a=c.match(/webOS\/([^\s]*);/);if(a&&a[1]){g.webos=e(a[1]);}}if(/ Android/.test(c)){g.mobile="Android";a=c.match(/Android ([^\s]*);/);if(a&&a[1]){g.android=e(a[1]);}}}a=c.match(/Chrome\/([^\s]*)/);if(a&&a[1]){g.chrome=e(a[1]);}else{a=c.match(/AdobeAIR\/([^\s]*)/);if(a){g.air=a[0];}}}if(!g.webkit){a=c.match(/Opera[\s\/]([^\s]*)/);if(a&&a[1]){g.opera=e(a[1]);a=c.match(/Version\/([^\s]*)/);if(a&&a[1]){g.opera=e(a[1]);}a=c.match(/Opera Mini[^;]*/);if(a){g.mobile=a[0];}}else{a=c.match(/MSIE\s([^;]*)/);if(a&&a[1]){g.ie=e(a[1]);}else{a=c.match(/Gecko\/([^\s]*)/);if(a){g.gecko=1;a=c.match(/rv:([^\s\)]*)/);if(a&&a[1]){g.gecko=e(a[1]);}}}}}}return g;};YAHOO.env.ua=YAHOO.env.parseUA();(function(){YAHOO.namespace("util","widget","example");if("undefined"!==typeof YAHOO_config){var b=YAHOO_config.listener,a=YAHOO.env.listeners,d=true,c;if(b){for(c=0;c<a.length;c++){if(a[c]==b){d=false;break;}}if(d){a.push(b);}}}})();YAHOO.lang=YAHOO.lang||{};(function(){var f=YAHOO.lang,a=Object.prototype,c="[object Array]",h="[object Function]",i="[object Object]",b=[],g={"&":"&amp;","<":"&lt;",">":"&gt;",'"':"&quot;","'":"&#x27;","/":"&#x2F;","`":"&#x60;"},d=["toString","valueOf"],e={isArray:function(j){return a.toString.apply(j)===c;},isBoolean:function(j){return typeof j==="boolean";},isFunction:function(j){return(typeof j==="function")||a.toString.apply(j)===h;},isNull:function(j){return j===null;},isNumber:function(j){return typeof j==="number"&&isFinite(j);},isObject:function(j){return(j&&(typeof j==="object"||f.isFunction(j)))||false;},isString:function(j){return typeof j==="string";},isUndefined:function(j){return typeof j==="undefined";},_IEEnumFix:(YAHOO.env.ua.ie)?function(l,k){var j,n,m;for(j=0;j<d.length;j=j+1){n=d[j];m=k[n];if(f.isFunction(m)&&m!=a[n]){l[n]=m;}}}:function(){},escapeHTML:function(j){return j.replace(/[&<>"'\/`]/g,function(k){return g[k];});},extend:function(m,n,l){if(!n||!m){throw new Error("extend failed, please check that "+"all dependencies are included.");}var k=function(){},j;k.prototype=n.prototype;m.prototype=new k();m.prototype.constructor=m;m.superclass=n.prototype;if(n.prototype.constructor==a.constructor){n.prototype.constructor=n;}if(l){for(j in l){if(f.hasOwnProperty(l,j)){m.prototype[j]=l[j];}}f._IEEnumFix(m.prototype,l);}},augmentObject:function(n,m){if(!m||!n){throw new Error("Absorb failed, verify dependencies.");}var j=arguments,l,o,k=j[2];if(k&&k!==true){for(l=2;l<j.length;l=l+1){n[j[l]]=m[j[l]];}}else{for(o in m){if(k||!(o in n)){n[o]=m[o];}}f._IEEnumFix(n,m);}return n;},augmentProto:function(m,l){if(!l||!m){throw new Error("Augment failed, verify dependencies.");}var j=[m.prototype,l.prototype],k;for(k=2;k<arguments.length;k=k+1){j.push(arguments[k]);}f.augmentObject.apply(this,j);return m;},dump:function(j,p){var l,n,r=[],t="{...}",k="f(){...}",q=", ",m=" => ";if(!f.isObject(j)){return j+"";}else{if(j instanceof Date||("nodeType" in j&&"tagName" in j)){return j;}else{if(f.isFunction(j)){return k;}}}p=(f.isNumber(p))?p:3;if(f.isArray(j)){r.push("[");for(l=0,n=j.length;l<n;l=l+1){if(f.isObject(j[l])){r.push((p>0)?f.dump(j[l],p-1):t);}else{r.push(j[l]);}r.push(q);}if(r.length>1){r.pop();}r.push("]");}else{r.push("{");for(l in j){if(f.hasOwnProperty(j,l)){r.push(l+m);if(f.isObject(j[l])){r.push((p>0)?f.dump(j[l],p-1):t);}else{r.push(j[l]);}r.push(q);}}if(r.length>1){r.pop();}r.push("}");}return r.join("");},substitute:function(x,y,E,l){var D,C,B,G,t,u,F=[],p,z=x.length,A="dump",r=" ",q="{",m="}",n,w;for(;;){D=x.lastIndexOf(q,z);if(D<0){break;}C=x.indexOf(m,D);if(D+1>C){break;}p=x.substring(D+1,C);G=p;u=null;B=G.indexOf(r);if(B>-1){u=G.substring(B+1);G=G.substring(0,B);}t=y[G];if(E){t=E(G,t,u);}if(f.isObject(t)){if(f.isArray(t)){t=f.dump(t,parseInt(u,10));}else{u=u||"";n=u.indexOf(A);if(n>-1){u=u.substring(4);}w=t.toString();if(w===i||n>-1){t=f.dump(t,parseInt(u,10));}else{t=w;}}}else{if(!f.isString(t)&&!f.isNumber(t)){t="~-"+F.length+"-~";F[F.length]=p;}}x=x.substring(0,D)+t+x.substring(C+1);if(l===false){z=D-1;}}for(D=F.length-1;D>=0;D=D-1){x=x.replace(new RegExp("~-"+D+"-~"),"{"+F[D]+"}","g");}return x;},trim:function(j){try{return j.replace(/^\s+|\s+$/g,"");}catch(k){return j;
}},merge:function(){var n={},k=arguments,j=k.length,m;for(m=0;m<j;m=m+1){f.augmentObject(n,k[m],true);}return n;},later:function(t,k,u,n,p){t=t||0;k=k||{};var l=u,s=n,q,j;if(f.isString(u)){l=k[u];}if(!l){throw new TypeError("method undefined");}if(!f.isUndefined(n)&&!f.isArray(s)){s=[n];}q=function(){l.apply(k,s||b);};j=(p)?setInterval(q,t):setTimeout(q,t);return{interval:p,cancel:function(){if(this.interval){clearInterval(j);}else{clearTimeout(j);}}};},isValue:function(j){return(f.isObject(j)||f.isString(j)||f.isNumber(j)||f.isBoolean(j));}};f.hasOwnProperty=(a.hasOwnProperty)?function(j,k){return j&&j.hasOwnProperty&&j.hasOwnProperty(k);}:function(j,k){return !f.isUndefined(j[k])&&j.constructor.prototype[k]!==j[k];};e.augmentObject(f,e,true);YAHOO.util.Lang=f;f.augment=f.augmentProto;YAHOO.augment=f.augmentProto;YAHOO.extend=f.extend;})();YAHOO.register("yahoo",YAHOO,{version:"2.9.0",build:"2800"});(function(){YAHOO.env._id_counter=YAHOO.env._id_counter||0;var e=YAHOO.util,k=YAHOO.lang,L=YAHOO.env.ua,a=YAHOO.lang.trim,B={},F={},m=/^t(?:able|d|h)$/i,w=/color$/i,j=window.document,v=j.documentElement,C="ownerDocument",M="defaultView",U="documentElement",S="compatMode",z="offsetLeft",o="offsetTop",T="offsetParent",x="parentNode",K="nodeType",c="tagName",n="scrollLeft",H="scrollTop",p="getBoundingClientRect",V="getComputedStyle",y="currentStyle",l="CSS1Compat",A="BackCompat",E="class",f="className",i="",b=" ",R="(?:^|\\s)",J="(?= |$)",t="g",O="position",D="fixed",u="relative",I="left",N="top",Q="medium",P="borderLeftWidth",q="borderTopWidth",d=L.opera,h=L.webkit,g=L.gecko,s=L.ie;e.Dom={CUSTOM_ATTRIBUTES:(!v.hasAttribute)?{"for":"htmlFor","class":f}:{"htmlFor":"for","className":E},DOT_ATTRIBUTES:{checked:true},get:function(aa){var ac,X,ab,Z,W,G,Y=null;if(aa){if(typeof aa=="string"||typeof aa=="number"){ac=aa+"";aa=j.getElementById(aa);G=(aa)?aa.attributes:null;if(aa&&G&&G.id&&G.id.value===ac){return aa;}else{if(aa&&j.all){aa=null;X=j.all[ac];if(X&&X.length){for(Z=0,W=X.length;Z<W;++Z){if(X[Z].id===ac){return X[Z];}}}}}}else{if(e.Element&&aa instanceof e.Element){aa=aa.get("element");}else{if(!aa.nodeType&&"length" in aa){ab=[];for(Z=0,W=aa.length;Z<W;++Z){ab[ab.length]=e.Dom.get(aa[Z]);}aa=ab;}}}Y=aa;}return Y;},getComputedStyle:function(G,W){if(window[V]){return G[C][M][V](G,null)[W];}else{if(G[y]){return e.Dom.IE_ComputedStyle.get(G,W);}}},getStyle:function(G,W){return e.Dom.batch(G,e.Dom._getStyle,W);},_getStyle:function(){if(window[V]){return function(G,Y){Y=(Y==="float")?Y="cssFloat":e.Dom._toCamel(Y);var X=G.style[Y],W;if(!X){W=G[C][M][V](G,null);if(W){X=W[Y];}}return X;};}else{if(v[y]){return function(G,Y){var X;switch(Y){case"opacity":X=100;try{X=G.filters["DXImageTransform.Microsoft.Alpha"].opacity;}catch(Z){try{X=G.filters("alpha").opacity;}catch(W){}}return X/100;case"float":Y="styleFloat";default:Y=e.Dom._toCamel(Y);X=G[y]?G[y][Y]:null;return(G.style[Y]||X);}};}}}(),setStyle:function(G,W,X){e.Dom.batch(G,e.Dom._setStyle,{prop:W,val:X});},_setStyle:function(){if(!window.getComputedStyle&&j.documentElement.currentStyle){return function(W,G){var X=e.Dom._toCamel(G.prop),Y=G.val;if(W){switch(X){case"opacity":if(Y===""||Y===null||Y===1){W.style.removeAttribute("filter");}else{if(k.isString(W.style.filter)){W.style.filter="alpha(opacity="+Y*100+")";if(!W[y]||!W[y].hasLayout){W.style.zoom=1;}}}break;case"float":X="styleFloat";default:W.style[X]=Y;}}else{}};}else{return function(W,G){var X=e.Dom._toCamel(G.prop),Y=G.val;if(W){if(X=="float"){X="cssFloat";}W.style[X]=Y;}else{}};}}(),getXY:function(G){return e.Dom.batch(G,e.Dom._getXY);},_canPosition:function(G){return(e.Dom._getStyle(G,"display")!=="none"&&e.Dom._inDoc(G));},_getXY:function(W){var X,G,Z,ab,Y,aa,ac=Math.round,ad=false;if(e.Dom._canPosition(W)){Z=W[p]();ab=W[C];X=e.Dom.getDocumentScrollLeft(ab);G=e.Dom.getDocumentScrollTop(ab);ad=[Z[I],Z[N]];if(Y||aa){ad[0]-=aa;ad[1]-=Y;}if((G||X)){ad[0]+=X;ad[1]+=G;}ad[0]=ac(ad[0]);ad[1]=ac(ad[1]);}else{}return ad;},getX:function(G){var W=function(X){return e.Dom.getXY(X)[0];};return e.Dom.batch(G,W,e.Dom,true);},getY:function(G){var W=function(X){return e.Dom.getXY(X)[1];};return e.Dom.batch(G,W,e.Dom,true);},setXY:function(G,X,W){e.Dom.batch(G,e.Dom._setXY,{pos:X,noRetry:W});},_setXY:function(G,Z){var aa=e.Dom._getStyle(G,O),Y=e.Dom.setStyle,ad=Z.pos,W=Z.noRetry,ab=[parseInt(e.Dom.getComputedStyle(G,I),10),parseInt(e.Dom.getComputedStyle(G,N),10)],ac,X;ac=e.Dom._getXY(G);if(!ad||ac===false){return false;}if(aa=="static"){aa=u;Y(G,O,aa);}if(isNaN(ab[0])){ab[0]=(aa==u)?0:G[z];}if(isNaN(ab[1])){ab[1]=(aa==u)?0:G[o];}if(ad[0]!==null){Y(G,I,ad[0]-ac[0]+ab[0]+"px");}if(ad[1]!==null){Y(G,N,ad[1]-ac[1]+ab[1]+"px");}if(!W){X=e.Dom._getXY(G);if((ad[0]!==null&&X[0]!=ad[0])||(ad[1]!==null&&X[1]!=ad[1])){e.Dom._setXY(G,{pos:ad,noRetry:true});}}},setX:function(W,G){e.Dom.setXY(W,[G,null]);},setY:function(G,W){e.Dom.setXY(G,[null,W]);},getRegion:function(G){var W=function(X){var Y=false;if(e.Dom._canPosition(X)){Y=e.Region.getRegion(X);}else{}return Y;};return e.Dom.batch(G,W,e.Dom,true);},getClientWidth:function(){return e.Dom.getViewportWidth();},getClientHeight:function(){return e.Dom.getViewportHeight();},getElementsByClassName:function(ab,af,ac,ae,X,ad){af=af||"*";ac=(ac)?e.Dom.get(ac):null||j;if(!ac){return[];}var W=[],G=ac.getElementsByTagName(af),Z=e.Dom.hasClass;for(var Y=0,aa=G.length;Y<aa;++Y){if(Z(G[Y],ab)){W[W.length]=G[Y];}}if(ae){e.Dom.batch(W,ae,X,ad);}return W;},hasClass:function(W,G){return e.Dom.batch(W,e.Dom._hasClass,G);},_hasClass:function(X,W){var G=false,Y;if(X&&W){Y=e.Dom._getAttribute(X,f)||i;if(Y){Y=Y.replace(/\s+/g,b);}if(W.exec){G=W.test(Y);}else{G=W&&(b+Y+b).indexOf(b+W+b)>-1;}}else{}return G;},addClass:function(W,G){return e.Dom.batch(W,e.Dom._addClass,G);},_addClass:function(X,W){var G=false,Y;if(X&&W){Y=e.Dom._getAttribute(X,f)||i;if(!e.Dom._hasClass(X,W)){e.Dom.setAttribute(X,f,a(Y+b+W));G=true;}}else{}return G;},removeClass:function(W,G){return e.Dom.batch(W,e.Dom._removeClass,G);},_removeClass:function(Y,X){var W=false,aa,Z,G;if(Y&&X){aa=e.Dom._getAttribute(Y,f)||i;e.Dom.setAttribute(Y,f,aa.replace(e.Dom._getClassRegex(X),i));Z=e.Dom._getAttribute(Y,f);if(aa!==Z){e.Dom.setAttribute(Y,f,a(Z));W=true;if(e.Dom._getAttribute(Y,f)===""){G=(Y.hasAttribute&&Y.hasAttribute(E))?E:f;Y.removeAttribute(G);}}}else{}return W;},replaceClass:function(X,W,G){return e.Dom.batch(X,e.Dom._replaceClass,{from:W,to:G});},_replaceClass:function(Y,X){var W,ab,aa,G=false,Z;if(Y&&X){ab=X.from;aa=X.to;if(!aa){G=false;}else{if(!ab){G=e.Dom._addClass(Y,X.to);}else{if(ab!==aa){Z=e.Dom._getAttribute(Y,f)||i;W=(b+Z.replace(e.Dom._getClassRegex(ab),b+aa).replace(/\s+/g,b)).split(e.Dom._getClassRegex(aa));W.splice(1,0,b+aa);e.Dom.setAttribute(Y,f,a(W.join(i)));G=true;}}}}else{}return G;},generateId:function(G,X){X=X||"yui-gen";var W=function(Y){if(Y&&Y.id){return Y.id;}var Z=X+YAHOO.env._id_counter++;
if(Y){if(Y[C]&&Y[C].getElementById(Z)){return e.Dom.generateId(Y,Z+X);}Y.id=Z;}return Z;};return e.Dom.batch(G,W,e.Dom,true)||W.apply(e.Dom,arguments);},isAncestor:function(W,X){W=e.Dom.get(W);X=e.Dom.get(X);var G=false;if((W&&X)&&(W[K]&&X[K])){if(W.contains&&W!==X){G=W.contains(X);}else{if(W.compareDocumentPosition){G=!!(W.compareDocumentPosition(X)&16);}}}else{}return G;},inDocument:function(G,W){return e.Dom._inDoc(e.Dom.get(G),W);},_inDoc:function(W,X){var G=false;if(W&&W[c]){X=X||W[C];G=e.Dom.isAncestor(X[U],W);}else{}return G;},getElementsBy:function(W,af,ab,ad,X,ac,ae){af=af||"*";ab=(ab)?e.Dom.get(ab):null||j;var aa=(ae)?null:[],G;if(ab){G=ab.getElementsByTagName(af);for(var Y=0,Z=G.length;Y<Z;++Y){if(W(G[Y])){if(ae){aa=G[Y];break;}else{aa[aa.length]=G[Y];}}}if(ad){e.Dom.batch(aa,ad,X,ac);}}return aa;},getElementBy:function(X,G,W){return e.Dom.getElementsBy(X,G,W,null,null,null,true);},batch:function(X,ab,aa,Z){var Y=[],W=(Z)?aa:null;X=(X&&(X[c]||X.item))?X:e.Dom.get(X);if(X&&ab){if(X[c]||X.length===undefined){return ab.call(W,X,aa);}for(var G=0;G<X.length;++G){Y[Y.length]=ab.call(W||X[G],X[G],aa);}}else{return false;}return Y;},getDocumentHeight:function(){var W=(j[S]!=l||h)?j.body.scrollHeight:v.scrollHeight,G=Math.max(W,e.Dom.getViewportHeight());return G;},getDocumentWidth:function(){var W=(j[S]!=l||h)?j.body.scrollWidth:v.scrollWidth,G=Math.max(W,e.Dom.getViewportWidth());return G;},getViewportHeight:function(){var G=self.innerHeight,W=j[S];if((W||s)&&!d){G=(W==l)?v.clientHeight:j.body.clientHeight;}return G;},getViewportWidth:function(){var G=self.innerWidth,W=j[S];if(W||s){G=(W==l)?v.clientWidth:j.body.clientWidth;}return G;},getAncestorBy:function(G,W){while((G=G[x])){if(e.Dom._testElement(G,W)){return G;}}return null;},getAncestorByClassName:function(W,G){W=e.Dom.get(W);if(!W){return null;}var X=function(Y){return e.Dom.hasClass(Y,G);};return e.Dom.getAncestorBy(W,X);},getAncestorByTagName:function(W,G){W=e.Dom.get(W);if(!W){return null;}var X=function(Y){return Y[c]&&Y[c].toUpperCase()==G.toUpperCase();};return e.Dom.getAncestorBy(W,X);},getPreviousSiblingBy:function(G,W){while(G){G=G.previousSibling;if(e.Dom._testElement(G,W)){return G;}}return null;},getPreviousSibling:function(G){G=e.Dom.get(G);if(!G){return null;}return e.Dom.getPreviousSiblingBy(G);},getNextSiblingBy:function(G,W){while(G){G=G.nextSibling;if(e.Dom._testElement(G,W)){return G;}}return null;},getNextSibling:function(G){G=e.Dom.get(G);if(!G){return null;}return e.Dom.getNextSiblingBy(G);},getFirstChildBy:function(G,X){var W=(e.Dom._testElement(G.firstChild,X))?G.firstChild:null;return W||e.Dom.getNextSiblingBy(G.firstChild,X);},getFirstChild:function(G,W){G=e.Dom.get(G);if(!G){return null;}return e.Dom.getFirstChildBy(G);},getLastChildBy:function(G,X){if(!G){return null;}var W=(e.Dom._testElement(G.lastChild,X))?G.lastChild:null;return W||e.Dom.getPreviousSiblingBy(G.lastChild,X);},getLastChild:function(G){G=e.Dom.get(G);return e.Dom.getLastChildBy(G);},getChildrenBy:function(W,Y){var X=e.Dom.getFirstChildBy(W,Y),G=X?[X]:[];e.Dom.getNextSiblingBy(X,function(Z){if(!Y||Y(Z)){G[G.length]=Z;}return false;});return G;},getChildren:function(G){G=e.Dom.get(G);if(!G){}return e.Dom.getChildrenBy(G);},getDocumentScrollLeft:function(G){G=G||j;return Math.max(G[U].scrollLeft,G.body.scrollLeft);},getDocumentScrollTop:function(G){G=G||j;return Math.max(G[U].scrollTop,G.body.scrollTop);},insertBefore:function(W,G){W=e.Dom.get(W);G=e.Dom.get(G);if(!W||!G||!G[x]){return null;}return G[x].insertBefore(W,G);},insertAfter:function(W,G){W=e.Dom.get(W);G=e.Dom.get(G);if(!W||!G||!G[x]){return null;}if(G.nextSibling){return G[x].insertBefore(W,G.nextSibling);}else{return G[x].appendChild(W);}},getClientRegion:function(){var X=e.Dom.getDocumentScrollTop(),W=e.Dom.getDocumentScrollLeft(),Y=e.Dom.getViewportWidth()+W,G=e.Dom.getViewportHeight()+X;return new e.Region(X,Y,G,W);},setAttribute:function(W,G,X){e.Dom.batch(W,e.Dom._setAttribute,{attr:G,val:X});},_setAttribute:function(X,W){var G=e.Dom._toCamel(W.attr),Y=W.val;if(X&&X.setAttribute){if(e.Dom.DOT_ATTRIBUTES[G]&&X.tagName&&X.tagName!="BUTTON"){X[G]=Y;}else{G=e.Dom.CUSTOM_ATTRIBUTES[G]||G;X.setAttribute(G,Y);}}else{}},getAttribute:function(W,G){return e.Dom.batch(W,e.Dom._getAttribute,G);},_getAttribute:function(W,G){var X;G=e.Dom.CUSTOM_ATTRIBUTES[G]||G;if(e.Dom.DOT_ATTRIBUTES[G]){X=W[G];}else{if(W&&"getAttribute" in W){if(/^(?:href|src)$/.test(G)){X=W.getAttribute(G,2);}else{X=W.getAttribute(G);}}else{}}return X;},_toCamel:function(W){var X=B;function G(Y,Z){return Z.toUpperCase();}return X[W]||(X[W]=W.indexOf("-")===-1?W:W.replace(/-([a-z])/gi,G));},_getClassRegex:function(W){var G;if(W!==undefined){if(W.exec){G=W;}else{G=F[W];if(!G){W=W.replace(e.Dom._patterns.CLASS_RE_TOKENS,"\\$1");W=W.replace(/\s+/g,b);G=F[W]=new RegExp(R+W+J,t);}}}return G;},_patterns:{ROOT_TAG:/^body|html$/i,CLASS_RE_TOKENS:/([\.\(\)\^\$\*\+\?\|\[\]\{\}\\])/g},_testElement:function(G,W){return G&&G[K]==1&&(!W||W(G));},_calcBorders:function(X,Y){var W=parseInt(e.Dom[V](X,q),10)||0,G=parseInt(e.Dom[V](X,P),10)||0;if(g){if(m.test(X[c])){W=0;G=0;}}Y[0]+=G;Y[1]+=W;return Y;}};var r=e.Dom[V];if(L.opera){e.Dom[V]=function(W,G){var X=r(W,G);if(w.test(G)){X=e.Dom.Color.toRGB(X);}return X;};}if(L.webkit){e.Dom[V]=function(W,G){var X=r(W,G);if(X==="rgba(0, 0, 0, 0)"){X="transparent";}return X;};}if(L.ie&&L.ie>=8){e.Dom.DOT_ATTRIBUTES.type=true;}})();YAHOO.util.Region=function(d,e,a,c){this.top=d;this.y=d;this[1]=d;this.right=e;this.bottom=a;this.left=c;this.x=c;this[0]=c;this.width=this.right-this.left;this.height=this.bottom-this.top;};YAHOO.util.Region.prototype.contains=function(a){return(a.left>=this.left&&a.right<=this.right&&a.top>=this.top&&a.bottom<=this.bottom);};YAHOO.util.Region.prototype.getArea=function(){return((this.bottom-this.top)*(this.right-this.left));};YAHOO.util.Region.prototype.intersect=function(f){var d=Math.max(this.top,f.top),e=Math.min(this.right,f.right),a=Math.min(this.bottom,f.bottom),c=Math.max(this.left,f.left);
if(a>=d&&e>=c){return new YAHOO.util.Region(d,e,a,c);}else{return null;}};YAHOO.util.Region.prototype.union=function(f){var d=Math.min(this.top,f.top),e=Math.max(this.right,f.right),a=Math.max(this.bottom,f.bottom),c=Math.min(this.left,f.left);return new YAHOO.util.Region(d,e,a,c);};YAHOO.util.Region.prototype.toString=function(){return("Region {"+"top: "+this.top+", right: "+this.right+", bottom: "+this.bottom+", left: "+this.left+", height: "+this.height+", width: "+this.width+"}");};YAHOO.util.Region.getRegion=function(e){var g=YAHOO.util.Dom.getXY(e),d=g[1],f=g[0]+e.offsetWidth,a=g[1]+e.offsetHeight,c=g[0];return new YAHOO.util.Region(d,f,a,c);};YAHOO.util.Point=function(a,b){if(YAHOO.lang.isArray(a)){b=a[1];a=a[0];}YAHOO.util.Point.superclass.constructor.call(this,b,a,b,a);};YAHOO.extend(YAHOO.util.Point,YAHOO.util.Region);(function(){var b=YAHOO.util,a="clientTop",f="clientLeft",j="parentNode",k="right",w="hasLayout",i="px",u="opacity",l="auto",d="borderLeftWidth",g="borderTopWidth",p="borderRightWidth",v="borderBottomWidth",s="visible",q="transparent",n="height",e="width",h="style",t="currentStyle",r=/^width|height$/,o=/^(\d[.\d]*)+(em|ex|px|gd|rem|vw|vh|vm|ch|mm|cm|in|pt|pc|deg|rad|ms|s|hz|khz|%){1}?/i,m={get:function(x,z){var y="",A=x[t][z];if(z===u){y=b.Dom.getStyle(x,u);}else{if(!A||(A.indexOf&&A.indexOf(i)>-1)){y=A;}else{if(b.Dom.IE_COMPUTED[z]){y=b.Dom.IE_COMPUTED[z](x,z);}else{if(o.test(A)){y=b.Dom.IE.ComputedStyle.getPixel(x,z);}else{y=A;}}}}return y;},getOffset:function(z,E){var B=z[t][E],x=E.charAt(0).toUpperCase()+E.substr(1),C="offset"+x,y="pixel"+x,A="",D;if(B==l){D=z[C];if(D===undefined){A=0;}A=D;if(r.test(E)){z[h][E]=D;if(z[C]>D){A=D-(z[C]-D);}z[h][E]=l;}}else{if(!z[h][y]&&!z[h][E]){z[h][E]=B;}A=z[h][y];}return A+i;},getBorderWidth:function(x,z){var y=null;if(!x[t][w]){x[h].zoom=1;}switch(z){case g:y=x[a];break;case v:y=x.offsetHeight-x.clientHeight-x[a];break;case d:y=x[f];break;case p:y=x.offsetWidth-x.clientWidth-x[f];break;}return y+i;},getPixel:function(y,x){var A=null,B=y[t][k],z=y[t][x];y[h][k]=z;A=y[h].pixelRight;y[h][k]=B;return A+i;},getMargin:function(y,x){var z;if(y[t][x]==l){z=0+i;}else{z=b.Dom.IE.ComputedStyle.getPixel(y,x);}return z;},getVisibility:function(y,x){var z;while((z=y[t])&&z[x]=="inherit"){y=y[j];}return(z)?z[x]:s;},getColor:function(y,x){return b.Dom.Color.toRGB(y[t][x])||q;},getBorderColor:function(y,x){var z=y[t],A=z[x]||z.color;return b.Dom.Color.toRGB(b.Dom.Color.toHex(A));}},c={};c.top=c.right=c.bottom=c.left=c[e]=c[n]=m.getOffset;c.color=m.getColor;c[g]=c[p]=c[v]=c[d]=m.getBorderWidth;c.marginTop=c.marginRight=c.marginBottom=c.marginLeft=m.getMargin;c.visibility=m.getVisibility;c.borderColor=c.borderTopColor=c.borderRightColor=c.borderBottomColor=c.borderLeftColor=m.getBorderColor;b.Dom.IE_COMPUTED=c;b.Dom.IE_ComputedStyle=m;})();(function(){var c="toString",a=parseInt,b=RegExp,d=YAHOO.util;d.Dom.Color={KEYWORDS:{black:"000",silver:"c0c0c0",gray:"808080",white:"fff",maroon:"800000",red:"f00",purple:"800080",fuchsia:"f0f",green:"008000",lime:"0f0",olive:"808000",yellow:"ff0",navy:"000080",blue:"00f",teal:"008080",aqua:"0ff"},re_RGB:/^rgb\(([0-9]+)\s*,\s*([0-9]+)\s*,\s*([0-9]+)\)$/i,re_hex:/^#?([0-9A-F]{2})([0-9A-F]{2})([0-9A-F]{2})$/i,re_hex3:/([0-9A-F])/gi,toRGB:function(e){if(!d.Dom.Color.re_RGB.test(e)){e=d.Dom.Color.toHex(e);}if(d.Dom.Color.re_hex.exec(e)){e="rgb("+[a(b.$1,16),a(b.$2,16),a(b.$3,16)].join(", ")+")";}return e;},toHex:function(f){f=d.Dom.Color.KEYWORDS[f]||f;if(d.Dom.Color.re_RGB.exec(f)){f=[Number(b.$1).toString(16),Number(b.$2).toString(16),Number(b.$3).toString(16)];for(var e=0;e<f.length;e++){if(f[e].length<2){f[e]="0"+f[e];}}f=f.join("");}if(f.length<6){f=f.replace(d.Dom.Color.re_hex3,"$1$1");}if(f!=="transparent"&&f.indexOf("#")<0){f="#"+f;}return f.toUpperCase();}};}());YAHOO.register("dom",YAHOO.util.Dom,{version:"2.9.0",build:"2800"});YAHOO.util.CustomEvent=function(d,c,b,a,e){this.type=d;this.scope=c||window;this.silent=b;this.fireOnce=e;this.fired=false;this.firedWith=null;this.signature=a||YAHOO.util.CustomEvent.LIST;this.subscribers=[];if(!this.silent){}var f="_YUICEOnSubscribe";if(d!==f){this.subscribeEvent=new YAHOO.util.CustomEvent(f,this,true);}this.lastError=null;};YAHOO.util.CustomEvent.LIST=0;YAHOO.util.CustomEvent.FLAT=1;YAHOO.util.CustomEvent.prototype={subscribe:function(b,c,d){if(!b){throw new Error("Invalid callback for subscriber to '"+this.type+"'");}if(this.subscribeEvent){this.subscribeEvent.fire(b,c,d);}var a=new YAHOO.util.Subscriber(b,c,d);if(this.fireOnce&&this.fired){this.notify(a,this.firedWith);}else{this.subscribers.push(a);}},unsubscribe:function(d,f){if(!d){return this.unsubscribeAll();}var e=false;for(var b=0,a=this.subscribers.length;b<a;++b){var c=this.subscribers[b];if(c&&c.contains(d,f)){this._delete(b);e=true;}}return e;},fire:function(){this.lastError=null;var h=[],a=this.subscribers.length;var d=[].slice.call(arguments,0),c=true,f,b=false;if(this.fireOnce){if(this.fired){return true;}else{this.firedWith=d;}}this.fired=true;if(!a&&this.silent){return true;}if(!this.silent){}var e=this.subscribers.slice();for(f=0;f<a;++f){var g=e[f];if(!g||!g.fn){b=true;}else{c=this.notify(g,d);if(false===c){if(!this.silent){}break;}}}return(c!==false);},notify:function(g,c){var b,i=null,f=g.getScope(this.scope),a=YAHOO.util.Event.throwErrors;if(!this.silent){}if(this.signature==YAHOO.util.CustomEvent.FLAT){if(c.length>0){i=c[0];}try{b=g.fn.call(f,i,g.obj);}catch(h){this.lastError=h;if(a){throw h;}}}else{try{b=g.fn.call(f,this.type,c,g.obj);}catch(d){this.lastError=d;if(a){throw d;}}}return b;},unsubscribeAll:function(){var a=this.subscribers.length,b;for(b=a-1;b>-1;b--){this._delete(b);}this.subscribers=[];return a;},_delete:function(a){var b=this.subscribers[a];if(b){delete b.fn;delete b.obj;}this.subscribers.splice(a,1);},toString:function(){return"CustomEvent: "+"'"+this.type+"', "+"context: "+this.scope;}};YAHOO.util.Subscriber=function(a,b,c){this.fn=a;this.obj=YAHOO.lang.isUndefined(b)?null:b;this.overrideContext=c;};YAHOO.util.Subscriber.prototype.getScope=function(a){if(this.overrideContext){if(this.overrideContext===true){return this.obj;}else{return this.overrideContext;}}return a;};YAHOO.util.Subscriber.prototype.contains=function(a,b){if(b){return(this.fn==a&&this.obj==b);}else{return(this.fn==a);}};YAHOO.util.Subscriber.prototype.toString=function(){return"Subscriber { obj: "+this.obj+", overrideContext: "+(this.overrideContext||"no")+" }";};if(!YAHOO.util.Event){YAHOO.util.Event=function(){var g=false,h=[],j=[],a=0,e=[],b=0,c={63232:38,63233:40,63234:37,63235:39,63276:33,63277:34,25:9},d=YAHOO.env.ua.ie,f="focusin",i="focusout";return{POLL_RETRYS:500,POLL_INTERVAL:40,EL:0,TYPE:1,FN:2,WFN:3,UNLOAD_OBJ:3,ADJ_SCOPE:4,OBJ:5,OVERRIDE:6,CAPTURE:7,lastError:null,isSafari:YAHOO.env.ua.webkit,webkit:YAHOO.env.ua.webkit,isIE:d,_interval:null,_dri:null,_specialTypes:{focusin:(d?"focusin":"focus"),focusout:(d?"focusout":"blur")},DOMReady:false,throwErrors:false,startInterval:function(){if(!this._interval){this._interval=YAHOO.lang.later(this.POLL_INTERVAL,this,this._tryPreloadAttach,null,true);}},onAvailable:function(q,m,o,p,n){var k=(YAHOO.lang.isString(q))?[q]:q;for(var l=0;l<k.length;l=l+1){e.push({id:k[l],fn:m,obj:o,overrideContext:p,checkReady:n});}a=this.POLL_RETRYS;this.startInterval();},onContentReady:function(n,k,l,m){this.onAvailable(n,k,l,m,true);},onDOMReady:function(){this.DOMReadyEvent.subscribe.apply(this.DOMReadyEvent,arguments);},_addListener:function(m,k,v,p,t,y){if(!v||!v.call){return false;}if(this._isValidCollection(m)){var w=true;for(var q=0,s=m.length;q<s;++q){w=this.on(m[q],k,v,p,t)&&w;}return w;}else{if(YAHOO.lang.isString(m)){var o=this.getEl(m);if(o){m=o;}else{this.onAvailable(m,function(){YAHOO.util.Event._addListener(m,k,v,p,t,y);});return true;}}}if(!m){return false;}if("unload"==k&&p!==this){j[j.length]=[m,k,v,p,t];return true;}var l=m;if(t){if(t===true){l=p;}else{l=t;}}var n=function(z){return v.call(l,YAHOO.util.Event.getEvent(z,m),p);};var x=[m,k,v,n,l,p,t,y];var r=h.length;h[r]=x;try{this._simpleAdd(m,k,n,y);}catch(u){this.lastError=u;this.removeListener(m,k,v);return false;}return true;},_getType:function(k){return this._specialTypes[k]||k;},addListener:function(m,p,l,n,o){var k=((p==f||p==i)&&!YAHOO.env.ua.ie)?true:false;return this._addListener(m,this._getType(p),l,n,o,k);},addFocusListener:function(l,k,m,n){return this.on(l,f,k,m,n);},removeFocusListener:function(l,k){return this.removeListener(l,f,k);},addBlurListener:function(l,k,m,n){return this.on(l,i,k,m,n);},removeBlurListener:function(l,k){return this.removeListener(l,i,k);},removeListener:function(l,k,r){var m,p,u;k=this._getType(k);if(typeof l=="string"){l=this.getEl(l);}else{if(this._isValidCollection(l)){var s=true;for(m=l.length-1;m>-1;m--){s=(this.removeListener(l[m],k,r)&&s);}return s;}}if(!r||!r.call){return this.purgeElement(l,false,k);}if("unload"==k){for(m=j.length-1;m>-1;m--){u=j[m];if(u&&u[0]==l&&u[1]==k&&u[2]==r){j.splice(m,1);return true;}}return false;}var n=null;var o=arguments[3];if("undefined"===typeof o){o=this._getCacheIndex(h,l,k,r);}if(o>=0){n=h[o];}if(!l||!n){return false;}var t=n[this.CAPTURE]===true?true:false;try{this._simpleRemove(l,k,n[this.WFN],t);}catch(q){this.lastError=q;return false;}delete h[o][this.WFN];delete h[o][this.FN];h.splice(o,1);return true;},getTarget:function(m,l){var k=m.target||m.srcElement;return this.resolveTextNode(k);},resolveTextNode:function(l){try{if(l&&3==l.nodeType){return l.parentNode;}}catch(k){return null;}return l;},getPageX:function(l){var k=l.pageX;if(!k&&0!==k){k=l.clientX||0;if(this.isIE){k+=this._getScrollLeft();}}return k;},getPageY:function(k){var l=k.pageY;if(!l&&0!==l){l=k.clientY||0;if(this.isIE){l+=this._getScrollTop();}}return l;},getXY:function(k){return[this.getPageX(k),this.getPageY(k)];},getRelatedTarget:function(l){var k=l.relatedTarget;
if(!k){if(l.type=="mouseout"){k=l.toElement;}else{if(l.type=="mouseover"){k=l.fromElement;}}}return this.resolveTextNode(k);},getTime:function(m){if(!m.time){var l=new Date().getTime();try{m.time=l;}catch(k){this.lastError=k;return l;}}return m.time;},stopEvent:function(k){this.stopPropagation(k);this.preventDefault(k);},stopPropagation:function(k){if(k.stopPropagation){k.stopPropagation();}else{k.cancelBubble=true;}},preventDefault:function(k){if(k.preventDefault){k.preventDefault();}else{k.returnValue=false;}},getEvent:function(m,k){var l=m||window.event;if(!l){var n=this.getEvent.caller;while(n){l=n.arguments[0];if(l&&Event==l.constructor){break;}n=n.caller;}}return l;},getCharCode:function(l){var k=l.keyCode||l.charCode||0;if(YAHOO.env.ua.webkit&&(k in c)){k=c[k];}return k;},_getCacheIndex:function(n,q,r,p){for(var o=0,m=n.length;o<m;o=o+1){var k=n[o];if(k&&k[this.FN]==p&&k[this.EL]==q&&k[this.TYPE]==r){return o;}}return -1;},generateId:function(k){var l=k.id;if(!l){l="yuievtautoid-"+b;++b;k.id=l;}return l;},_isValidCollection:function(l){try{return(l&&typeof l!=="string"&&l.length&&!l.tagName&&!l.alert&&typeof l[0]!=="undefined");}catch(k){return false;}},elCache:{},getEl:function(k){return(typeof k==="string")?document.getElementById(k):k;},clearCache:function(){},DOMReadyEvent:new YAHOO.util.CustomEvent("DOMReady",YAHOO,0,0,1),_load:function(l){if(!g){g=true;var k=YAHOO.util.Event;k._ready();k._tryPreloadAttach();}},_ready:function(l){var k=YAHOO.util.Event;if(!k.DOMReady){k.DOMReady=true;k.DOMReadyEvent.fire();k._simpleRemove(document,"DOMContentLoaded",k._ready);}},_tryPreloadAttach:function(){if(e.length===0){a=0;if(this._interval){this._interval.cancel();this._interval=null;}return;}if(this.locked){return;}if(this.isIE){if(!this.DOMReady){this.startInterval();return;}}this.locked=true;var q=!g;if(!q){q=(a>0&&e.length>0);}var p=[];var r=function(t,u){var s=t;if(u.overrideContext){if(u.overrideContext===true){s=u.obj;}else{s=u.overrideContext;}}u.fn.call(s,u.obj);};var l,k,o,n,m=[];for(l=0,k=e.length;l<k;l=l+1){o=e[l];if(o){n=this.getEl(o.id);if(n){if(o.checkReady){if(g||n.nextSibling||!q){m.push(o);e[l]=null;}}else{r(n,o);e[l]=null;}}else{p.push(o);}}}for(l=0,k=m.length;l<k;l=l+1){o=m[l];r(this.getEl(o.id),o);}a--;if(q){for(l=e.length-1;l>-1;l--){o=e[l];if(!o||!o.id){e.splice(l,1);}}this.startInterval();}else{if(this._interval){this._interval.cancel();this._interval=null;}}this.locked=false;},purgeElement:function(p,q,s){var n=(YAHOO.lang.isString(p))?this.getEl(p):p;var r=this.getListeners(n,s),o,k;if(r){for(o=r.length-1;o>-1;o--){var m=r[o];this.removeListener(n,m.type,m.fn);}}if(q&&n&&n.childNodes){for(o=0,k=n.childNodes.length;o<k;++o){this.purgeElement(n.childNodes[o],q,s);}}},getListeners:function(n,k){var q=[],m;if(!k){m=[h,j];}else{if(k==="unload"){m=[j];}else{k=this._getType(k);m=[h];}}var s=(YAHOO.lang.isString(n))?this.getEl(n):n;for(var p=0;p<m.length;p=p+1){var u=m[p];if(u){for(var r=0,t=u.length;r<t;++r){var o=u[r];if(o&&o[this.EL]===s&&(!k||k===o[this.TYPE])){q.push({type:o[this.TYPE],fn:o[this.FN],obj:o[this.OBJ],adjust:o[this.OVERRIDE],scope:o[this.ADJ_SCOPE],index:r});}}}}return(q.length)?q:null;},_unload:function(s){var m=YAHOO.util.Event,p,o,n,r,q,t=j.slice(),k;for(p=0,r=j.length;p<r;++p){n=t[p];if(n){try{k=window;if(n[m.ADJ_SCOPE]){if(n[m.ADJ_SCOPE]===true){k=n[m.UNLOAD_OBJ];}else{k=n[m.ADJ_SCOPE];}}n[m.FN].call(k,m.getEvent(s,n[m.EL]),n[m.UNLOAD_OBJ]);}catch(w){}t[p]=null;}}n=null;k=null;j=null;if(h){for(o=h.length-1;o>-1;o--){n=h[o];if(n){try{m.removeListener(n[m.EL],n[m.TYPE],n[m.FN],o);}catch(v){}}}n=null;}try{m._simpleRemove(window,"unload",m._unload);m._simpleRemove(window,"load",m._load);}catch(u){}},_getScrollLeft:function(){return this._getScroll()[1];},_getScrollTop:function(){return this._getScroll()[0];},_getScroll:function(){var k=document.documentElement,l=document.body;if(k&&(k.scrollTop||k.scrollLeft)){return[k.scrollTop,k.scrollLeft];}else{if(l){return[l.scrollTop,l.scrollLeft];}else{return[0,0];}}},regCE:function(){},_simpleAdd:function(){if(window.addEventListener){return function(m,n,l,k){m.addEventListener(n,l,(k));};}else{if(window.attachEvent){return function(m,n,l,k){m.attachEvent("on"+n,l);};}else{return function(){};}}}(),_simpleRemove:function(){if(window.removeEventListener){return function(m,n,l,k){m.removeEventListener(n,l,(k));};}else{if(window.detachEvent){return function(l,m,k){l.detachEvent("on"+m,k);};}else{return function(){};}}}()};}();(function(){var a=YAHOO.util.Event;a.on=a.addListener;a.onFocus=a.addFocusListener;a.onBlur=a.addBlurListener;
/*! DOMReady: based on work by: Dean Edwards/John Resig/Matthias Miller/Diego Perini */
if(a.isIE){if(self!==self.top){document.onreadystatechange=function(){if(document.readyState=="complete"){document.onreadystatechange=null;a._ready();}};}else{YAHOO.util.Event.onDOMReady(YAHOO.util.Event._tryPreloadAttach,YAHOO.util.Event,true);var b=document.createElement("p");a._dri=setInterval(function(){try{b.doScroll("left");clearInterval(a._dri);a._dri=null;a._ready();b=null;}catch(c){}},a.POLL_INTERVAL);}}else{if(a.webkit&&a.webkit<525){a._dri=setInterval(function(){var c=document.readyState;if("loaded"==c||"complete"==c){clearInterval(a._dri);a._dri=null;a._ready();}},a.POLL_INTERVAL);}else{a._simpleAdd(document,"DOMContentLoaded",a._ready);}}a._simpleAdd(window,"load",a._load);a._simpleAdd(window,"unload",a._unload);a._tryPreloadAttach();})();}YAHOO.util.EventProvider=function(){};YAHOO.util.EventProvider.prototype={__yui_events:null,__yui_subscribers:null,subscribe:function(a,c,f,e){this.__yui_events=this.__yui_events||{};var d=this.__yui_events[a];if(d){d.subscribe(c,f,e);}else{this.__yui_subscribers=this.__yui_subscribers||{};var b=this.__yui_subscribers;if(!b[a]){b[a]=[];}b[a].push({fn:c,obj:f,overrideContext:e});}},unsubscribe:function(c,e,g){this.__yui_events=this.__yui_events||{};var a=this.__yui_events;if(c){var f=a[c];if(f){return f.unsubscribe(e,g);}}else{var b=true;for(var d in a){if(YAHOO.lang.hasOwnProperty(a,d)){b=b&&a[d].unsubscribe(e,g);
}}return b;}return false;},unsubscribeAll:function(a){return this.unsubscribe(a);},createEvent:function(b,g){this.__yui_events=this.__yui_events||{};var e=g||{},d=this.__yui_events,f;if(d[b]){}else{f=new YAHOO.util.CustomEvent(b,e.scope||this,e.silent,YAHOO.util.CustomEvent.FLAT,e.fireOnce);d[b]=f;if(e.onSubscribeCallback){f.subscribeEvent.subscribe(e.onSubscribeCallback);}this.__yui_subscribers=this.__yui_subscribers||{};var a=this.__yui_subscribers[b];if(a){for(var c=0;c<a.length;++c){f.subscribe(a[c].fn,a[c].obj,a[c].overrideContext);}}}return d[b];},fireEvent:function(b){this.__yui_events=this.__yui_events||{};var d=this.__yui_events[b];if(!d){return null;}var a=[];for(var c=1;c<arguments.length;++c){a.push(arguments[c]);}return d.fire.apply(d,a);},hasEvent:function(a){if(this.__yui_events){if(this.__yui_events[a]){return true;}}return false;}};(function(){var a=YAHOO.util.Event,c=YAHOO.lang;YAHOO.util.KeyListener=function(d,i,e,f){if(!d){}else{if(!i){}else{if(!e){}}}if(!f){f=YAHOO.util.KeyListener.KEYDOWN;}var g=new YAHOO.util.CustomEvent("keyPressed");this.enabledEvent=new YAHOO.util.CustomEvent("enabled");this.disabledEvent=new YAHOO.util.CustomEvent("disabled");if(c.isString(d)){d=document.getElementById(d);}if(c.isFunction(e)){g.subscribe(e);}else{g.subscribe(e.fn,e.scope,e.correctScope);}function h(o,n){if(!i.shift){i.shift=false;}if(!i.alt){i.alt=false;}if(!i.ctrl){i.ctrl=false;}if(o.shiftKey==i.shift&&o.altKey==i.alt&&o.ctrlKey==i.ctrl){var j,m=i.keys,l;if(YAHOO.lang.isArray(m)){for(var k=0;k<m.length;k++){j=m[k];l=a.getCharCode(o);if(j==l){g.fire(l,o);break;}}}else{l=a.getCharCode(o);if(m==l){g.fire(l,o);}}}}this.enable=function(){if(!this.enabled){a.on(d,f,h);this.enabledEvent.fire(i);}this.enabled=true;};this.disable=function(){if(this.enabled){a.removeListener(d,f,h);this.disabledEvent.fire(i);}this.enabled=false;};this.toString=function(){return"KeyListener ["+i.keys+"] "+d.tagName+(d.id?"["+d.id+"]":"");};};var b=YAHOO.util.KeyListener;b.KEYDOWN="keydown";b.KEYUP="keyup";b.KEY={ALT:18,BACK_SPACE:8,CAPS_LOCK:20,CONTROL:17,DELETE:46,DOWN:40,END:35,ENTER:13,ESCAPE:27,HOME:36,LEFT:37,META:224,NUM_LOCK:144,PAGE_DOWN:34,PAGE_UP:33,PAUSE:19,PRINTSCREEN:44,RIGHT:39,SCROLL_LOCK:145,SHIFT:16,SPACE:32,TAB:9,UP:38};})();YAHOO.register("event",YAHOO.util.Event,{version:"2.9.0",build:"2800"});YAHOO.register("yahoo-dom-event", YAHOO, {version: "2.9.0", build: "2800"});

/*
stylehseet-min.js
Copyright (c) 2011, Yahoo! Inc. All rights reserved.
Code licensed under the BSD License:
http://developer.yahoo.com/yui/license.html
version: 2.9.0
*/
(function(){var j=document,b=j.createElement("p"),e=b.style,c=YAHOO.lang,m={},i={},f=0,k=("cssFloat" in e)?"cssFloat":"styleFloat",g,a,l;a=("opacity" in e)?function(d){d.opacity="";}:function(d){d.filter="";};e.border="1px solid red";e.border="";l=e.borderLeft?function(d,o){var n;if(o!==k&&o.toLowerCase().indexOf("float")!=-1){o=k;}if(typeof d[o]==="string"){switch(o){case"opacity":case"filter":a(d);break;case"font":d.font=d.fontStyle=d.fontVariant=d.fontWeight=d.fontSize=d.lineHeight=d.fontFamily="";break;default:for(n in d){if(n.indexOf(o)===0){d[n]="";}}}}}:function(d,n){if(n!==k&&n.toLowerCase().indexOf("float")!=-1){n=k;}if(c.isString(d[n])){if(n==="opacity"){a(d);}else{d[n]="";}}};function h(u,o){var x,s,w,v={},n,y,q,t,d,p;if(!(this instanceof h)){return new h(u,o);}s=u&&(u.nodeName?u:j.getElementById(u));if(u&&i[u]){return i[u];}else{if(s&&s.yuiSSID&&i[s.yuiSSID]){return i[s.yuiSSID];}}if(!s||!/^(?:style|link)$/i.test(s.nodeName)){s=j.createElement("style");s.type="text/css";}if(c.isString(u)){if(u.indexOf("{")!=-1){if(s.styleSheet){s.styleSheet.cssText=u;}else{s.appendChild(j.createTextNode(u));}}else{if(!o){o=u;}}}if(!s.parentNode||s.parentNode.nodeName.toLowerCase()!=="head"){x=(s.ownerDocument||j).getElementsByTagName("head")[0];x.appendChild(s);}w=s.sheet||s.styleSheet;n=w&&("cssRules" in w)?"cssRules":"rules";q=("deleteRule" in w)?function(r){w.deleteRule(r);}:function(r){w.removeRule(r);};y=("insertRule" in w)?function(A,z,r){w.insertRule(A+" {"+z+"}",r);}:function(A,z,r){w.addRule(A,z,r);};for(t=w[n].length-1;t>=0;--t){d=w[n][t];p=d.selectorText;if(v[p]){v[p].style.cssText+=";"+d.style.cssText;q(t);}else{v[p]=d;}}s.yuiSSID="yui-stylesheet-"+(f++);h.register(s.yuiSSID,this);if(o){h.register(o,this);}c.augmentObject(this,{getId:function(){return s.yuiSSID;},node:s,enable:function(){w.disabled=false;return this;},disable:function(){w.disabled=true;return this;},isEnabled:function(){return !w.disabled;},set:function(B,A){var D=v[B],C=B.split(/\s*,\s*/),z,r;if(C.length>1){for(z=C.length-1;z>=0;--z){this.set(C[z],A);}return this;}if(!h.isValidSelector(B)){return this;}if(D){D.style.cssText=h.toCssText(A,D.style.cssText);}else{r=w[n].length;A=h.toCssText(A);if(A){y(B,A,r);v[B]=w[n][r];}}return this;},unset:function(B,A){var D=v[B],C=B.split(/\s*,\s*/),r=!A,E,z;if(C.length>1){for(z=C.length-1;z>=0;--z){this.unset(C[z],A);}return this;}if(D){if(!r){if(!c.isArray(A)){A=[A];}e.cssText=D.style.cssText;for(z=A.length-1;z>=0;--z){l(e,A[z]);}if(e.cssText){D.style.cssText=e.cssText;}else{r=true;}}if(r){E=w[n];for(z=E.length-1;z>=0;--z){if(E[z]===D){delete v[B];q(z);break;}}}}return this;},getCssText:function(A){var B,z,r;if(c.isString(A)){B=v[A.split(/\s*,\s*/)[0]];return B?B.style.cssText:null;}else{z=[];for(r in v){if(v.hasOwnProperty(r)){B=v[r];z.push(B.selectorText+" {"+B.style.cssText+"}");}}return z.join("\n");}}},true);}g=function(n,p){var o=n.styleFloat||n.cssFloat||n["float"],r;try{e.cssText=p||"";}catch(d){b=j.createElement("p");e=b.style;e.cssText=p||"";}if(c.isString(n)){e.cssText+=";"+n;}else{if(o&&!n[k]){n=c.merge(n);delete n.styleFloat;delete n.cssFloat;delete n["float"];n[k]=o;}for(r in n){if(n.hasOwnProperty(r)){try{e[r]=c.trim(n[r]);}catch(q){}}}}return e.cssText;};c.augmentObject(h,{toCssText:(("opacity" in e)?g:function(d,n){if(c.isObject(d)&&"opacity" in d){d=c.merge(d,{filter:"alpha(opacity="+(d.opacity*100)+")"});delete d.opacity;}return g(d,n);}),register:function(d,n){return !!(d&&n instanceof h&&!i[d]&&(i[d]=n));},isValidSelector:function(n){var d=false;if(n&&c.isString(n)){if(!m.hasOwnProperty(n)){m[n]=!/\S/.test(n.replace(/\s+|\s*[+~>]\s*/g," ").replace(/([^ ])\[.*?\]/g,"$1").replace(/([^ ])::?[a-z][a-z\-]+[a-z](?:\(.*?\))?/ig,"$1").replace(/(?:^| )[a-z0-6]+/ig," ").replace(/\\./g,"").replace(/[.#]\w[\w\-]*/g,""));}d=m[n];}return d;}},true);YAHOO.util.StyleSheet=h;})();YAHOO.register("stylesheet",YAHOO.util.StyleSheet,{version:"2.9.0",build:"2800"});

/*
imageloader-min.js
Copyright (c) 2011, Yahoo! Inc. All rights reserved.
Code licensed under the BSD License:
http://developer.yahoo.com/yui/license.html
version: 2.9.0
*/
if(typeof(YAHOO.util.ImageLoader)=="undefined"){YAHOO.util.ImageLoader={};}YAHOO.util.ImageLoader.group=function(A,B,C){this.name="unnamed";this._imgObjs={};this.timeoutLen=C;this._timeout=null;this._triggers=[];this._customTriggers=[];this.foldConditional=false;this.className=null;this._classImageEls=null;if(YAHOO.util.Event.DOMReady){this._onloadTasks();}else{YAHOO.util.Event.onDOMReady(this._onloadTasks,this,true);}this.addTrigger(A,B);};YAHOO.util.ImageLoader.group.prototype.addTrigger=function(B,C){if(!B||!C){return;}var A=function(){this.fetch();};this._triggers.push([B,C,A]);YAHOO.util.Event.addListener(B,C,A,this,true);};YAHOO.util.ImageLoader.group.prototype.addCustomTrigger=function(B){if(!B||!B instanceof YAHOO.util.CustomEvent){return;}var A=function(){this.fetch();};this._customTriggers.push([B,A]);B.subscribe(A,this,true);};YAHOO.util.ImageLoader.group.prototype._onloadTasks=function(){if(this.timeoutLen&&typeof(this.timeoutLen)=="number"&&this.timeoutLen>0){this._timeout=setTimeout(this._getFetchTimeout(),this.timeoutLen*1000);}if(this.foldConditional){this._foldCheck();}};YAHOO.util.ImageLoader.group.prototype._getFetchTimeout=function(){var A=this;return function(){A.fetch();};};YAHOO.util.ImageLoader.group.prototype.registerBgImage=function(B,A){this._imgObjs[B]=new YAHOO.util.ImageLoader.bgImgObj(B,A);return this._imgObjs[B];};YAHOO.util.ImageLoader.group.prototype.registerSrcImage=function(D,B,C,A){this._imgObjs[D]=new YAHOO.util.ImageLoader.srcImgObj(D,B,C,A);return this._imgObjs[D];};YAHOO.util.ImageLoader.group.prototype.registerPngBgImage=function(C,B,A){this._imgObjs[C]=new YAHOO.util.ImageLoader.pngBgImgObj(C,B,A);return this._imgObjs[C];};YAHOO.util.ImageLoader.group.prototype.fetch=function(){var B,A,C;clearTimeout(this._timeout);for(B=0,A=this._triggers.length;B<A;B++){YAHOO.util.Event.removeListener(this._triggers[B][0],this._triggers[B][1],this._triggers[B][2]);}for(B=0,A=this._customTriggers.length;B<A;B++){this._customTriggers[B][0].unsubscribe(this._customTriggers[B][1],this);}this._fetchByClass();for(C in this._imgObjs){if(YAHOO.lang.hasOwnProperty(this._imgObjs,C)){this._imgObjs[C].fetch();}}};YAHOO.util.ImageLoader.group.prototype._foldCheck=function(){var C=(document.compatMode!="CSS1Compat")?document.body.scrollTop:document.documentElement.scrollTop,D=YAHOO.util.Dom.getViewportHeight(),A=C+D,E=(document.compatMode!="CSS1Compat")?document.body.scrollLeft:document.documentElement.scrollLeft,G=YAHOO.util.Dom.getViewportWidth(),I=E+G,B,J,F,H;for(B in this._imgObjs){if(YAHOO.lang.hasOwnProperty(this._imgObjs,B)){J=YAHOO.util.Dom.getXY(this._imgObjs[B].domId);if(J[1]<A&&J[0]<I){this._imgObjs[B].fetch();}}}if(this.className){this._classImageEls=YAHOO.util.Dom.getElementsByClassName(this.className);for(F=0,H=this._classImageEls.length;F<H;F++){J=YAHOO.util.Dom.getXY(this._classImageEls[F]);if(J[1]<A&&J[0]<I){YAHOO.util.Dom.removeClass(this._classImageEls[F],this.className);}}}};YAHOO.util.ImageLoader.group.prototype._fetchByClass=function(){if(!this.className){return;}if(this._classImageEls===null){this._classImageEls=YAHOO.util.Dom.getElementsByClassName(this.className);}YAHOO.util.Dom.removeClass(this._classImageEls,this.className);};YAHOO.util.ImageLoader.imgObj=function(B,A){this.domId=B;this.url=A;this.width=null;this.height=null;this.setVisible=false;this._fetched=false;};YAHOO.util.ImageLoader.imgObj.prototype.fetch=function(){if(this._fetched){return;}var A=document.getElementById(this.domId);if(!A){return;}this._applyUrl(A);if(this.setVisible){A.style.visibility="visible";}if(this.width){A.width=this.width;}if(this.height){A.height=this.height;}this._fetched=true;};YAHOO.util.ImageLoader.imgObj.prototype._applyUrl=function(A){};YAHOO.util.ImageLoader.bgImgObj=function(B,A){YAHOO.util.ImageLoader.bgImgObj.superclass.constructor.call(this,B,A);};YAHOO.lang.extend(YAHOO.util.ImageLoader.bgImgObj,YAHOO.util.ImageLoader.imgObj);YAHOO.util.ImageLoader.bgImgObj.prototype._applyUrl=function(A){A.style.backgroundImage="url(http://duckduckgo.com/'"+this.url+"')";};YAHOO.util.ImageLoader.srcImgObj=function(D,B,C,A){YAHOO.util.ImageLoader.srcImgObj.superclass.constructor.call(this,D,B);this.width=C;this.height=A;};YAHOO.lang.extend(YAHOO.util.ImageLoader.srcImgObj,YAHOO.util.ImageLoader.imgObj);YAHOO.util.ImageLoader.srcImgObj.prototype._applyUrl=function(A){A.src=this.url;};YAHOO.util.ImageLoader.pngBgImgObj=function(C,B,A){YAHOO.util.ImageLoader.pngBgImgObj.superclass.constructor.call(this,C,B);this.props=A||{};};YAHOO.lang.extend(YAHOO.util.ImageLoader.pngBgImgObj,YAHOO.util.ImageLoader.imgObj);YAHOO.util.ImageLoader.pngBgImgObj.prototype._applyUrl=function(B){if(YAHOO.env.ua.ie&&YAHOO.env.ua.ie<=6){var C=(YAHOO.lang.isUndefined(this.props.sizingMethod))?"scale":this.props.sizingMethod,A=(YAHOO.lang.isUndefined(this.props.enabled))?"true":this.props.enabled;B.style.filter='progid:DXImageTransform.Microsoft.AlphaImageLoader(src="'+this.url+'", sizingMethod="'+C+'", enabled="'+A+'")';}else{B.style.backgroundImage="url(http://duckduckgo.com/'"+this.url+"')";}};YAHOO.register("imageloader",YAHOO.util.ImageLoader,{version:"2.9.0",build:"2800"});

/*
cookie-min.js
Copyright (c) 2009, Yahoo! Inc. All rights reserved.
Code licensed under the BSD License:
http://developer.yahoo.net/yui/license.txt
version: 2.8.0r4
*/
YAHOO.namespace("util");YAHOO.util.Cookie={_createCookieString:function(B,D,C,A){var F=YAHOO.lang,E=encodeURIComponent(B)+"="+(C?encodeURIComponent(D):D);if(F.isObject(A)){if(A.expires instanceof Date){E+="; expires="+A.expires.toUTCString();}if(F.isString(A.path)&&A.path!==""){E+="; path="+A.path;}if(F.isString(A.domain)&&A.domain!==""){E+="; domain="+A.domain;}if(A.secure===true){E+="; secure";}}return E;},_createCookieHashString:function(B){var D=YAHOO.lang;if(!D.isObject(B)){throw new TypeError("Cookie._createCookieHashString(): Argument must be an object.");}var C=[];for(var A in B){if(D.hasOwnProperty(B,A)&&!D.isFunction(B[A])&&!D.isUndefined(B[A])){C.push(encodeURIComponent(A)+"="+encodeURIComponent(String(B[A])));}}return C.join("&");},_parseCookieHash:function(E){var D=E.split("&"),F=null,C={};if(E.length>0){for(var B=0,A=D.length;B<A;B++){F=D[B].split("=");C[decodeURIComponent(F[0])]=decodeURIComponent(F[1]);}}return C;},_parseCookieString:function(J,A){var K={};if(YAHOO.lang.isString(J)&&J.length>0){var B=(A===false?function(L){return L;}:decodeURIComponent);var H=J.split(/;\s/g),I=null,C=null,E=null;for(var D=0,F=H.length;D<F;D++){E=H[D].match(/([^=]+)=/i);if(E instanceof Array){try{I=decodeURIComponent(E[1]);C=B(H[D].substring(E[1].length+1));}catch(G){}}else{I=decodeURIComponent(H[D]);C="";}K[I]=C;}}return K;},exists:function(A){if(!YAHOO.lang.isString(A)||A===""){throw new TypeError("Cookie.exists(): Cookie name must be a non-empty string.");}var B=this._parseCookieString(document.cookie,true);return B.hasOwnProperty(A);},get:function(B,A){var E=YAHOO.lang,C;if(E.isFunction(A)){C=A;A={};}else{if(E.isObject(A)){C=A.converter;}else{A={};}}var D=this._parseCookieString(document.cookie,!A.raw);if(!E.isString(B)||B===""){throw new TypeError("Cookie.get(): Cookie name must be a non-empty string.");}if(E.isUndefined(D[B])){return null;}if(!E.isFunction(C)){return D[B];}else{return C(D[B]);}},getSub:function(A,C,B){var E=YAHOO.lang,D=this.getSubs(A);if(D!==null){if(!E.isString(C)||C===""){throw new TypeError("Cookie.getSub(): Subcookie name must be a non-empty string.");}if(E.isUndefined(D[C])){return null;}if(!E.isFunction(B)){return D[C];}else{return B(D[C]);}}else{return null;}},getSubs:function(B){var A=YAHOO.lang.isString;if(!A(B)||B===""){throw new TypeError("Cookie.getSubs(): Cookie name must be a non-empty string.");}var C=this._parseCookieString(document.cookie,false);if(A(C[B])){return this._parseCookieHash(C[B]);}return null;},remove:function(B,A){if(!YAHOO.lang.isString(B)||B===""){throw new TypeError("Cookie.remove(): Cookie name must be a non-empty string.");}A=YAHOO.lang.merge(A||{},{expires:new Date(0)});return this.set(B,"",A);},removeSub:function(B,E,A){var F=YAHOO.lang;A=A||{};if(!F.isString(B)||B===""){throw new TypeError("Cookie.removeSub(): Cookie name must be a non-empty string.");}if(!F.isString(E)||E===""){throw new TypeError("Cookie.removeSub(): Subcookie name must be a non-empty string.");}var D=this.getSubs(B);if(F.isObject(D)&&F.hasOwnProperty(D,E)){delete D[E];if(!A.removeIfEmpty){return this.setSubs(B,D,A);}else{for(var C in D){if(F.hasOwnProperty(D,C)&&!F.isFunction(D[C])&&!F.isUndefined(D[C])){return this.setSubs(B,D,A);}}return this.remove(B,A);}}else{return"";}},set:function(B,C,A){var E=YAHOO.lang;A=A||{};if(!E.isString(B)){throw new TypeError("Cookie.set(): Cookie name must be a string.");}if(E.isUndefined(C)){throw new TypeError("Cookie.set(): Value cannot be undefined.");}var D=this._createCookieString(B,C,!A.raw,A);document.cookie=D;return D;},setSub:function(B,D,C,A){var F=YAHOO.lang;if(!F.isString(B)||B===""){throw new TypeError("Cookie.setSub(): Cookie name must be a non-empty string.");}if(!F.isString(D)||D===""){throw new TypeError("Cookie.setSub(): Subcookie name must be a non-empty string.");}if(F.isUndefined(C)){throw new TypeError("Cookie.setSub(): Subcookie value cannot be undefined.");}var E=this.getSubs(B);if(!F.isObject(E)){E={};}E[D]=C;return this.setSubs(B,E,A);},setSubs:function(B,C,A){var E=YAHOO.lang;if(!E.isString(B)){throw new TypeError("Cookie.setSubs(): Cookie name must be a string.");}if(!E.isObject(C)){throw new TypeError("Cookie.setSubs(): Cookie value must be an object.");}var D=this._createCookieString(B,this._createCookieHashString(C),false,A);document.cookie=D;return D;}};YAHOO.register("cookie",YAHOO.util.Cookie,{version:"2.8.0r4",build:"2446"});



/*http://www.featureblend.com/flash_detect_1-0-4/yahoo_flash_detect_min.js*/
YAHOO.util.FlashDetect=new function(){var self=this;self.installed=false;self.raw="";self.major=-1;self.minor=-1;self.revision=-1;self.revisionStr="";var activeXDetectRules=[{"name":"ShockwaveFlash.ShockwaveFlash.7","version":function(obj){return getActiveXVersion(obj);}},{"name":"ShockwaveFlash.ShockwaveFlash.6","version":function(obj){var version="6,0,21";try{obj.AllowScriptAccess="always";version=getActiveXVersion(obj);}catch(err){}
return version;}},{"name":"ShockwaveFlash.ShockwaveFlash","version":function(obj){return getActiveXVersion(obj);}}];var getActiveXVersion=function(activeXObj){var version=-1;try{version=activeXObj.GetVariable("$version");}catch(err){}
return version;};var getActiveXObject=function(name){var obj=-1;try{obj=new ActiveXObject(name);}catch(err){obj={activeXError:true};}
return obj;};var parseActiveXVersion=function(str){var versionArray=str.split(",");return{"raw":str,"major":parseInt(versionArray[0].split(" ")[1],10),"minor":parseInt(versionArray[1],10),"revision":parseInt(versionArray[2],10),"revisionStr":versionArray[2]};};var parseStandardVersion=function(str){var descParts=str.split(/ +/);var majorMinor=descParts[2].split(/\./);var revisionStr=descParts[3];return{"raw":str,"major":parseInt(majorMinor[0],10),"minor":parseInt(majorMinor[1],10),"revisionStr":revisionStr,"revision":parseRevisionStrToInt(revisionStr)};};var parseRevisionStrToInt=function(str){return parseInt(str.replace(/[a-zA-Z]/g,""),10)||self.revision;};self.majorAtLeast=function(version){return self.major>=version;};self.minorAtLeast=function(version){return self.minor>=version;};self.revisionAtLeast=function(version){return self.revision>=version;};self.versionAtLeast=function(major){var properties=[self.major,self.minor,self.revision];var len=Math.min(properties.length,arguments.length);for(i=0;i<len;i++){if(properties[i]>=arguments[i]){if(i+1<len&&properties[i]==arguments[i]){continue;}else{return true;}}else{return false;}}};self.FlashDetect=function(){if(navigator.plugins&&navigator.plugins.length>0){var type='application/x-shockwave-flash';var mimeTypes=navigator.mimeTypes;if(mimeTypes&&mimeTypes[type]&&mimeTypes[type].enabledPlugin&&mimeTypes[type].enabledPlugin.description){var version=mimeTypes[type].enabledPlugin.description;var versionObj=parseStandardVersion(version);self.raw=versionObj.raw;self.major=versionObj.major;self.minor=versionObj.minor;self.revisionStr=versionObj.revisionStr;self.revision=versionObj.revision;self.installed=true;}}else if(navigator.appVersion.indexOf("Mac")==-1&&window.execScript){var version=-1;for(var i=0;i<activeXDetectRules.length&&version==-1;i++){var obj=getActiveXObject(activeXDetectRules[i].name);if(!obj.activeXError){self.installed=true;version=activeXDetectRules[i].version(obj);if(version!=-1){var versionObj=parseActiveXVersion(version);self.raw=versionObj.raw;self.major=versionObj.major;self.minor=versionObj.minor;self.revision=versionObj.revision;self.revisionStr=versionObj.revisionStr;}}}}}();};YAHOO.util.FlashDetect.JS_RELEASE="1.0.4";



// Fixes emacs display.
//'"}
//			alert('test');

var d=document;
var w=window;
if (!w.ka) ka=YAHOO.util.Cookie.get("a")||'';
if (!w.kb) kb=YAHOO.util.Cookie.get("b")||'';
if (!w.kc) kc=YAHOO.util.Cookie.get("c")||'';
if (!w.kd) kd=YAHOO.util.Cookie.get("d")||'';
if (!w.ke) ke=YAHOO.util.Cookie.get("e")||'';
if (!w.kf) kf=YAHOO.util.Cookie.get("f")||'';
if (!w.kg) kg=YAHOO.util.Cookie.get("g")||'';
if (!w.kh) kh=YAHOO.util.Cookie.get("h")||'';
if (!w.ki) ki=YAHOO.util.Cookie.get("i")||'';
if (!w.kj) kj=YAHOO.util.Cookie.get("j")||'';
if (!w.kk) kk=YAHOO.util.Cookie.get("k")||'';
if (!w.kl) kl=YAHOO.util.Cookie.get("l")||'';
if (!w.km) km=YAHOO.util.Cookie.get("m")||'';
if (!w.kn) kn=YAHOO.util.Cookie.get("n")||'';
if (!w.ko) ko=YAHOO.util.Cookie.get("o")||'';
if (!w.kp) kp=YAHOO.util.Cookie.get("p")||'';
if (!w.kq) kq=YAHOO.util.Cookie.get("q")||'';
if (!w.kr) kr=YAHOO.util.Cookie.get("r")||'';
if (!w.ks) ks=YAHOO.util.Cookie.get("s")||'';
if (!w.kt) kt=YAHOO.util.Cookie.get("t")||'';
if (!w.ku) ku=YAHOO.util.Cookie.get("u")||'';
if (!w.kv) kv=YAHOO.util.Cookie.get("v")||'';
if (!w.kw) kw=YAHOO.util.Cookie.get("w")||'';
if (!w.kx) kx=YAHOO.util.Cookie.get("x")||'';
if (!w.ky) ky=YAHOO.util.Cookie.get("y")||'';
if (!w.kz) kz=YAHOO.util.Cookie.get("z")||'';
if (!w.k1) k1=YAHOO.util.Cookie.get("1")||'';
if (!w.k2) k2=YAHOO.util.Cookie.get("2")||'';
if (!w.k3) k3=YAHOO.util.Cookie.get("3")||'';
if (!w.k4) k4=YAHOO.util.Cookie.get("4")||'';
if (!w.k5) k5=YAHOO.util.Cookie.get("5")||'';
if (!w.k6) k6=YAHOO.util.Cookie.get("6")||'';
if (!w.k7) k7=YAHOO.util.Cookie.get("7")||'';
if (!w.k8) k8=YAHOO.util.Cookie.get("8")||'';
if (!w.k9) k9=YAHOO.util.Cookie.get("9")||'';
if (!w.kaa) kaa=YAHOO.util.Cookie.get("aa")||'';
if (!w.kab) kab=YAHOO.util.Cookie.get("ab")||'';
if (!w.kac) kac=YAHOO.util.Cookie.get("ac")||'';
if (!w.kad) kad=YAHOO.util.Cookie.get("ad")||'';
if (!w.kae) kae=YAHOO.util.Cookie.get("ae")||'';
if (!w.kaf) kaf=YAHOO.util.Cookie.get("af")||'';
if (!w.kag) kag=YAHOO.util.Cookie.get("ag")||'';
if (!w.kah) kah=YAHOO.util.Cookie.get("ah")||'';
if (!w.kai) kai=YAHOO.util.Cookie.get("ai")||'';
if (!w.kaj) kaj=YAHOO.util.Cookie.get("aj")||'';
if (!w.kak) kak=YAHOO.util.Cookie.get("ak")||'';
if (!w.kal) kal=YAHOO.util.Cookie.get("al")||'';
if (!w.kam) kam=YAHOO.util.Cookie.get("am")||'';
if (!w.kan) kan=YAHOO.util.Cookie.get("an")||'';
if (!w.kao) kao=YAHOO.util.Cookie.get("ao")||'';
if (!w.kap) kap=YAHOO.util.Cookie.get("ap")||'';
if (!w.kaq) kaq=YAHOO.util.Cookie.get("aq")||'';
if (!w.kar) kar=YAHOO.util.Cookie.get("ar")||'';
if (!w.kas) kas=YAHOO.util.Cookie.get("as")||'';
if (!w.kat) kat=YAHOO.util.Cookie.get("at")||'';
if (!w.kau) kau=YAHOO.util.Cookie.get("au")||'';
if (!w.kav) kav=YAHOO.util.Cookie.get("av")||'';
if (!w.kaw) kaw=YAHOO.util.Cookie.get("aw")||'';
if (!w.kax) kax=YAHOO.util.Cookie.get("ax")||'';
if (!w.kay) kay=YAHOO.util.Cookie.get("ay")||'';
if (!w.kaz) kaz=YAHOO.util.Cookie.get("az")||'';




// Fix for missing l function.
if (!window.l) l = function (str) {return str};

// http://www.zachleat.com/web/namespacing-outside-of-the-yahoo-namespace/
if (typeof DDG == "undefined") {
    var DDG = {};
}
DDG.namespace = function() {
    var a=arguments, o=null, i, j, d;
    for (i=0; i<a.length; i=i+1) {
        d=a[i].split(".");
        o=window;
        for (j=0; j<d.length; j=j+1) {
            o[d[j]]=o[d[j]] || {};
            o=o[d[j]];
        }
    }
    return o;
};


/*
   ^new DDG space

   ^instance variables
   page_type - 0 for results, 1 for homepage, 2 for internal pages (about)
*/

DDG.stylesheet = YAHOO.util.StyleSheet('DDG');
DDG.first_result = 'r1-0';
DDG.is_deep_loaded = 0;
DDG.is_ad_blocked = false;
DDG.is_ad_called = false;
DDG.is_top_map = false;
DDG.is_side_map = false;

DDG.first_source = false;

DDG.is_results_page = false; 
if (window.irp) DDG.is_results_page = true; /* marked in View.pm */

/* http://adblockdetector.com/ 
  http://stackoverflow.com/questions/3393490/converting-adblock-detecting-javascript-to-jquery
*/
DDG.detect_ad_block = function (isDetected) {


    if (!DDG.is_ad_blocked && isDetected) DDG.is_ad_blocked = true;

    //    console.log(DDG.is_ad_called);

    if (!DDG.is_ad_blocked && !DDG.is_ad_called && d.getElementById('ads') && !iqa) {
	    
	nrj('/y.js?x=1&q='+rq+(ra ? '&a='+ra : ''));
	
	DDG.is_ad_called = true;
    }
}
var _abdStatusFnc = 'DDG.detect_ad_block';

(function () {
    var _ab = false;
    var _af = undefined;
    var _am = undefined;
    
    function detect_ab() {
	//	console.log(DDG.is_results_page);
	if (!DDG.is_results_page) return false;
	setTimeout(detect_ab2, 100);
    };

    function detect_ab2() {

	_af = document.createElement("IFRAME");
	_am = document.createElement("IMG");
	_af.id = '_afd';
	_af.src = '/adimages/';
	_af.style.display = 'block';
	_af.style.border = 'none';
	_am.id = '_amd';
	_am.src = '/adimages/textlink-ads.jpg';
	_am.style.width = _af.style.width = '1px';
	_am.style.height = _af.style.height = '1px';
	_am.style.top = _af.style.top = '-1000px';
	_am.style.left = _af.style.left = '-1000px';

	if (document && document.body) {
	    document.body.appendChild(_af);
	    document.body.appendChild(_am);
	    setTimeout(_ss, 100)
		}
    };
    
    function _ss() {
	if (document.getElementById('_amd').style.display.indexOf('none') > -1) _ab = true;
	else if (document.getElementById('_afd').style.visibility == 'hidden') _ab = true;
	else if (document.getElementById('_afd').clientHeight == 0) _ab = true;
	_af.parentNode.removeChild(_af);
	_am.parentNode.removeChild(_am);
	if (typeof(_abdStatusFnc) != 'undefined') eval(_abdStatusFnc + '(' + _ab + ');');
	else {
	    if ((_ab == true) && (typeof(_abdDetectedFnc) != 'undefined')) eval(_abdDetectedFnc + '();');
	    if ((_ab == false) && (typeof(_abdNotDetectedFnc) != 'undefined')) eval(_abdNotDetectedFnc + '();')
										   }
    };
    detect_ab()}
    )();
						
/* 
ads 
*/
DDG.is_ad_loaded = 0;
DDG.is_default_ad_loaded = 0;
DDG.default_ad = '';
DDG.show_default_ad = function () {

    //    console.log('showing default ad');
    //    console.log(DDG.default_ad);
    //    console.log(DDG.is_ad_loaded);

    DDG.is_default_ad_loaded = 1;
    if (DDG.is_ad_loaded) return false;
    if (DDG.default_ad) {

	//	console.log('showing default ad');
	//	console.log(DDG.default_ad);

	nrn('a',DDG.default_ad);
	YAHOO.util.Dom.setStyle('ads','display','block');
    } else {
	YAHOO.util.Dom.setStyle('ads','display','none');
    }
}


/* get internal variables */
DDG.get_query_encoded = function() {return rq};
DDG.get_query = function() {return decodeURIComponent(rq)};

DDG.get_asset_path = function(spice_name, asset) {
  var sharedir = "/share/spice/" + spice_name + 
      "/" + spice_version + "/";
  return sharedir + asset;
}

DDG.get_now = function() {
    var dateNow = new Date();
    return dateNow.getTime();
}

/* Set top padding for result sections based on what is showing on top 
   examples:
   examplez (spice, spelling, ads, links)
   examplez test (spelling, ads, links)
   examplez dfdfd (spelling, links)
   superbad dvd (ads, links)
   superbaddfdfd (spelling, links)
   blink182 video (spice, ads, links)
   dfdggffxs (links)
   superbad dvd xxx (ads, safe_search, links)
   lady chatterly (fathead, ads, safe_search, links)
   343+343 (answer, ads, links) 
   Gettysburg Battlefield Historic District (fathead, links)
   kosmix (fathead, official_site, links)
*/
DDG.set_results_spacing = function() {

    var padding = 10;

    // Reset.
    YAHOO.util.Dom.setStyle('links','padding-top','0px');        
    YAHOO.util.Dom.setStyle('ads','padding-top','0px');        
    YAHOO.util.Dom.setStyle('did_you_means','padding-top','0px');        

    var is_above_links = 0;

    // Order of display.
    if (YAHOO.util.Dom.getStyle('did_you_means', 'display')=='block') {
	YAHOO.util.Dom.setStyle('did_you_means','padding-top',padding + 'px');
	is_above_links = 1;

    } else if (YAHOO.util.Dom.getStyle('ads', 'display')=='block') {
	YAHOO.util.Dom.setStyle('ads','padding-top',padding + 'px');
	is_above_links = 1;

    } else if (YAHOO.util.Dom.getStyle('links', 'display')=='block') {
	YAHOO.util.Dom.setStyle('links','padding-top',padding + 'px');
	is_above_links = 1;

    }

    if (is_above_links) {
	YAHOO.util.Dom.setStyle('zero_click_message','padding-top',padding + 'px');	
    }
}

DDG.report_bad_query = function() {
    DDG.toggle('report_bad_query_link');
    DDG.toggle('try_search_on_links');
    DDG.toggle('feedback_modal',1);
    div = document.getElementById('feedback_modal_title');

    var report_url = 'https://collect.duckduckgo.com/collect.js?type=relevancy&q='+rq;
    if (rl) report_url += '&region=' + rl;
    if (locale) report_url += '&language=' + locale;
    report_url += '&safe=' + ( (rp && rp != '-1') ? -1 : 1 );
    if (DDG.first_source) report_url += '&source=' + DDG.first_source;

    nrj(report_url);

    div.innerHTML = "Thanks!";
}

//console.log(DDG.get_query());

/* 
Whether to show the side or not 
*/
DDG.is_side = function () {

    var side = d.getElementById('side');
    var side_wrapper = d.getElementById('side_wrapper');

    var is_side = 0;

    if (side_wrapper && YAHOO.util.Dom.getStyle(side_wrapper, 'display')=='block' && 
	(YAHOO.util.Dom.getY(side_wrapper)+side.scrollHeight+250<viewport_height)) is_side=1;

    //    console.log(side.scrollHeight);
    //    console.log(side_wrapper.scrollHeight);

    return is_side;
}


/*
To capture bang suggestions for display in right column.
 */
DDG.bang_suggestions = new Array();
DDG.bang_suggestions_shown = new Array();
DDG.show_bang_suggestions = function() {

    //    if (!DDG.bang_suggestions || DDG.bang_suggestions.length==0) return false;
    //    console.log(DDG.bang_suggestions.length);

    // 2013.04.06 was is_side, but then it won't show if you start narrow and expand;
    // this way it is hidden by the general is_side check but still can show.
    if (1) {

	var div = d.getElementById('side_suggestions');
	var is_first = 1;

	var div2 = d.createElement('div');
	if (div.firstChild) {
	    is_first = 0;
	    div2 = div.firstChild;
	}

	//	console.log(DDG.is_side());
	if (!is_first && !DDG.is_side()) return;

	var is_count = 0;

	var bang_re = new RegExp('^(.*?)\\t(.*?)\\t(.*?)$');

	for (var bang_stuff in DDG.bang_suggestions) {
	    var domain = DDG.bang_suggestions[bang_stuff];

	    var bang = '';
	    var site_name = '';
	    if (bang_re.test(bang_stuff)) {
		bang = RegExp.$1;
		site_name = RegExp.$2;
		icon_domain = RegExp.$3;

		//		console.log(bang);
		//		console.log(site_name);
	    }

	    if (!bang) continue;
	    if (!site_name) continue;
	    if (DDG.bang_suggestions_shown[bang]) continue;
	    DDG.bang_suggestions_shown[bang] = 1;
	    
	    //	    console.log(bang);


	    //    console.log(YAHOO.util.Dom.getY(div));
	    //    console.log(viewport_height);

	    var title = 'Search directly on ' + site_name + ' using !' + bang + '.';

	    var div3 = d.createElement('div');
	    //div3.onclick = function () {nutp('bs'+ this.firstChild.bang);nbb('','!' + this.firstChild.bang)};

	    var img = '';
	    var img_url = ga+icon_domain+'.ico';

	    //	    console.log(bang);
	    if (bang == 'bimages') img_url = '/assets/icon_camera.v103.png';

	    if (nur) img = nur('',title,img_url,16,16);
	    if (img) {
		div3.appendChild(img);
		img.bang = bang;
	    }

	    var link = d.createElement('a');
	    //	    link.innerHTML += '<b>!</b> ' + bang;
	    link.innerHTML += site_name;
	    link.bang = bang;
	    link.href = '/?q='+rq+'+!'+bang;
	    link.onclick = function() {nutp('b_'+this.bang);}
	    link.target = bang;
	    link.title = title;
	    div3.appendChild(link);

	    YAHOO.util.Dom.addClass(div3,'bang_suggestion');

	    if (is_first) div2.innerHTML += '<div class="spacer_bottom_7"><a href="/bang/">Try this search on</a>:</div>';
		    
	    div2.appendChild(div3);

	    if (is_first) YAHOO.util.Dom.setStyle(div3,'margin-top','2px');
	    is_first = 0;
	    is_count++;

	    if (is_count==7) break;

	    // 2011.07.08 cutting off to avoid scroll issues and clutter.
	    // making default 7
	}

        div.insertBefore(div2,div.firstChild);

	YAHOO.util.Dom.setStyle(div,'padding-top','30px');
	YAHOO.util.Dom.setStyle(div,'padding-bottom','0px');
	YAHOO.util.Dom.setStyle(div,'display','block');

    }
}


// For not auto-going to links when things are selected,
// so people can copy and paste.
DDG.last_selection = '';

/* NOTE
For hashes, you cannot have a trailing , because it messes up IE.
 */

DDG.spice_force_time = {
    // ADD NEW STUFF ABOVE HERE
    // 2013.03.03 take time away.
    //    "WolframAlpha" : 1
    "Tmp" : 1
};

DDG.spice_force_no_header = {
    "WolframAlpha" : 1,
    // ADD NEW STUFF ABOVE HERE
    "Amazon" : 1
};

DDG.spice_force_no_icon = {
    "Google+" : 1,
    "Quixey": 1, 
    //    "WolframAlpha": 1, 
    // ADD NEW STUFF ABOVE HERE
    "Big Huge Thesaurus" : 1
};

DDG.spice_force_favicon_domain = {
    "ESPN" : "espnplus.com",
    "OpenStreetMap" : "openstreetmap.org"
};
// for those times when you just need to force the URL
DDG.spice_force_favicon_url = {
    "Yummly" : 'http://www.yummly.com/favicon.ico',
    "Yelp" : 'http://yelp.com/favicon.ico'
};

DDG.spice_force_space_after = {
    "Big Huge Thesaurus" : 1,
    "search[code]" : 1,
    // ADD NEW STUFF ABOVE HERE
    "Rotten Tomatoes" : 1
};

DDG.spice_force_big_header = {
    "Twitter" : 1,
    "XKCD" : 1,
    "Rotten Tomatoes" : 1,
    "HNSearch" : 1,
    "The Drink Project" : 1,
    "CanIStream.It" : 1,
    "Big Huge Thesaurus" : 1,
    "search[code]" : 1,
    "LongURL" : 1,
    "Google+" : 1,
    "Yummly" : 1,
    // ADD NEW STUFF ABOVE HERE
    "Wikipedia " : 1 // NLP when we do API call to recreate fathead
};

DDG.spice_force_message = {
    // ADD NEW STUFF ABOVE HERE
        "WolframAlpha" : l("Computed by %s","Wolfram|Alpha")
    //    "Temp" : 1
};

DDG.spice_force_no_scroll = {
    "PunchFork" : 1,
    "OpenStreetMap" : 1,
    //    "Yummly" : 1,
    // ADD NEW STUFF ABOVE HERE
    "Wikipedia " : 1
};


/* page_type */
{
  var page_type = new Array();
  page_type[0] = 'results';
  page_type[1] = 'homepage';

  // About pages.
  page_type[2] = 'internal';

  DDG.get_page_type = function () {
    var idx = DDG.page_type || 0;

    return page_type[idx];
  }
}


/* For OSM links */			
DDG.OSM_lat_lon_search = function (lat,lon) {
    return '[' + lat + ',' + lon + ']';
}

/* Fix browser bugs
   called on initial page initialization.
*/
DDG.fix_browser_bugs = function () {
  nuv();

  // Silk can't handle side placement.
  if (is_silk) {
    YAHOO.util.Dom.setStyle('side','display','none');
  }

}


/* To make skimlinks ads */
DDG.make_skimlink = function (link) {
    var url;

    //    url = 'http://go.redirectingat.com/?';
    url = 'http://ad.ddg.gg/?';
    url += 'id=40063X1035282';
    url += '&xs=1';
    url += '&url='+encodeURIComponent(link);
    url += '&sref='+encodeURIComponent('https://duckduckgo.com');

    return url;
}
			


/*
Add a message about safe search getting rid of results.
*/
DDG.add_safe_search_message = function() {

    //    console.log('test');

    var links = d.getElementById('links');
    var zcm = d.getElementById('zero_click_message');
    
    //    console.log(links);
    //    console.log(zcm);

    if (links && !zcm) {
	var div = d.createElement('div');
	div.id = 'zero_click_message';

        div.innerHTML = 'Safe search blocked some results for ' + decodeURIComponent(rqd) + '. ' + l('Turn off:') + ' [';

	var link = d.createElement('a');
	link.innerHTML = l('temporarily');
	link.href = '/?q='+rq+' !safeoff' + kurl;
	div.appendChild(link);

	div.appendChild(d.createTextNode('] ['));

	var link = d.createElement('a');
	link.innerHTML = l('permanently');
	link.href = '/settings/';
	div.appendChild(link);

	div.appendChild(d.createTextNode('].'));

	var height = YAHOO.util.Dom.getY(links);

	/*
	if (height<100) {
	    YAHOO.util.Dom.setStyle(div,'padding-top','0px');
	    YAHOO.util.Dom.setStyle('ads','padding-bottom','15px');
	}
	*/

	//	console.log(YAHOO.util.Dom.getY(links));
	//	console.log(div.offsetHeight);       
	//	YAHOO.util.Dom.setStyle('content_wrapper_homepage','padding-top','20px');

	links.insertBefore(div,links.firstChild);

    }

}



/*
Bound to document onresize
and called on initial page initalization.
Each block needs to have an if/else block to react
to a changing viewport_width.
*/
DDG.resize = function(e) {
  nuv();

  var tmp,tmp2;

  // Based on gingerbread numbers.
  // 2012.07.14 -- based on galaxy nexus numbers.
  //  var width_mobile_landscape = 533;
  var width_mobile_landscape = 600;
  var height_mobile_landscape = 239;
  var width_mobile_portrait = 320;
  var height_mobile_portrait = 453;

//  alert(viewport_height)
//  alert(viewport_width)

  // Width where everything fits on results page without horizontal scrolling.
  var width_normal = 871;
  var height_normal = 600;

  // Width where it makes sense to start centering.
  var width_center = 767;

  // Width to go right up to the edge of the zero click box.
  var width_side_edge = 55;

  // From css.
  var width_side = 150;
  var width_content_wrapper_padding_right = 50;
  var width_content_wrapper_margin_left = 0;
  var width_content_padding_left = 62;
  var width_header_content_padding_left = 87;
  var width_header_content_wrapper_max_width = 1027;
  var width_content_wrapper_max_width = 1027;
  var width_header_content_wrapper_min_width = 647;
  var width_content_wrapper_min_width = 647;
  var width_content_min_width = 520;
  var width_fluid = 97;
  var width_links = 86.5;
  var width_zero_click = 86.5;

  var page_type = DDG.get_page_type();

  //  console.log(page_type);

  // Placement of logo.
  if (page_type=='homepage') {

      // Silk thing is for the kindle fire dropping the input box on select
      if (( !is_silk || viewport_height>height_mobile_portrait) && viewport_width > width_mobile_portrait) {
	  YAHOO.util.Dom.setStyle('content_wrapper_homepage','padding-top',parseInt(((viewport_height * 2/10) - 50)) + 'px');
      } else {
	  YAHOO.util.Dom.setStyle('content_wrapper_homepage','padding-top','20px');	  
      }
      YAHOO.util.Dom.setStyle('content_wrapper_homepage','top','0');

      // 2013.04.24 moving to publisher only.
      //      if (viewport_width > 800) {
      //      	  d.getElementById('footer_homepage_left').innerHTML = lp('webelieve','%s believe in %s and %s.','<a href="/about">' + lp('webelieve','We') + '</a>','<a href="/goodies">' + lp('webelieve','better search') + '</a>', '<a href="http://donttrack.us">' + lp('webelieve','no tracking') + '</a>' );
      //      }
  }


//  console.log(viewport_width);
//  console.log(width_mobile_portrait);

  // So highlight doesn't flow onto zero_click image.
  if (d.getElementById('zero_click_image') && d.getElementById('zero_click_abstract') && !is_mobile) {

      // If the image hasn't loaded yet.
      tmp2 = d.getElementById('zero_click_image').scrollWidth;
	  if (tmp2 > 280) { YAHOO.util.Dom.addClass('zero_click_image','zci_big'); }
	  if (tmp2 > 430) { YAHOO.util.Dom.addClass('zero_click_image','nofloat'); }
      tmp2 = tmp2 < 10 ? 130 : 30;	  
	  
      tmp = YAHOO.util.Dom.getX('zero_click_image')-YAHOO.util.Dom.getX('zero_click_abstract')-tmp2;

      //      console.log(d.getElementById('zero_click_image').scrollWidth);
      //	  console.log(YAHOO.util.Dom.getX('zero_click_image'));
      //	  console.log(YAHOO.util.Dom.getX('zero_click_abstract'));
      //	  console.log(viewport_width + ' ' + width_normal + ' ' + tmp);

      if (isNaN && !isNaN(tmp)) {
		if (viewport_width>728) {
			YAHOO.util.Dom.setStyle('zero_click_abstract','max-width',tmp+'px');
			tmp2 = YAHOO.util.Dom.getElementsByClassName('hidden','span','zero_click_topics');
			if (!tmp2 || tmp2.length<1) YAHOO.util.Dom.setStyle('zero_click_topics','max-width',tmp+'px');
		}
		else {
			YAHOO.util.Dom.setStyle('zero_click_abstract','max-width','100%');
			YAHOO.util.Dom.setStyle('zero_click_topics','max-width','100%');
		}
		
      }

  } else if (is_mobile) {
      YAHOO.util.Dom.setStyle('zero_click_abstract','max-width','100%');
      YAHOO.util.Dom.setStyle('zero_click_topics','max-width','100%');
  }


  /* Homepage mobile.
     Matches block in index.html.
   */

  if (is_mobile && !ipa) {
     /* YAHOO.util.Dom.setStyle('logo_homepage','background','url(http://duckduckgo.com//assets/logo_homepage_mobile.normal.png) no-repeat center top');*/
      YAHOO.util.Dom.setStyle('logo_homepage','margin-bottom','0px');
      YAHOO.util.Dom.setStyle('logo_homepage','padding-bottom','20px');
      YAHOO.util.Dom.setStyle('logo_homepage','width','275px');
      YAHOO.util.Dom.setStyle('logo_homepage','height','62px');
      YAHOO.util.Dom.addClass('logo_homepage','mobile');
      YAHOO.util.Dom.addClass('content_wrapper_homepage','mobile');
  } else {

      //      console.log('test');
     /* YAHOO.util.Dom.setStyle('logo_homepage','background','url(http://duckduckgo.com//assets/logo_homepage.normal.png) no-repeat center top');*/

      //      console.log(YAHOO.util.Dom.getStyle('logo_homepage','background'));

      YAHOO.util.Dom.setStyle('logo_homepage','margin-bottom','40px');
      YAHOO.util.Dom.setStyle('logo_homepage','padding-bottom','1px');
      YAHOO.util.Dom.setStyle('logo_homepage','width','220px');
      YAHOO.util.Dom.setStyle('logo_homepage','height','161px');

  }


  // Search box size.
  if (viewport_width > 720) {
      YAHOO.util.Dom.setStyle('search_form','width','554px');
      YAHOO.util.Dom.setStyle('search_form_input','width','446px');

      YAHOO.util.Dom.setStyle('search_form_homepage','width','518px');
      YAHOO.util.Dom.setStyle('search_form_input_homepage','width','430px');

      YAHOO.util.Dom.setStyle('header_button_wrapper','margin-left','40px');

  } else if (viewport_width > 620) {
      YAHOO.util.Dom.setStyle('search_form','width','453px');
      YAHOO.util.Dom.setStyle('search_form_input','width','346px');

      YAHOO.util.Dom.setStyle('search_form_homepage','width','418px');
      YAHOO.util.Dom.setStyle('search_form_input_homepage','width','330px');

      YAHOO.util.Dom.setStyle('header_button_wrapper','margin-left','30px');

  } else if (viewport_width>525) {
      YAHOO.util.Dom.setStyle('search_form','width','360px');
      YAHOO.util.Dom.setStyle('search_form_input','width','253px');

      YAHOO.util.Dom.setStyle('search_form_homepage','width','375px');
      YAHOO.util.Dom.setStyle('search_form_input_homepage','width','287px');

      YAHOO.util.Dom.setStyle('header_button_wrapper','margin-left','20px');

  } else {
      YAHOO.util.Dom.setStyle('search_form','width','260px');
      YAHOO.util.Dom.setStyle('search_form_input','width','153px');

      YAHOO.util.Dom.setStyle('search_form_homepage','width','275px');
      YAHOO.util.Dom.setStyle('search_form_input_homepage','width','187px');

      YAHOO.util.Dom.setStyle('header_button_wrapper','margin-left','10px');
  }

  // Search drop down
  // Can be shown on ipad sometimes in landscape since !is_mobile so adding it specifically.
  if (is_mobile || ie6 || ip || (kq && kq==-1)) {
      /*YAHOO.util.Dom.setStyle('search_form_input_clear','display','none');*/
   // now showing the clear button
	  YAHOO.util.Dom.setStyle('search_form_input_clear','position','absolute');
	  YAHOO.util.Dom.setStyle('search_form_input_clear','top','0px');
	  YAHOO.util.Dom.setStyle('search_form_input_clear','right','42px');
	  YAHOO.util.Dom.setStyle('search_form_input_clear','background-color','transparent');
	  YAHOO.util.Dom.setStyle('search_form_input_clear','z-index','1');
	  
	  YAHOO.util.Dom.setStyle('search_form_input','padding-right','34px');
	  
      YAHOO.util.Dom.setStyle('search_wrapper','width','42px');
      YAHOO.util.Dom.setStyle('search_dropdown','display','none');
	
      YAHOO.util.Dom.setStyle('search_wrapper_homepage','width','42px');
	  YAHOO.util.Dom.setStyle('search_form_input_homepage','right','42px');	  
      YAHOO.util.Dom.setStyle('search_dropdown_homepage','display','none');

      if (d.getElementById('search_form')) YAHOO.util.Dom.setStyle('search_form','width',parseInt(d.getElementById('search_form').scrollWidth - 23 /*- 25*/)+'px');
      if (d.getElementById('search_form_homepage')) YAHOO.util.Dom.setStyle('search_form_homepage','width',parseInt(d.getElementById('search_form_homepage').scrollWidth - 33)+'px');		
  }


  // Mobile items.
  // 2013.01.10 no longer needs to be restricted to mobile since in sidebar,
  // and that gets taken care of independently.
  if (!ke || ke=='1') {
      YAHOO.util.Dom.setStyle('feedback_wrapper','display','block');
  } else {
      YAHOO.util.Dom.setStyle('feedback_wrapper','display','none');
  }

  // Extra (side) items.
  if (viewport_width>width_normal && viewport_height>height_normal && (!k4 || k4==1)) {
      YAHOO.util.Dom.setStyle('side_wrapper','display','block');

  } else {
      YAHOO.util.Dom.setStyle('side_wrapper','display','none');
  }


  // Center everything at the end.
  //    if (viewport_width>width_center && d.getElementById('header_content') && (d.getElementById('header_content').scrollWidth>900 || kr)) {
  if (viewport_width>width_center) {
      var tmp = width_content_wrapper_padding_right;
      var tmp2 = 0;

      // For debugging.
      //	alert('test');
      //console.log(viewport_width);
      //	console.log(d.getElementById('header_content').scrollWidth);
      //	console.log(kr);

      // If sidebar.
      if (!k4 || k4==1) {
	  YAHOO.util.Dom.setStyle('side_wrapper','display','block');
	  div = d.getElementById('links');
	  tmp2 = width_side;

	  /* The sidebar has less impact on medium-width screens
	     since the centering looks weird on them */
	  if (viewport_width>950 && viewport_width<=1210) {
	      tmp2 = parseInt((1210 - viewport_width)/2);
	  } else if (viewport_width>1210) {
	      tmp2 = 0;
	  }

	  // console.log(tmp2);

      } else {
	  tmp = 0;
	  tmp2 = width_content_wrapper_padding_right;
	  div = d.getElementById('links');

	  // For debugging.
	  //	    alert('test');

	  YAHOO.util.Dom.setStyle('side_wrapper','display','none');
      }

	// For debugging.
	//	console.log(div.scrollWidth);
//	alert(div.scrollWidth);

	// If centered.
	if (div && (!km || km!='l')) {

	    // For debugging.
	    //alert(viewport_width);
	    //	    alert(div.scrollWidth);
	    //	    console.log(viewport_width);
	    //	    console.log(div.scrollWidth);

	    // What it would take to center.
	    diff = parseInt( (viewport_width - div.scrollWidth - tmp - tmp2) / 2);

	    // For debugging.
//	    alert(diff);
//	    alert(YAHOO.util.Dom.getX('content'));

	    // The actual padding amount to center #content.
	    diff = diff-parseInt(YAHOO.util.Dom.getX('content'));

	    // For debugging.
	    //	    alert(diff);
	    //	    console.log(diff);
	    //	    console.log(YAHOO.util.Dom.getX('content'));

	    if (diff>width_content_padding_left) {
		//		console.log(d.getElementById('header_content_wrapper').scrollWidth);
		//		console.log(d.getElementById('content_wrapper').scrollWidth);

		var header_content_offset_diff = 25;

		YAHOO.util.Dom.setStyle('content','padding-left',parseInt(diff)+'px');

		// Experimenting with centered.
		if (0 && kr && kr=='c') {
		    //		    YAHOO.util.Dom.setStyle('header_content','padding-left','0px');
		    //		    YAHOO.util.Dom.setStyle('header_content','margin','auto');
		    //		    YAHOO.util.Dom.setStyle('header_content_wrapper','margin','auto');
		    //		    YAHOO.util.Dom.setStyle('header_content','min-width','0px');
		    //		    YAHOO.util.Dom.setStyle('header_content','width',parseInt(d.getElementById('search_form').scrollWidth-100)+'px');
		}
		else YAHOO.util.Dom.setStyle('header_content','padding-left',parseInt(diff+header_content_offset_diff)+'px');

		//		console.log(d.getElementById('header_content').scrollWidth);
		//		console.log(d.getElementById('content').scrollWidth);

		YAHOO.util.Dom.setStyle('content_wrapper','max-width',parseInt(d.getElementById('content').scrollWidth+diff)+'px');
		YAHOO.util.Dom.setStyle('header_content_wrapper','max-width',parseInt(d.getElementById('header_content').scrollWidth+diff+header_content_offset_diff)+'px');

	    // Otherwise match default css.
	    } else {
		YAHOO.util.Dom.setStyle('content','padding-left',width_content_padding_left+'px');
		YAHOO.util.Dom.setStyle('header_content','padding-left',width_header_content_padding_left+'px');
		YAHOO.util.Dom.setStyle('header_content_wrapper','max-width',width_header_content_wrapper_max_width+'px');
		YAHOO.util.Dom.setStyle('content_wrapper','max-width',width_content_wrapper_max_width+'px');
	    }

	    //	    console.log(div);
	    //	    console.log(width_side);
	    //	    console.log(width_side_edge);
	    //	    console.log(viewport_width);
	    //	    console.log(div.scrollWidth);
	    //	    console.log( YAHOO.util.Dom.getX(div));

	    // Look if there is enough room for the side left.
	    diff = viewport_width - div.scrollWidth - YAHOO.util.Dom.getX(div);

	    if (d.getElementById('side_map')) width_side = d.getElementById('side_map').scrollWidth;

	    //	    console.log(width_side);

	    // Plus a little margin.
	    if (diff>width_side+width_side_edge && (!k4 || k4==1)) {

		YAHOO.util.Dom.setStyle('side_wrapper','display','block');

		// Center it.
		diff2 = ((diff-width_side)/2)+30;

		//		console.log(diff);
		//		console.log(diff2);

		if (kw=='s' || kw=='w') diff2+=45;

		YAHOO.util.Dom.setStyle('side_wrapper2','right','-' + diff2 + 'px');

	    } else {
		YAHOO.util.Dom.setStyle('side_wrapper','display','none');
	    }

	    //	    console.log(diff);

	}

  // Reset CSS
  } else {
      YAHOO.util.Dom.setStyle('content','padding-left',width_content_padding_left+'px');
      YAHOO.util.Dom.setStyle('header_content','padding-left',width_header_content_padding_left+'px');
      YAHOO.util.Dom.setStyle('header_content_wrapper','max-width',width_header_content_wrapper_max_width+'px');
      YAHOO.util.Dom.setStyle('content_wrapper','max-width',width_content_wrapper_max_width+'px');
  }

  // Fixed width vs fluid for mobile.
  if (viewport_width<=width_mobile_landscape) {
      YAHOO.util.Dom.setStyle('header_content_wrapper','min-width',width_fluid+'%');
      YAHOO.util.Dom.setStyle('content_wrapper','min-width',width_fluid+'%');
      YAHOO.util.Dom.setStyle('content_wrapper','padding-right',0+'px');
      YAHOO.util.Dom.setStyle('content_wrapper','margin','0 auto');
      YAHOO.util.Dom.setStyle('content','min-width',width_fluid+'%');
      YAHOO.util.Dom.setStyle('content','padding-left',0+'px');
      YAHOO.util.Dom.setStyle('zero_click','width',width_fluid+'%');      
	  YAHOO.util.Dom.setStyle('links','width',width_fluid+'%');	  
      YAHOO.util.Dom.setStyle('ads','width',width_fluid+'%');	 
	  YAHOO.util.Dom.addClass('ads','zero_auto');
	  YAHOO.util.Dom.addClass('links','zero_auto');
	  YAHOO.util.Dom.addClass('zero_click','zero_auto');
  } else {
      YAHOO.util.Dom.setStyle('header_content_wrapper','min-width',width_header_content_wrapper_min_width);
      YAHOO.util.Dom.setStyle('content_wrapper','min-width',width_content_wrapper_min_width);
      YAHOO.util.Dom.setStyle('content_wrapper','padding-right',width_content_wrapper_padding_right);
      YAHOO.util.Dom.setStyle('content_wrapper','margin-left',width_content_wrapper_margin_left+'px');
      YAHOO.util.Dom.setStyle('content','min-width',width_content_min_width+'px');
      YAHOO.util.Dom.setStyle('content','padding_left',width_content_padding_left+'px');
      YAHOO.util.Dom.setStyle('zero_click','width',width_zero_click+'%');
      YAHOO.util.Dom.setStyle('links','width',width_links+'%');	  
      YAHOO.util.Dom.setStyle('ads','width',width_links+'%');	  
	  YAHOO.util.Dom.removeClass('ads','zero_auto');
	  YAHOO.util.Dom.removeClass('links','zero_auto');
	  YAHOO.util.Dom.removeClass('zero_click','zero_auto');
  }

  // Ad height.
  if (d.getElementById('ads') && d.getElementById('ra-0')) {
      /*
	  div = d.getElementById('ra-0');
      YAHOO.util.Dom.setStyle('ads','height',parseInt((parseInt(div.scrollHeight)+2)) + 'px');
	  */
	  YAHOO.util.Dom.setStyle('ads','height','auto');
  }
}

/* Get a a link number given a highlight class number */			
DDG.get_link_num = function (highlight_num) {
    var link_num = 0;

    //    console.log(highlight_num);

    if (!highlight_num) link_num = 0;
    else if (highlight_num==3) link_num=-1;
    else if (kf&&(kf=='fw'||kf=='b')) link_num = 2;
    else link_num = parseInt(highlight_num) - 1;

    return link_num;
}


/* Toggles the deisplay of an onscreen element. */
DDG.toggle = function(id,on) {

//    console.log(id);

    var element = d.getElementById(id);

    //    console.log(on);

    if (element) {
	if ((!on || on!=-1) && (YAHOO.util.Dom.getStyle(element,'display')=='none' || on)) YAHOO.util.Dom.setStyle(element,'display','block');
	else if (!on || on==-1) YAHOO.util.Dom.setStyle(element,'display','none');
	else if (on==1) YAHOO.util.Dom.setStyle(element,'display','block');
    }
}

/* Toggles all elements of a certain class. */
DDG.toggleall = function(cla,on,id) {
	if (!cla) { 
		cla = "grp_modal";
		/* if nothing is declared, the default behaviour is to hide all modals (.grp_modal) (this was the original intent of this function) */
	}
	
	var element = d.getElementById(id);	
	var elements = YAHOO.util.Dom.getElementsByClassName(cla);
	
	// console.log(elements);	
	
	if (elements) {
		if (!on || on==-1) {
			for (var i = 0; i <= elements.length; i++) {	  
			  if(!id || (element != elements[i])) YAHOO.util.Dom.setStyle(elements[i],'display','none');
			}
		} else if (on==1) {
			for (var i = 0; i <= elements.length; i++) {	  
			  YAHOO.util.Dom.setStyle(elements[i],'display','block');
			}
		}
    }
}

/* 
 * creates a 'trigger' element to display a modal box (usually crafted in the document) 
*/
DDG.modaltrig = function (id,cla,pre,post,label) {
	document.write('<span class="modal_trig" id="trig_'+id+'"></span>'+pre+'<a href="');
	document.write('javascript:;');
	document.write('" class="'+cla+'" onclick="');
	document.write('DDG.mv_elem(\''+id+'\',\'trig_'+id+'\');DDG.toggleall(\'grp_modal\',-1,\''+id+'\');DDG.toggle(\''+id+'\')');
	document.write('">'+label+'</a>'+post);	
}

/*
 * Shortens text and returns a span with a link to expand inline.
 * Note that the inner function is returned. DDG.shorten(text)
*/
DDG.shorten = (function (i) {
    return function(text) {
        var container = '<span id="blurb' + i + '" style="display: inline;">';
        if (text.length > 200) {
            var fullText = '<span id="fullText' + i
                         + '" style="display:none;">' + text + '</span>';
            var link = '<a style="display: inline; color: rgb(119, 119, 119);'
                     + 'font-size: 11px;" id="expand' + i + '" href="javascript:;"'
                     + 'onclick="DDG.toggle(\'fullText' + i
                     + '\', 1);DDG.toggle(\'blurb' + i + '\', -1);'
                     + 'DDG.toggle(\'expand' + i + '\', -1);">' + l('More') + '...</a>';
            container += text.slice(0,200) + '</span>' + fullText + link;
        } else { container = text }
        i++;
        return container;
    }
})(0);

/*
Called onkeyup from search input box
*/
DDG.clear_button_toggle = function(e) {
  var div;

  div = d.getElementById('search_form_input');
  if (!div) div = d.getElementById('search_form_input_homepage');

//  console.log(div);

  if (div && !ipa) {
    if (div.value=='') {
      YAHOO.util.Dom.addClass('search_form_input_clear','empty')
    } else {
      YAHOO.util.Dom.removeClass('search_form_input_clear','empty')
    }
  }
}

/*
Called onclick from search_form_input_clear
*/
DDG.clear_button = function(e) {
  var div;

  div = d.getElementById('search_form_input');
  if (!div) div = d.getElementById('search_form_input_homepage');

  if (div) {
    div.value = '';
    div.focus();
    DDG.clear_button_toggle();
  }
}

DDG.mv_elem  = function(id,tgt) {

	var element = d.getElementById(id);
	var target = d.getElementById(tgt);
    if ((element) && (target)) {
		target.appendChild(element.parentNode.removeChild(element));
	}
}



/* Legacy code */

/* global variables minified to two letters (at most).

   ^c, count space
   cd = dot count for loading... pages (defined in Index.pm)
   ci = initial state tries

   ^d, duck duck go space
   dx = data object (defined in news js)
   dz = zoom
   da = default ad
   dam = default ad main column
   daiq = default ad image query
   daia = default ad send to amazon

   ^f, focus space
   fb = whether the bangs have focus (1) or not
   fk = whether the keyboard has focus (1) or not (0)
   fq = whether the query box has focus (1) or not (0) (defined in Index.pm)
   fe = whether the explore box has focus (1) or not (0)
   fl = whether we are already going to a link (1) or not (0)
   fs = whether we are in nrb or not
   fd = whether we are loading a deep results section (defined in Index.pm)
   fo = whether we are opening a new state or not
   fz = whether we are on a zoom icon
   fn = whether we are opening a new window or not.
   fmx = mouse press x
   fmy = mouse press y
   fs = whether we are scrolling or not
   fa = whether the apple key is pressed
   fm = whether the middle mouse button is pressed or not

   ^i, is* global space

   /* browsers *.
   ie = is_internet_explorer
   ie6 = is_internet_explorer_6
   ie7 = is_internet_explorer_7
   ie9 = is_internet_explorer_9
   ir = is_chrome
   ir12 = is_chrome
   irl = is_chrome loaded
   iw = is_webkit
   im = is_mozilla
   io = opera
   io11 = opera
   iom = opera mini
   is_opera_mobile = opera mobile
   ip = ipad/iphone
   iph = iphone
   ipa = ipad
   ia = android
   iam = android mobile
   is_silk = silk (e.g. kindle)
   is_konqueror = Konqueror
   is_mobile = a collection of tests to check mobile

   il = is last result
   ih5 = is html5
   issl = is ssl
   idom = is_dom_ready
   is = is safari
   it = is static (defined in Index.pm)
   ieof = is_out_of_results
   iwa = is wolfram called
   iad = is ad called
   iadt = is ad type
   iad2 = is ad returned
   iad3 = is ad shown
   iqa = is adult query (defined in Index.pm)
   iqm = is minus query (defined in Index.pm)
   iqs = is site query (defined in Index.pm)
   iqq = is quote query (defined in Index.pm)
   iqd = is domain query (defined in Index.pm) 
   irp = is results page (defined in Index.pm)

   ^g, string space.
   ga = amazon aws domain
   gd = duckduckgo.com
   gre = regex for embedly
   grb = regex for bangs
   grbn = regex for bangs (news)
   grbm = regex for bangs (maps)
   gra = regex for amazon
   gra2 = more regex for amazon
   gra3 = more regex for amazon
   gra[a-z] = more regex for amazon
   qw = query words (defined in Index.pm)

   ^k, cookie space, see settings.html (defined in Index.pm)
   kp = safe search
   kl = region
   ks = size
   kw = width
   ka = link font
   kt = text font
   ky = highlighting
   kk = shortcuts
   kf = favicons
   kc = scrollwheel
   ke = feedback
   kr = side bar
   ko = top bar
   kj = header
   kz = 0-click box
   kg = post
   kh = https
   kd = redirect
   ki = disambiguation
   kn = new window
   kb = embeds
   km = placement
   ku = underline
   kq = bangs
   kv = page numbers
   k2 = snippet links
   k3 = twitter username
   kurl = settings in urls

   ^n, reserved for function space (see below).

   ^r, result space
   rc = reference to current result
   rpc = count of pages
   r1c = count of column1 results (defined in Index.pm)
   r1hc = count of hidden column1 results (defined in Index.pm)
   r2c = count of column2 results (defined in Index.pm)
   r3c = count of column3 results (defined in Index.pm)
   rdc = count of column1 deep sections
   rtc = count of column2 topic sections
   rsc = count of strip results left to load
   rsd = result strip (for duplicate checking).
   ric = count of images (defined in Index.pm)
   rii = idx of start of image results
   rin = idx of start of news results
   rir = idx of start of related topics results
   rds = start of deep results (defined in Index.pm)
   rq = query (defined in Index.pm)
   rqd = query for display (defined in Index.pm) ALWAYS USE FOR DISPLAY INSTEAD OF decodeURIComponent(rq)
   rfq = query (defined in Index.pm)
   rdq = deep query (defined in Deep.pm)
   rd = result domains (for duplicate checking).
   rl = result language
   rp = result safe search
   rt = result type (defined in Index.pm)
   rv = result vertical (defined in Index.pm)
   ra = result affiliate (defined in Index.pm)
   rs = special type? (defined in Index.pm)
   rad = result abstract domain (defined in Index.pm)
   reb = result array for embedly
   rebc = result count for embedly

   ^s, screen space
   sx = mouse x position
   sy = mouse y position

   ^t, temp space
   ti = used for images (defined in Index.pm)
   tig = used for images (defined in Index.pm)
   tl = loading gif reference
   tlz = loading gif zoom reference
   tr = array for asynchronous screen redawing, see nua function.
   ts = array for asynchronous serialized calls
   tsl = lock var for serialization
   tn = lock for nsr
   tac = temp ad initalize count
   tz = temp zoom link

   global shortcuts, letters reserved
   d = document
   w = window
   dow = day of week
*/
var cd,ci,dz,da,fk,fb,fs,fm,fe,fl,fo,fa,fn,fz,ie,ih5,issl,idom,io,il,ir,is,is5,ga,gd,rc,rd,rs,rdc,rsc,rtc,rii,rin,rir,rl,rp,reb,rebc,sx,sy,tl,tlz,tac,tr,ts,tn,tsl,tz,nir,kurl,is_mobile;
viewport_width = YAHOO.util.Dom.getViewportWidth();
viewport_height = YAHOO.util.Dom.getViewportHeight();
nuv();
ie=d.all?true:false;
ie6=/msie 6/.test(navigator.userAgent.toLowerCase())?true:false;
ie7=/msie 7/.test(navigator.userAgent.toLowerCase())?true:false;
ie9=/msie 9/.test(navigator.userAgent.toLowerCase())?true:false;
ie10=/msie 10/.test(navigator.userAgent.toLowerCase())?true:false;
is=/safari/.test(navigator.userAgent.toLowerCase())?true:false;
iw=/webkit/.test(navigator.userAgent.toLowerCase())?true:false;
ir=/chrome(?!frame)/.test(navigator.userAgent.toLowerCase())?true:false;
ir12=/chrome\/12/.test(navigator.userAgent.toLowerCase())?true:false;
is5=(is && /version\/[56]/.test(navigator.userAgent.toLowerCase()))?true:false;
im=(navigator.userAgent.indexOf('Firefox')!=-1)?true:false;
io=(navigator.userAgent.indexOf('Opera')!=-1)?true:false;
io11=(navigator.userAgent.indexOf('Opera')!=-1 && navigator.userAgent.indexOf('/11')!=-1)?true:false;
iom=(navigator.userAgent.indexOf('Opera Mini')!=-1)?true:false;
is_opera_mobile=(navigator.userAgent.indexOf('Opera Mobi')!=-1)?true:false;
ip=(navigator.userAgent.indexOf('iPad')!=-1 || navigator.userAgent.indexOf('iPhone')!=-1)?true:false;
ipa=(navigator.userAgent.indexOf('iPad')!=-1)?true:false;
iph=(navigator.userAgent.indexOf('iPhone')!=-1)?true:false;
ia=(navigator.userAgent.indexOf('Android')!=-1)?true:false;
iam=(navigator.userAgent.indexOf('Android')!=-1 && /mobile/.test(navigator.userAgent.toLowerCase()))?true:false;
is_silk=(navigator.userAgent.indexOf('Silk')!=-1)?true:false;
is_konqueror=(navigator.userAgent.indexOf('Konqueror')!=-1)?true:false;
ida=(navigator.userAgent.indexOf('DDG-Android')!=-1)?true:false;
idi=(navigator.userAgent.indexOf('DDG-iOS')!=-1)?true:false;
ih5=w.postMessage?true:false;
issl=document.location.protocol=='https:' ? 1 : 0;

is_mobile = /mobile/.test(navigator.userAgent.toLowerCase()) ? true : false;
if (iom || is_opera_mobile || ip || ia || is_silk || (viewport_width<600 && viewport_height<400)) is_mobile = 1;

// Allows ipad to show landscape stuff; unfortunately on android it mis-represnets the viewport width/height, and so cannot use this.
if (ip && viewport_width>900) is_mobile = 0;

			//			alert(viewport_height);
			//			alert(viewport_width);
			//			alert(is_mobile);

// For embedly checking.
// http://api.embed.ly/tools/generator
// Does NOT copy and paste -- have to scp text file and insert.
gre = new RegExp('((http:\/\/(.*yfrog\..*\/.*|www\.flickr\.com\/photos\/.*|flic\.kr\/.*|twitpic\.com\/.*|www\.twitpic\.com\/.*|twitpic\.com\/photos\/.*|www\.twitpic\.com\/photos\/.*|.*imgur\.com\/.*|.*\.posterous\.com\/.*|post\.ly\/.*|twitgoo\.com\/.*|i.*\.photobucket\.com\/albums\/.*|s.*\.photobucket\.com\/albums\/.*|phodroid\.com\/.*\/.*\/.*|www\.mobypicture\.com\/user\/.*\/view\/.*|moby\.to\/.*|xkcd\.com\/.*|www\.xkcd\.com\/.*|imgs\.xkcd\.com\/.*|www\.asofterworld\.com\/index\.php\?id=.*|www\.asofterworld\.com\/.*\.jpg|asofterworld\.com\/.*\.jpg|www\.qwantz\.com\/index\.php\?comic=.*|23hq\.com\/.*\/photo\/.*|www\.23hq\.com\/.*\/photo\/.*|.*dribbble\.com\/shots\/.*|drbl\.in\/.*|.*\.smugmug\.com\/.*|.*\.smugmug\.com\/.*#.*|emberapp\.com\/.*\/images\/.*|emberapp\.com\/.*\/images\/.*\/sizes\/.*|emberapp\.com\/.*\/collections\/.*\/.*|emberapp\.com\/.*\/categories\/.*\/.*\/.*|embr\.it\/.*|picasaweb\.google\.com.*\/.*\/.*#.*|picasaweb\.google\.com.*\/lh\/photo\/.*|picasaweb\.google\.com.*\/.*\/.*|dailybooth\.com\/.*\/.*|brizzly\.com\/pic\/.*|pics\.brizzly\.com\/.*\.jpg|img\.ly\/.*|www\.tinypic\.com\/view\.php.*|tinypic\.com\/view\.php.*|www\.tinypic\.com\/player\.php.*|tinypic\.com\/player\.php.*|www\.tinypic\.com\/r\/.*\/.*|tinypic\.com\/r\/.*\/.*|.*\.tinypic\.com\/.*\.jpg|.*\.tinypic\.com\/.*\.png|meadd\.com\/.*\/.*|meadd\.com\/.*|.*\.deviantart\.com\/art\/.*|.*\.deviantart\.com\/gallery\/.*|.*\.deviantart\.com\/#\/.*|fav\.me\/.*|.*\.deviantart\.com|.*\.deviantart\.com\/gallery|.*\.deviantart\.com\/.*\/.*\.jpg|.*\.deviantart\.com\/.*\/.*\.gif|.*\.deviantart\.net\/.*\/.*\.jpg|.*\.deviantart\.net\/.*\/.*\.gif|www\.fotopedia\.com\/.*\/.*|fotopedia\.com\/.*\/.*|photozou\.jp\/photo\/show\/.*\/.*|photozou\.jp\/photo\/photo_only\/.*\/.*|instagr\.am\/p\/.*|instagram\.com\/p\/.*|skitch\.com\/.*\/.*\/.*|img\.skitch\.com\/.*|share\.ovi\.com\/media\/.*\/.*|www\.questionablecontent\.net\/|questionablecontent\.net\/|www\.questionablecontent\.net\/view\.php.*|questionablecontent\.net\/view\.php.*|questionablecontent\.net\/comics\/.*\.png|www\.questionablecontent\.net\/comics\/.*\.png|picplz\.com\/.*|twitrpix\.com\/.*|.*\.twitrpix\.com\/.*|www\.someecards\.com\/.*\/.*|someecards\.com\/.*\/.*|some\.ly\/.*|www\.some\.ly\/.*|pikchur\.com\/.*|achewood\.com\/.*|www\.achewood\.com\/.*|achewood\.com\/index\.php.*|www\.achewood\.com\/index\.php.*|www\.whosay\.com\/content\/.*|www\.whosay\.com\/photos\/.*|www\.whosay\.com\/videos\/.*|say\.ly\/.*|ow\.ly\/i\/.*|color\.com\/s\/.*|bnter\.com\/convo\/.*|mlkshk\.com\/p\/.*|lockerz\.com\/s\/.*|soundcloud\.com\/.*|soundcloud\.com\/.*\/.*|soundcloud\.com\/.*\/sets\/.*|soundcloud\.com\/groups\/.*|snd\.sc\/.*|www\.last\.fm\/music\/.*|www\.last\.fm\/music\/+videos\/.*|www\.last\.fm\/music\/+images\/.*|www\.last\.fm\/music\/.*\/_\/.*|www\.last\.fm\/music\/.*\/.*|www\.mixcloud\.com\/.*\/.*\/|www\.radionomy\.com\/.*\/radio\/.*|radionomy\.com\/.*\/radio\/.*|www\.hark\.com\/clips\/.*|www\.rdio\.com\/#\/artist\/.*\/album\/.*|www\.rdio\.com\/artist\/.*\/album\/.*|www\.zero-inch\.com\/.*|.*\.bandcamp\.com\/|.*\.bandcamp\.com\/track\/.*|.*\.bandcamp\.com\/album\/.*|freemusicarchive\.org\/music\/.*|www\.freemusicarchive\.org\/music\/.*|freemusicarchive\.org\/curator\/.*|www\.freemusicarchive\.org\/curator\/.*|www\.npr\.org\/.*\/.*\/.*\/.*\/.*|www\.npr\.org\/.*\/.*\/.*\/.*\/.*\/.*|www\.npr\.org\/.*\/.*\/.*\/.*\/.*\/.*\/.*|www\.npr\.org\/templates\/story\/story\.php.*|huffduffer\.com\/.*\/.*|www\.audioboo\.fm\/boos\/.*|audioboo\.fm\/boos\/.*|boo\.fm\/b.*|www\.xiami\.com\/song\/.*|xiami\.com\/song\/.*|www\.saynow\.com\/playMsg\.html.*|www\.saynow\.com\/playMsg\.html.*|grooveshark\.com\/.*|radioreddit\.com\/songs.*|www\.radioreddit\.com\/songs.*|radioreddit\.com\/\?q=songs.*|www\.radioreddit\.com\/\?q=songs.*|www\.gogoyoko\.com\/song\/.*|.*amazon\..*\/gp\/product\/.*|.*amazon\..*\/.*\/dp\/.*|.*amazon\..*\/dp\/.*|.*amazon\..*\/o\/ASIN\/.*|.*amazon\..*\/gp\/offer-listing\/.*|.*amazon\..*\/.*\/ASIN\/.*|.*amazon\..*\/gp\/product\/images\/.*|.*amazon\..*\/gp\/aw\/d\/.*|www\.amzn\.com\/.*|amzn\.com\/.*|www\.shopstyle\.com\/browse.*|www\.shopstyle\.com\/action\/apiVisitRetailer.*|api\.shopstyle\.com\/action\/apiVisitRetailer.*|www\.shopstyle\.com\/action\/viewLook.*|gist\.github\.com\/.*|twitter\.com\/.*\/status\/.*|twitter\.com\/.*\/statuses\/.*|www\.twitter\.com\/.*\/status\/.*|www\.twitter\.com\/.*\/statuses\/.*|mobile\.twitter\.com\/.*\/status\/.*|mobile\.twitter\.com\/.*\/statuses\/.*|www\.crunchbase\.com\/.*\/.*|crunchbase\.com\/.*\/.*|www\.slideshare\.net\/.*\/.*|www\.slideshare\.net\/mobile\/.*\/.*|slidesha\.re\/.*|scribd\.com\/doc\/.*|www\.scribd\.com\/doc\/.*|scribd\.com\/mobile\/documents\/.*|www\.scribd\.com\/mobile\/documents\/.*|screenr\.com\/.*|polldaddy\.com\/community\/poll\/.*|polldaddy\.com\/poll\/.*|answers\.polldaddy\.com\/poll\/.*|www\.5min\.com\/Video\/.*|www\.howcast\.com\/videos\/.*|www\.screencast\.com\/.*\/media\/.*|screencast\.com\/.*\/media\/.*|www\.screencast\.com\/t\/.*|screencast\.com\/t\/.*|issuu\.com\/.*\/docs\/.*|www\.kickstarter\.com\/projects\/.*\/.*|www\.scrapblog\.com\/viewer\/viewer\.aspx.*|ping\.fm\/p\/.*|chart\.ly\/symbols\/.*|chart\.ly\/.*|maps\.google\.com\/maps\?.*|maps\.google\.com\/\?.*|maps\.google\.com\/maps\/ms\?.*|.*\.craigslist\.org\/.*\/.*|my\.opera\.com\/.*\/albums\/show\.dml\?id=.*|my\.opera\.com\/.*\/albums\/showpic\.dml\?album=.*&picture=.*|tumblr\.com\/.*|.*\.tumblr\.com\/post\/.*|www\.polleverywhere\.com\/polls\/.*|www\.polleverywhere\.com\/multiple_choice_polls\/.*|www\.polleverywhere\.com\/free_text_polls\/.*|www\.quantcast\.com\/wd:.*|www\.quantcast\.com\/.*|siteanalytics\.compete\.com\/.*|statsheet\.com\/statplot\/charts\/.*\/.*\/.*\/.*|statsheet\.com\/statplot\/charts\/e\/.*|statsheet\.com\/.*\/teams\/.*\/.*|statsheet\.com\/tools\/chartlets\?chart=.*|.*\.status\.net\/notice\/.*|identi\.ca\/notice\/.*|brainbird\.net\/notice\/.*|shitmydadsays\.com\/notice\/.*|www\.studivz\.net\/Profile\/.*|www\.studivz\.net\/l\/.*|www\.studivz\.net\/Groups\/Overview\/.*|www\.studivz\.net\/Gadgets\/Info\/.*|www\.studivz\.net\/Gadgets\/Install\/.*|www\.studivz\.net\/.*|www\.meinvz\.net\/Profile\/.*|www\.meinvz\.net\/l\/.*|www\.meinvz\.net\/Groups\/Overview\/.*|www\.meinvz\.net\/Gadgets\/Info\/.*|www\.meinvz\.net\/Gadgets\/Install\/.*|www\.meinvz\.net\/.*|www\.schuelervz\.net\/Profile\/.*|www\.schuelervz\.net\/l\/.*|www\.schuelervz\.net\/Groups\/Overview\/.*|www\.schuelervz\.net\/Gadgets\/Info\/.*|www\.schuelervz\.net\/Gadgets\/Install\/.*|www\.schuelervz\.net\/.*|myloc\.me\/.*|pastebin\.com\/.*|pastie\.org\/.*|www\.pastie\.org\/.*|redux\.com\/stream\/item\/.*\/.*|redux\.com\/f\/.*\/.*|www\.redux\.com\/stream\/item\/.*\/.*|www\.redux\.com\/f\/.*\/.*|cl\.ly\/.*|cl\.ly\/.*\/content|speakerdeck\.com\/u\/.*\/p\/.*|www\.kiva\.org\/lend\/.*|www\.timetoast\.com\/timelines\/.*|storify\.com\/.*\/.*|.*meetup\.com\/.*|meetu\.ps\/.*|www\.dailymile\.com\/people\/.*\/entries\/.*|.*\.kinomap\.com\/.*|www\.metacdn\.com\/api\/users\/.*\/content\/.*|www\.metacdn\.com\/api\/users\/.*\/media\/.*|prezi\.com\/.*\/.*|.*\.uservoice\.com\/.*\/suggestions\/.*|formspring\.me\/.*|www\.formspring\.me\/.*|formspring\.me\/.*\/q\/.*|www\.formspring\.me\/.*\/q\/.*|twitlonger\.com\/show\/.*|www\.twitlonger\.com\/show\/.*|tl\.gd\/.*|www\.qwiki\.com\/q\/.*|crocodoc\.com\/.*|.*\.crocodoc\.com\/.*|www\.wikipedia\.org\/wiki\/.*|www\.wikimedia\.org\/wiki\/File.*|.*youtube\.com\/watch.*|.*\.youtube\.com\/v\/.*|youtu\.be\/.*|.*\.youtube\.com\/user\/.*|.*\.youtube\.com\/.*#.*\/.*|m\.youtube\.com\/watch.*|m\.youtube\.com\/index.*|.*\.youtube\.com\/profile.*|.*\.youtube\.com\/view_play_list.*|.*\.youtube\.com\/playlist.*|.*justin\.tv\/.*|.*justin\.tv\/.*\/b\/.*|.*justin\.tv\/.*\/w\/.*|www\.ustream\.tv\/recorded\/.*|www\.ustream\.tv\/channel\/.*|www\.ustream\.tv\/.*|qik\.com\/video\/.*|qik\.com\/.*|qik\.ly\/.*|.*revision3\.com\/.*|.*\.dailymotion\.com\/video\/.*|.*\.dailymotion\.com\/.*\/video\/.*|collegehumor\.com\/video:.*|collegehumor\.com\/video\/.*|www\.collegehumor\.com\/video:.*|www\.collegehumor\.com\/video\/.*|.*twitvid\.com\/.*|www\.break\.com\/.*\/.*|vids\.myspace\.com\/index\.cfm\?fuseaction=vids\.individual&videoid.*|www\.myspace\.com\/index\.cfm\?fuseaction=.*&videoid.*|www\.metacafe\.com\/watch\/.*|www\.metacafe\.com\/w\/.*|blip\.tv\/.*\/.*|.*\.blip\.tv\/.*\/.*|video\.google\.com\/videoplay\?.*|.*revver\.com\/video\/.*|video\.yahoo\.com\/watch\/.*\/.*|video\.yahoo\.com\/network\/.*|.*viddler\.com\/explore\/.*\/videos\/.*|liveleak\.com\/view\?.*|www\.liveleak\.com\/view\?.*|animoto\.com\/play\/.*|dotsub\.com\/view\/.*|www\.overstream\.net\/view\.php\?oid=.*|www\.livestream\.com\/.*|www\.worldstarhiphop\.com\/videos\/video.*\.php\?v=.*|worldstarhiphop\.com\/videos\/video.*\.php\?v=.*|teachertube\.com\/viewVideo\.php.*|www\.teachertube\.com\/viewVideo\.php.*|www1\.teachertube\.com\/viewVideo\.php.*|www2\.teachertube\.com\/viewVideo\.php.*|bambuser\.com\/v\/.*|bambuser\.com\/channel\/.*|bambuser\.com\/channel\/.*\/broadcast\/.*|www\.schooltube\.com\/video\/.*\/.*|bigthink\.com\/ideas\/.*|bigthink\.com\/series\/.*|sendables\.jibjab\.com\/view\/.*|sendables\.jibjab\.com\/originals\/.*|www\.xtranormal\.com\/watch\/.*|socialcam\.com\/v\/.*|www\.socialcam\.com\/v\/.*|dipdive\.com\/media\/.*|dipdive\.com\/member\/.*\/media\/.*|dipdive\.com\/v\/.*|.*\.dipdive\.com\/media\/.*|.*\.dipdive\.com\/v\/.*|v\.youku\.com\/v_show\/.*\.html|v\.youku\.com\/v_playlist\/.*\.html|www\.snotr\.com\/video\/.*|snotr\.com\/video\/.*|video\.jardenberg\.se\/.*|www\.clipfish\.de\/.*\/.*\/video\/.*|www\.myvideo\.de\/watch\/.*|www\.whitehouse\.gov\/photos-and-video\/video\/.*|www\.whitehouse\.gov\/video\/.*|wh\.gov\/photos-and-video\/video\/.*|wh\.gov\/video\/.*|www\.hulu\.com\/watch.*|www\.hulu\.com\/w\/.*|hulu\.com\/watch.*|hulu\.com\/w\/.*|.*crackle\.com\/c\/.*|www\.fancast\.com\/.*\/videos|www\.funnyordie\.com\/videos\/.*|www\.funnyordie\.com\/m\/.*|funnyordie\.com\/videos\/.*|funnyordie\.com\/m\/.*|www\.vimeo\.com\/groups\/.*\/videos\/.*|www\.vimeo\.com\/.*|vimeo\.com\/groups\/.*\/videos\/.*|vimeo\.com\/.*|vimeo\.com\/m\/#\/.*|www\.ted\.com\/talks\/.*\.html.*|www\.ted\.com\/talks\/lang\/.*\/.*\.html.*|www\.ted\.com\/index\.php\/talks\/.*\.html.*|www\.ted\.com\/index\.php\/talks\/lang\/.*\/.*\.html.*|.*nfb\.ca\/film\/.*|www\.thedailyshow\.com\/watch\/.*|www\.thedailyshow\.com\/full-episodes\/.*|www\.thedailyshow\.com\/collection\/.*\/.*\/.*|movies\.yahoo\.com\/movie\/.*\/video\/.*|movies\.yahoo\.com\/movie\/.*\/trailer|movies\.yahoo\.com\/movie\/.*\/video|www\.colbertnation\.com\/the-colbert-report-collections\/.*|www\.colbertnation\.com\/full-episodes\/.*|www\.colbertnation\.com\/the-colbert-report-videos\/.*|www\.comedycentral\.com\/videos\/index\.jhtml\?.*|www\.theonion\.com\/video\/.*|theonion\.com\/video\/.*|wordpress\.tv\/.*\/.*\/.*\/.*\/|www\.traileraddict\.com\/trailer\/.*|www\.traileraddict\.com\/clip\/.*|www\.traileraddict\.com\/poster\/.*|www\.escapistmagazine\.com\/videos\/.*|www\.trailerspy\.com\/trailer\/.*\/.*|www\.trailerspy\.com\/trailer\/.*|www\.trailerspy\.com\/view_video\.php.*|www\.atom\.com\/.*\/.*\/|fora\.tv\/.*\/.*\/.*\/.*|www\.spike\.com\/video\/.*|www\.gametrailers\.com\/video\/.*|gametrailers\.com\/video\/.*|www\.koldcast\.tv\/video\/.*|www\.koldcast\.tv\/#video:.*|techcrunch\.tv\/watch.*|techcrunch\.tv\/.*\/watch.*|mixergy\.com\/.*|video\.pbs\.org\/video\/.*|www\.zapiks\.com\/.*|tv\.digg\.com\/diggnation\/.*|tv\.digg\.com\/diggreel\/.*|tv\.digg\.com\/diggdialogg\/.*|www\.trutv\.com\/video\/.*|www\.nzonscreen\.com\/title\/.*|nzonscreen\.com\/title\/.*|app\.wistia\.com\/embed\/medias\/.*|hungrynation\.tv\/.*\/episode\/.*|www\.hungrynation\.tv\/.*\/episode\/.*|hungrynation\.tv\/episode\/.*|www\.hungrynation\.tv\/episode\/.*|indymogul\.com\/.*\/episode\/.*|www\.indymogul\.com\/.*\/episode\/.*|indymogul\.com\/episode\/.*|www\.indymogul\.com\/episode\/.*|channelfrederator\.com\/.*\/episode\/.*|www\.channelfrederator\.com\/.*\/episode\/.*|channelfrederator\.com\/episode\/.*|www\.channelfrederator\.com\/episode\/.*|tmiweekly\.com\/.*\/episode\/.*|www\.tmiweekly\.com\/.*\/episode\/.*|tmiweekly\.com\/episode\/.*|www\.tmiweekly\.com\/episode\/.*|99dollarmusicvideos\.com\/.*\/episode\/.*|www\.99dollarmusicvideos\.com\/.*\/episode\/.*|99dollarmusicvideos\.com\/episode\/.*|www\.99dollarmusicvideos\.com\/episode\/.*|ultrakawaii\.com\/.*\/episode\/.*|www\.ultrakawaii\.com\/.*\/episode\/.*|ultrakawaii\.com\/episode\/.*|www\.ultrakawaii\.com\/episode\/.*|barelypolitical\.com\/.*\/episode\/.*|www\.barelypolitical\.com\/.*\/episode\/.*|barelypolitical\.com\/episode\/.*|www\.barelypolitical\.com\/episode\/.*|barelydigital\.com\/.*\/episode\/.*|www\.barelydigital\.com\/.*\/episode\/.*|barelydigital\.com\/episode\/.*|www\.barelydigital\.com\/episode\/.*|threadbanger\.com\/.*\/episode\/.*|www\.threadbanger\.com\/.*\/episode\/.*|threadbanger\.com\/episode\/.*|www\.threadbanger\.com\/episode\/.*|vodcars\.com\/.*\/episode\/.*|www\.vodcars\.com\/.*\/episode\/.*|vodcars\.com\/episode\/.*|www\.vodcars\.com\/episode\/.*|confreaks\.net\/videos\/.*|www\.confreaks\.net\/videos\/.*|video\.allthingsd\.com\/video\/.*|videos\.nymag\.com\/.*|aniboom\.com\/animation-video\/.*|www\.aniboom\.com\/animation-video\/.*|clipshack\.com\/Clip\.aspx\?.*|www\.clipshack\.com\/Clip\.aspx\?.*|grindtv\.com\/.*\/video\/.*|www\.grindtv\.com\/.*\/video\/.*|ifood\.tv\/recipe\/.*|ifood\.tv\/video\/.*|ifood\.tv\/channel\/user\/.*|www\.ifood\.tv\/recipe\/.*|www\.ifood\.tv\/video\/.*|www\.ifood\.tv\/channel\/user\/.*|logotv\.com\/video\/.*|www\.logotv\.com\/video\/.*|lonelyplanet\.com\/Clip\.aspx\?.*|www\.lonelyplanet\.com\/Clip\.aspx\?.*|streetfire\.net\/video\/.*\.htm.*|www\.streetfire\.net\/video\/.*\.htm.*|trooptube\.tv\/videos\/.*|www\.trooptube\.tv\/videos\/.*|sciencestage\.com\/v\/.*\.html|sciencestage\.com\/a\/.*\.html|www\.sciencestage\.com\/v\/.*\.html|www\.sciencestage\.com\/a\/.*\.html|www\.godtube\.com\/featured\/video\/.*|godtube\.com\/featured\/video\/.*|www\.godtube\.com\/watch\/.*|godtube\.com\/watch\/.*|www\.tangle\.com\/view_video.*|mediamatters\.org\/mmtv\/.*|www\.clikthrough\.com\/theater\/video\/.*|espn\.go\.com\/video\/clip.*|espn\.go\.com\/.*\/story.*|abcnews\.com\/.*\/video\/.*|abcnews\.com\/video\/playerIndex.*|washingtonpost\.com\/wp-dyn\/.*\/video\/.*\/.*\/.*\/.*|www\.washingtonpost\.com\/wp-dyn\/.*\/video\/.*\/.*\/.*\/.*|www\.boston\.com\/video.*|boston\.com\/video.*|www\.facebook\.com\/photo\.php.*|www\.facebook\.com\/video\/video\.php.*|www\.facebook\.com\/v\/.*|cnbc\.com\/id\/.*\?.*video.*|www\.cnbc\.com\/id\/.*\?.*video.*|cnbc\.com\/id\/.*\/play\/1\/video\/.*|www\.cnbc\.com\/id\/.*\/play\/1\/video\/.*|cbsnews\.com\/video\/watch\/.*|www\.google\.com\/buzz\/.*\/.*\/.*|www\.google\.com\/buzz\/.*|www\.google\.com\/profiles\/.*|google\.com\/buzz\/.*\/.*\/.*|google\.com\/buzz\/.*|google\.com\/profiles\/.*|www\.cnn\.com\/video\/.*|edition\.cnn\.com\/video\/.*|money\.cnn\.com\/video\/.*|today\.msnbc\.msn\.com\/id\/.*\/vp\/.*|www\.msnbc\.msn\.com\/id\/.*\/vp\/.*|www\.msnbc\.msn\.com\/id\/.*\/ns\/.*|today\.msnbc\.msn\.com\/id\/.*\/ns\/.*|multimedia\.foxsports\.com\/m\/video\/.*\/.*|msn\.foxsports\.com\/video.*|www\.globalpost\.com\/video\/.*|www\.globalpost\.com\/dispatch\/.*|guardian\.co\.uk\/.*\/video\/.*\/.*\/.*\/.*|www\.guardian\.co\.uk\/.*\/video\/.*\/.*\/.*\/.*|bravotv\.com\/.*\/.*\/videos\/.*|www\.bravotv\.com\/.*\/.*\/videos\/.*|video\.nationalgeographic\.com\/.*\/.*\/.*\.html|dsc\.discovery\.com\/videos\/.*|animal\.discovery\.com\/videos\/.*|health\.discovery\.com\/videos\/.*|investigation\.discovery\.com\/videos\/.*|military\.discovery\.com\/videos\/.*|planetgreen\.discovery\.com\/videos\/.*|science\.discovery\.com\/videos\/.*|tlc\.discovery\.com\/videos\/.*|video\.forbes\.com\/fvn\/.*))|(https:\/\/(skitch\.com\/.*\/.*\/.*|img\.skitch\.com\/.*|twitter\.com\/.*\/status\/.*|twitter\.com\/.*\/statuses\/.*|www\.twitter\.com\/.*\/status\/.*|www\.twitter\.com\/.*\/statuses\/.*|mobile\.twitter\.com\/.*\/status\/.*|mobile\.twitter\.com\/.*\/statuses\/.*|crocodoc\.com\/.*|.*\.crocodoc\.com\/.*|.*youtube\.com\/watch.*|.*\.youtube\.com\/v\/.*|app\.wistia\.com\/embed\/medias\/.*|www\.facebook\.com\/photo\.php.*|www\.facebook\.com\/video\/video\.php.*|www\.facebook\.com\/v\/.*)))$');

// For debugging.
//console.log(gre.test('https://www.youtube.com/watch?v=lngY_OFIoSI'));

grb = new RegExp('^((?=[013479\.\/abcdefghijklmnopqrstuvwxyz])(?:s(?:p(?:r(?:ing(?:source|er)|oducts)?|a(?:rknotes|nishdict)|inoza|hp|orcle|ezify)?|e(?:r(?:ch|ebii|verfault)|a(?:rch(?:c(?:h|pan|ode)|yc|mygmail|forphp|works)|monkey|tgeek)|c(?:tube)?|sli(?:sozluk)?|lfhtml(?:wiki)?|[bqp]|znam|eks|nderbase)|q(?:uidoo|lalchemy)|w(?:agbucks|db|eetsearch)|m(?:a(?:llsafari|shwords)|og(?:on)?|[gh]|ention)?|h(?:o(?:ut(?:itou|cas)t|p(?:ping|wiki|zilla|athome)?|dan(?:hq)?|wtimes)|e(?:lfari|etmusicplus)|utterstock|areware|bd)?|c(?:i(?:ence(?:daily|blogs)|py|fi|rus)|o(?:pe(?:\.d)?k|nj|op)|holar(?:pedia)?|r(?:i(?:tique|bd)|a(?:pe|bblelookup))|2ranks|ala)?|l(?:i(?:ckdeals|deshare)|a(?:ckbuilds?|te(?:fr)?|shdot|ng)|(?:oane|yric)s|wiki)|o(?:n(?:g(?:meanings?|sterr)|2teuf|icretro)|u(?:rceforge|ndcloud)|so?|m|ftware|zluk)?|t(?:a(?:ti(?:cice|onsweb)|r(?:t(?:r(?:ek|ibune)|page(?:(?:image|video)s)?)?|wars)|ck(?:exchange|overflow)|(?:ple|b)s|gevu)|e(?:x|am)|u(?:mble(?:upon)?|bhub|pi|ffnz|dydroid)|ock(?:photos)?)|d(?:[nz]|ict)?|a(?:fe(?:o(?:n|ff)|booru)?|mpled|s|lon|nakirja|vannah)|i(?:m(?:ilar(?:sitesearch)?|plyhired)|te(?:alytics|slike|duzero)|gma|errasoftworks)?|s(?:life|kj)|k(?:epticsbible|yrock)?|u(?:n(?:patch|times)|per(?:d(?:ownloads)?|user)|b(?:s(?:earch|cene)?|reddit)|se(?:bu|pk)g|(?:li|mmitpos)t)?|n(?:opes|uson|l)|y(?:nonym(?:e?s)?|mbolhound)|f(?:(?:gat)?e|s)?|xc?|b[ao]|v|rfi)?|u(?:rban(?:comfort|dictionary)?|b(?:untu(?:f(?:orums)?|users)|ottu)|n(?:i(?:prot|x|ty|code)|scatter|cyclopedia|wiki)|p(?:down|(?:ackage)?s|coming)|s(?:e(?:rs(?:tyle|cript)s)?|a(?:today)?|ps)|it(?:inv|m)|u(?:de)?|g(?:lifyjs)?|ltimateguitar|(?:k|es)p|zg|tf8|d|man)|c(?:o(?:m(?:ic(?:rocket|vine)|p(?:fight|ass|ete)|mons)|de(?:canyon|(?:ple)?x|weavers)?|oks?|l(?:lege(?:board|confidential)|dfusion|or)|n(?:j|certs)|rriere|stco|(?:algirl|upon|wboylyric)s|coa)|h(?:a(?:rity(?:navigator)?|kra(?:wiki|forum|pkg)|nnel[54]|mmy|cha)|e(?:a(?:tc(?:odes|c)|passgamer)|f(?:koch)?)|i(?:cagotribune|lango)|o(?:w|rds)|rome)|r(?:a(?:cked|te|wl|igslist|n)|eativecow(?:lib)?|unch(?:yroll|base)|i(?:ticker|cinfo)|x)|e(?:(?:ne|rcavin)o|llartracker|an)|b(?:s(?:new|sport)s|c)|s(?:theory|pan|s|db|monitor|fd|harp)|l(?:ip(?:stijl|art)|oj(?:ure(?:docs)?|ars)|u(?:sty|bic)|ker|seattle)|p(?:a(?:n(?:[m1]|deps)?|p)|pr?|lusplus)|a(?:r(?:(?:eerbuild|anddriv)er|mag|toonnetwork)?|p(?:ost|taincrawl)|n(?:oo|istream)|ke(?:2(?:book)?|book)?|ched?|mel|ld|shback|talinstefan|fepress)|cr?|fp?|i(?:teul|rcuitcity|sco)?|n(?:bc|rtl|et|n)|d[cnt]|1(?:neon|024)|(?:webstor|v)e|tan|(?:k1)?2|ultureunplugged)|l(?:i(?:b(?:r(?:i(?:vox|s)|arything)|(?:e|universita)ria)|n(?:k(?:edin|scape|up)|g(?:uee|vo)?|ux(?:hcl|fr|mint))|quid?pedia|veleak|fehacker|ke|sp)?|o(?:c(?:al(?:ch)?|ita)?|ngurl|gin|vefilm|lolyrics)|m(?:d(?:dg)?tfy|gtfy|a)|e(?:o[resifc]?|(?:wrockwel|ga)l|boncoin|novo)|u(?:cir|aforg)e|yri(?:c(?:s(?:wiki|mania)?|wiki|ful)|ki)|a(?:s(?:er(?:ship)?|t\.?fm)|t(?:ex|imes)|unchpad|r|vva)|p(?:bug|archive)?|(?:wjg)?l|[cg]c|ds|nu|[hvj]|1sp|xr)|o(?:r(?:tho(?:doxwiki|net)|(?:ei|ie)lly|d|acle|kut)|p(?:e(?:ra(?:ext)?|n(?:s(?:treet(?:map)?|u(?:se(?:software)?|btitles))|p(?:orts|rocessing)|b(?:sd|ook)|cv|radar|library))|timot)|k(?:f|azii|geek)|s(?:[ime]|(?:u|vd)b|news|xdaily|alt)|n(?:elook|imoto|r|trac)|t(?:ran|hes)|e(?:is|[dr])|h(?:loh|(?:norobo|interne)t)|m(?:gu(?:buntu)?|im)|c(?:al?|(?:topar|cuprin)t|w)|v(?:erstock|i)|o(?:lone|pon)|ldcpan|x|bb)|m(?:a(?:m(?:ont|ma)|p(?:s(?:fr)?|quest)?|n(?:gafox)?|t(?:h(?:wor(?:ks|ld)|overflow|se|ematica)|lab(?:fx)?|plotlib)|r(?:k(?:et|(?:tplaat|o)s|mail)|miton|ch)|ke(?:useof)?|c(?:world|dic|update|(?:port|y|addres)s)?|sh(?:able)?|g(?:ma(?:wiki)?|iccards)|l(?:ist|pha)|(?:deinus|fi)a|jorsbooks|xthon)?|y(?:a(?:llsearch|nimelist)|s(?:ql|pace)|etym|dealz|wot|opera|fonts)|e(?:m(?:oryalpha|e)|t(?:a(?:c(?:r(?:itic|awler)|pan|afe)|l(?:storm)?|filter|so)|eo(?:fr|ciel)|rolyrics)|d(?:ia(?:dico|wiki)|nar)|r(?:c(?:adoli[vb]re|urynews)|riamwebster)|n(?:upages|eame|deley)|fi)|p(?:la?|ny|fl|bo|gde|[pc]h|sf|dc)?|o(?:n(?:go|oprice|ster)|d(?:x|ulusfe|db)|vie(?:pilot|s|web)|o(?:tools)?|(?:(?:u|zbrow)se|rningsta|g)r|bygames)|vn(?:repository)?|u(?:si(?:c(?:iansfriend|brainz|me)|pedia|km)|lticolr)|i(?:c(?:ro(?:soft|center)|haelis)|n(?:e(?:craft|forum)|iclip)|t(?:ocw|vid)|s?o|mvi|b|ll|ghtyape)|m(?:nt|ls)|c(?:wiki|anime|(?:ski|pa)n)?|b(?:ug|sdman)?|s(?:m(?:alware|vps)|nbc|dn|kb|q)?|lb?|t[vg]|d(?:[cn]|bg)|[wq])?|g(?:u(?:i(?:tartabs|ldwiki)|a(?:rdian)?|[ks]|lesider|tenberg)|o(?:o(?:gle(?:maps?|uk|images)?|kokugo|sh|dreads)|l(?:ang|em)|g|daddy|(?:ea|phe)r|rp|vtrack)|n(?:o(?:mebugs)?|[lmzu]|ews|fr|de)?|d(?:[tke]|ay|ocs)?|e(?:iz(?:hals)?|o(?:cach(?:e|ing)|names|ip)|t(?:tyimages|human)|e(?:gain)?|n(?:toowiki|esis)|phi|m?s)|t(?:r(?:anslate|ends)?|(?:ur|n)l|abs|[hw]|de)?|w(?:p(?:de)?|orkshop|eek|iki)|v(?:iew(?:er)?|[ne]|pl)?|f(?:i(?:nance)?|aqs|[rcl])?|b(?:l(?:ast|ogs)|[mrek]|(?:ug|ook)s|(?:an)?g)?|s(?:c(?:holar)?|s?l|(?:maren)?a|(?:hoppin)?g|u?k|e)?|a(?:me(?:s(?:radar|pot)|(?:trailer|ranking|cheat|faq)s|(?:pr|zeb)o|jaunt)|en?|t(?:herer)?|(?:wke)?r|(?:cces)?s|u|llica\.bnf)|h(?:[ku]|acks)?|r(?:e(?:p(?:c(?:pan|ode)|lin)|lated|ader)|o(?:ov(?:y|eshark)|klaw)?|a(?:ph(?:emica|icriver)|tefuldead|ve)|i(?:dcalendar|cal)?|[uv])?|g(?:r(?:oups)?)?|i(?:t(?:\-scm|l|hub)?|e(?:z(?:hals)?)?|m(?:ages)?|s(?:(?:afe)?off|t)|[rnkd]|gaom|zmodo)?|c(?:o(?:de)?|a(?:che|l)?|(?:pa)?n|[hlz])|p(?:l(?:usp?|ay)?|h(?:otos)?|a(?:ckages|t)|[tde])?|l(?:o(?:b(?:o|eandmail)|cal)|(?:ates)?t|v|yde|ink)?|m(?:a(?:ps?|il|ne)|o(?:b|nth)|[yx]|usic)?|za|jp|(?:yea|k)r|24|4tv)?|b(?:i(?:g(?:fish|words)|n(?:g(?:(?:image|map)s)?|search)|bl(?:e(?:gateway|tools)?|srv)|t(?:gamer|bucket|snoop)|mages|znar|ography)?|l(?:o(?:g(?:s(?:pot)?|talkradio)|omberg|cket)|e(?:kkoi?|nd(?:er|api))|ackbook(?:mag)?|i(?:ndsearch|ptv)|ueletterbible)|s(?:d(?:man)?|ocial)?|u(?:lba(?:pedia)?|ej|y|(?:rnbi|gmeno)t|sinessweek)|a(?:se(?:search|ballreference)|n(?:gs?|dcamp)|r(?:tlets|nesandnoble)|i(?:xaki|du)|con|y12|kabt|tlyrics)|v(?:ideos?)?|m(?:p3|aps)?|o(?:o(?:k(?:f(?:inde|lavo)r|mine|[so]|depository)|st)|ardgamegeek|l|ingboing|xoh)|c(?:p|wiki)|r(?:itannica|ew)?|e(?:s(?:ch|tbuy)|o(?:es|pt)?|hind(?:sur|the)name|atport|er)|b(?:c(?:food|w)?|apps|t)?|n(?:ews|f)?|t(?:abs|(?:mo)?n|digg)|g[gp]|kr|wc)?|w(?:3(?:c|schools)?|h(?:at(?:is)?|o(?:is)?|i(?:te(?:pages|water))?)|n(?:[nlo]|etwork)|i(?:n(?:ehq|[ck]|fu)|k(?:i(?:s(?:um|imple)|t(?:ravel)?|p(?:aintings|edia)|how|[ca]|(?:new|book|v)s|de)?|t(?:[fb]r|de|ionary)?)|[qt]|mp|ssen|(?:eowi|ggl)e|red|llh)|d[ae]?|t(?:[rf]|en|sv)?|e(?:b(?:m(?:d|enu)|s(?:ta(?:ts|gram)|itedown)|cams|(?:warp|tend)er|2py|oftrust)|ather(?:bug)?|heartit|[soun]|tter)|m(?:eta|c)?|a(?:tch(?:anime)?|l(?:l(?:base|paper)|pha|mart)|doku|yback|ffles|shingtonpost|koopa)?|o(?:s[ni]?|r(?:d(?:n(?:et|ik)|reference|press)|ld(?:cat|ofspectrum)|m)|w(?:armory(?:eu)?|head|battlenet|pedia)|t(?:if)?|lfram(?:alpha)?|g|xikon)|s(?:j(?:mw)?|[lv])|p(?:t(?:hemes)?|7(?:fr)?|l|plugins)?|r(?:e(?:s(?:fr)?|f|nit)|fe|u|iten)?|w(?:wjdic|end)?|l(?:find|n)|c[sa]?|u(?:k|nderground)|f[ri]|br|ja|ykop|g|zh)?|e(?:s(?:sef(?:n|fr)|p(?:ac(?:oliberdade|enet)|n)|en|it|g|vonline)|c(?:o(?:sia|nomist)|[ha])|d(?:gart?|e|itus)?|b(?:u(?:ilds?|k)|a(?:y(?:i[etn]|c[ha]|p[lh]|a[ut]|my|[uh]k|[bd]e|fr|es|nl|sg)?|[ut])|e(?:rt|s)?|i[net]|c[ha]|p[hl]|nl|[bd]e|fr|hk|sg|my)?|n(?:e[ols]|t(?:rez|ireweb)|cyclopedia|[sl]|dthelie|(?:i|gadge)t)|q(?:beats|uestriadaily)|i[ten]|p(?:i(?:c(?:urious|mafia)|nions)|ubbud|[lh])?|r(?:lang|owid)|v(?:e(?:r(?:y(?:click|mac)|note)|ntful)?|irt(?:a[ut]|des|tit|ed)?|ri)|u(?:rogamer|k)|x(?:p(?:loitdb|edia)|t(?:ratorrent)?|alead|if)|m(?:a(?:cs(?:wiki)?|g)|u(?:sic|(?:paradis|l)e)|edicine|y)|f[rf]|l(?:e(?:xiko)?n|reg)|e(?:gg)?s|a(?:[ut]|rth911)|h(?:k|ow)|ksi(?:sozluk)?|t(?:ym(?:ology)?|ree|sy)|[2o]|ggtimer)?|d(?:p(?:lb?|dt?|(?:t|ackage)s|[ibwvn]|kg)?|o(?:c(?:jar|s)|wn(?:load|for)|main(?:r|sbot)?|lu|i|aj|uban|gpile|ttk)|b(?:ugs|asx|(?:sn|l)p|yte)|e(?:b(?:ian(?:f(?:r|orums))?|ml|bug)|v(?:eloppez|iantart|apple)|l(?:l|icious)|(?:(?:xonl|f)in|alextrem)e|sura|ezer|(?:monoi|rstandar)d)|i(?:g(?:i(?:tal(?:comic(?:museum|s)|spy)|key)|g)?|c(?:t(?:ionary|\.?cc|leode)?|cionari)?|s(?:tro(?:watch)?|c(?:o(?:very|gs)|ussion)|ney)|l(?:bert|andau)|aspora(?:tags)?|(?:ra)?e|padova|igo)?|j(?:ango(?:me)?|packages)?|20(?:(?:pf)?srd)?|f(?:m(?:an)?|w|iles)?|r(?:i(?:bbb?le|nkify)|u(?:pal(?:api|contrib)?|gbank)|a[me]|eamincode)|a(?:t(?:a(?:sheet)?|piff|e)|wanda|nbooru|ilymotion|sh|font|pi|rklyrics)?|h(?:l(?:gm|de)?|net)|m(?:oz|an)?|t(?:ag|deals|c)|d[og]|u(?:c(?:k\.?co)?|den)|l(?:ang|ss|po)|[wx]|cc|ns|\&d)?|p(?:o(?:rt(?:ableapps)?|w(?:iki|ells)|ll(?:in|star)|st(?:e(?:n|rs)|gresql)|n(?:d5|sde)|e(?:try|ms)|dnapisi|psike|kepedia)|y(?:thon(?:3[120]?|2[76]|dev)?|3k|lons|pi|ramid|side)?|r(?:i(?:ce(?:grabber)?|beram|sjakt)|o(?:c(?:essing)?|nounce|ofwiki|garchives)|fc|pm)|e(?:r(?:l(?:mo(?:d|nks)|doc)?|ezhilton|seus)|ppermintos)|i(?:n(?:board|g|voke)|c(?:tures)?|rate(?:nwiki|sea|bay)|x(?:iv|elp)|tchfork)|b(?:[si]|one)?|u(?:n(?:chfork|guzo)|c|rolator|ppet|bmed)|a(?:r(?:a(?:shift|bola)|lysearch|king)|l(?:eo|gn)|t(?:ft|ternry)|ndora|(?:gin|ckag)e|stebin)|s(?:ql|implified)?|c(?:g(?:w|arage)|mag|world|partpicker)|p(?:[ca]|lware)|h(?:p(?:net)?|oto(?:bucket|dune))|l(?:a(?:y(?:term|list|asia)?|n(?:etmc|3t))|ot)|d[bf]|kgs(?:rc)?|minister|[gt]p|w|4k)|1(?:23p(?:eople)?|1870|ddl)|n(?:e(?:w(?:s(?:day|(?:vin|archiv)e|max|yc|now|week|comau)?|(?:ff|yorke)r|ark|grounds|egg)|t(?:(?:fli|work)x|craft|gear|hack)|st(?:uk|de)|xt)?|f[lb]|a(?:t(?:uresp|ionalgeograph)ic|sa|ver|jdi|ruto|metoolkit)|b(?:sdman|a)|u(?:llege|get|tridata|mpy)|o(?:rsk|kiamaps|lo|aa|de)|i(?:n(?:ja|tendolife)|co(?:linux)?|h|if)|rc(?:next)?|y(?:aa|(?:pos)?t)|p[mr]|zb(?:matrix|s)?|v(?:idia|d)|c(?:[ze]|iku|heap|bi)|(?:nd|la)b|ds|hl|x|ginxwiki)?|a(?:l(?:l(?:e(?:gro|lec|xperts)|m(?:ovie|usic)|abolag|(?:(?:bibl|recip)e|poster)s|ocine)|exa(?:si)?|bum(?:art(?:c|dv)d)?|t(?:ernat(?:ive(?:to)?|e)|t?o)|jazeera|c)|o(?:ps|3)|r(?:t(?:work|ist|urogoga)|c(?:h(?:ived?|pkg|forums|linux|aur|wiki)?|gis(?:res)?)|s(?:technica)?|k|gos|duino|xiv)|z(?:font|lyric)s|c(?:ro(?:nyms?)?|ademic(?:earth)?|tive(?:den|state)|m|cuweather)|u(?:k(?:ro)?|s(?:gov|tralian)|(?:toca)?r|diojungle)|n(?:droid(?:pit)?|i(?:me(?:newsnetwork|lyrics)?|search|db)|yr|n|agram|swers)|p(?:p(?:le(?:d(?:iscuss|ev))?|brain|(?:n|shoppe)r|cel|engine|vv)|ac(?:kages|he)|i(?:dockruby)?|ertium)?|m(?:fr?|azon(?:mp3)?|c[an]|uk(?:mp3)?|jp|it|o|de|es)?|h[wk]|b(?:cn(?:ews|otation)|andonia|out|buc)|d(?:s(?:labs)?|libris(?:no|se|dk|fi)|[ac]|planner|dic7ed|(?:ob)?e)|s(?:k(?:ubuntu|sutra|news)?|[n3]|oiaf)|w(?:esomecow|img)|i(?:rbnb|on)|jc|vclub|t|gdl)?|i(?:con(?:finder|s)?|n(?:s(?:tructables|pire)|fo(?:chimps|space)|d(?:i(?:ego)?go|e(?:ed|pendent))|(?:taljazeer|vestopedi)a|ab|ci)|d(?:e(?:ntica|alode)|ioms)|m(?:age(?:net|s|ry)?|(?:f?d)?b|g|eem|slp)?|e(?:ee|c)|w(?:ant)?|k(?:ea(?:nl|fr|de)?|so)|p(?:ernity|(?:artsplane)?t|s|layer)?|s(?:o(?:hunt)?|bn(?:db|nu)|tockphoto|up|gd|itdown)|x(?:quick(?:(?:image|video)s)?)?|t(?:e[nos]|v|unes)|f(?:ixit|db)|r[cs]|op?s|bm|usethis|(?:archiv|lsole24or)e|qdb|gn)?|r(?:o(?:t(?:tentomatoes|o)|s(?:ettacode)?|ckethub|m|otsarchives|ku|adandtrack|btex|llingstone)|e(?:c(?:i(?:pes?|va)|ycle|ordclick)|d(?:f(?:lagdeals|in)|tram|z|dit)|ad(?:thedocs|writeweb)|g(?:ister|ex)|tailmenot|i|ed|(?:flet|uter)s|pubblica)|b(?:l|ugs)|t(?:news)?|p(?:m(?:find)?|ggeek|s)|f(?:c|aces)|u(?:by(?:doc|gems)?|tube)|s(?:eek|wiki)|a(?:nd(?:om|t)|p(?:idonline|genius)|ils(?:dock)?|teyourmusic|diotimes|e|cket)|i(?:pestat|cardo|ngtones)|d(?:io|ns|oc)|l(?:ib|slog)|hyme|ym|mp)?|t(?:h(?:e(?:s(?:aurus|ession|tar)|m(?:ag|oviedb|eforest)|fu(?:toncritic|llwiki)|(?:on|nat)ion|h|register|piratebay)|in(?:k(?:geek|tutorial)|giverse)|oma(?:nn|s)|wiki|alia|umbplay)|v(?:(?:trope|link)s|com|(?:rag|guid)e|db)?|r(?:a(?:de(?:m(?:arks|e)|ra)|ns(?:fermarkt|late)|c(?:eroute|k)|kt|ffic|iler)|i(?:squel|padvisor)|u(?:veo|eknowledge|lia)|e(?:ccani|llo)|l|fde)?|i(?:n(?:y(?:url|pic)|eye)|g(?:erdirect|source|db)?|cket(?:network|s|master)|mestamp|[vh]o)|p(?:bs?|roj|p)|u(?:reng|aw|nein|mblr|dou)|o(?:r(?:rent(?:freak|z)?|wiki)|f|kyotosho|nes|psy|uhou|talcmd|mshardware)|a(?:r(?:inga|get)|wlk|toeba|obao|nzil|bs|stekid)|e(?:x(?:ture)?|r(?:raria)?|ch(?:(?:iri|right)s|(?:ne|dir)t|jungle|crunch)|legraph|(?:amliqui)?d)|f(?:d|2wiki)|w(?:i(?:t(?:ch|ter)|npedia)|e(?:et(?:grid)?|akers)|n)?|k(?:nowledge)?|c(?:rf|l)?|l(?:dp?|fi)|m(?:[zt]|db)|s[ar]|(?:n|gdic)?t|yda|411|z)?|y(?:m(?:ap|ovie)s|o(?:u(?:t(?:ube|ify)|ku|dao)|pmail)|u(?:mmly|i|bnub)|a(?:n(?:dex(?:m(?:aps)?|en)?|swers)|en|hoo)?|e(?:l(?:lownz|p)|gg|ahway)|i(?:ppy|mages|i)|f(?:inance)?|tw?|go|[rc]|jp|news)?|q(?:tc?|rz?|u(?:o(?:ra|tes)|ran|ixey|(?:eryca|antcas)t)|o(?:buz|mun)|ype|wiki|ssl)|j(?:q(?:uery)?|a(?:va(?:[4567]|script)?|lop(?:nik)?|ba|r|mendo)|i(?:sho[ej]?|gsaw|nni)|s(?:tor)?|e(?:ux(?:video\.com)?|t(?:wick|slide)|opardy|d)|o(?:b|hnlewi)s|[lf]|umpr|dk|pg|cpenney)|k(?:p(?:op|rojects)|a(?:p(?:i|aza)|zazz|yak|rmadecay|t)|i(?:ndle(?:uk)?|ck(?:starter|(?:new|asstorrent)s)|llerstartups)|o(?:lw?|(?:der)?s|(?:b|mputek)o|ng|tobank)|t(?:b|echbase)|e(?:epvid|rodicas|lkoo)|h(?:anacademy|ronos)|c(?:ls|ommunity)|(?:kbruc|nowyourmem)e|ym|bugs|uler)|x(?:i(?:ami|ng)|d(?:af?|cc)|ep|kcd|marks|86|anga)|h(?:e(?:ad\-?fi|cf|s|ise|roku|lp)|o(?:w(?:t(?:hingswork|oforge)|stuffworks|jsay)|me(?:depot|base)|epli|tukdeals|st|ogle)|a(?:b(?:ra|botrading)|ck(?:a(?:ge|day)|ernews)|rk|lf|stane|doop|yoo)|p(?:hys|v)?|u(?:ffingtonpost|lu)|n(?:search)?|i(?:storious|tta|ghrec|5)|tf|gnc|ypem|33t|rwiki|18)|f(?:i(?:n(?:d(?:l(?:aw|unchin)|chips|jar)|alfantasy|n)|le(?:stube|xt|crop|(?:hipp|inf)o)?|refox|shpond)|r(?:e(?:e(?:dict(?:ionary)?|bsd(?:man)?|[nc]ode)|sh(?:meat|ports)|itag)|ancesurf|iendster)|o(?:r(?:kd|rst|bes|vo)|o(?:lz?|d(?:subs)?|find)|to(?:banka|log)|l(?:ktunefinder|ha)|ursquare|wiki|(?:xnew|nplu)s)|t(?:p|ube|ram)?|a(?:twallet|(?:ceboo|r)k|ncy)|u(?:r(?:affinity|et)|llwiki|zz)|l(?:i(?:ck(?:r(?:iver|c)?|peek)|pkart)|a(?:shback|ttr)|uidinfo|ex)|br?|e(?:d(?:ex|orawiki)|nopy|edbooks|fe)|sfe?|c(?:atch)?|da?|g?f|nac|ports|xr)|v(?:i(?:deo(?:hive|sift)?|m(?:scripts|doc|eo)|asona|ewpdf)|a(?:l(?:a|idate|leywag)|(?:ndal|galum)e)|g(?:g(?:uk|de)?|mdb|d)|e(?:r(?:o(?:nica|ot)|s(?:andapo|iontracker)|b(?:omatic)?|ge)|ekun|oh|mo)|o(?:gue(?:uk)?|l|ssey)|box7|ukajlija|(?:mk|nd)b|tkcd)?|\/\.j?|z(?:u(?:ckerzauber|mi)|a(?:p(?:(?:ik|po)s|aday)|nran|he|vvi)|i(?:pca|llow)|e(?:mljevid|rohedge)|bmath|f|yrv|(?:vo|he)n|dnet|oho)|4(?:3things|chan|shared)|\.(?:net|\/)|3tailer|7digital|9gag|013))$');

			// 2012.08.18 deal is a false positive: windows loopback speed
gra2 = new RegExp('\\b(selling|sellers?|rents?|stores?|shops?|shopping|shopper|buy|orders?|products?|pricing|prices?|reviews?|deals|dealer|isbn)\\b','i');
// no book so facebook, buy - best buy, shop - shopzilla, price - pricegrabber, music - allmusic
//gra = new RegExp('^https?:\/\/.*(amazon|netflix|ebay|lyrics|myspace|itunes|barnesandnoble|game|bizrate|imdb|nextag|cnet|zdnet|softpedia|shop|buy|blockbuster|download|powells|isbn|target|walmart|newegg|macys|overstock|sears|jcpenney|last|cdwow|cduniverse|tower|goodreads|sale|teenourmous|cafepress|zazzle|spreadshirt|store|shelfari|oreilly|librarything|woldcat|costco|ikea|jcpenney|johnlewis|staples|etsy|allposters|cicuitcity|music|order|product|price|review)\\.');
gra = new RegExp('^https?:\/\/(?:www\.|)(amazon|netflix|(?:rover\.|)ebay|shopping.yahoo|barnesandnoble|bizrate|imdb|nextag|cnet|buy|blockbuster|powells|target|walmart|newegg|macys|overstock|khols|kmart|sears|homedepot|jcpenney|qvc|last|cdwow|cduniverse|mtv|getglue|rhapsody|pandora|tower|goodreads|teenourmous|cafepress|zazzle|spreadshirt|shelfari|oreilly|librarything|worldcat|costco|ikea|jcpenney|johnlewis|staples|etsy|allposters|circuitcity|bestbuy|toysrus|shopping|coupons\.thefind|lyricsmode|metrolyrics|librarything|dpreview|gizmodo)\\.');
gram = new RegExp('^https?:\/\/(?:www\.|)(cdwow|cduniverse|mtv|rhapsody|pandora|lyricsmode|metrolyrics|last)\\.');
grab = new RegExp('^https?:\/\/(?:www\.|)(oreilly|shelfari|goodreads|librarything|barnesandnoble)\\.');
grad = new RegExp('^https?:\/\/(?:www\.|)(netflix|imdb)\\.');
grae = new RegExp('^https?:\/\/(?:www\.|)(newegg|dpreview|gizmodo)\\.');
// tighter domains to leave room
gra3 = new RegExp('^https?:\/\/.*amazon\.com.*\/dp\/([\\dA-Z]{10})[\/\?]');
//console.log(gra);

grbn = new RegExp('news');
grbm = new RegExp('loca');

// For debugging.
//alert(YAHOO.util.FlashDetect.installed);
//alert(ih5);
//alert(navigator.userAgent);
//alert(im);
//alert(is5);
//alert(iw);
//alert(navigator.plugins["Shockwave Flash"]);
//alert(navigator.plugins);

tr = new Array();ts = new Array();rd = new Array();rsd = new Array();reb = new Array();
dow = new Array('Sun','Mon','Tue','Wed','Thu','Fri','Sat');
//ga='http://i.duck.co/i/';
ga='//icons.duckduckgo.com/i/';
//ga='/i/';
gd='http://duckduckgo.com/';
if (issl) {
  gd='https://duckduckgo.com/';
//  ga='/i/';
}
fb=ci=iwa=irl=idom=il=dz=da=dam=daiq=daia=fz=tl=tlz=sx=sy=fl=fo=fa=fn=rdc=rtc=rsc=rii=rin=rebc=tsl=tac=tn=tz=fe=fmx=fmy=ieof=iad=iad2=iad3=iadt=0;
kurl='';
rpc=fk=fs=1;

rl=YAHOO.util.Cookie.get("l")||'us-en';
if (w.kl) rl=kl;
rp=YAHOO.util.Cookie.get("p")||1;
if (w.kp) rp=kp;
if (w.k1 && w.k1=='-1') DDG.is_ad_blocked = true;


// For debugging.
//console.log(window.r2c);
//alert(kr);
//console.log(ki);

if (w.r2c) rir='r2-0';
/*
   function names don't get minified, so we do that.

   ^nc, click binding
   ncf = click binding function
   ncg = click binding function
   nckd = onkeydown binding
   ncku = onkeyup binding
   nckp = onkeypress binding

   ^nb, bang functions
   nbc = click binding for bangs
   nbb = click binding for split button
   nbr = register new bangs on submit
   nbp = put cookie bangs into dropdown
   nbm = callback for bangs more call

   ^nf, format functions
   nfn = format number with commas

   ^nk, keybaord bindings functions
   nkua = keyboad up arrow binding
   nkda = keybaord down arrow binding
   nke = keybaord enter binding
   nko = keybaord o binding
   nkn = keybaord new window binding
   nkm = keybaord main results shortcuts binding
   nkes = keybaord escape binding
   nks = keybaord slash binding
   nkex = keybaord exclamation point binding
   nksp = spelling binding
   nksb = keybaord space bar binding
   nkf = keybard focus binding (to mouse)
   nki = keybard image binding
   nkr = keybard topics binding
   nkdc = keyboard detect control
   nkds = keyboard detect alt
   nkdt = keyboard detect shift
   nkdm = keyboard detect meta
   nkt = keyboard t binding
   nkd = keyboard d binding

   ^nh, history functions
   nhs = history state change
   nhr = history register state

   ^ni, initilize functions
   nik = initilize keyboard bindings
   nir = initilize results
   nix = initilize search box text
   nih = initilize history manager
   nip = initiliaze page, calls others
   nipo = initialize page for opera
   nis = initial state
   nib = initilize add to browser
   nic = initilize css
   nif = initilize fonts
   nim = initilize map

   ^nn, news functions

   ^nr, result functions
   nrv = result onmouseover
   nro = result onmouseout
   nrm = result move
   nrq = result query builder
   nrqc = result query builder onclick handler
   nrs = result scroll
   nrg = result go
   nrl = result link click
   nrn = make new results
   nrp = make new misspellings
   nrc = make new css
   nrji = initial calls (defined in Index.pm)
   nrj = make new results javascript
   nrji = initial calls (defined in Index.pm)
   nra = make new abstract
   nra2 = make new abstract2 (for external API rendering)
   nra3 = expand zero-click info box
   nrt = go to result vertical
   nrb = automatic results via scroll
//   nrss = make similar sites
   nrtd = make tagdef (external js file)
   nrfv = make fanvibe (external js file)
   nrnm = make numote (external js file)
   nrwot = make wot
   nreb = make embedly
   nrsg = make seatgeek (external js file)
   nrrel = make related searces

   ^ns, screen functions
   nsd = show dots
   nsr = show results
//   nsz = show zoom
   nsl = remove loading gif
   nse = fire image event
   nsh = show hidden section
   nsk = show keyboard shortcuts

   ^nu, util functions
   nua = asyncrhonous call
   nue = event cancel
   nug = go to link
   nui = install search engine
   nut = create image group and custom trigger event
   nur = create and register image
   nus = register image
   nul = reset link
   nuc = expand anchor for fixed position header
   nuo = scroll to top
   nun = get link number given div
   nux = check if xtra stuff is on top.
   nuv = set current viewport width
//   nud = set a delay -- not implemented yet
   nutr = add to temp space
   nuov = make an overlay play video
   nutp = grab tracking pixel

   ^nt, shortcut functions
   ntk - hide keyboard shortcut legend
   nte - hide feedback icon


*/


function nfn(n) {
    if (!isFinite(n)) {
        return n;
    }

    var s = ""+n, abs = Math.abs(n), _, i;

    if (abs >= 1000) {
        _  = (""+abs).split(/\./);
        i  = _[0].length % 3 || 3;

        _[0] = s.slice(0,i + (n < 0)) +
               _[0].slice(i).replace(/(\d{3})/g,',$1');

        s = _.join('.');
    }

    return s;
}

// Add an object to temp variable and return length.
function nutr(obj) {
    var length = tr.length;
    tr[length] = obj;
    return length;
}

// Grab a tracking pixel.
function nutp (id) {
    var img,rand;
    rand = Math.ceil(Math.random()*10000000)
    img = nur('','','/t/'+id+'?'+rand);
}

// set current viewport width
function nuv() {

    /* 2012.12.20
       Not sure exactly why the screen.width/height thing is in there, 
       but the commit message talks about small screens, so making it
       only apply to small screens since it is breaking the ipad 3
       on landscape to show the right sidebar.
    */

    viewport_width = YAHOO.util.Dom.getViewportWidth();
    //    alert(viewport_width);
    if (screen.width<viewport_width && screen.width<500) viewport_width = screen.width;
    viewport_height = YAHOO.util.Dom.getViewportHeight();
    if (screen.height<viewport_height && screen.height<500) viewport_height = screen.height;
}

// hide keyboard shortcut legend
function ntk() {
    if (confirm(l('Hide this legend?'))) {
	YAHOO.util.Cookie.set('k', 'l', { expires: new Date("January 12, 2025") });
	YAHOO.util.Dom.setStyle('keyboard_shortcuts','display','none');
    }
}

function nte() {
    if (confirm(l('Hide feedback icon?'))) {
	YAHOO.util.Cookie.set('e', '-1', { expires: new Date("January 12, 2025") });
	YAHOO.util.Dom.setStyle('feedback_wrapper','display','none');
    }
}

/* Looks for extra stuff on top to prevent doube 0-click */
function nux() {
    var is_xtra = 1;

    // 2011.01.15 -- allow spelling
    // 2011.01.17 -- allow zero_click_answer
    if ((!d.getElementById('zero_click_abstract') || YAHOO.util.Dom.getStyle('zero_click_abstract','display')=='none')) is_xtra=0;

    // 2012.05.29 -- e.g. (disambig heading).
    if (d.getElementById('zero_click_heading') && YAHOO.util.Dom.getStyle('zero_click_heading','display')=='block') is_xtra=1;

    return is_xtra;
}


/* Asyncrhonous call.
   On safari mainly (some on IE), if you do
   quick mouseover/mouseout events triggered in JS
   that change the screen, they aren't always
   renderered correctly.  But if you put them
   in their own thread, it forces a screen redraw.

   We all do these in serial fashion, if asked.
*/
function nua(f,o,timeout,serial,l,arg1,arg2,arg3) {

    // For debugging.
//    alert(f);

    if (!l) {
	l = tr.length;
	tr[l] = o;
    }
    if (!timeout) timeout=10;
    if (!serial) setTimeout(f+'(tr['+l+'],'+arg1+','+arg2+','+arg3+');',timeout);

    else if (!tsl) {

	// For debugging.
//	alert('test');
//	alert(f);

	// Set lock.
	tsl = ts.length;

	// Run immediately, and clear lock when finished.
	setTimeout(f+'(tr['+l+'],'+arg1+','+arg2+','+arg3+');tsl=0',10);

    } else {

	// Try again in a bit.
	setTimeout('nua('+f+',0,1,'+l+','+arg1+','+arg2+','+arg3+')',100);
    }
}


// Tells if ctrl key is pressed or not.
function nkdc(event) {
    var target;
    if (event) target=event.ctrlKey;
    return target;
}

// Tells if meta key is pressed or not.
function nkdm(event) {
    var target;
    if (!ie && event) target=event.metaKey;
    return target;
}

// Tells if alt is pressed or not.
function nkdt(event) {
    var target;
    if (event) target=event.altKey;
    return target;
}

// Tells if shift is pressed or not.
function nkds(event) {
    var target;
    if (event) target=event.shiftKey;
    return target;
}


/*
   Onclick for links.
*/
function nrl(event,link) {
    var target,new_link;

    // For debugging.
    //        return false;
    //    alert('test');
//    return true;
//    console.log('test');
//    return false;
//    console.log(event + ' ' + link);

    event = event || window.event;

    // For debugging.
    //    alert(event);
//    alert(event.button);
    //alert('test');
    //    alert(fm);
//    console.log(event.nodename);
//    return false;
//    console.log(target);

    fl=1;

    target = nkdc(event) || nkdm(event) || '';
    // 2011.07.01 let internal links pass.
    if (!target && kn && kn=='1' && link && link.href && link.getAttribute("href").indexOf('http')!=-1) target=1;

    // For debugging.
    //alert(event.button);
    //	console.log(target);
    //	console.log(nkds(event));
//    console.log(link.href);
 //   console.log(target);

    // fm is for ie bc window.event isn't set correctly as it is overridden by onmousedown
    if (!target && (nkds(event) || fm || (event.button && (((!ie||ie9) && event.button==1) || (ie && event.button==4))))) target=1;

    // For debugging.
    //	alert(event.button);
    //	alert(fm);
    //    alert(target);
    //	console.log(target);

    // ctrl-click
    if (target) {

	// For debugging.
//	alert('test');
//	alert(link.href);
	//alert(link.href.indexOf('/k/?'));

	if (kg!='p' && (!kd || kd==1) && link.href.indexOf('/l/?')==-1 && link.href.indexOf('/k/?')==-1) {
	    link.href='/l/?uddg='+encodeURIComponent(link.href);

	    // For debugging.
//	    alert(link.href);

	    nua('nul',link,500);
	}

	// For debugging.
	//	    alert(link.href);
	//	    nua('nug',link);
	//	    alert('test');
	//	    alert(nkds(event));
	//	    alert(ie);

	// Safari and ie handle fine.
	if (nkds(event) && !ie && !is) {

	    // For debugging.
//	    alert('test');

	    nua('nug',link.href,'','','',target);

	    // For debugging.
	    //		console.log('test');
	    //	    alert('test1');

	    // So link doesn't open in regular window either.
	    return false;
	}
	else return true;

    } else {

	new_link = link.href;

	if (kg!='p' && (!kd || kd==1) && !ih5 && !ie7 && link.href.indexOf('/k/?')==-1 && link.href.indexOf('/l/?')==-1) {

	    // For debugging.
//	    alert('test');
//	    console.log('test');

	    if (ie) new_link='/l/?uddg='+encodeURIComponent(link.href);
	    else new_link='/k/?uddg='+encodeURIComponent(link.href);
	}

	//	alert(new_link);

	nua('nug',new_link);

	// For debugging.
//	console.log('test2');
//	alert('test2');

	return false;
    }
}

// reset link
function nul(link) {
    var index,new_link;
    var index = link.href.indexOf('/k/?uddg=');
    if (index==-1) index=link.href.indexOf('/l/?uddg=');
    if (index!=-1) new_link=decodeURIComponent(link.href.substring(index+9));
    link.href=new_link;
    fl=0;
}



/*
   Go to result given div x and link num y.
   Looks through the div for links.
*/
function nrg(div,link_num,event,target) {
    var link,href,re,id;
    if (!link_num) link_num = 0;

    // For debugging.
    //    console.log(link_num);
//    alert(link_num);
//    console.log(div.id);
    //   console.log(div + ' ' + link_num + ' ' + target);
    //    alert('test2');
//    return false;

    event = event || window.event;
    re = new RegExp('highlight_[a-z]*?(\\d+)');

    // For debugging.
    //alert(target);
    //alert(YAHOO.util.Dom.get(div).className);

    if (target && re.test(YAHOO.util.Dom.get(div).className)) {
	link_num = DDG.get_link_num(RegExp.$1);

	// For debugging.
	//	alert(link_num);
	//	console.log("TEST " + link_num);
    }

    if (link_num=='-1') link = div.getElementsByTagName('a')[div.getElementsByTagName('a').length - 1];
    else link = div.getElementsByTagName('a')[link_num] || div.getElementsByTagName('a')[0];


    /*
    console.log(target);
    console.log(YAHOO.util.Dom.get(div).className);
    console.log(re.test(YAHOO.util.Dom.get(div).className));
    console.log(link_num);
    console.log(div.getElementsByTagName('a')[link_num]);
    console.log(link);
    return false;
    */

    if (!target) target = nkdc(event) || nkdm(event) || fn;
    if (!target && kn && kn=='1') target=1;

    //    console.log(target);

    // Internal links.
    // 2011.07.21 moving outside block so that if target is explicitly set this will unset it.
    if (target && link && link.href && link.getAttribute("href").indexOf('http')==-1) target=0;

    // For debugging.
    //    console.log(link.getAttribute("href"));
    //    console.log(target);
    //    return false;

    if (link.href && link.href != 'javascript:;') {

	
	/* get the actual element that was clicked */
	// 2013.05.09 do not uncomment without changing since breaks firefox.
	//	tname=event.target || event.srcElement;	

	// For debugging.
	//	alert('test');
	//alert(link.href);
	//	console.log(fl);

	/*
	  Register state in history object so that
	  when we come back it will be highlighted.
	 */
	nhr(div.id);
	//	console.log(div.id);
	//	alert(div.id);

	/* Go to link asynchronously,
	   because otherwise nhr can mess it up.
	   Don't go if we are going to something already.
	*/
	if (fl) fl=0;
	else {

	    // For debugging.
	    //	    alert('test');
	    fl=1;
	    if (link.clickurl && link.clickurl != link.href) link.href=link.clickurl;
	    href = link.href;
	    if (target && kg!='p' && (!kd || kd==1) && href.indexOf('/l/?')==-1 && href.indexOf('/k/?')==-1) href='/l/?uddg=' + encodeURIComponent(href);

	    // For debugging.
	    //alert(href);
	    //	    alert('test4');
	    //	    open_in_tab();
	    //	    console.log('test');
		
	    // Can't call async or messes up new tab approach.
	    if (target) {
		nug(href,target);
	    } else {
		nua('nug',href,'','','',target);
	    }
	}

	// For debugging.
	//alert('test');

    } else if (fl) {
	fl=0;

	//	alert('test');

    } else if (link.href && link.href == 'javascript:;') {

	// For debugging.
	//	alert('test');

	link.onclick();

    }
}


/*
  Function to actually go to a link.
  It is in its own function so it can
  happen asyncrhonously.

  target does new window
 */
function nug(link,target) {
    var iframe,content,doc,selection;

    // For debugging.
    //    alert('test');
    //    alert(link);

    fl=0;
    fn=0;

    // For debugging.
//    alert(link);
    //    alert(target);
//        return false;
//    console.log(window.getSelection());

    selection = '';
    if (window.getSelection) {
	selection = window.getSelection().toString();
    } else if (document.selection) {
	selection = document.selection.createRange();
	selection = selection.text;
    }
    {
	var is_match = selection == DDG.last_selection ? 1 : 0;
	DDG.last_selection = selection;

	if (!is_match) {
	    //alert('test1');
	    return false;
	}
    }

    //    return false;

    if (target) {

	// For debugging.
	//	alert('test5');
	    //	    alert(rand);
//	alert(link);
//	console.log(link);

	// old method.
	window.open(link);


	//	if (link.indexOf('/k/?')!=-1 || link.indexOf('/l/?')!=-1) {
	//	    link=decodeURIComponent(link.substring(6));
	//	}
	//	d.y.u.value=link;
	//	d.y.submit();

    } else {

	// For debugging.
	//	alert('test through');
	//	alert(w.postMessage);
	//	alert(link.indexOf('http')!=-1);
	//	alert((ie||ip||ir||is||im) && link.indexOf('http')!=-1)
	//	alert(kd);

	// Fix chrome history bug.
	if (ir && !irl) {
// 	    alert(window.history.length);
//	    window.history.go(window.location.href);
// 	    iframe = d.createElement("iframe");
//	    iframe.src=window.location.href;
//	    d.body.appendChild(iframe);
//	    return false;
	}

	//	alert('new test1');

	// For some reason newer safari is not storing the history here.
	// 20121127 (yegg & nil): iOS 6 finally made this break so added !ip.
	if (ih5 && !is && !ip && !is_konqueror && kg!='p' && (!kd || kd==1) ) {

	    // For debugging.
	    //	    alert('test through a');

	    iframe=document.getElementById('iframe_hidden');
	    iframe.contentWindow.postMessage( 'ddg:' + link, location.protocol+'//'+location.hostname );

	    // For debugging.
	    //	    alert(iframe);

	    //	    console.log('test');
	    //	    alert('test');

	} else if ((ie||ip||ir||is||im) && link.indexOf('http')!=-1 && kg!='p' && (!kd || kd==1) ) {

	    // For debugging.
	    //alert(link);
	    //	    alert('test through b');

	    //	    console.log('test2');
	    //	    alert('test2');

	    //	    link.replace("'",'\\\'');
	    //alert(link);

	    if (d.getElementById('iframe_hidden')) d.body.removeChild(d.getElementById('iframe_hidden'));
	    content = "<html><head><body><script language='JavaScript'>top.window.location=\""+link+"\";</script></body></html>";
	    iframe = d.createElement("iframe");
	    iframe.id='iframe_hidden';
	    d.body.appendChild(iframe);
	    doc = iframe.document;
	    if(iframe.contentDocument)
		doc = iframe.contentDocument; // For NS6
	    else if(iframe.contentWindow)
		doc = iframe.contentWindow.document; // For IE5.5 and IE6
	    doc.open();
	    doc.writeln(content);
	    doc.close();
	} else {

	    // For debugging.
	    //	    alert(link);
	    //	    alert('test through c');

	    w.location = link;
	}
    }
}


/*
Function to switch between vertical search types.
Use JS in case they change what is in the search box.
*/
function nrt(vertical) {
    var div = d.getElementById('search_elements_hidden');
    if (div) {
	div.innerHTML='<input type="hidden" name="v">';
	document.x.v.value = vertical;
	setTimeout('document.x.submit()',100);
    }
}


/*
  On mouseover for div, reset the class name to be highlighted.
  Also, if hidden, unhide.
 */
function nrv(div,no_highlight,initial_state,keyboard) {

    //    console.log('call nrv');

    if (!div) return false;
    var div2,link,re,y1,y2,divs,i,items,item,tmp;
    div2 = div;

    // For debugging.
    //    alert('test');
    //    alert(div.id+' '+no_highlight+' '+initial_state);
    //    console.log(div.id);
    //    console.log(div.id+' '+no_highlight+' '+initial_state);
//    console.log(div.id+' '+(parseInt(r1c)-1));
//    initial_state = 1;
//    no_highlight = 0;
//    console.log(div.id);

    // Unhide.
    div = div.parentNode;
    if (div && div.style) {

	// For debugging.
	//    alert('test');
	//	alert(div.id+' '+no_highlight+' '+initial_state);
	//	console.log(div.id+' '+no_highlight+' '+initial_state);


	while (YAHOO.util.Dom.getStyle(div, 'display')=='none') {

	    // For debugging.
//	    console.log(div.id);
	    //	    alert(div.id);

	    nsr(div.previousSibling.firstChild,div!=div2.parentNode ? 1 : 0,initial_state);
	    div = div.parentNode;
	}
    }

    // If last show next.
    if (div2.id=='r1-'+(parseInt(r1c)-1)) {

	// For debugging.
//	console.log('test');
	//	alert('test');

	// 2013.01.08 add new check for disabled auto-load.
	if (!il && nrb && (!kc || kc!='-1')) nrb('',1);
    }

    // Look for highlight div.
    //    console.log(div2.class);

    // Highlight.
    if (!no_highlight) {

	// For keyboard shortcuts that trigger a div with no highlight class,
	// but they have an internal div with one, like in the 0-click.
	if (div2.className && div2.className.indexOf('highlight')==-1 && div2.children.length) {
	    for (var i=0; i<div2.children.length; i++) {
		var tmp_child = div2.children[i];
		if (tmp_child && tmp_child.className && tmp_child.className.indexOf('highlight')!=-1) {
		    div2 = tmp_child;
		    break;
		}
	    }
	}

	// For debugging.
//	alert(YAHOO.util.Dom.hasClass(div2,'highlight'))
//	console.log(div2);

	if (!YAHOO.util.Dom.hasClass(div2,'highlight')) {

	    // For debugging.
//	    alert(div2.id + ' ' + div2.style.class + ' ' + YAHOO.util.Dom.hasClass(div2,'highlight'));

	    YAHOO.util.Dom.addClass(div2,'highlight');

	    if (YAHOO.util.Dom.hasClass(div2,'highlight_sponsored')) YAHOO.util.Dom.addClass(div2,'highlight_sponsored_hover');

	    // For debugging.
//	    console.log(div2.id);

	    link = nun(div2);

	    y1 = YAHOO.util.Dom.getY(div2);
	    y2 = YAHOO.util.Dom.getDocumentScrollTop();

	    // For debugging.
	    //	alert(y1 + ' ' + y2);
	    //	alert(rc.id);
	    //	console.log(div2.scrollHeight);
	    //	console.log(div2.parentNode.parentNode.scrollHeight);

	    if (keyboard && link && !fq && y1>y2) {

		// 2010.12.12 now that the image is linked we can focus on that without scrolling.
//		if (rc.id!='zerp_click_abstract') link.focus();
//		else if (div2.scrollHeight<div2.parentNode.parentNode.scrollHeight) link.focus();
		link.focus();
		link.onclick=function(e){return nrl(e,this)}

		// For debugging.
//		console.log(link);
//		alert(link.onclick);
	    }

	    // Look for hidden sections.
	    items = YAHOO.util.Dom.getElementsByClassName('hidden','a',div2);
	    for (item in items) {
		tmp = items[item];
		if (!tmp) continue;
		YAHOO.util.Dom.removeClass(tmp, 'hidden');
		YAHOO.util.Dom.addClass(tmp, 'hidden2');
		break;
	    }
	}
    }

    // Unhide internals.
    if (div2.childNodes[1] && div2.childNodes[1].childNodes[1] && div2.childNodes[1].childNodes[1].className == 'hidden') {
	div2.childNodes[1].childNodes[1].style.display='inline';
    }

}

// Get link given div.
function nun (div) {
    var link,link_num,class_name;

    link = '';

    link_num = 0;
    re = new RegExp('highlight_?[a-z]*?(\\d+)');

    if (re.test(YAHOO.util.Dom.get(div).className)) {
	link_num = DDG.get_link_num(RegExp.$1);
    }

//    alert(link_num);
//    console.log(YAHOO.util.Dom.get(div).className);
//    console.log(link_num);

    if (link_num=='-1') link = div.getElementsByTagName('a')[div.getElementsByTagName('a').length - 1];
    else link = div.getElementsByTagName('a')[link_num] || div.getElementsByTagName('a')[0];

//    alert(link);
//    console.log(link);

    return link;
}


/*
  On mouseout for div, reset the class name to unhighlighted.
 */
function nro(div,sx,sy) {
    var link,x1,x2,y1,y2,divs,i,items,item,tmp;

    // For debugging.
//    alert('test');
//    return false;

    if (!div) return false;

    // For keyboard shortcuts that trigger a div with no highlight class,
    // but they have an internal div with one, like in the 0-click.
    if (!YAHOO.util.Dom.hasClass(div,'highlight') && div.className && div.children.length) {
	for (var i=0; i<div.children.length; i++) {
	    var tmp_child = div.children[i];
	    if (YAHOO.util.Dom.hasClass(tmp_child,'highlight')) {
		div = tmp_child;
		break;
	    }
	}
    }

    if (YAHOO.util.Dom.hasClass(div,'highlight')) {

	if (sx && sy) {
	    x1 = YAHOO.util.Dom.getX(div);
	    x2 = x1+div.scrollWidth;
	    y1 = YAHOO.util.Dom.getY(div);
	    y2 = y1+div.scrollHeight;

	    // For debugging.
//	    alert((sx>x1) + ' ' + (sx<x2) + ' ' + (sy>y1) + ' ' + (sy<y2) + ' ' + sx + ' ' + sy);

	    if (sx>x1 && sx<x2 && sy>y1 && sy<y2) {

		// For debugging.
//		alert('catch');

		return false;
	    }

	}

	// For debugging.
//	alert('test');

	YAHOO.util.Dom.removeClass(div,'highlight');
	if (YAHOO.util.Dom.hasClass(div,'highlight_sponsored_hover')) YAHOO.util.Dom.removeClass(div,'highlight_sponsored_hover');

	// Look for hidden sections.
	items = YAHOO.util.Dom.getElementsByClassName('hidden2','a',div);
	for (item in items) {
	    tmp = items[item];
	    if (!tmp) continue;
	    YAHOO.util.Dom.removeClass(tmp, 'hidden2');
	    YAHOO.util.Dom.addClass(tmp, 'hidden');
	    break;
	}

	link = nun(div);

    // For debugging.
//    alert(typeof(link));
//    alert(link.tagName());

	// Need fq check for firefox2
	if (link && !fq) link.blur();

    // For debugging.
//    d.body.focus();
    //    alert('test');
//    console.log(nun(div));

    }
}


/* Populates results from query builder */
function nrq(items) {
    var i,item,divo,divw,div2,div3,div4,link,synonym,replacement,count;

    nuv();

    if (!items || !items.length) return false;

    // For debugging.
//    console.log(items);
//    console.log(d.referrer);
//    console.log(viewport_height);
//    console.log(YAHOO.util.Dom.getStyle('side', 'display'));

    div = d.getElementById('side_suggestions');
    divw = d.getElementById('side_wrapper');

//    console.log(YAHOO.util.Dom.getY(div));
//    console.log(viewport_height);

    if (div && YAHOO.util.Dom.getStyle(divw, 'display')=='block' && (YAHOO.util.Dom.getY(divw)+divw.scrollHeight+250<viewport_height)) {
	div2 = d.createElement('div');
	div2.innerHTML += '<div class="spacer_bottom_7">' + l('Search suggestions') + ':</div>';
	divo = div2;
	//	nutp('d1-si');

	count=0;
	for (i=0;i<items.length;i++) {
	    item = items[i];

	    synonym = item['s'] || '';
            replacement = item['r'] || '';

	    // For debugging.
	    //	console.log(item);

	    if (d.referrer.match(synonym)) continue;

	    count++;

	    div3 = d.createElement('div');
	    div3.onclick = function () {nrqc(this.firstChild);};
	    link = d.createElement('a');
	    if (replacement) link.innerHTML = ' ' + replacement + ' -> ';
//	    else link.innerHTML = '<b>+</b>';
	    link.innerHTML += synonym;
	    link.nrqs = synonym;
	    link.nrqr = replacement;
	    link.href = 'javascript:;'
		//	    link.onclick = function () {nrqc(this);};
	    YAHOO.util.Dom.addClass(div3,'search_suggestion');
	    div3.appendChild(link);
	    div2.appendChild(div3);
	    if (count==1) YAHOO.util.Dom.setStyle(div3,'margin-top','2px');

	    // 2011.07.08 cutting off to avoid scroll issues and clutter.
	    // making default 7
	    if (count==7) break;
	    if (count==8 && items.length>10) {
		div4 = d.createElement('div');
		div2.appendChild(div4);
		YAHOO.util.Dom.setStyle(div4,'display','none');
		link = d.createElement('a');
		link.innerHTML = l('More') + '...';
		link.onclick = function () {nsh('cpq');}
		link.href = 'javascript:;';
		link.id = 'cpq';
		div4.id = 'cpqh';
		div.insertBefore(link,div.firstChild);
		div.insertBefore(div2,div.firstChild);
		div2 = div4;
	    }
	}

	if (count>=8 && items.length>10) div.insertBefore(div4,div.firstChild.nextSibling);
        else div.insertBefore(div2,div.firstChild);

	YAHOO.util.Dom.setStyle(div,'padding-top','10px');
	YAHOO.util.Dom.setStyle(div,'padding-bottom','15px');
	YAHOO.util.Dom.setStyle(div,'display','block');

//	console.log(div);
//	divo.innerHTML += '<br><br>';
    }
}

/* onclick handler for nrq links */
function nrqc (link) {

    if (link.nrqr) {
	d.x.q.value = d.x.q.value.replace(new RegExp(link.nrqr,'i'),link.nrqs);
    } else if (link.nrqs.indexOf(' ')!=-1) {
	d.x.q.value += ' "' + link.nrqs + '"';
    } else {
	d.x.q.value += ' ' + link.nrqs;
    }
    nutp('b1');
    setTimeout('document.x.submit()',100);
}


/*
  Moves the highligted result depending on given action.
  If a particular id is passed, it uses that as a base
  instead of the current result.
*/
function nrm(action,use_id) {
    var re,re2,re3,col,num,num2,tmp,id,trc,urc,is_more,x,y,object_top,scroll_top;

    if (fq) return false;

    // For debugging.
//    console.log(fo);
//    return false;
//    console.log(action + ' ' + use_id);

    if (fo) {
	setTimeout("nrm("+action+",'"+use_id+"')",100);
	return false;
    }
    fo=1;

    // For debugging.
//    alert(action);
//    console.log(action + ' ' + use_id);

    nuv();

    // Regex to detect column and link num.
    re = new RegExp('r(\\d+)-(\\d+)');
    re2 = new RegExp('rl([ei])(\\d+)-(\\d+)');
    re3 = new RegExp('rld-(\\d+)');


    // For debugging.
    //    alert(rc.id);
    //    if (action=='6') alert(use_id);
    //    alert(action + ' ' + rc);
    //    alert(viewport_height);

    // If an id to use, use it.
    if (use_id) {

	// If it is valid.
	if (re.test(use_id)) {
	    col = RegExp.$1 || 0;
	    num = RegExp.$2 || 0;

	// Valid abstract
	} else if (use_id=='zero_click_abstract' || use_id=='did_you_mean') {
	    col = 1;
	    num = -1;

	/* Otherwise, bail.
	   This can happen if the page
	   was in no initial state.
	*/
	} else {
	    fo=0;
	    return false;
	}

    // Abstract catch.
    } else if (rc && rc.id == 'zero_click_abstract') {
	col = 1;
	num = -1;

    // Abstract catch.
    } else if (rc && rc.id == 'did_you_mean') {
	col = 1;
	num = -1;

    // Grab info from current result.
    } else if (rc && re.test(rc.id)) {
	col = RegExp.$1 || 0;
	num = RegExp.$2 || 0;

    // Grab info from current result.
    } else if (rc && re2.test(rc.id)) {
	col = rs ? 1 : 2;
	is_more = 1;

    // Grab info from current result.
    } else if (rc && re3.test(rc.id)) {
	col = 1;
	is_more = 1;

    // Otherwise hit first result.
    } else {
	rc = d.getElementById(DDG.first_result);
	if (!rc) rc = d.getElementById('zero_click_abstract');
	if (!rc) rc = d.getElementById('did_you_mean');

	//	console.log(rc.id);

	if (!rc) {
	    fo=0;
	    return false;
	} else {
	    num = 0;
	    col = 1;
	}
    }

    // For debugging.
//    fo=0;

    switch(action) {
    case 1: // Down one.

	// For debugging.
	//	alert(rc.id);
	//	alert(YAHOO.util.Dom.hasClass(rc,'highlight'));

	if (rc && rc.id && rc.id==DDG.first_result && !YAHOO.util.Dom.hasClass(rc,'highlight')) {
	    ;
	} else {
	    num++;
	}
	break;
    case 2: // Up one.
	num--;
	break;
    case 3: // Right top.
	col++;
	num=0;
	break;
    case 4: // Left top.
	col--;
	num=0;
	break;
    case 5: // Stay current.
	break;
    case 6: // Stay current and force high focus.
	break;
    case 7: // Down one (no focus).
	num++;
	break;
    default:
	num++;
    }

    // Construct new id.
    id = 'r'+col+'-'+num;

    // For debugging.
//    if (action==5) console.log(id);
//    console.log(r2c);
//    console.log(d.getElementById('zero_click_abstract'));

    // Special case for abstract.
    if (num<=-1) {
	if (d.getElementById('did_you_mean')) id='did_you_mean';
	else id='zero_click_abstract';
    }

    // For debugging.
//    console.log(action + ' ' + use_id);
//    console.log(id);


    // Temp new result.
    trc = d.getElementById(id);
    urc = 0;
    if (use_id) urc = d.getElementById(use_id);

    // Move from related to real.
    if (action==1 && col==2 && !trc && r1c) {
	id=DDG.first_result;
	trc = d.getElementById(id);
    }

    // For debugging.
    //    alert(action);
//    console.log(id);
//    fo=0;

    // Down arrow, check for off-screen.
    if (action==1) {
	scroll_top = YAHOO.util.Dom.getDocumentScrollTop();
	object_top = YAHOO.util.Dom.getY(id);
	if (object_top && (object_top<scroll_top || object_top>scroll_top+viewport_height)) {

	    num2=0; // Start at top

	    // For debugging.
///	    console.log(fo + ' ' + num2);
//	    fo=0;
//	    console.log(id + ' ' + object_top + ' ' + scroll_top + ' ' + viewport_height);
//	    console.log(num);

	    while (num2>-1) {
		tmp=d.getElementById('r1-'+num2);
		if (!tmp) break;

		object_top = YAHOO.util.Dom.getY(tmp.id);

		// For debugging.
//		console.log(num2+' '+object_top+' '+scroll_top);
		//	    alert(viewport_height);
//		console.log(num2);

		if (object_top-90<scroll_top) {
		    num2++;
		} else {
		    trc=tmp;
		    break;
		}
	    }
	}
    }

    // For debugging.
    //    alert(action + ' ' + id);
//    fo=0;
//    console.log(action + ' ' + id);

    // Up arrow, check for off-screen.
    if (action==2) {
	scroll_top = YAHOO.util.Dom.getDocumentScrollTop();
	object_top = YAHOO.util.Dom.getY(id);
	if (object_top<scroll_top || object_top>scroll_top+viewport_height) {

	    num2=r1c-2;

	    // For debugging.
//	    console.log(num2);

	    while (num2>0) {
		tmp=d.getElementById('r1-'+num2);
		object_top = YAHOO.util.Dom.getY(tmp.id);

		if (!tmp) break;

		// For debugging.
		//	alert(object_top+' '+scroll_top);
		//	    alert(viewport_height);

		if (object_top+90>scroll_top+viewport_height) {
		    num2--;
		} else {
		    trc=tmp;
		    break;
		}
	    }
	}
    }


//    console.log(action+' '+id);
//    return false;

    // Last result is before a more link.
    if (urc && !trc && action==7 && urc.nextSibling && urc.nextSibling.firstChild) {

	// For debugging.
	//	alert('test1');
//	console.log('test1');
//	return;

	if (urc.nextSibling.firstChild.onclick) urc.nextSibling.firstChild.onclick();
	fo=0;
	return;

    // Next result is a more link.
    } else if (!urc && !trc && action==7 && rc && rc.nextSibling && rc.nextSibling.firstChild) {

	// For debugging.
	//	alert('test2');
//	console.log('test2');
//	return;

	if (rc.nextSibling.firstChild.onclick) rc.nextSibling.firstChild.onclick();
	fo=0;
	return;
    }

    if ((id=='zero_click_abstract'||id=='did_you_mean') && YAHOO.util.Dom.getStyle(trc, 'display')=='none'){

	if (id=='zero_click_abstract' && r2c) trc=d.getElementById('r2-0');
	else {
	    fo=0;
	    return;
	}
    }

    //    console.log(trc);
    //    console.log(is_more);

    if (is_more) {
	switch(action) {
	case 1:
 	  if (col==2) {

	      //	      console.log(rc);

	      // Next more header.
	      trc = rc.nextSibling.nextSibling;

	      //	      console.log('TEST: ' + trc);
	      //	      console.log(trc);

		// Last section to to main results.
		if (!trc) {
		    id=DDG.first_result;
		    trc = d.getElementById(id);

		// An already open section.
		} else if (YAHOO.util.Dom.getStyle(trc, 'display')=='none') {
		    trc = trc.nextSibling.firstChild;

		    //		    console.log(trc);

		    // Skip through header (except for Misc sections).
		    if (!trc.id && trc.nextSibling) {
			trc = trc.nextSibling;
		    }
		}


	      //	      console.log(trc);
	    }
	    else if (col==1 && rc.nextSibling.nextSibling) trc = rc.nextSibling.nextSibling.nextSibling;
	    else if (1) {
		id=DDG.first_result;
		trc = d.getElementById(id);
	    }
	    else trc=rc.nextSibling.firstChild;

	//	console.log(trc);

	    break;
	case 2:
	    trc = rc.previousSibling.previousSibling;

	//	console.log(trc);

 	    // An already open section.
	    if (YAHOO.util.Dom.getStyle(trc, 'display')=='none') {
		trc = trc.nextSibling.lastChild;
	    }
	    break;
	case 4:
	    break;
	case 7:
	    if (rc.nextSibling.nextSibling) trc = rc.nextSibling.nextSibling.nextSibling;
	    else trc=rc.nextSibling.firstChild;
	    break;
	default:
	    fo=0;
	    return false;
	}
    }

    // For debugging.
//    return false;
//    console.log(action);
//    console.log(trc);
//    console.log(trc.id);

    // For debugging.
    //    console.log(trc);
//    console.log(col);

    if (trc) {

	// For debugging.
	//	alert(trc.id);

	// If still on a more links link, go to next result.
	if (col==1 && re2.test(trc.id)) trc=trc.nextSibling.firstChild;

	// For debugging.
	//	alert(rc.id);
	//	console.log(rc.id);

	// Unhighlight current result if it exists.
	if (action!=7) if (rc) nua('nro',rc);

	// For debugging.
//	return false;

//	console.log(trc);
//	console.log(trc.parentNode);

	/*
	  If the new result is hidden, and there
	  are visible sections below, e.g. news
	  below related topics, than move up to the
	  more part but do not actually expand it.
	 */
	if (action!=5 && (col==2 || rs) && YAHOO.util.Dom.getStyle(trc.parentNode, 'display')=='none') {

	    //	    console.log(trc);
	    //	    console.log(trc.parentNode);
	    //	    console.log(YAHOO.util.Dom.getStyle(trc.parentNode, 'display'));

	    x=trc;

	    // Move up to the top level.
	    while (x.parentNode.id!='zero_click_topics' && x.parentNode.id!='links' && x.parentNode.id!='content') {
		x=x.parentNode;
		if (!y && YAHOO.util.Dom.getStyle(x, 'display')=='block') {
		    y=x;
		}
	    }

	    //	    	    console.log(y);
	    // console.log(is_more);
	    //	    	    console.log(x.nextSibling);
	    //	    console.log(x.innerHTML);
	    //	    console.log(x);
	    //	    console.log(x.nextSibling);
	    //	    console.log(x);

	    if (y && is_more) {
		trc = x.nextSibling.nextSibling;

		//		console.log(trc);

	    // Move down to a closed disambiguations section.
	    } else if (YAHOO.util.Dom.getStyle(x, 'display')=='none') {
		trc = x.previousSibling;

		//		console.log(trc.innerHTML);
		//		console.log(trc);

	    } else if (x.nextSibling && YAHOO.util.Dom.getStyle(x.nextSibling, 'display')=='block') {
		trc = y.lastChild.previousSibling;

		//		console.log(trc);

	    // Move up from open to closed disambiguation section.
	    } else if (action==2 && x.previousSibling) {
		trc = x.previousSibling;

		//		console.log(trc);

	    // Move down through open disambiguation section.
	    } else if (action==1 && x.nextSibling && YAHOO.util.Dom.getStyle(x.nextSibling, 'display')=='none') {
		//		console.log('NEXT SIB:' + x.nextSibling.innerHTML);

		trc = x.nextSibling.nextSibling.firstChild.nextSibling;

		//		    console.log(trc);

	    // Move down to last disambiguation section.
	    } else if (action==1 && !x.nextSibling) {
		trc = x.previousSibling;

		//		console.log(trc);
	    }

	    //	    console.log(trc);

	    // Pass through (hidden) more links section.
	    if (re2.test(trc.id) && rs && RegExp.$1=='e') trc=trc.nextSibling.firstChild;

	}

	// For debugging.
//	return false;
//	console.log(action);
//	console.log(trc.id);

	// Highlight new result.
	nua('nrv',trc,0,1,0, action==7 ? 1 : 0, (action==5 || action==7) ? 1 : 0,1);

	// Mark new result as current.
	if (action!=7) rc = trc;

	// Scroll to the new result if needed.
	//	if (action=='6') nua('nrs',rc,0,1,0,1,1);
	//	else nua('nrs',rc,0,1);
	if (action!=7 && rc && rc.id && rc.id!=DDG.first_result) {

	    // For debugging.
	    //	    if (action==5) alert('test');
	    //alert(action);

	    if (fk && (num>6 || action==2)) {
		if (!io) nua('nrs',rc,0,1,0,1,action==5?0:(action==1?1:-1));
		else nrs(rc,1,action==5?0:(action==1?1:-1));
	    } else {
		if (!io) nua('nrs',rc,0,1);
		else nrs(rc,0,0);
	    }
	}

    } else if (col==1 && id!='zero_click_abstract' && id!='did_you_mean' && !ieof && (!rs || !it) && ++ci<20) {

	// For debugging.
//	alert('test');
//	console.log(action + ' ' + rs + ' ' + it);
//	return false;
//	console.log('skip to ' + parseInt(r1c-1));
      	//if (action==5) alert(parseInt(r1c-1));
	//	if (action==5) console.log(parseInt(r1c-1));
	//	alert(action);
	//	console.log(r1c);

	// Highlight the last result available,
	// which will pull the next set.
	nrv(d.getElementById("r1-"+parseInt(r1c-1)),1);

	// Try again in a bit.
	// needed to highlight last result, i.e. action==5
	setTimeout("nrm("+action+",'"+use_id+"')",100);
    }

    // Opera auto-load replicator.
    if (io && action==1 && nrb) nrb();

    // For debugging.
//    console.log('test');

    fo=0;
}

// Scroll to object if off-screen.
function nrs(object,force,high) {
    var object_top,scroll_top,object_height,new_top,pos;

    // For debugging.
    //    alert(object.id);
    //    alert(high);

    object_top = YAHOO.util.Dom.getY(object);
    object_height = object.scrollHeight;
    scroll_top = YAHOO.util.Dom.getDocumentScrollTop();
    nuv();
    pos = viewport_height/2;

    // For debugging.
    //    alert(object.id+' '+object_height+' '+object_top+' '+scroll_top);

    if (!object_height || object_top==scroll_top) return;

    if (force || ((object_top+object_height+10)>(viewport_height+scroll_top)) || ((object_top-10)<scroll_top)) {

	// For debugging.
	//alert(object.id+' '+object_height+' '+object_top+' '+scroll_top);
	//	alert(high);

	//	if (high) new_top=object_top-viewport_height/5;
	//	else new_top=object_top-viewport_height/2;

	new_top=object_top-pos;

	// For debugging.
	//	alert(object_top + ' ' + (object_top-scroll_top));

	if (!high || (high==1 && (object_top-scroll_top)>pos) || (high==-1 && (object_top-scroll_top)<pos) ) {

	    // For debugging.
	    //	    alert('test2');

	    w.scroll(0,new_top);
	}
    }

}

// Keyboard i.
function nki(event) {
    if (fq) return false;
    if (event && (nkdc(event) || nkdm(event) || nkds(event) || nkdt(event) || fa)) return false;
    fk=1;

    // Move to images.
    if (rii) nrm(5,rii);
}


// Keyboard r.
function nkr(event) {
    if (fq) return false;
    if (event && (nkdc(event) || nkdm(event) || nkds(event) || nkdt(event) || fa)) return false;
    fk=1;

    // Move to related topics.
    if (rir) nrm(5,rir);
}

// Keyboard down arrow.
function nkda(event) {
    if (fq) return false;
    if (event && (nkdc(event) || nkdm(event) || nkds(event) || nkdt(event) || fa)) return false;
    fk=1;

    // Move result down.
    nrm(1);
}

// Keyboard up arrow.
function nkua(event) {
    if (fq) return false;
    if (event && (nkdc(event) || nkdm(event) || nkds(event) || nkdt(event) || fa)) return false;
    fk=1;

    // For debugging.
    //    alert('test');

    // Move result down.
    nrm(2);
}

// Keyboard enter.
function nke(event) {

    // For debugging.
//    console.log('test');

    if (fq) {

	if (YAHOO.util.Dom.getStyle('bang', 'display')=='block') {
	    nbb(d.getElementById('bang'));
	}

	// For debugging.
//	for (k in event) {
//	    console.log(event[k]);
//	}

	return false;
    }

    // For debugging.
//    console.log('test');
//    if (rc && rc.id && rc.id=='zero_click_abstract') {
//	alert('test');
//    }

    if (event && (nkdc(event) || nkdm(event) || nkds(event) || nkdt(event) || fa)) return false;
    fk=1;

    /* If the query has focus, do nothing,
       since enter should submit that form.

       Otherwise, if a current result, click it.
    */

    // For debugging.
//        alert(rc.onclick);
//    alert(rc.id);
//    console.log('test');
//    console.log(rc.id);
//    console.log(kn);
//    for (x in event) {
//	console.log(event[x]);
//    }

    if (rc && (!kn || kn!='1')) {

	// For debugging.
	//	console.log(rc.id);
	//	console.log(rc.onclick);
	//	console.log(rc.firstChild.onclick);

	var re = new RegExp('rl([ei])(\\d+)-(\\d+)');
	var re2 = new RegExp('^r2-(\\d+)$');

	// Keyboard shortcut for opening a disambiguation section.
	if (rc.id && re.test(rc.id)) {

	    // Misc. section.
	    if (re2.test(rc.nextSibling.firstChild.id)) {
		rc = rc.nextSibling.firstChild;

            // Sections with headers.
	    } else {
		rc = rc.nextSibling.firstChild.nextSibling;
	    }

	    nrv(rc);

	    //	    console.log(rc);

	} else {
	    rc.onclick();
	}
    }
}

// Keyboard o -- mimics, enter but without new window hook.
function nko(event) {
    if (fq) return false;
    if (event && (nkdc(event) || nkdm(event) || nkds(event) || nkdt(event) || fa)) return false;
    fk=1;
    if (rc) rc.onclick();
}

// Keyboard t -- go to top
function nkt(event) {
    if (fq) return false;
    if (event && (nkdc(event) || nkdm(event) || nkds(event) || nkdt(event) || fa)) return false;
    fk=1;
    nuo();
}

// Keyboard d -- site search
function nkd(event) {
    if (fq) return false;
    if (event && (nkdc(event) || nkdm(event) || nkds(event) || nkdt(event) || fa)) return false;
    fk=1;
    nrg(rc,'-1');
}

// Keyboard new window.
function nkn(event) {
    if (fq) return false;
    if (event && (nkdc(event) || nkdm(event) || nkds(event) || nkdt(event) || fa)) return false;
    fk=1;

    // New window.
    fn=1;

    if (rc) rc.onclick();
}



// Keyboard main results.
function nkm(event) {
    if (fq) return false;
    if (event && (nkdc(event) || nkdm(event) || nkds(event) || nkdt(event) || fa)) return false;
    fk=1;

//    nua('nug','/goodies.html','','','');
    // Move to related topics.
    if (d.getElementById(DDG.first_result)) nrm(5,DDG.first_result);
}



// Keyboard escape.
function nkes(event) {
    if (event && (nkdc(event) || nkdm(event) || nkds(event) || nkdt(event) || fa)) return false;
    if (fq) {
	fq=0;
	d.x.q.blur();	
	if (rc && rc.id) nrm(5,rc.id);	
    }
	DDG.toggleall('grp_modal','-1');	
}

// Keyboard exclamation point.
function nkex(event) {
    if (fq) return false;
    if (event && (nkdc(event) || nkdm(event) || nkdt(event) || fa)) return false;
    fk=1;
    nbc();
}

// Keyboard sbacebar.
function nksb(event) {

    if (fq) return false;
    if (event && (nkdc(event) || nkdm(event) || nkds(event) || nkdt(event) || fa)) return false;

    fk=1;

    if (!il && nrb) nrb();

}


// Keyboard s for spelling.
function nksp(event) {
    var div;
    if (fq) return false;
    if (event && (nkdc(event) || nkdm(event) || nkds(event) || nkdt(event) || fa)) return false;

    fk=1;

    if (YAHOO.util.Dom.getStyle('did_you_means', 'display')=='block') nrm(5,'did_you_mean');
}


// Keyboard slash.
function nks(event) {
    if (fq) return false;

    // Allow nktd for intl keyboards.
    if (event && (nkdc(event) || nkdm(event) || nkds(event) || fa)) return false;

    fk=1;

    // Set focus to query.
    setTimeout('d.x.q.focus()',10);
    setTimeout('d.x.q.select()',15);

    // Scroll to top.
    if (ko && ko=='s') setTimeout('w.scrollTo(0,0)',10);
}


// History state change.
function nhs (state) {

    // For debugging.
//    alert(state);
//    console.log(state);

    // Highlight last result.
    nrm(5,state);
}

// History register.
function nhr (state) {
    d.getElementById('state_hidden').value=state;
    //    d.getElementById("sx").value=state;

    // For debugging.
    //    alert('test');
    //alert(d.getElementById('state_hidden').value);
}

// Function to make misspellings.
function nrp (misspelling,misspellingb) {
    var container,div,match;

    if (!misspelling) return false;

    var zero_click_abstract = d.getElementById('zero_click_abstract');
    var did_you_means = d.getElementById('did_you_means');


    if (!d.getElementById('special_page_header') && (!zero_click_abstract || YAHOO.util.Dom.getStyle('zero_click_abstract', 'display')=='none') && YAHOO.util.Dom.getStyle('did_you_means', 'display')=='none') {

	// For debugging.
	//	console.log('test');
	//	console.log(misspelling.replace(/%20/i,'+'));
	//	console.log(decodeURIComponent(d.referrer));
	//	console.log(d.referrer.match(misspelling.replace(/%20/i,'+')));

	// Stops loops.
	match = misspelling.replace(/%20/i,'+');

	// For debugging.
	// console.log(d.referrer);
	// console.log(match);
	// console.log(d.referrer.match(match));
	// console.log(d.referrer.indexOf(match));

	// 2013.04.04 -- if 'duckduck' is in the suggestion, don't return false here.
	// bing got their shit together and they don't mess up 'duckduck' stuff anymore.
	if (d.referrer.indexOf(match)!=-1 && match.indexOf('duckduck')==-1) return false;

	var div = d.createElement('div');
	div.id = 'did_you_mean';
	div.innerHTML='<b>Did you mean </b>';
	link = d.createElement('a');
	link.innerHTML=decodeURIComponent(misspellingb);
	link.href='/?q='+misspelling+(rv ? '&v='+rv : '')+(kurl ? kurl : '');

	// For debugging.
//	console.log(link.getAttribute("href"));
	// 2011.07.21 commenting out because turns a relative link into a full one.
//	if (kurl) link.href+=kurl

	// For debugging.
//	console.log(link.getAttribute("href"));

	link.onclick=function() {fl=1;};
	div.appendChild(link);
	div.appendChild(d.createTextNode('?'));
	YAHOO.util.Dom.addClass(div,'highlight_s1');

	// For debugging.
//	link.href='test';
//	console.log(kurl);
//	console.log(link.href);
//	console.log(link.getAttribute("href"));

	container = did_you_means;
	container.insertBefore(div,container.firstChild);

	YAHOO.util.Dom.setStyle(did_you_means,'display','block');

	if (d.getElementById('zero_click_answer')) YAHOO.util.Dom.setStyle(did_you_means,'padding-bottom','20px');

	if (nir) nir('s');
    }
}

// Function to make new abstract.
// For cases of external API renderings.
// DO NOT CHANGE FUNCTION NAME
function nra2(heading,id) {

    var div,div2;

    // For debugging.
    //    alert(id);

    div = d.getElementById(id);
    nuv();

    // For debugging.
    //    alert(div);
    //    alert('test');

    if (div) {

	if (heading) {
	    div2 = d.getElementById('zero_click_header');
	    if (div2) {
		div2.innerHTML=heading;
		YAHOO.util.Dom.setStyle(div2,'display','block');
		div3 = d.getElementById('zero_click_plus_wrapper');	
		div2.appendChild(div3.parentNode.removeChild(div3));
		YAHOO.util.Dom.addClass(div3,'icon_zero_click_header');
	    }
	}

	div2 = d.getElementById('zero_click_abstract');
	div2.appendChild(div);
	if (div2) YAHOO.util.Dom.setStyle(div2,'display','block');

	div2 = d.getElementById('zero_click_wrapper');
	if (div2) YAHOO.util.Dom.setStyle(div2,'display','block');
	if (div2) YAHOO.util.Dom.setStyle(div2,'visibility','visible');

	if (viewport_width>900) {
	    if (ie6) YAHOO.util.Dom.setStyle(div2,'padding-top','25px');

	} else if (viewport_width<900) {
	    if (ie6) YAHOO.util.Dom.setStyle(div2,'padding-top','45px');
	}
    }
}

// Function to make new abstract.
/*
h - header
a - snippet


CASES:
Simple answer: https://yegg.duckduckgo.com/?q=random+word
Answer with image: http://yegg.duckduckgo.com/?q=war+on+the+middle+class+book
Answer with image and header: http://yegg.duckduckgo.com/?q=%40yegg
WolframAlpha simple answer: http://yegg.duckduckgo.com/?q=time+in+london
- WolframAlpha large image: http://yegg.duckduckgo.com/?q=msft+vs+aapl+5yr
Stacked: http://yegg.duckduckgo.com/?q=oyster%20house
Inline: http://yegg.duckduckgo.com/The_Big_Bang_Theory
Floating array: http://yegg.duckduckgo.com/?q=recipes+slow+cooker
Long header with time: http://yegg.duckduckgo.com/?q=news+test
Multiple results: http://yegg.duckduckgo.com/?q=nginx+apache
Long header: http://yegg.duckduckgo.com/?q=snow+albedo
Floating right: http://yegg.duckduckgo.com/?q=phillies
*/
function nra(items,favicon_placement,is_internal_highlight) {
    var div,div2,div3,link,link2,links,i,j,span,hr,resize,item_count,count,item,re,domain,force_url,img,favicon,date,tmp,time,first_item;
    var is_stacked,is_header,is_time;

    //    console.log('test');

    // Get updated browser dimensions.
    nuv();

    // For debugging.
        // console.log('NRA:');
        // console.log(items);
        // console.log(rt);
        // console.log(nux());
        // console.log(items.length);

    if (!items) return;
    count = items.length;
    if (!count) return;
    first_item = items[0];

    //    console.log(items);
    //    console.log(rt);

    // Look for a force of the small version, e.g. yelp for http://yegg.duckduckgo.com/?q=oyster%20house
    // This is where it is bolted on an existing 0-click.
    is_stacked = 0;
    if ((rt==='D') || (nux() && first_item['is_top'])) is_stacked = 1;

    // console.log(is_stacked);

    // Abort if something is already displayed.
    if (nux() && (rt!=='D') && !is_stacked) return false;

    //console.log(is_stacked);
    //    console.log(nux());

    // Abort if stacking and we already have a stack.
    if (is_stacked && d.getElementById('zero_click_abstract_stacked') && YAHOO.util.Dom.getStyle(d.getElementById('zero_click_abstract_stacked'),"display")=='block') return false;

    // For showing the favicon after.
    favicon = '';

    /* To display time.
     */
    is_time = 0;
    if (DDG.spice_force_time[first_item['s']] || first_item['time']) is_time = 1;

    //    alert(DDG.get_query());

    /* Header types 
       0 - no header
       1 - inline header
       2 - big header
     */
    is_header = 0;
    if (first_item['h'] && !is_stacked && !DDG.spice_force_no_header[first_item['s']]) {
	if (!is_time && (DDG.spice_force_big_header[first_item['s']] || first_item['force_big_header'])) is_header = 2;
	else is_header = 1;
    }

    /* Favicon placements 
       0 - beg
       1 - after with spacing
       2 - after on next line
       3 - after on next line with clear div 
       4 - after inline
     */
    if (!favicon_placement) {
	if (is_header==2 || is_stacked) favicon_placement = 4;
    }


    item_count=0;
    for (item in items) {
	if (!items[item]) continue;
	if (is_stacked && item > 0) break;
	obj = items[item];

	// Get time for display.
	if (is_time) {
	    span = d.createElement('span');
	    YAHOO.util.Dom.setStyle(span,'color','#777');
	    YAHOO.util.Dom.setStyle(span,'font-size','11px');
	    date = new Date();
	    if (obj['time']) span.innerHTML = ' - ' + obj['time'];
	    else span.innerHTML = ' at ' + date.toString();
	    time = span;
	}

	// getfavicon needs www.
	re = new RegExp('^.*?\/\/([^\/\?\:\#]+)');
	if (re.test(obj['u'])) {
	    domain = RegExp.$1;
	}

    if (DDG.spice_force_favicon_domain[first_item['s']]) {
        domain = DDG.spice_force_favicon_domain[first_item['s']];
    }
    else if (DDG.spice_force_favicon_url[first_item['s']]) {
	force_url = DDG.spice_force_favicon_url[first_item['s']];
    }

	// For debugging.
//	console.log(obj['a']);
//	console.log(obj['i']);


	// If an abstract exists (threshold for showing).
	if (obj['a']) {
	    item_count++;

	    // For debugging.
//	    console.log(items);

	    // Main item.
	    if (item_count==1) {

		// Image set up -- not for a stacked 0-click, which shouldn't compete with existing image.
		if (obj['i'] && !is_stacked) {
		    
		    div2 = d.getElementById('zero_click_plus_wrapper');
		    div = d.getElementById('zero_click_image');
		    
		    // For debugging.
		    //	    console.log(div);

		    if (div2 && !div) {
			div3 = d.createElement('div');
			div3.id = 'zero_click_image';
			div2.parentNode.insertBefore(div3,div2.nextSibling);
			div = div3;
		    }
		    
		    if (div && obj['i']) {
			if (obj['i'].indexOf('http')==0) {
			    obj['i'] = "<img src='/iu/?u=" + encodeURIComponent(obj['i']) + "'>";
			}
			div.innerHTML=obj['i'];
			YAHOO.util.Dom.setStyle(div,'display','block');
			YAHOO.util.Dom.setStyle(div,'margin-top','2px');
			YAHOO.util.Dom.setStyle(div,'padding-bottom','2px');

			// console.log(obj['w']);
			
			// Explicit width.
			if (obj['w']) {
			    YAHOO.util.Dom.setStyle(div,'width',obj['w']+'px');
			    if (obj['w']>100) {
				YAHOO.util.Dom.setStyle(div,'max-width',obj['w']+'px');
				YAHOO.util.Dom.setStyle(div.first_child,'max-width',obj['w']+'px');
			    }

			// Forces 100px.
			} else {
			    YAHOO.util.Dom.addClass(div.firstChild,'img_zero_click');
			}
		    }

		    // So highlight doesn't overlap image.		    
			if (viewport_width>728) {
			tmp = YAHOO.util.Dom.getX('zero_click_image')-YAHOO.util.Dom.getX('zero_click_wrapper')-50;

				if (isNaN && !isNaN(tmp)) {
					YAHOO.util.Dom.setStyle('zero_click_abstract','max-width',tmp+'px');
				}
		    }
			else YAHOO.util.Dom.setStyle('zero_click_abstract','max-width','100%');
		}


		div = is_stacked ? d.getElementById('zero_click_abstract_stacked') : d.getElementById('zero_click_abstract');

		if ((domain || force_url) && !DDG.spice_force_no_icon[first_item['s']] && !first_item['force_no_icon']) {

		    img = d.createElement('img');
		    if (img) {
			if (force_url) {
			    img.src = '/iu/?u=' + force_url;
			}
			else {
			    img.src = ga+domain+'.ico';
			}

			link = d.createElement('a');
			link.href=obj['u'];
//			if (link.href.indexOf('?')!=-1) link.href=obj['u']+rq;
			link.onclick=function() {fl=1;};
			if (kn && kn=='1') link.target='_blank';

			if (favicon_placement==4) YAHOO.util.Dom.addClass(img,'icon_spice_inline');
			else YAHOO.util.Dom.addClass(img,'icon_spice');

			link.appendChild(img);

//			div.parentNode.insertBefore(link,div);
			if (favicon_placement) { 
			    favicon = link;
			} else {
			    div.appendChild(link)
			}

			YAHOO.util.Dom.addClass(div,'zero_click_snippet');
			YAHOO.util.Dom.setStyle(div,'margin-right','50px');

			if (!is_internal_highlight) {
			    if (favicon_placement) YAHOO.util.Dom.addClass(div,'highlight_zero_click3');
			    else YAHOO.util.Dom.addClass(div,'highlight_zero_click');
			}

			// For debugging.
//			console.log(div.id);

		    }


		} else {

		    // For debugging.
//		    console.log(div);

		    YAHOO.util.Dom.addClass(div,'zero_click_snippet_no_image');
		    if (!is_internal_highlight) YAHOO.util.Dom.addClass(div,'highlight_zero_click3');
		}

		// Add main header.
		if (is_header==2) {
		    div2 = d.getElementById('zero_click_header');
			div3 = d.getElementById('zero_click_plus_wrapper');
		    div2.innerHTML+='<h1>' + obj['h'] + '</h1>';
		    YAHOO.util.Dom.setStyle(div2,'display','block');
		    div2.appendChild(div3.parentNode.removeChild(div3));
			YAHOO.util.Dom.addClass(div3,'icon_zero_click_header');
		} else if (is_header==1) {
		    div.innerHTML += obj['h'];
		    if (time) div.appendChild(time);
		    div.innerHTML+='<div style="margin-top:5px"></div>';
		}

                // For debugging.
//              console.log(typeof(obj['a']));

                if (typeof(obj['a']) == 'object') {
                    div.appendChild(obj['a']);
		    div.appendChild(d.createTextNode(' '));
                } else {
                    div.innerHTML+=obj['a']+' ';
                }

		link = d.createElement('a');
		link.href=obj['u'];
//		if (link.href.indexOf('?')!=-1) link.href=obj['u']+rq;
		if (DDG.spice_force_message[obj['s']]) link.innerHTML=DDG.spice_force_message[obj['s']];
                else if (first_item['force_more_at_logo']) {
		    path = DDG.get_asset_path(first_item['force_more_at_logo'][0], first_item['force_more_at_logo'][1]);
		    img = d.createElement('img');
		    img.src = path;
		    img.id = "zero_click_more_at_logo";
		    link.innerHTML="More at";
		    link.appendChild(img);
		}
		else link.innerHTML=l('More at %s',obj['s']);
		YAHOO.util.Dom.addClass(link,'zero_click_more_at_link');

		link.onclick=function() {fl=1;};

		if (kn && kn=='1') link.target='_blank';
		if (favicon_placement && favicon) {

		    div2 = d.createElement('div');

		    if (DDG.spice_force_space_after[first_item['s']] || first_item['force_space_after']) YAHOO.util.Dom.setStyle(div2,'margin-top','5px')

		    // Inline -- new default.
		    else if (favicon_placement==4) YAHOO.util.Dom.setStyle(div2,'display','inline');

		    // If something is displayed above the More link then don't put the spacing in.
		    else if (favicon_placement!=2) YAHOO.util.Dom.setStyle(div2,'margin-top','10px');


		    // If we float things in the box, this will make sure things go after.
		    if (favicon_placement==3) {
			YAHOO.util.Dom.setStyle(favicon,'clear','left');
			YAHOO.util.Dom.setStyle(div2,'clear','left');
		    }
		    div2.appendChild(link);

		    if (favicon_placement==4) div2.insertBefore(favicon,div2.firstChild);
		    else div2.appendChild(favicon);

		    div.appendChild(div2);
		    div2 = d.createElement('div');
		    YAHOO.util.Dom.addClass(div2,'clear');
		    div.appendChild(div2);

		} else if (DDG.spice_force_space_after[first_item['s']]) {
		    div2 = d.createElement('div');
		    YAHOO.util.Dom.setStyle(div2,'margin-top','5px');
		    div2.appendChild(link);
		    div.appendChild(div2);

		} else {
		    div.appendChild(link);
		}
		YAHOO.util.Dom.setStyle(div,'display','block');

		if (time && !obj['h']) div.appendChild(time);

	    } else {
		if (item_count==2) {
		    div = d.getElementById('zero_click');
		    div2 = d.createElement('div');
		    div2.id = 'zero_click_topics';

		    hr = d.createElement('hr');
		    YAHOO.util.Dom.addClass(hr,'horizontal_line');
		    div2.appendChild(hr);

		    div.appendChild(div2);
		}
		div = d.getElementById('zero_click_topics');

		div2 = d.createElement('div');
		div2.id='r2-'+(r2c++);
		YAHOO.util.Dom.addClass(div2,'results_zero_click');
		YAHOO.util.Dom.setStyle(div2,'margin-right','50px');

		div3 = d.createElement('div');
		YAHOO.util.Dom.addClass(div3,'icon_fav');
		div2.appendChild(div3);

		div3 = d.createElement('div');
		YAHOO.util.Dom.addClass(div3,'links_zero_click');

		link = d.createElement('a');
		//		link.href = gd+'?q='+obj['t'];
		link.url = gd+'?q='+obj['t'];
		link.href = 'javascript:;';
		link.innerHTML = obj['t'];
		//		link.onclick=function() {nrv(this.parentNode,1);};
		link.onclick=function() {fl=1;nrv(d.getElementById(this.parentNode.parentNode.id),1);YAHOO.util.Dom.addClass(this.parentNode.parentNode,'highlight_zero_click3');if (nir) nir('zero_click');setTimeout('fl=0',100);};
		div3.appendChild(link);

		span=d.createElement('span');
		span.innerHTML=' - ' + obj['a'] + ' ';
		YAHOO.util.Dom.addClass(span, 'hidden');
		YAHOO.util.Dom.setStyle(span,'display','none');

		link = d.createElement('a');
		link.href=obj['u'];
//		if (link.href.indexOf('?')!=-1) link.href=obj['u']+rq;
		link.innerHTML=l('More at %s',obj['s']);
		link.onclick=function() {fl=1;};
		if (kn && kn=='1') link.target='_blank';
		span.appendChild(link);

		div3.appendChild(span);

		div2.appendChild(div3);
		div.appendChild(div2);
	    }

	    // Onclick handlers for links.
	    if (div) {
		links = div.getElementsByTagName('a');
		for (i=0;i<links.length;i++) {
		    link = links[i];

		    //		    console.log(link);
		    //		    console.log(link.href);

		    if (link.href != 'javascript:;') link.onclick=function() {fl=1;};
		}
	    }


	    // Max items to display.
	    if (item_count==3) break;
	}
    }


    // If we ended up having anything.
    if (item_count) {

	// Mouseovers, i.e. highlighting.
	if (nir) nir('zero_click');

	// Show the hidden (now populated) 0-click section.
	div = d.getElementById('zero_click_wrapper');
	if (div) {
	    YAHOO.util.Dom.setStyle(div,'display','block');
	    YAHOO.util.Dom.setStyle(div,'visibility','visible');
	    YAHOO.util.Dom.setStyle(div,'padding-top','15px');
	}

	// 2012.03.08
	// Need to check if spice is Quixey
	// so it can control the zero_click divs
	// as needed (remove padding/margins)
	// TODO: 
	// - Generalize this, allows spices to
	//   classs these divs when needed
	// - Remove this hardcoded snippet.
	if (first_item['s'] === "Quixey") {
	    YAHOO.util.Dom.addClass('zero_click_wrapper2', 'quixey');
	   
	     // load quixey css
	    var quixey_css = DDG.get_asset_path("quixey", "quixey.css");
	    nrc(quixey_css);
	}

	if (is_stacked) div = d.getElementById('zero_click_abstract_stacked');

	// If stacked, add in a horizontal separator.
	// ki is check for meanings and kz is check for 0-click box settings.
	if ((rt=='D' || is_stacked) && (!ki || ki==1) && (!kz || kz==1)) {
	    hr = d.createElement('hr');
	    hr.id = 'zero_click_separator';
	    YAHOO.util.Dom.addClass(hr,'horizontal_line');
//	    YAHOO.util.Dom.setStyle(hr,'margin-bottom','10px');	    
	    YAHOO.util.Dom.setStyle(hr,'width','100%');
	    YAHOO.util.Dom.setStyle(hr,'clear','both');
	    //	    div.parentNode.insertBefore(hr,div.nextSibling);
	    div.parentNode.insertBefore(hr,div);
	}


	//	console.log(obj['s']);
	//	console.log(DDG.spice_force_no_scroll[obj['s']]);

	// Add scrolling if needed.
	if (!is_stacked && !DDG.spice_force_no_scroll[first_item['s']] && !obj['force_no_fold'] && obj['s']!=undefined && first_item['s'].indexOf('Punchfork')==-1) {
	    
	    div = d.getElementById('zero_click_wrapper2') || d.getElementById('zero_click_wrapper');

//	    console.log(div);
//	    console.log(div.scrollHeight);

	    if (div && div.scrollHeight>150 && count==1) {
		YAHOO.util.Dom.setStyle('zero_click_wrapper2','height','125px');
		YAHOO.util.Dom.setStyle('zero_click_wrapper2','overflow','auto');
		YAHOO.util.Dom.setStyle('zero_click_wrapper2','margin','auto');
		YAHOO.util.Dom.setStyle('zero_click','padding-right','0px');
		YAHOO.util.Dom.setStyle('zero_click','padding-bottom','5px');
		YAHOO.util.Dom.setStyle('zero_click_plus_wrapper','padding-right','5px');
		YAHOO.util.Dom.setStyle('zero_click_abstract','margin-right','40px');
	    } else if (div && div.scrollHeight>125 && count>1) {
		YAHOO.util.Dom.setStyle('zero_click_wrapper2','height','100px');
		YAHOO.util.Dom.setStyle('zero_click_wrapper2','overflow','auto');
		YAHOO.util.Dom.setStyle('zero_click_wrapper2','margin','auto');
		YAHOO.util.Dom.setStyle('zero_click','padding-right','0px');
		YAHOO.util.Dom.setStyle('zero_click','padding-bottom','5px');
		YAHOO.util.Dom.setStyle('zero_click_plus_wrapper','padding-right','5px');
		YAHOO.util.Dom.setStyle('zero_click_abstract','margin-right','40px');
	    }
	}


	// Add + or -
	div = d.getElementById('zero_click_wrapper2');
	div2 = d.getElementById('zero_click');

	if (div && div.scrollHeight && div2.scrollHeight && (div.scrollHeight<125 || div2.scrollHeight>=div.scrollHeight)) {
	    div3 = d.getElementById('zero_click_plus');
	    if (div3) {
		div3.onclick=nra4;
		YAHOO.util.Dom.removeClass('zero_click_header','min');
		YAHOO.util.Dom.removeClass('zero_click_plus','plus');
	    }
	} else {
	    div3 = d.getElementById('zero_click_plus');
	    if (div3) {
		div3.onclick=nra3;		
		//YAHOO.util.Dom.addClass('zero_click_header','min');
		YAHOO.util.Dom.addClass('zero_click_plus','plus');
	    }
	}


	// Make sure screen is still drawn right.
	DDG.resize();
    }
}

// expand zero-click info box
function nra3() {
    var div,a;

    // 2013.05.04 because zero_click_plus is now a child element of a highlight div with a link.
    fl=1;

    div = d.getElementById('zero_click_abstract');
    if (div && div.innerHTML!='') YAHOO.util.Dom.setStyle(div,'display','block');
    div = d.getElementById('zero_click_abstract_stacked');
    if (div && div.innerHTML!='') YAHOO.util.Dom.setStyle(div,'display','block');
    div = d.getElementById('zero_click_topics');
    if (div) YAHOO.util.Dom.setStyle(div,'display','block');
    div = d.getElementById('zero_click_separator');
    if (div) YAHOO.util.Dom.setStyle(div,'display','block');

    div = d.getElementById('zero_click_image');
    if (div) YAHOO.util.Dom.setStyle(div,'display','block');

    div = d.getElementById('zero_click_header');
    if (div) YAHOO.util.Dom.setStyle(div,'margin-bottom','0px');

    if (div && div.firstChild) YAHOO.util.Dom.setStyle(div,'display','block');
    div = d.getElementById('zero_click_wrapper2');
    if (div) {
	YAHOO.util.Dom.setStyle(div,'height','100%');
	YAHOO.util.Dom.setStyle(div,'overflow-y','auto');

    // For debugging.
//    console.log(rt);

	if (!rt) YAHOO.util.Dom.setStyle(div,'max-height','800px');
	else YAHOO.util.Dom.setStyle(div,'max-height','100%');
    }
    a = d.getElementById('zero_click_plus');
    if (a) {
	a.onclick=nra4;	
	YAHOO.util.Dom.removeClass('zero_click_header','min');
	YAHOO.util.Dom.removeClass('zero_click_plus','plus');
    }
}

// contract zero-click info box
function nra4() {
    var div,a;

    // 2013.05.04 because zero_click_plus is now a child element of a highlight div with a link.
    fl=1;

    //    console.log(fl);

    div = d.getElementById('zero_click_abstract');
    if (div) YAHOO.util.Dom.setStyle(div,'display','none');
    div = d.getElementById('zero_click_abstract_stacked');
    if (div) YAHOO.util.Dom.setStyle(div,'display','none');
    div = d.getElementById('zero_click_image');
    if (div) YAHOO.util.Dom.setStyle(div,'display','none');
    div = d.getElementById('zero_click_separator');
    if (div) YAHOO.util.Dom.setStyle(div,'display','none');
    div = d.getElementById('zero_click_topics');
    if (div) YAHOO.util.Dom.setStyle(div,'display','none');

    div = d.getElementById('zero_click_header');
    if (div) YAHOO.util.Dom.setStyle(div,'margin-bottom','0px');

    div = d.getElementById('zero_click_wrapper2');
    if (div) {
	YAHOO.util.Dom.setStyle(div,'max-height','50px');
	YAHOO.util.Dom.setStyle(div,'overflow-y','hidden');
    }

    a = d.getElementById('zero_click_plus');
    if (a) {
	a.onclick=nra3;	
	YAHOO.util.Dom.addClass('zero_click_header','min');
	YAHOO.util.Dom.addClass('zero_click_plus','plus');
    }
}


// Function to make new results.
function nrn (type,items) {
    var item,div,div2,div3,div4,span,link,link2,link3,link4,link5,img,title,title_cap,col,ocol,col_num,count,re2,re3,rc1,i,j,ic,ic2,domain,x,y,z,length,is_more,is_more2,is_more3,is_eof2,is_eof,is_official,is_officialb,is_continue,is_next,embed,wot,amazon,is_amazon,amazon2,is_first,h2,ad_item;

    var is_bang_news = 0;
    var is_bang_maps = 0;

    // For debugging.
    //    alert(type);
    //    if (type=='r') {
    //	alert(items.length);
    //	alert(items);
    //    }
    //    for (var i=0; i<items.length; i++) {
    //	alert(items[i]['u']);
    //    }
    //    alert('test');
    //    if (type=='r') alert(items);
    //    if (type=='d') alert(items);
//    return false;

    // For domain checking.
    re2 = new RegExp('^.*?\/\/(?:ww[\\dw]+\.|)([^\/\?\:\#]+)');

    var isLyrics = rq.search(/lyrics/i) != -1;
    //console.log('lyrics? : '+isLyrics);

    link3 = link4 = link5 = embed = wot = amazon = amazon2 = is_amazon = '';

    switch(type) {
    case 'd':
	col_num = '1';
	count = r1c;
	break;
    case 'r':
	col_num = '1';
	count = r1c;
	break;
    case 'a':
	col_num = 'a';
	count = r3c;
	break;
    }

    if (!type || !items) return false;

    length = items.length;

    // For debugging.
    //    alert(length);
//    console.log(type);
//    console.log(items.length);
//    console.log(col_num);
//    console.log(YAHOO.util.Dom.getStyle('ads','height'));
//    if (type=='a') {
//		console.log(YAHOO.util.Dom.getStyle('ads','height'));
//		console.log(DDG.is_deep_loaded);
//		console.log(DDG.is_ad_loaded);
//		console.log(DDG.get_now()-DDG.is_deep_loaded);
//    }
    
    // When to show ads.
    if (type == 'a' && YAHOO.util.Dom.getStyle('ads','height')=='0px' && DDG.is_deep_loaded && ( (DDG.get_now()-DDG.is_deep_loaded) > 500 ) ) return false;
    if (type == 'a' && k1 && k1=='-1') return false;
    if (type == 'a' && DDG.is_ad_loaded) return false;
    if (type == 'a') DDG.is_ad_loaded = 1;

    //    if (type=='a') console.log('ad call');

    if (rq.indexOf('site%3A')!=-1) iqs=1;

//    console.log(rds);

    is_first = (type=='d' && rds==30) ? 1 : 0;

    // Click tracking base measurement.
    //    if (type=='d' && is_first) nutp('d1');

    // For debugging.
//    console.log(col_num);

    // Column div.
    if (col_num=='a') {
	col = d.getElementById("ads");

    } else if (col_num=='3') {
	col = d.getElementById('side');

	// For debugging.
//	console.log(col);


    } else if (is_first && d.getElementById("rre0-1")) {

	col = d.getElementById("rre0-1");
	col.removeChild(col.lastChild);
	count--;

    } else if (count) {

	// For debugging.
//	console.log(col_num + ' ' + count);

	col = d.getElementById("r1-"+parseInt(count-1)).parentNode;

    } else {
	col = d.getElementById("r1a") || d.getElementById('links');
    }
    ocol=col;

    // Initial deep setup.
    if (type=='d' && (r1c || rad) && rd.length==0) {

	// Mark we did this.
	rd[0]=1;

	//	console.log(rad);
	//	console.log(rt);

	// Abstract domain.
	if (rad && (!kz || kz==1) && rt) rd[rad]=1;

	// Icon event firing.
	nut(col);

	// Grab domains.
	for (i=0;i<count;i++) {
	    if (!ie || ie9) links = d.getElementById("r1-"+i).getElementsByTagName('a');
	    for (j=0;j<links.length;j++) {

		// For debugging.
//		console.log(links[j]);

		if (YAHOO.util.Dom.hasClass(links[j],'url')) {

		    // For debugging.
//		    console.log(links[j].textContent);

		    if (links[j].textContent == 'Official site') is_official = 1;
		    if (links[j].textContent == 'Official blog') is_officialb = 1;
		    if (re2.test(links[j].href)) {
			rd[RegExp.$1]=links[j].href;

			// For debugging.
//			console.log(RegExp.$1);
//			console.log(is_official);

			if (kf && (kf=='w'||kf=='fw'||kf=='b') && is_first && !rs) wot += (wot ? ',' : '') + RegExp.$1 + ':' + 'r1-'+i;
		    }
		}
	    }
	}

	// Grab hidden domains.
	for (i=0;i<r1hc;i++) {
	    links = d.getElementById("r1h-"+i);
	    if (!links) continue;
	    links = links.getElementsByTagName('a');
	    if (!links) continue;
	    for (j=0;j<links.length;j++) {
		if (links[j].textContent == 'Official site') is_official = 1;
		if (links[j].textContent == 'Official blog') is_officialb = 1;
		if (re2.test(links[j].href)) {
		    rd[RegExp.$1]=links[j].href;
		    if (kf && (kf=='w'||kf=='fw'||kf=='b') && is_first && !rs) wot += (wot ? ',' : '') + RegExp.$1 + ':' + 'r1h-'+i;
		}
	    }
	}
    }

    // For debugging.
    //    if (type=='d') alert(rd.length);
    //    alert(type + ' ' + rv + ' ' + length);
//    return false;
//    if (type=='a') console.log('ad call');

    // No links.
    if (!length && ( (type=='r' && rsc<=0) || (type=='d' && rv=='d') ) ) {

	// For debugging.
//	alert('test');
//	return false;

	// Must come before we reset type.
	if (type=='d' && !r1c) {
	    div = d.getElementById('rfd');
	    YAHOO.util.Dom.setStyle(div,'display','none');
	}

	type='r';
	items['x'] = new Array();
	items['x']['t'] = 'EOH';
    }

    // Deep no results message.
    is_eof2 = 0;
    if (type=='d' && (items[length-1]['t']=='EOP' || items[length-1]['t']=='EOF')) {
	is_eof2=1;
	ieof=1; // global
	il=1;

	if (items[length-1]['t']=='EOP') is_eof2 = 2;

	// For debugging.
	//alert(il);
	//	alert(items[length-1]['t']);
//	alert('test');
    }

    // For debugging.
    //    console.log(items.length);
//    alert(items.length);
//    return false;

    ic=ic2=is_more=is_more2=is_more3=0;
    for (item in items) {
	ic++;
	is_continue = 0;

	if (!items[item]) continue;

	// No ads.
	if (k1 && k1=='-1' && items[item]['p']) continue;

	// Grab affiliate ad.
	if (!ad_item && items[item]['k']) ad_item = item;

	// Disable loading gif.
	if (type=='d' && rv!='d' && ic==1) {
	    nsl();
	}

	// I'm Feeling Ducky
	if (ic==1 && rv=='i') {
	    setTimeout('top.location.replace("'+items[item]['u']+'")',100);
	    return;
	}


	// Bang suggestions.
	if (type=='d' && items[item]['b']) {

	    DDG.bang_suggestions[items[item]['b']] = items[item]['i'];

	    //	    console.log(items[item]['b']);
	}

	// Set domain.
	domain = '';
	if (re2.test(items[item]['c'])) domain = RegExp.$1;

	// For debugging.
	//	if (!domain) alert(items[item]['c']);
	//	alert(items[item]['c']);
	//	console.log(items[item]['c']);

	// Deep no results message.
	is_eof = 0;
	if (type=='d' && items[item]['t']=='EOP') {
	    items[item]['t'] = l('Safe search is on. No safe search results.');
	    is_eof=1;
	} else if (type=='d' && items[item]['t']=='EOF') {

	    //	    alert('test');
	    //	    alert(YAHOO.util.Dom.getStyle('zero_click_wrapper', 'display'));

//	    items[item]['t'] = 'No ' + (rad || count || length>1 || YAHOO.util.Dom.getStyle('zero_click_wrapper', 'display')=='block' ? 'more ' : '') + 'results. Try Google.';
	    is_eof=1;
	    continue;
	}


	// For debugging.
//	console.log(items[item]['u']);

	// Skip dups.
	//	if (is_eof) alert(count);
	//	alert(is_eof);
	//	alert(ic+ ' ' + length + ' ' + is_eof);
	// Last link needs to make more link.
	// EOF makes its own implicit more link.
	if (type=='d' && !is_eof && !items[item]['p'] && (rv!='d' || (rv=='d' && count==0))) {

	    // For debugging.
	    //	    alert(domain);
	    //	    alert(rd[');

	    if (!domain || (rd[domain] && !iqs) || rd[items[item]['c']]) {

		// If we contiued through all links.
		if (ic2==0 && ic==length && !is_first) {

		    // For debugging.
		    //		    alert('test');
		    //		    alert(is_more);
		    //		    alert(length);
		    //		    alert(ic);
		    //		    alert(domain);
//		    console.log(domain);
//		    alert('test');

		    nrj('/l.js?q='+rq);
		    is_eof2=1;
		}

		// For debugging.
		//		alert(ic);

		if (ic==length) is_continue=1;
		else continue;
	    } else {
		rd[domain] = items[item]['c'];
		rd[items[item]['c']] = items[item]['c'];
	    }
	}

	//	if (type=='a') console.log('ad call');

	if (type=='r' && items[item]['t']=='EOH') {
	    is_continue=1;
	}

	// Skip strip dups.
	if (type=='r') {
	    if (rsd[items[item]['a']]) is_continue=1;
	    else rsd[items[item]['a']] = 1;
	    if (domain && !iqs) rd[domain] = items[item]['c'];
	    rd[items[item]['c']] = items[item]['c'];
	    rsd[0]=1;
	}


	// Skip deep after setup for duck vertical.
	if (rv=='d' && type=='d') {
		rsc++;
		nrj('/r.js?u='+encodeURIComponent(items[item]['c'])+'&q='+rq+(rp && rp != '-1' ? '&p=1' : ''));
	    if (count!=0) continue;
	}

	// For debugging.
//	alert(is_continue);
//	if (type=='a') console.log(is_continue);

	if (!is_continue) {

	    // After all continues.
	    ic2++;

	    // Result div.
	    div = d.createElement('div');
	    div.id='r'+col_num+'-'+count++;
	    YAHOO.util.Dom.addClass(div, 'results_links'+(type=='d'&&!items[item]['h']?'_deep':'')+' highlight_'+type+( (type=='r' || items[item]['i']) ? '2' : ''));

	    if (type=='d') {

		var text_to_match = items[item]['t'] + ' ' + items[item]['a'];

		// Check for wot.
		if (kf && (kf=='w'||kf=='fw'||kf=='b') && domain && !is_eof) {
		    wot += (wot ? ',' : '') + domain + ':' + div.id;
		}

		// Check for embedly.
		if (0 && !iqs && gre.test(items[item]['u'])) {
		    embed += (embed ? ',' : '') + items[item]['u'];

		    // Store url to div.
		    reb[reb.length] = div.id;
		}

		//		console.log(rt);
		//		console.log(rs);
		//		console.log(gra3);

		// Look for amazon.
		if (!amazon && is_first && count>1 && count<8 && rt!='A' && !rs && gra3.test(items[item]['u'])) {

		    // For debugging.
		    //		alert(rt);
		    //		alert(rs);
		    //		    console.log('test');
		    //		console.log(RegExp.$1 + ' ' + items[item]['u']);
		    //		console.log(count);

		    amazon = RegExp.$1;
		}


		//		console.log(gra);
		//		console.log(items[item]['u']);
		//		console.log(gra.test(items[item]['u']));

		// Needs to be independent because we sometimes don't call amazon 0-click for other reasons.
		// Moving rt within !da bc yahoo prob converts better.
		if (!amazon2 && is_first && (gra.test(items[item]['u']) || (!da && (rt || gra2.test(items[item]['a'] + ' ' + items[item]['t']))))) {

		    // For debugging.
		    //		    alert('test');
		    //		    console.log(RegExp.$1 + ' ' + items[item]['u']);

		    if (gram.test(items[item]['u'])) amazon2 = 'm';
		    else if (grae.test(items[item]['u'])) amazon2 = 'e';
		    else if (grad.test(items[item]['u'])) amazon2 = 'd';
		    else if (grab.test(items[item]['b'])) amazon2 = 'b';
		    else amazon2 = 1;
		}

	    }

	    // Mark beginning.
	    if (type=='i' && !rii) rii=div.id;
	    else if (type=='n' && !rin) rin=div.id;
	    else if (type=='t' && !rir) rir=div.id;
	}


	/*
	  If a deep or topics result and too many links in section,
	  then make a new hidden section for it.
	  ic2>1 prevents an immediate more links...

	  The !rs block ensures you get an adeqate amount of link
	  before showing the next more link on special pages
	  which may have an arbitraty number of links showing before
	  the first more link is hit.

	  The ic==items.length ensures that if less than 4 flow through
	  the last one ends with the more link.
	*/
	// For debugging.
	//	alert(items.length);
	//	alert(ic2);
	//	alert(ic);
	//	alert(ic==length && !is_more);
	// if ((type=='d' && !is_eof2 && ( (ic2>1 && ( ((count==9||((count-9)%15)==0) && (!rs || rdc || ic2>6)))) || (ic==length && !is_more)) ) || (type=='r' && rsc<=0)) {
	if ( (type=='d' && !is_eof2 && ic==length && !is_more) || (type=='r' && rsc<=0) ) {


	    // For debugging.
	    //	    alert('test');
	    //	    if (type=='d' && ic==length && !is_more) {
	    //		alert('test');
	    //	    }
	    //alert(ic2 + ' ' + ic + ' ' + length);
	    //	    if (type=='r') alert('test');
	    //	    alert(count + ' ' + ic + ' ' + ic2 + ' ' + is_continue);

	    div2 = d.createElement('div');
	    YAHOO.util.Dom.addClass(div2, 'results_links_more highlight_'+type);

	    link = d.createElement('a');
	    link.href='javascript:;';
	    link.onclick=function() {

		// For debugging.
		//		console.log('test');
		//alert('test');

		nsr(this)
	    };

	    // For debugging.
	    //	    alert(link.onclick);

	    if (type=='d' || type=='r') {

		// For debugging.
		//		alert('test');

		if (type=='d') div2.id='rld-'+(++rdc);
		else if (type=='r') div2.id='rle0-1';
		if (type=='r' && !r1hc) link.appendChild(d.createTextNode(l('Get Web links') + '...'));
		else link.appendChild(d.createTextNode(l('More Links') + '...'));
		YAHOO.util.Dom.addClass(link,'large');
		YAHOO.util.Dom.addClass(div2,'links_deep');

	    } else if (type=='t') {
		div2.id='rli1-'+(++rtc);
		link.appendChild(d.createTextNode(l('More Related Topics') + '...'));
	    }

	    div2.appendChild(link);

	    if (type=='r' && !is_continue) {
		is_more = div2;
		is_more3 = div3;
	    } else {
		if (type=='r') col.appendChild(div3);
		col.appendChild(div2);
	    }

	    div2 = d.createElement('div');

	    if (type=='d') div2.id='rrd-'+rdc;
	    else if (type=='r') div2.id='rre0-1';
	    else if (type=='t') div2.id='rri1-'+rtc;

	    YAHOO.util.Dom.setStyle(div2,'display','none');

	    if (type=='r') {
		div3 = d.createElement('div');
		div3.id='r'+col_num+'-'+count++;
		div2.appendChild(div3);
	    }

	    if (type=='r' && !is_continue) {
		is_more2 = div2;
	    } else {
		col.appendChild(div2);
		col=div2;

		// Mark we did this.
		is_more=1;

		// Custom event & icon group to display icons when using keyboard.
		nut(col);

		if (type=='r' && count<=6) nua('nsr',col.previousSibling.firstChild,0,0,0,1);
	    }
	}

	if (is_continue) continue;

	// Icon div.
	div2 = d.createElement('div');
	YAHOO.util.Dom.addClass(div2, 'icon_'+(type=='d'&&!items[item]['h']?'fav2':'fav'));
	if ((type=='d' || type=='r') && items[item]['i']!='' && (!kf || kf=='1' || kf=='fw' || kf=='b')) {
	    title = l('Search domain %s',items[item]['i']);
	    if (nur) img = nur(YAHOO.util.Dom.getStyle(col, 'display')=='block' && col.event && col.event.is_fired ? '' : col.ig,title,ga+items[item]['i']+'.ico',16,16);
	    if (img) {
		link = d.createElement('a');
		link.href = iqs ? '/?q='+rq : '/?q='+rq+'+site:'+items[item]['i'] + (kurl ? kurl : '');
		link.title = title;
		link.appendChild(img);
		link.onclick=function() {fl=1;};
		div2.appendChild(link);

		// For debugging.
//		console.log('test');
	    }

	    // For debugging.
//	    console.log('test');


	} else if (type=='r') {
	    div2.innerHTML+='&#149;';
	    //	    YAHOO.util.Dom.setStyle(div2,'display','none');
	}
	div.appendChild(div2);

	// Link div.
	div2 = d.createElement('div');
	YAHOO.util.Dom.addClass(div2, 'links_'+ ((col_num==1||col_num=='a') ? 'main' : 'zero_click'));
	if ((type=='d'||type=='a') && !items[item]['h']) YAHOO.util.Dom.addClass(div2, 'links_deep');

	// Main link.
	if (type != 'r') {

	    link = d.createElement('a');
	    if (type=='d' || type=='a') YAHOO.util.Dom.addClass(link, 'large');
	    link.href=items[item]['c'];
	    if (kn && kn=='1' && link && link.href && link.getAttribute("href").indexOf('http')!=-1) link.target='_blank';

	    //	if (ic==3) {
	    //	    d.getElementById("debug").value+='\n'+items[item]['u'];
	    //d.getElementById("debug").value+='\n'+items[item]['c'];
	    //	    d.getElementById("debug").value+=(items[item]['u']=="http://lrd.yahooapis.com/_ylc=X3oDMTRvYmw1ZDQ2BF9TAzIwMjMxNTI3MDIEYXBwaWQDcnhBSFNrVElrWTBhOXF4dl9taklQc0pENlJJY1RDQ0luMm9FOE1kSzJEZkpCXzZRBHBvcwMzBHNlcnZpY2UDWVNlYXJjaFdlYgRzbGsDdGl0bGUEc3JjcHZpZANFMGtvbFVTTzVxOUJ1aXM0THd2YzN3Z3BTRjc1SWtsQVR5MEFCblEz/SIG=12p5rolob/**http%3A//people.brandeis.edu/~nika/schoolwork/Poland%2520Lectures/Lecture%25252007.pdf");
	    //	}

	    // No tool tip.
	    //	    link.title=items[item]['c'];

	    if (items[item]['t'] == '<b>' + l('Official site') + '</b>') {

		// For debugging.
//		alert('test');

		if (is_official || count>1) {
		    items[item]['t'] = items[item]['h'];
		    items[item]['h'] = 0;
		} else {
		    items[item]['a'] = ' - ' + rqd;
		}
	    } else if (is_officialb && items[item]['t'] == 'Official blog') {
		count--;
		continue;
	    }
	    link.innerHTML=items[item]['t'];


	    if (type=='i' && items[item]['h']) {
		if (nur) img = nur('',items[item]['t'],items[item]['h'],items[item]['w'],items[item]['x']);
		if (img) {
		    link.insertBefore(img,link.firstChild);
		}
	    }

//	    if (items[item]['u'] && items[item]['u']!=items[item]['c']) {
//		link.clickurl=items[item]['u'];
//	    }

	    link2=link;

	    h2 = d.createElement('h2');
	    h2.appendChild(link);

	    div2.appendChild(h2);
	}

	// For debugging ~ problem.
	//	if (ic==3) document.getElementById("container").appendChild(link);

	if (type=='d' || type=='a') {

	    //	    if (type=='a') console.log('ad call');

	    if (items[item]['h'] && items[item]['a']) {
		span=d.createElement('span');
		span.innerHTML=' ' + items[item]['a'];
		div2.appendChild(span);
	    } else if (items[item]['a']) {
		div3 = d.createElement('div');
		YAHOO.util.Dom.addClass(div3, 'snippet');

		if (k2 && k2=='1') {
		    link4 = d.createElement('a');
		    link4.href=items[item]['c'];
		    if (kn && kn=='1' && link4.getAttribute("href").indexOf('http')!=-1) link4.target='_blank';
		    link4.innerHTML=items[item]['a'];
		    div3.appendChild(link4);
		} else {
		    div3.innerHTML = items[item]['a'];
		}

		div2.appendChild(div3);
	    }

	    div3 = d.createElement('div');
	    link3 = d.createElement('a');
	    link3.href=items[item]['c'];
	    if (kn && kn=='1' && link3.getAttribute("href").indexOf('http')!=-1) link3.target='_blank';
	    link3.appendChild(d.createTextNode(' '+items[item]['d']));

	    div3.appendChild(link3);
	    YAHOO.util.Dom.addClass(link3, 'url');

	    if (!is_eof) {

		if (items[item]['e']) {
		    span=d.createElement('span');
		    YAHOO.util.Dom.addClass(span, 'links_menu');
		    span.innerHTML='&nbsp; &nbsp;'+items[item]['e'];
		    div3.appendChild(span);
		}

		if (!iqs && !items[item]['p']) {
		    div3.appendChild(d.createTextNode('\u00a0 \u00a0'));

		    link5=d.createElement('a');
		    link5.href = iqs ? '/?q='+rq : '/?q='+rq+'+site:'+items[item]['i'] +(kurl ? kurl : '');
		    if (kurl) link5.href+=kurl
		    link5.appendChild(d.createTextNode('More from ' + domain));
		    link5.title = l('Search domain %s',items[item]['i']);
		    YAHOO.util.Dom.addClass(link5, 'links_menu');
//		    YAHOO.util.Dom.setStyle(link5,'float','right');

		    // 2013.02.21 -- try showing site search all the time
//		    if (!items[item]['m']) YAHOO.util.Dom.addClass(link5, 'hidden');
		    div3.appendChild(link5);

		} else if (items[item]['p']) {
		    div3.appendChild(d.createTextNode('\u00a0 \u00a0'));

		    link5 = d.createElement('a');
		    link5.href = 'http://help.duckduckgo.com/customer/portal/articles/216405-advertising';
		    link5.onclick=function() {fl=1;};
		    link5.appendChild(d.createTextNode('Sponsored link'));
		    YAHOO.util.Dom.addClass(link5, 'sponsored_info');
		    YAHOO.util.Dom.addClass(div, 'highlight_sponsored');
		    YAHOO.util.Dom.addClass(div, 'sponsored');
		    div3.appendChild(link5);

		    if (div.id==DDG.first_result) DDG.first_result = 'r'+col_num+'-'+count;
		    //		    console.log(DDG.first_result);
		}

	    }

	    div2.appendChild(div3);

	} else if (type=='t' && items[item]['a']!='') {
	    span=d.createElement('span');
	    span.innerHTML=' - ' + items[item]['a'];
	    YAHOO.util.Dom.addClass(span, 'hidden');
	    YAHOO.util.Dom.setStyle(span,'display','none');
	    div2.appendChild(span);

	} else if (type=='i') {


	} else if (type=='r') {

	    YAHOO.util.Dom.addClass(div2, 'snippet');
	    div2.innerHTML += items[item]['a']+ '<br>';

	    link = d.createElement('a');
	    link.href=items[item]['c'];
	    if (kn && kn=='1' && link.getAttribute("href").indexOf('http')!=-1) link.target='_blank';

	    // No tooltip.
	    //	    link.title=items[item]['d'];

	    link.innerHTML+=''+items[item]['d'];
	    div2.appendChild(link);
	    if (items[item]['t']) {
		span=d.createElement('span');
		YAHOO.util.Dom.addClass(span, 'url');
		span.innerHTML += '&nbsp;[' + items[item]['t'] + ']';
		div2.appendChild(span);
	    } else {
		span=d.createElement('span');
		span.innerHTML += '&nbsp;';
		div2.appendChild(span);
	    }
	}

	//	if (type=='a') console.log(div2);

	div.appendChild(div2);

	// Has to go after innerhtml, because that messes up event handlers.
	// May conflict with link redirector.
	//	if (type!='r') div.childNodes[1].firstChild.onclick=function() {fl=1;if (this.clickurl&this.clickurl!=this.href) {this.href=this.clickurl;};};
	//        else if (type=='r') {
	//	    div.childNodes[1].lastChild.previousSibling.onclick=function() {fl=1;if (this.clickurl&&this.clickurl!=this.href) {this.href=this.clickurl;};};
	//	}

	if (type=='t') {
	    col.options[col.options.length] = new Option(items[item]['t'],items[item]['u']+(rv?'?v='+rv:''));
	} else if (rv=='d' && type=='d') {
	    div2 = d.getElementById('zero_click_answer') || d.getElementById("rfd") || '';
	    if (div2) {
		if (div2.id=='zero_click_answer') YAHOO.util.Dom.setStyle(div2,'padding-bottom','5px')
		div2.parentNode.insertBefore(div,div2.nextSibling);
	    }
	} else if (type=='i') {
	    col.insertBefore(div,col.firstChild);
	} else {
	    col.appendChild(div);
	    if (!rc && div.id==DDG.first_result) rc=div;
	}

	if (type=='r' && is_more && is_more2) {
	    col.appendChild(is_more3);
	    col.appendChild(is_more);
	    col.appendChild(is_more2);
	    col=is_more;
	    nut(col);
	    if (count<=6) nua('nsr',is_more.firstChild,0,0,0,1);
	}


	// If new deep results, and first to load.
	// Don't highligt automatically if the first section of duckit (21 hack),
	// unless we had hidden results, in which case it is not really the first section.
	if (type=='d' && ic2==1) {

	    // For debugging.
	    //	    alert('test');
	    //	    alert(div.previousSibling);
	    is_next=0;
	    re3 = new RegExp('^r1-(\\d+)$');
	    if (rc && re3.test(rc.id)) {
		rc1 = RegExp.$1;
	    }
	    is_next = (rc1==count) ? 1 : 0;

	    // Highlight if first in seciton.
	    if (fk && is_next && (!div.previousSibling || div.previousSibling.id.indexOf('r1-')==-1)) nrm(6,div.id);
	}

	// click redirect.
	// Yahoo event handler doesn't work all the time--weird.
	//	if (link2) YAHOO.util.Event.addListener(link2, "click", function(e){return nrl(e,this)});
	if (link2) link2.onclick=function(e){return nrl(e,this)};
	if (link3) link3.onclick=function(e){return nrl(e,this)};
	if (link4) link4.onclick=function(e){return nrl(e,this)};
	if (link5) link5.onclick=function(e){return nrl(e,this)};

	// For debugging.
//	if (link5) {
//	    console.log(link5);
//	    console.log(link5.onclick);
//	}


	if (type=='i') break;
    }


    // Powered by.
    if (type=='d' && items[0]['s'] && !d.getElementById('powered_by')) {

	DDG.first_source = items[0]['s'];

	// For debugging.
//	items[0]['s'] = 'test';

	div2 = d.createElement('div');
	div2.id = 'powered_by';

	if (count>5 && items[0]['s'] && items[0]['s'] != 'disco' && items[0]['s'] != 'boss' ) {

	    for (item in items) {
		if (items[item] && items[item]['s'] && items[item]['s'].indexOf('yandex')!=-1) items[0]['s'] = 'yandex';
	    }

	    div2.appendChild(d.createTextNode('Built by '));

	    // Our part.
	    if (nur) img = nur('','','/assets/attribution/duckduckgo.v101.png');

	    link = d.createElement('a');
	    link.href = '/about/';
	    link.target = '_blank';
	    link.appendChild(img);
	    link.onclick=function() {fl=1;};
	    div2.appendChild(link);

	    //	    items[0]['s']='yandex';
	    if (items[0]['s'].indexOf('yandex')!=-1) items[0]['s'] = 'yandex';
	    if (items[0]['s'].indexOf('boss')!=-1) items[0]['s'] = 'yahoo';

	    if (nur) img = nur('','','/assets/attribution/'+items[0]['s']+'.v101.png');

	    // In between us and them.
	    var div3 = d.createElement('div');
	    YAHOO.util.Dom.setStyle(div3,'margin-top','14px');
	    div2.appendChild(div3);

	    var div3 = d.createElement('div');
	    link = d.createElement('a');
	    link.href = 'http://help.duckduckgo.com/customer/portal/articles/216399';
	    link.target = '_blank';
	    link.innerHTML = 'In partnership with: ';
	    link.onclick=function() {fl=1;};
	    div3.appendChild(link);
	    YAHOO.util.Dom.setStyle(div3,'float','left');
	    YAHOO.util.Dom.setStyle(div3,'margin-top','3px');
	    if (items[0]['s'] == 'blekko') YAHOO.util.Dom.setStyle(div3,'margin-top','0px');
	    if (items[0]['s'] == 'yahoo') YAHOO.util.Dom.setStyle(div3,'margin-top','2px');
	    if (items[0]['s'] == 'bing') YAHOO.util.Dom.setStyle(div3,'margin-top','0px');

	    div2.appendChild(div3);

	    link = d.createElement('a');
	    link.href = '/'+items[0]['s']+'/';
	    link.target = '_blank';
	    link.appendChild(img);
	    link.onclick=function() {fl=1;};
	    div2.appendChild(link);

	    // Clear div at bottom.
	    var div3 = d.createElement('div');
	    YAHOO.util.Dom.addClass(div3,'clear');
	    div2.appendChild(div3);

	    div = d.getElementById('side_powered_by_wrapper');
	    if (div) {
		div.appendChild(div2);
		y = YAHOO.util.Dom.getY(div2);

		YAHOO.util.Dom.addClass(div,'border');
		YAHOO.util.Dom.removeClass(div,'hide');
		YAHOO.util.Dom.setStyle(div,'margin-top','35px');
	    }
	}
    }

    // Set counts.
    if (col_num=='a') {
	r3c=count;
    } else {
	r1c=count;
    }

    // Make sure images are seen.
    if (!ip) window.scrollBy(0,1);

    // Affiliate ad, before zero out.
    if (is_first && ad_item) {
	ad_item = items[ad_item];

	DDG.default_ad = [{
		"a" : ad_item['a'].substring(0,100) + '...',
		"d" : ad_item['d'],
		"m" : 0,
		"s" : 'skimlinks',
		"p" : 1,
		"c" : DDG.make_skimlink(ad_item['c']),
		"u" : DDG.make_skimlink(ad_item['u']),
		"h" : 0,
		"k" : 0,
		"i" : 1,
		"t" : ad_item['t']
	}];


	// If we didn't get an ad from the ad server, but 
	// we have an ad here than show it.
	if (DDG.is_default_ad_loaded) DDG.show_default_ad();
	else setTimeout('DDG.show_default_ad()',500);
	//	console.log(DDG.default_ad);
	//	console.log(items[ad_item]);
    }

    // Zero out items.
    items = null;

    // Set mouseovers and such.
    if (nir) nir(type);

    // Show images if visible.
    if (type=='d' && YAHOO.util.Dom.getStyle(ocol, 'display')=='block' && ocol.event) nua('nse',ocol,200);

    // Show bang suggestions.
    if (type=='d') DDG.show_bang_suggestions();

    // Reset padding for results blocks.
    DDG.set_results_spacing();

    // Grab embeds.
    //    alert(YAHOO.util.FlashDetect.installed);
    //    console.log(embed);
    if (embed && (!kb || kb!='n') && (YAHOO.util.FlashDetect.installed || ip || ia)) {

	// For debugging.
//	console.log(embed);

	nrj('/ie/?urls='+embed+'&maxwidth=600&format=json&wmode=window&callback=nreb&autoplay=1');
    }

    // Grab wot ratings.
    if (wot) {
	nrj('/o.js?d='+wot+(kf&&kf=='b' ? '&t=b' : ''));
    }

    // For debugging.
//  console.log('amazon: '+amazon);
//  console.log('zero_click_answer style: '+YAHOO.util.Dom.getStyle('zero_click_answer','display'));
//  console.log('is_first: '+is_first);
//  console.log('kz: '+kz);
//  console.log('!nux(): '+!nux());
//    console.log(is_first);
    //    console.log(iwa);
    //    console.log(iqa);
    //    console.log(iqm);
    //    console.log('test');

    // Mark done.
    if (is_first) {
	DDG.is_deep_loaded = DDG.get_now();
    }

    // Fire triggers.
    if (is_first && !iwa && !iqa && !iqm && (!kz || kz==1) && (!rt || rt!='E')) {
	//console.log('fire triggers!');

        // Triggers not to display with other things.
	if (rt != 'D' && !nux()) {

	    /*console.log(amazon2);
	    console.log(amazon);
	    console.log('k1: '+k1);
	    console.log('isLyrics: '+isLyrics);*/

	    // Amazon.
	    // 2012.10.07 turn off amazon2 since too slow and having associates issues
	    if (0 && (amazon || amazon2) && (!k1 || k1 != '-1') && !isLyrics) {
		nrj('/m.js?q='+rq+(rt ? '&t='+rt : '')+'&l='+rl+(amazon ? '&i='+amazon : '')+(amazon2 ? '&c='+amazon2 : '')+(ra ? '&a='+ra : ''));
		if (amazon) YAHOO.util.Dom.setStyle(d.getElementById('zero_click_wrapper'),'display','block'); // Leave some room.
		is_amazon = 1;
	    }	
	}
    }

    // For debugging.
//    alert(is_eof);

    if (is_eof2 && is_eof2==1) {
	nrj('/l.js?q='+rq);
    }

    // See if we need to display even more.
    if (nrb) nrb();
}


function nrj(url,sync) {

//    console.log(url);

    var script,scripts;
    script = d.createElement('script');
    script.type='text/javascript';
    if (!sync) {
	script.async = true;
    } else {
	script.async = false;
    }
    script.src = url;

    scripts = document.getElementsByTagName('script')[0];
    scripts.parentNode.insertBefore(script, scripts);

    return script;
    // Old way.
//    d.getElementsByTagName("head")[0].appendChild(x);
}

// Dynamically add CSS file.
function nrc(url) {

//    console.log(url);

    var script,scripts;
    script = d.createElement('link');
    script.type='text/css';
    script.rel='stylesheet';
    script.async = true;
    script.href = url;
    script.media = 'screen';

    scripts = document.getElementsByTagName('head')[0];
    scripts.parentNode.insertBefore(script, scripts);

    // Old way.
//    d.getElementsByTagName("head")[0].appendChild(x);
}


// Stops an event.
function nue(e) {

    // For debugging.
    //    alert('test');

    if (e.preventDefault) {

	// For debugging.
	//	alert('test');

	e.preventDefault()
	e.stopPropagation();

    } else {

	// For debugging.
	//	alert('test');
	//	alert(e.cancelBubble);
	//	alert(e.returnValue);

	e.cancelBubble = true;
	e.returnValue = false;
    }
}

// Creates image group and custom event trigger.
function nut(div) {

    // If already defined.
    if (div.event) {

	// If already shown, make sure it is fired.
	if (YAHOO.util.Dom.getStyle(div, 'display')=='block') nua('nse',div,200);
	else return false; // Otherwise skip.
    }

    // New click event.
    div.event=new YAHOO.util.CustomEvent('it');
    var ig1=new YAHOO.util.ImageLoader.group(div,'click');
    ig1.addCustomTrigger(div.event);
    div.ig = ig1;
}


// Creates and registered an image.
function nur(ig1,title,src,height,width) {
    var img = d.createElement('img');
    if (title) img.title=title;
    img.alt='';
    img.id='i'+(++ric);
    if (!ig1) {

	// For debugging.
//	console.log(src);

	img.src = src;
	if (height && width) {
	    img.height = height;
	    img.width = width;
	}
	YAHOO.util.Dom.setStyle(img,'visibility','visible');
    } else {

	// For debugging.
//	console.log(src);

	nus(ig1,ric,src,height,width);
    }
    return img;
}

// Registers image
function nus(ig1,num,src,height,width) {
    if (!ig1) {
	ig1=new YAHOO.util.ImageLoader.group('content_wrapper','mousemove',0.1);
	ig1.addTrigger('header_wrapper','mousemove',0.1);
	ig1.addTrigger(window,'scroll',0.1);
    }
    var ti=ig1.registerSrcImage('i'+num,src,width,height);ti.setVisible=true;
}

// Shows dots on loading... pages.
function nsd () {
  cd++;
  if (cd<50) {
    d.getElementById("o").innerHTML+='.';
  }
}

// Shows hidden result sections.
function nsr(t,inner,initial_state) {
    var rc1,rc2,re,re2,rf,rb,r1,r2,r3,script,is_new_section,img,is_next;
    is_new_section = 0;

    // For debugging.
    //    alert('test');
    //    console.log('test');

    re = new RegExp('^r[lr](.*)-(\\d+)$');
    t=t.parentNode;

    if (t.id && re.test(t.id)) {
	rf = RegExp.$1 || 0;
	rb = RegExp.$2 || 0;
    }

    if (rf && rb) {

	// For debugging.
	//	console.log(rf+' '+rb);
	//	alert(rf+' '+rb);

	// Prevent double firings.
	if (tn==t.id) return false;
	tn = t.id;

	// For debugging.
	//	alert(rc.id);

	is_next=rc1=rc2=0;
	re2 = new RegExp('^r1-(\\d+)$');
	if (rc && re2.test(rc.id)) {
	    rc1 = RegExp.$1;
	}
	if (t.previousSibling && re2.test(t.previousSibling.id)) {
	    rc2 = RegExp.$1;
	}

	// For debugging.
	//	alert(rc1+' '+rc2);

	is_next = rc1 && rc2 && parseInt(rc1)==parseInt(rc2)+1 ? 1 : 0;
	if (!fk) is_next = 2;


	// For debugging.
	//alert(is_next);

	r1 = d.getElementById("rl"+rf+'-'+rb);
	r2 = d.getElementById("rr"+rf+'-'+rb);
	r3 = d.getElementById("rl"+rf+'-'+(parseInt(rb)+1));

	// For debugging.
	//	is_next = 0;
	//console.log(r1+' '+r2+' '+r3);
	//	alert('test');
//	console.log(rf+' '+rb);


	// Don't show if first section or r2.
	if ((kv && (kv=='1' || kv=='n' || kv=='l')) && rds != 0 && (rds != 1 || r1hc) && rf && rf.indexOf('i')==-1) {
	    if (kv=='n') r1.innerHTML='<hr class="page_count_post" size="1" style="width: 85%;" noshade><div class="clear"></div>';
	    else if (kv=='l') r1.innerHTML='<div class="page_count">&nbsp;&nbsp;page ' + (++rpc) + '&nbsp;&nbsp;</div><div class="clear"></div>';
	    else r1.innerHTML='<hr class="page_count_pre" size="1" noshade><div class="page_count">&nbsp;&nbsp;page ' + (++rpc) + '&nbsp;&nbsp;</div><hr class="page_count_post" size="1" noshade>&nbsp<div class="clear"></div>';
	    r1.onmouseover=function() {};
	    r1.onmouseout=function() {};
	    r1.onclick=function() {};
	    YAHOO.util.Dom.removeClass(r1,'highilghtd');
	    YAHOO.util.Dom.removeClass(r1,'links_deep');
	    YAHOO.util.Dom.setStyle(r1,'width','99%');
	    YAHOO.util.Dom.setStyle(r1,'padding-top','4px');
	    YAHOO.util.Dom.setStyle(r1,'padding-bottom','1px');
	} else {
	    YAHOO.util.Dom.setStyle(r1,'display','none');
	}

	// Fire favicon show event if exists.
	if (r2.event) nua('nse',r2,200);

	// Display results.
	r2.style.display = "block";

	// If we didn't come from an inner result, or on the last section,
	// then show the last more link.
	if (r3 && !inner) {
	    YAHOO.util.Dom.setStyle(r3,'display','block');


	// Otherwise if there are no more results, load another deep section.
	} else if (!r3 && (rf=='d' || (rf=='e0' && !fd))) {

	    // Loading gif.
	    img = d.createElement('img');
	    img.src = '/l.gif';
	    img.id = 'loading';
	    r2.parentNode.appendChild(img);
	    tl=img;

	    if (rv=='d') rv='';

	    // For debugging.
//	    console.log(fd);

	    script = d.createElement('script');
	    script.src='/?duckduckhack_ignore=1&q='+rq+(rt ? '&t='+rt : '')+(rv ? '&v='+rv : '')+'&l='+rl+(rp && rp != '-1' ? '&p=1' : '')+'&s='+rds+(ra ? '&a='+ra : '');
	    script.type='text/javascript';


	    // For debugging.
	    //console.log(script.src);
	    //	    alert(script.src);


	    // For the next call.
	    // Needs to be done before call,
	    // or IE won't update in time.
	    if (rds) rds+=50;
	    else rds+=30;

	    d.getElementsByTagName("head")[0].appendChild(script);

	    // We made a new section.
	    is_new_section = 1;

	}


	/*
	  If we hit the more link,
	  give the next result focus,
	  and force a scroll to the middle.
	  Also, give the keyboard focus,
	  so the mouse doesn't mess up the highlighting.

	  Don't do this if we are setting initial state
	  because soemthing will already be highlighted.

	  2008.09.20.  Turning off auto-scroll--too distracting.
	  Will re-evaluate if it is useful in certain situations.
	 */
	//	if (!inner && !initial_state && (r3 || is_new_section || r2.childNodes.length>2)) {
	if (!inner && !initial_state && is_next==1) {

	    // For debugging.
	    //alert('test');
	    //	    alert(t.nextSibling.firstChild);

	    if (t.nextSibling.firstChild) {

		// For debugging.
		//alert(t.id);
		//alert(t.nextSibling.firstChild.id);
		//		fk=1;
		//		alert('test');

		nrm(6,t.nextSibling.firstChild.id);
	    }
	}
    }
}

// Installs DDG in search bar.
function nui(skip) {
    var agent=navigator.userAgent.toLowerCase();

    // Hide link.
    // No longer needed as not in top links.
//    if (!kr || kr=='1') YAHOO.util.Cookie.set('r', 'b', { expires: new Date("January 12, 2025") });

//	console.log(kh);
//	alert(kh);

    if (!skip && w.external && ("AddSearchProvider" in w.external)) {

	// 2012.06.03 -- trying SSL as default install here.
	//	if (issl || (kh&&kh=='1')) w.external.AddSearchProvider(gd+"opensearch_ssl.xml");
	//	else w.external.AddSearchProvider(gd+"opensearch.xml");
	w.external.AddSearchProvider(gd+"opensearch_ssl.xml");
	setTimeout('top.location.replace(gd)',10);
    }
}




// Initilize search box text.
/* NO LONGER NEEDED as in $referer_query in Index.pm
function nix() {
    var search_box,re;
    re = new RegExp('http:\/\/(?:duckduckgo\\.com|localhost|127\\.0\\.0\\.1)');

    // If external referrer
    if (d.referrer && !re.test(d.referrer)) {
	search_box = (d.x ? d.x.q : '');
	search_box.value = '';
    }
}
*/

/*
  Initialize function to set up onmouseover, omouseout, and onclick events
  for divs that get highligted (those with highlight classes).
 */
nir = function(type) {
    var x,re,link_num,i,cname,links,j;
    if (!type) type='';
    cname = 'highlight_' + type;
    x = d.getElementsByTagName("div");
    re = new RegExp('(?:^|\\s+)' + cname + '(\\d?)' + '(?:\\s+|$)');

    // For debugging.
//    alert(type);

    for (i=0; i<x.length; i++) {

	//	console.log(x[i]);
	//	console.log(x[i].className);

	if (re.test(x[i].className) ) {

	    // For debugging.
	    //	    alert('test');
	    //	    if (type=='a') alert(x[i]);
//	    console.log(x[i].id);

	    // Skip if done already.
	    if (x[i].onmouseover) continue;

	    link_num = DDG.get_link_num(RegExp.$1);

	    // For debugging.
	    //	    console.log(x[i].className + ' ' + link_num);
//	    alert(rel);
//	    console.log(rel);

	    x[i].onmouseover=function(e) {

		// Skip mouse event if keyboard or explore box has focus.
		if (fk || fe) return false;

		if (ky && ky==-1) return false;

		// Hide preview if exists and changed.
//		if (rc && rc!=this && dz) dz.hide();

		/* If something is already highlighted,
		   make sure it is unhighligted.  This
		   is needed because if the keyboard highlighted it,
		   or it was highligted initially,
		   a mouseout event may not be triggered.
		 */
		// For debugging.
//		alert(rc==this);

		if (rc && rc!=this) nua('nro',rc);

		// Highligt asyncrhonously.
		nua('nrv',this);

		// Mark as current result.
		rc=this;

	    }

	    x[i].onmouseout=function(e) {

		// Skip mouse event if keyboard or explore box has focus.
		if (fk || fe) return false;

		if (ky && ky==-1) return false;

		// Hide preview if exists and changed.
//		if (rc && rc!=this && dz) dz.hide();

		// Unhihglight asynchronously.
		if (e && e.clientX) nua('nro',this,'','','',e.clientX,e.clientY);
		else nua('nro',this);
	    }

	    /* If the regex said the first link is not to be used,
	       then set the onclick to go to the second one.

	       2010.03.23 DROPPED THIS BECAUSE OF KEYBOARD NAV CLICKS
	       Also, unhihglight onclick because Safari will
	       keep it highlighted if the user goes back.
	    */
	    if (link_num==-1) {
		x[i].onclick=function(e) {
		    if (!fe) nrg(this,-1,e,0);
		}

	    } else if (link_num==2) {
		x[i].onclick=function(e) {
		    // Skip if explore box has focus.
		    if (!fe) nrg(this,2,e,0);
		}

	    } else if (link_num==1) {
		x[i].onclick=function(e) {
		    // Skip if explore box has focus.
		    if (!fe) nrg(this,1,e,0);
		}

	    } else {
		x[i].onclick=function(e) {

		    // For degbugging.

		    //		    return false;

		    // Skip if explore box has focus.
		    if (!fe) nrg(this,0,e,0);

		    //		    this.className=this.className.replace(new RegExp(" highlight\\b"), "");
		}
	    }

	    // For debugging.
//	    alert(type);

	    // Set titles and onclicks for main results.
	    if (!type || type=='a') {

		//		console.log(x[i]);

		links = x[i].getElementsByTagName('a');

		// For debugging.
//		if (type=='a') {
//		    alert(links.length);
//		}

		for (j=0;j<links.length;j++) {

		    // For debugging.
		    //		    console.log( x[i].id);

		    // For debugging.
		    // No tool tips.
		    //		    links[j].title=links[j].href;
		    //		    console.log(links[j].href + ' ' + links[j].onclick + ' ' + links[j].title);
		    //		    console.log(links[j].innerHTML);
		    //		    console.log(links[j].id);

		    // Click redirect.
		    // Yahoo event handler doesn't work all the time--weird.
		    //		    if (!links[j].onclick) YAHOO.util.Event.addListener(links[j], "click", function(e){return nrl(e,this);});
		    if (!links[j].onclick && !rs) {
			links[j].onclick=function(e){this.blur();return nrl(e||window.event,this);}

		    } else if (!links[j].onclick) {
			links[j].onclick=function(){this.blur();fl=1;};
		    }

		    if (kn && kn=='1' && links[j].href && links[j].href != 'javascript:;' && links[j].getAttribute("href").indexOf('http')!=-1) {
			links[j].target='_blank';

			// For debugging.
//			console.log(links[j].href + ' ' + links[j].onclick);
//			console.log(links[j].href);
//			console.log('test');
		    }


		    // For debugging.
//		    console.log(links[j].href + ' ' + links[j].onclick);
		}
	    }
	}
    }
}


// Side-bar map initilization.
function nim(zoom,lat,lon,search) {
    var div,links,width,div2,img,link;

    if (DDG.is_side_map) return false;
    if (DDG.is_top_map) return false;
    if (!search) search = DDG.OSM_lat_lon_search(lat,lon);

    div = d.getElementById('side');
    links = d.getElementById('links');
    nuv();

	    // For debugging.
//    console.log(viewport_width);
//    console.log(YAHOO.util.Dom.getX(div));

    if (div && !d.getElementById('side_map') && YAHOO.util.Dom.getStyle(div,'display')=='block' && viewport_width>1000) {

	div2 = d.createElement('div');
	div2.id = 'side_map';
	img = d.createElement('img');
	img.id = 'side_map_img';

	width = ie6 ? 130 : viewport_width - YAHOO.util.Dom.getX(links) - links.scrollWidth - 100;
	img.src = '/imq2/?size='+width+',200&zoom='+zoom+'&center='+ lat +','+ lon +'&imageType=jpg&mcenter='+lat+','+lon;
	YAHOO.util.Dom.setStyle(div,'width',width+'px');
	//	YAHOO.util.Dom.setStyle(img,'margin-top','10px');

	link = d.createElement('a');
	link.href = 'http://open.mapquest.com/?q='+search;
	link.appendChild(img);
	link.onclick=function() {fl=1;};
	div2.appendChild(link);

	YAHOO.util.Dom.addClass(div2,'border');

	div.insertBefore(div2,div.firstChild);

	nua('DDG.resize','',10);

	DDG.is_side_map = 1;
    }
}


// Add to browser initialization.
function nib(fallback,cla,pre,post,force,homepage) {

    // For debugging.
//    console.log(cla + ' ' + pre + ' ' + post + ' ' + force + ' ' + homepage);

    var agent,label,directions,href,home,onclick,id,html;
    agent=navigator.userAgent.toLowerCase();
    home=label=onclick=href=directions='';
    if (!post) post = '';
    if (!homepage) homepage=0;

    // 2013.02.02 no longer top links so not needed. https://app.asana.com/0/inbox/137252944993/3817811856217/3903844914973
    //    if (!force && kr && kr!='1') return false;

    // ipad and andriod first since they go to app store.
    if(/ipad/.test(agent)) label='iPad';
    else if (/android/.test(agent)) label='Android';
    else if (/xbox/.test(agent)) label='xBox';
    else if (/midori/.test(agent)) label='Midori';
    else if (/chrome/.test(agent)) label='Chrome';
    else if (/fennec/.test(agent)) label='Fennec';
    else if (/seamonkey/.test(agent)) label='SeaMonkey';
    else if (/iceape/.test(agent)) label='Iceape';
    else if (/maxthon/.test(agent)) label='Maxthon';
    else if (/epiphany/.test(agent)) label='Epiphany';
    else if (/firefox/.test(agent)) label='Firefox';
    else if (/uzbl/.test(agent)) label='Uzbl';
    else if (/msie 6/.test(agent)) label='IE6';
    // 20121119 (caine): this is a best guess here.
    // Metro only runs in full screen mode and in 64bit
    // There is an (unlikely) case where a user could be running
    // desktop IE10 in 64bit mode and FS mode.
    // http://www.codeproject.com/Articles/269356/Internet-Explorer-10-User-Agent-Strings-On-Windows?display=Print
    else if (/msie 10.*win64/.test(agent) && window.innerWidth == screen.width && window.innerHeight == screen.height) label='IEMetro';
    else if (/msie [78910]/.test(agent)) label='IE';
    else if (/opera/.test(agent)) label='Opera';
    else if(/iphone/.test(agent)) label='iPhone';
    else if(/arora/.test(agent)) label='Arora';
    else if(/safari/.test(agent)) label='Safari';
    else{label='Browser'};

    if (is_silk) label = '';

    home = 'duckduckgo.com';
    if (w.k3u) home += '/tw/'+k3u;
    else if (k3) home += '/tw/'+k3;

    // For debugging.
//    alert('label: '+label);
//    alert(RegExp.$1); //IEMetro
//    alert("IsSubscribed" in w.external);
//    alert(gd);
//    alert(w.external.IsSearchProviderInstalled(gd)==true);

    // Can't do this check first because it messes up locked down IE computers.
//    if(!homepage && label && label!='Chrome' && w.external&&(('IsSearchProviderInstalled' in w.external && w.external.IsSearchProviderInstalled(gd)==false)||(!('IsSearchProviderInstalled' in w.external)&&'AddSearchProvider' in w.external))) {

    if (label=='IE' && !homepage) {
	directions = '<a target="_blank" href="javascript:;" onclick="nui()" class="add icon">Install IE search provider</a>';

    } else if (label=='IEMetro' && !homepage) {
	directions = '<a target="_blank" href="http://www.iegallery.com/en-US/Addons/Details/10202" class="add icon">Install IE search provider</a>';

    } else if (document.all || (label=='IE' && homepage)) {
	directions = '<a target="_blank" href="javascript:;" onclick="this.style.behavior=\'url(http://duckduckgo.com/#default#homepage)\';this.setHomePage(\'http://duckduckgo.com/\');" class="add icon">Install IE homepage</a>';

    } else if (label=='Firefox' && homepage) {
	directions = '<a href="http://'+home+'" class="add icon">Drag to toolbar home icon</a> <a target="_blank" href="http://help.duckduckgo.com/customer/portal/articles/216441/" class="more icon">More ways to add DDG</a>';

    } else if (label=='Firefox') {
	directions = '<a target="_blank" href="https://addons.mozilla.org/en-US/firefox/addon/duckduckgo-for-firefox/" class="add icon">Install Firefox add-on</a> <a target="_blank" href="http://help.duckduckgo.com/customer/portal/articles/216441/" class="more icon">More ways to add DDG</a>';

    } else if (label=='Chrome' && homepage) {
	directions = '<a target="_blank" href="https://chrome.google.com/webstore/detail/duckduckgo-home-page/ljkalbbbffedallekgkdheknngopfhif" class="add icon">Install Chrome home icon</a> <a target="_blank" href="http://help.duckduckgo.com/customer/portal/articles/216440/" class="more icon">More ways to add DDG</a>';

    } else if (label=='Chrome') {
	directions = '<a target="_blank" href="https://chrome.google.com/webstore/detail/duckduckgo-for-chrome/bpphkkgodbfncbcpgopijlfakfgmclao" class="add icon">Install Chrome extension</a> <a target="_blank" href="http://help.duckduckgo.com/customer/portal/articles/216440/" class="more icon">More ways to add DDG</a>';

    } else if (label=='Arora' && !homepage) {
	directions = '1. Click the magnifying glass in the search bar (upper right).<br><br>2. Click Add DuckDuckGo (bottom).<br><br>3. Click Yes.<br><br>4. Click the magnifying glass again.<br><br>5. Select DuckDuckGo from the drop down.';

    } else if (label=='Android' && !homepage) {
	href="market://details?id=com.duckduckgo.mobile.android";
	onclick=";"

    } else if ((label=='iPhone' || label=='iPad') && !homepage) {
	href="http://itunes.apple.com/us/app/id479988136?mt=8";
	onclick=";"

    } else if ((label=='SeaMonkey'||label=='Iceape') && !homepage) {
	href="https://addons.mozilla.org/seamonkey/addon/duckduckgo-ssl/"
	onclick=";"

    } else if (label=='Maxthon' && !homepage) {
	directions = '1. Go to Options.<br><br>2. Go to Search Engine.<br><br>3. Click add.<br><br>4. Name: DuckDuckGo<br>4b) URL: http://duckduckgo.com/?q=%s<br>4c) Alias: d<br><br>5. Click OK!';

    } else if (label=='Safari' && homepage) {

	if (/mac/.test(agent)) {
	    directions = '1. Click Safari on the top left.<br><br>2. Select Preferences.<br><br>3. Under the General tab, click Set to Current Page.<br><br>4. Close Window.';
	} else {
	    directions = '1. Click the gears icon in the browser toolbar (top right).<br><br>2. Select Preferences.<br><br>3. Click the General tab.<br><br>4. Where it says Home page click Set to Current Page.<br><br>5. If you want, select Home Page next to New windows and New tabs (open with).<br><br>6. Close window.';
	}

    } else if (label=='Safari') {

	//duckduckgo.com/extensions/duckduckgo.safariextz
	if (ih5) directions = '<a href="https://duckduckgo.com/extensions/duckduckgo.safariextz" target="com.duckduckgo.safari-HKE973VLUW" class="add icon">Install Safari extension</a> <a target="_blank" href="http://help.duckduckgo.com/customer/portal/articles/216447-safari" class="more icon">More ways to add DDG</a>';
	else directions = '<a target="_blank" href="http://www.machangout.com/" class="add icon">Install Glims</a> <a target="_blank" href="http://help.duckduckgo.com/customer/portal/articles/216447-safari" class="more icon">More ways to add DDG</a>';

    } else if (label=='Opera' && homepage) {
	directions = '<a href="https://addons.opera.com/en/extensions/details/duckduckgo-speed-dial/" target="_blank" class="add icon">Install Opera Speed Dial</a> <a target="_blank" href="http://help.duckduckgo.com/customer/portal/articles/216453" class="more icon">More ways to add DDG</a>';

    } else if (label=='Opera') {
	directions = '<a href="https://addons.opera.com/en/extensions/details/duckduckgo-for-opera-2/" target="_blank" class="add icon">Install our Opera add-on</a> <a target="_blank" href="http://help.duckduckgo.com/customer/portal/articles/216453" class="more icon">More ways to add DDG</a>';

    } else {
	label = '';

    };

    if (label) {
	if (homepage) {
	    label = l('Set as Homepage');
	    id = 'add_to_browser_homepage';
		id2 = 'add_to_browser';
	} else {
	    // 2013.02.17 took out non-breaking space since adds a weird space between it and say a period after.
	    if (label=='Android' || label=='iPhone') label = 'Get App';
	    //	    else label = 'Add to '+label;
	    // 2012.08.23 add to browser everywhere.
	    else label = l('Add to Browser');
	    id = 'add_to_browser';
		id2 = 'add_to_browser_homepage';
	}

	html = '';
	clickfunc = 'DDG.mv_elem(\''+id+'\',\'trig_'+id+'\');DDG.toggleall(\'grp_modal\',-1,\''+id+'\');DDG.toggle(\''+id+'\')';
	hoverfunc = 'DDG.mv_elem(\''+id+'\',\'trig_'+id+'\');DDG.toggleall(\'grp_modal\',-1);DDG.toggle(\''+id+'\')'

	if (!onclick) html = ('<h4>'+label+'</h4>'+directions);
	// [<a href="javascript:;" onclick="YAHOO.util.Dom.setStyle(document.getElementById(\''+id+'\'),\'display\',\'none\');">X</a>]	
	if ((!w.k3u) && (!onclick) && (!href)) document.write('<span class="modal_trig" id="trig_'+id+'"></span>'+pre+'<a href="');
	else document.write(pre+'<a href="');
	if (href) document.write(href);
	else document.write('javascript:;');
	document.write('" class="'+cla+'" onclick="');
	if (onclick) document.write(onclick);
	/*else document.write('DDG.mv_elem(\''+id+'\',\'trig_'+id+'\');DDG.toggle(\'more_menu\',-1);DDG.toggle(\''+id2+'\',-1);DDG.toggle(\''+id+'\')');*/
	else document.write(clickfunc);
	if (d.getElementById('footer_homepage')) { document.write('" onmouseover ="'+hoverfunc); }
	if (w.k3u) document.write(';YAHOO.util.Cookie.set(\'3\', k3u, { path: \'/\', expires: new Date(\'January 12, 2025\') });');	
	document.write('">'+label+'</a>'+post);

	// For dubgging.
	//	console.log(id);

	if (d.getElementById(id)) {
	    d.getElementById(id).innerHTML = html;

	    // For debugging.
//	    console.log(html);
	} else {
	    document.write('<div id="'+id+'" class="cnib modal grp_modal">'+html+'</div>');
	}
    }
}

// Remove loading gif.
function nsl() {
    var x = d.getElementById('loading');
    if (x && x.id) {
	x.parentNode.removeChild(x);
    } else if (tl && tl.id) {
	if (tl.parentNode) tl.parentNode.removeChild(tl);
	tl='';
    }
}

// Fire image event.
function nse(o) {
    if (!o || !o.event) return;
    o.event.fire();
    o.event.is_fired=1;
}

// Zoom reload
/*
function nsz(aUrl) {
  var div,iframe,url,img;
  if (!fz) return;
  if (aUrl) url=decodeURIComponent(aUrl);
  else url=tz.curl;
  if (!url) return;
  dz = new YAHOO.widget.Panel("zoom", {
	  width:"500px",
	  height:"350px",
	  //	  fixedcenter:true,
	  //	  context:["sd","tl","bl",,[0,25]],
	  context:[tz,"tl","tl",,[25,-15]],
	  constraintoviewport:true,
	  underlay:"none",
	  effect:{effect:YAHOO.widget.ContainerEffect.FADE,duration:0.25},
	  close:true,
	  visible:true,
	  iframe:true,
	  draggable:false} );
  dz.setHeader('<img src="/zoom.v102.png" style="float:left;margin-top:6px;margin-right:6px;"> <b><font color="#888888">Take a Peek!</font></b> <div style="float:right;padding-right:40px;"><a href="'+url+'">Go to Site</a></div>');
  div = d.createElement('div');
  YAHOO.util.Dom.setStyle(div,'height','100%');
  YAHOO.util.Dom.setStyle(div,'background','#FFF');
  img = d.createElement('img');
  img.src = '/l.gif';
  img.id = 'lz';
  tlz=img;
  iframe = d.createElement('iframe');
  iframe.src='/r.html?u='+encodeURIComponent(url)+'&q='+rq;
  YAHOO.util.Dom.setStyle(iframe,'height','260px');
  YAHOO.util.Dom.setStyle(iframe,'width','100%');
  YAHOO.util.Dom.setStyle(iframe,'border','0');
  div.appendChild(img);
  div.appendChild(iframe);
  dz.setBody(div);
  dz.setFooter('<a href="'+url+'"><b>Click here</b></a> to go to the Web page.');
  dz.render(document.body);
  fz=0;
}
*/

function not(){
    document.y.action='http://www.gabrielweinberg.com/';
    setTimeout('document.y.submit()');
}

// Keyboard shortcut initializations.
function nik(homepage) {
    // Doesn't work if you keep reassinging one variable.
    var kl1,kl2,kl3,kl4,kl5,kl6,kl7,kl8,kl9,kl10,kl11,kl12,kl13,kl14,kl15,kl16,kl17,kl18,kl19,kl20,kl21;

    // For debugging.
    //    alert('test');

    if (!homepage) {

	kl1 = new YAHOO.util.KeyListener(document, { keys:[40,74] }, { fn:nkda } );
	kl1.enable();
	kl2 = new YAHOO.util.KeyListener(document, { keys:[38,75] }, { fn:nkua } );
	kl2.enable();

	// intl /
	if (!im) {
	    k3 = new YAHOO.util.KeyListener(document, { shift:true, keys:[191] }, { fn:nks } );
	    k3.enable();
	    kl4 = new YAHOO.util.KeyListener(document, { keys:[191] }, { fn:nks } );
	    kl4.enable();
	}

	kl19 = new YAHOO.util.KeyListener(document, { keys:[79] }, { fn:nko } );
	kl19.enable();
	kl6 = new YAHOO.util.KeyListener(document, { keys:[76] }, { fn:nko } );
	kl6.enable();
	kl7 = new YAHOO.util.KeyListener(document, { keys:[111,72] }, { fn:nks } );
	kl7.enable();
	kl8 = new YAHOO.util.KeyListener(document, { keys:[222] }, { fn:nkn } );
	kl8.enable();
	kl9 = new YAHOO.util.KeyListener(document, { keys:[73] }, { fn:nki } );
	kl9.enable();
	kl10 = new YAHOO.util.KeyListener(document, { keys:[82] }, { fn:nkr } );
	kl10.enable();
	kl11 = new YAHOO.util.KeyListener(document, { keys:[86] }, { fn:nkn } );
	kl11.enable();
	kl12 = new YAHOO.util.KeyListener(document, { keys:[32] }, { fn:nksb } );
	kl12.enable();
	kl13 = new YAHOO.util.KeyListener(document, { keys:[77] }, { fn:nkm } );
	kl13.enable();
	kl14 = new YAHOO.util.KeyListener(document, { keys:[70] }, { fn:not } );
	kl14.enable();
	kl18 = new YAHOO.util.KeyListener(document, { keys:[83] }, { fn:nksp } );
	kl18.enable();
    }

    // Enter.
    kl5 = new YAHOO.util.KeyListener(document, { keys:[13] }, { fn:nke } );
    kl5.enable();
    kl15 = new YAHOO.util.KeyListener(document, { keys:[27] }, { fn:nkes } );
    kl15.enable();
    kl20 = new YAHOO.util.KeyListener(document, { keys:[84] }, { fn:nkt } );
    kl20.enable();

    if (!io) {
	kl16 = new YAHOO.util.KeyListener(document, { keys:[49] }, { fn:nkex } );
	kl16.enable();
    }

    kl17 = new YAHOO.util.KeyListener(document, { shift:true,keys:[49] }, { fn:nkex } );
    kl17.enable();

    kl21 = new YAHOO.util.KeyListener(document, { keys:[68] }, { fn:nkd } );
    kl21.enable();
}

// onkeyup
function ncku(e) {
   if (!ie && !e.metaKey) fa=0;
}

// onkeydown
function nckd(e) {
    if (!ie && e.metaKey) fa=1;

   // Needed for IE -- keypress doesn't work

   // Up/down arrows
   if (!fq && (!kk || kk=='1') && e.keyCode && (e.keyCode==40||e.keyCode==74||e.keyCode==38||e.keyCode==75)) {

       // For debugging.
       //alert('test');

       // Kill event so it doesn't trigger browser actions.
       if (e && (nkdc(e) || nkdm(e) || nkds(e) || nkdt(e) || fa)) ;
       else nue(e);
   }
}

// onkeypress
function nckp(e) {

    // Needed for Opera -- key down down work.

   // Skip control chars.


   //   alert('test');

   // Up/down arrows
   if (!fq && (!kk || kk=='1') && e.keyCode && (e.keyCode==40||e.keyCode==74||e.keyCode==38||e.keyCode==75)) {

       // For debugging.
       //alert('test');

       // Kill event so it doesn't trigger browser actions.
       if (e && (nkdc(e) || nkdm(e) || nkds(e) || nkdt(e) || fa)) ;
       else nue(e);
   }
}

// onmousedown
function ncf(e) {
    var target,id,position,position_id;

    fmx=e.clientX;
    fmy=e.clientY;

    // For debugging.
//    alert(e.button);
    //alert('test');

    // Set viewport dimensions.
    nuv();


    // Scrollbar button.
    // Detect if pressed and catches if the scrollbar is already
    // at the bottom.
    if (fmx>(viewport_width-100) && fmy>(parseInt(viewport_height)-17) ) {
	if (!il && nrb) nrb();
    }

    // For debugging.
//    alert(e.button);
    //    alert(nkds(e));



    target = '';
    if (ie) target = e.srcElement;
    else target = e.target;

    //    console.log(target.nodeName);
    //    console.log(target.id);

    // Hide menus.
	 //if (target && target.id && target.id.indexOf('header_button_menu')==-1) DDG.toggle('header_button_menu',-1)
    if (target && target.id) {
        /* depreciated with DDG.toggleall ...
		if (!target.id || target.id.indexOf('header_button_menu')==-1) DDG.toggle('header_button_menu',-1);
		if (!target.id || (target.id.indexOf('newbang')==-1 && target.id.indexOf('search_dropdown')==-1 && target.id.indexOf('search_dropdown_homepage')==-1)) DDG.toggle('newbang',-1);
		if (!target.id || target.id.indexOf('add_to_browser')==-1) DDG.toggle('add_to_browser',-1);
		if (!target.id || target.id.indexOf('add_to_browser_homepage')==-1) DDG.toggle('add_to_browser_homepage',-1);		
		if (!target.id || target.id.indexOf('more_menu')==-1) DDG.toggle('more_menu',-1);
		if (!target.id || target.id.indexOf('feedback_modal')==-1) DDG.toggle('feedback_modal',-1);
		*/		
		DDG.toggleall();
		if (target.id == 'report_bad_query_link') DDG.report_bad_query();
    }
	if (target.nodeName == "HTML" || target.nodeName == "BODY") {
		/*
		DDG.toggle('header_button_menu',-1);
		DDG.toggle('newbang',-1);
		DDG.toggle('add_to_browser',-1);
		DDG.toggle('add_to_browser_homepage',-1);
		DDG.toggle('more_menu',-1);
		*/
		DDG.toggleall();
	}

    position = target;
    while (position != window) {
	if (position.id) {
	    position_id = position.id;
	    break;
	} else if (position.parentNode) position=position.parentNode;
	else break;
    }
    if (!position_id) position_id = 'x';
    //    nutp('c-'+position_id);

    // Middle mouse won't fire with regular onclick events,
    // so we look generally.
    // Or shift click.
    if ( ( (e.button && (((!ie||ie9) && e.button==1) || (ie && e.button==4))) ) && rc && rc.id) {
	fm=1;

	// For debugging.
	//	alert(target.nodeName);
	//	alert(target.hostname);
	//	alert('test');
	//	return false;
	//	alert('test');

	while (target != window) {
	    if (target.nodeName && target.nodeName=='A') {

		// For debugging.
		//		alert(target.href);
		//alert('test');
		//		alert(fm);

		if (target.href=='javascript:;') {

		    // For debugging.
		    //alert('test');
		    target.onclick();

		    return false;

		// Firefox needs replacing on middle click bc onclick doesn't fire.
		} else if (kg!='p' && (!kd || kd==1) && target.href.indexOf('/k/?')==-1 && target.href.indexOf('/l/?')==-1) target.href='/k/?uddg='+encodeURIComponent(target.href);

		// For debugging.
		//alert(target.href);

		// Just go to the link (i.e. don't go to any other link at the same time).
		fl=1;

		break;
	    }

	    // For debugging.
	    //alert(target.nodeName);

	    id = target.id;
	    if (id) {
		if (id=='links') break;
		if (id==rc.id) {

		    // For debugging.
		    //		    alert('test2');

		    nrg(rc,0,e,1);
		}
	    }
	    if (target.parentNode) target=target.parentNode;
	    else break;
	}

    } else {
	fm=0;
    }

    // For debugging.
    //    alert(target.href);
    //    alert(target.href);
    //alert(fmy);
    //    if (dz) dz.hide();
}

//onmouseup
function ncg(e) {

    fmx=0;
    fmy=0;

    nuv();

    // For debugging.
    //    alert(viewport_width)
    //    console.log(viewport_width);

    // Scrollbar.
    // Detect if pressed and auto-load when released.
    // Only works in FF.
    if (e.clientX>(viewport_width-25)) {
	if (!il && nrb) nrb();
    }
}


/* Function to detect if the keyboard has focus or not.
   Note that we have to check for actual positions because
   IE will triggere a mousevent even if the position has
   not changed in some cases.  Also we have an initial condition
   of sx=sy=0 and fk=1 so that the keyboard has initial focus,
   and doing nothing with the mouse will not change that.
*/
//onmousemove
function nkf(e) {
   var temp_x,temp_y;

    // For debugging.
    //   alert('test');


  if (ie) {
    temp_x = e.clientX + d.body.scrollLeft
    temp_y = e.clientY + d.body.scrollTop
  } else {
    temp_x = e.pageX
    temp_y = e.pageY
  }
  if (fk && sx && sy && (sx!=temp_x||sy!=temp_y)) fk=0;
  sx=temp_x;sy=temp_y;
}

// Capture mouse events to set that the keyboard no longer has focus (fk).
var mousewheelevt=(/Firefox/i.test(navigator.userAgent))? "DOMMouseScroll" : "mousewheel";
if (document.attachEvent) document.attachEvent("on"+mousewheelevt, nkw)
else if (document.addEventListener) document.addEventListener(mousewheelevt, nkw, false)
function nkw(event) {

    // For debugging.
    //    alert('test');

    // Opera has auto-scroll disabled because cannot detect mousemovements on scrollbar
    // so call scroll function manually
    if (io && !il && nrb) nrb();

    // No keyboard focus.
    fk=0;
}


// Have to wait fo onDOMReady because IE will
// not populate the hidden form variable with the
// right variable until the DOM is finished.
// Same goes for top links.
function nis() {
    var div,width;

    setTimeout("idom=1;",250);

    // Ignore if keyboard has focus.
    if (fq) return false;

    // For debugging.
    //    setTimeout('alert(d.getElementById('state_hidden').value)',1000);

    // Grab state and highligh.
    var state = d.getElementById('state_hidden').value;

    // For debugging.
    //    alert(state);
    //    console.log(state);

    if (state) nhs(state);
    else rc = d.getElementById(DDG.first_result);

    // For debugging.
//    alert(state);
//    alert(rc);
//    alert(rc.id);
//    console.log(rc);

    // Done with state, allow scrolling.
    fs=0;

    // For debugging.
    // console.log(r1c + ' ' + il);
   //    console.log('state');
    //    alert(il);
    //    alert(nrb);

    // See if we need to add more.
    if (!il && nrb) nrb();
}

// Make an overlay play video.
function nuov (thumbnail_url,thumbnail_height,thumbnail_width,is_right,is_border,max_thumbnail_height,max_thumbnail_width,embed_height,embed_width,payload,embed_margin) {
    var div3,div2,img,img2,length

    div2 = d.createElement('div');
    YAHOO.util.Dom.addClass(div2, 'inline');
    if (is_right) {
	YAHOO.util.Dom.setStyle(div2,'clear','right');
	YAHOO.util.Dom.setStyle(div2,'float','right');
	YAHOO.util.Dom.setStyle(div2,'margin-left','10px');
    } else {
	YAHOO.util.Dom.setStyle(div2,'clear','left');
	YAHOO.util.Dom.setStyle(div2,'float','left');
	YAHOO.util.Dom.setStyle(div2,'margin-left','10px');
	YAHOO.util.Dom.setStyle(div2,'margin-right','10px');
    }
    if (is_border) {
	YAHOO.util.Dom.setStyle(div2,'border','1px solid #FFF');
    }

    if (nur) img = nur('','','/iu2/?u='+decodeURIComponent(thumbnail_url));
    if (img) {
	YAHOO.util.Dom.addClass(img,'inline');
	YAHOO.util.Dom.setStyle(img,'max-height',max_thumbnail_height + 'px');
	YAHOO.util.Dom.setStyle(img,'max-width',max_thumbnail_width + 'px');
	if (ie6) {
	    if (thumbnail_height>65) {
		YAHOO.util.Dom.setStyle(img,'height',max_thumbnail_height + 'px');
	    } else if (thumbnail_width>100) {
		YAHOO.util.Dom.setStyle(img,'width',max_thumbnail_width + 'px');
	    }
	}
	div2.appendChild(img);

	// For debugging.
	//		    alert('test');


	img2 = nur('','','/assets/icon_play.v101.png');
	if (img2) {
	    YAHOO.util.Dom.setStyle(img2,'z-index','100');

	    YAHOO.util.Dom.setStyle(img2,'margin','auto');

	    // For debugging.
//	    console.log(img.offsetHeight);

	    // Center of thumbnail.
	    YAHOO.util.Dom.setStyle(img2,'margin-top','-' + parseInt( (max_thumbnail_height/2) + 22 ) + 'px');
	    YAHOO.util.Dom.setStyle(img2,'margin-bottom',parseInt( (max_thumbnail_height/2) - 21) + 'px');

	    //			    YAHOO.util.Dom.setStyle(img2,'margin-left',Math.floor(embedly[i]['thumbnail_width']*(65/embedly[i]['thumbnail_height']))-33+'px');

	    div2.appendChild(img2);
	}

	length = nutr(payload);

	// Not needed now since embedly now dows this
	//			tr[l] = tr[l].replace( /(youtube.com[^\"]+)/g, "$1" + (tr[l].indexOf('?')==-1 ? '?' : '&') + 'autoplay=1' );
	//			tr[l] = tr[l].replace( /autoplay=false/ig, 'autoplay=true' );

	// For debugging.
	//			console.log(embedly[i]['html']);


	div2.embedly=length;
	div2.embedlyw=embed_width;
	div2.embedlyh=embed_height;
	div2.onclick=function() {
	    fl=1; // don't go to link.
	    var div = this.parentNode;
	    var tmp = this;
	    div.removeChild(this);
	    tmp.innerHTML = tr[tmp.embedly];
	    YAHOO.util.Dom.setStyle(tmp,'float','none');
	    YAHOO.util.Dom.removeClass(tmp, 'inline');
	    YAHOO.util.Dom.setStyle(tmp,'max-width','600px');
	    div2 = d.createElement('div');
	    YAHOO.util.Dom.setStyle(div2,'padding-top','5px');
	    tmp.onmouseout=function() {;};
	    tmp.onmouseover=function() {;};
	    YAHOO.util.Dom.setStyle(tmp,'border','none');

	    if (div.id && div.id=='side_map') {
		div = d.getElementById('content');
		div.insertBefore(tmp,div.firstChild);
		div.insertBefore(div2,div.firstChild);
	    } else {
		YAHOO.util.Dom.setStyle(tmp,'margin-left',embed_margin+'px');
		div.appendChild(div2);
		div.appendChild(tmp);
	    }
	};
	if (is_border) {
	    div2.onmouseover=function() {YAHOO.util.Dom.setStyle(this,'border','1px solid #ff6666');};
	    div2.onmouseout=function() {YAHOO.util.Dom.setStyle(this,'border','1px solid #FFF');};
	}
    }

    // For debugging.
//    console.log(div2.innerHTML);

    return div2;
}


// Make embedly.
function nreb(embedly) {
    var provider,embed,i,l,div,div2,img,img2,re,is_provider,re2,is_vid,is_pic,is_r3m,re3,num;
    re3 = new RegExp('^r1-(\\d+)$');

    for (i=0;i<embedly.length;i++) {
	div = d.getElementById(reb[rebc++]);

	// For debugging.
	//	alert(decodeURIComponent(rq));
	//	  alert(embedly[i]['type']);
	//	console.log(i);
	//	alert(div.id);
	//	console.log(rebc);
	//	console.log(reb.length);

	num = 0;
	if (div.id && re3.test(div.id)) {
	    num = RegExp.$1;

	    // For debugging.
//	    console.log("catch");
	}

	// For debugging
//	alert(num);
//	console.log(div.id);
//	console.log(num);

	provider = embedly[i]['provider_name'];
	if (!provider) continue;

	re = new RegExp(embedly[i]['provider_name'].replace(/^the/i,''),'i');

	is_provider=re.test(decodeURIComponent(rq)) ? true : false;

	// For debugging.
	//	re = new RegExp('highlight[a-z]?(\\d+)');
	//	alert(is_provider);
	//	alert(kb);

	if (div && (provider=='YouTube' || (embedly[i]['type']=='video' && embedly[i]['html'])) && ( !kb || (is_provider && kb=='d') || (kb && (kb=='e' || kb=='v')) ) ) {

	    // For debugging.
//	    alert('test');

//	    if (!is_vid) is_vid = -1;
	    if (!is_vid) is_vid = 1000;

	    // For debugging.
//	    console.log(is_vid);
//	    console.log(num);

	    if (embedly[i]['thumbnail_url']) {

		// Actual play.
		if ( ((!ip && !ia) || provider == 'YouTube') && embedly[i]['type']=='video' && embedly[i]['html']) {

		    div2 = nuov(embedly[i]['thumbnail_url'],embedly[i]['thumbnail_height'],embedly[i]['thumbnail_width'],!is_vid || is_vid !=-1 ? 1 : 0,1,65,100,embedly[i]['height'],embedly[i]['width'],embedly[i]['html'],29);

		    if (is_vid == -1) {
			is_vid = div2;
//			i--;
//			rebc--;
		    } else {

			// For debugging.
//			console.log(div.id);

			div.insertBefore(div2,div.firstChild);
		    }
		}
	    }

	} else if (div && embedly[i]['thumbnail_url'] && (!kb || kb=='d' || kb=='e' || kb=='t') ) {
	    div2 = d.createElement('div');
	    YAHOO.util.Dom.addClass(div2, 'inline');
	    YAHOO.util.Dom.setStyle(div2,'clear','right');
	    if (is_pic) {
		YAHOO.util.Dom.setStyle(div2,'float','right');
		YAHOO.util.Dom.setStyle(div2,'margin-left','10px');
	    }
            if (nur) img = nur('','','/iu2/?u='+decodeURIComponent(embedly[i]['thumbnail_url']));
	    if (img) {
		YAHOO.util.Dom.addClass(img,'inline');
		YAHOO.util.Dom.setStyle(img,'max-height','65px');
		YAHOO.util.Dom.setStyle(img,'max-width','100px');
		if (ie6) {
		    if (embedly[i]['thumbnail_height']>65) {
			YAHOO.util.Dom.setStyle(img,'height','65px');
		    } else if (embedly[i]['thumbnail_width']>100) {
			YAHOO.util.Dom.setStyle(img,'width','100px');
		    }
		}
		div2.appendChild(img);
		if (!is_pic) {
		    is_pic = div2;
		    i--;
		    rebc--;
		} else {
		    div.insertBefore(div2,div.firstChild);
		}
	    }
	}
    }

//    is_r3m = is_vid ? is_vid : (is_pic ? is_pic : 0);
/*
    is_r3m = is_vid ? is_vid : 0;
    if (is_r3m) {
	div2 = d.getElementById('side_map');
	if (!div2) {
	    div2 = d.createElement('div');
	    div2.id = 'side_map';
	    div2.appendChild(is_r3m);
	    div = d.getElementById('side');
	    if (div) div.insertBefore(div2,div.firstChild);
	}
    }
*/
}

// Keyboard shortcuts lefgend.
function nsk() {

    // Param override.
    if (kk && kk=='-1') return false;

    YAHOO.util.Dom.setStyle('keyboard_shortcuts','display','block');
    YAHOO.util.Dom.setStyle('keyboard_shortcuts','padding-top','10px');
    YAHOO.util.Dom.setStyle('keyboard_shortcuts','padding-bottom','15px');
}

// Show a hidden section.
function nsh(id) {
    var div,div2;

    // For debugging.
//    console.log(id);
//    console.log(d.getElementById(id));
//    console.log(d.getElementById(id + '_hidden'));

    if (!id) return;

    div = d.getElementById(id);
    div2 = d.getElementById(id + 'h');
    if (!div2) div2 = d.getElementById(id + '_hidden');
    if (div && div2) {
	YAHOO.util.Dom.setStyle(div,'display','none');
	YAHOO.util.Dom.setStyle(div2,'display','inline');
    }
}



// Make related searches.
function nrrel(rel) {
    var title,url,footer,div,div2,div3,link,is_related,is_top,is_date,bang;

    // For debugging.
//    alert('test');

    if (d.getElementById('nrreld')) return;

    div = d.getElementById('links');

    is_related = rel['r'] && rel['r'].length ? 1 : 0;
    is_top = r1c || d.getElementById("did_you_mean") || d.getElementById('zero_click_answer') || rad || YAHOO.util.Dom.getStyle('zero_click_wrapper', 'visibility')=='visible' ? 1 : 0;

    div2 = d.createElement('div');
    div2.id = 'nrreld';
    YAHOO.util.Dom.setStyle(div2,'font-size','107.1%');
    if (d.getElementById('zero_click_answer') && !r1c) YAHOO.util.Dom.setStyle(div2,'font-size','95.2%');
    rs ? YAHOO.util.Dom.setStyle(div2,'padding-left','64px') : YAHOO.util.Dom.setStyle(div2,'padding-left','33px');
    if (is_top) YAHOO.util.Dom.setStyle(div2,'padding-top','20px');

    if (rq.indexOf('sort%3Adate')!=-1 || rq.indexOf('s%3Ad')!=-1) is_date=1;
    else is_date = '';


    div3 = d.createElement('div');
    div3.innerHTML = 'No ' + (is_top ? 'more ' : '') + (is_date ? 'date ' : '') + 'results.' + (is_related ? ' Try:' : '');
    div2.appendChild(div3);

    if (is_related) {
	for (title in rel['r']) {
	    url = rel['u'][title];
	    title = rel['r'][title];

	    // For debugging.
//	    console.log(title);

	    div3 = d.createElement('div');
	    link = d.createElement('a');
	    link.href = '/?q=' + encodeURIComponent(url) +(kurl ? kurl : '');
	    if (kurl) link.href+=kurl
	    link.innerHTML = title;
	    div3.appendChild(link);
	    YAHOO.util.Dom.setStyle(div3,'padding-top','2px');
	    div2.appendChild(div3);

	}
    }

    div3 = d.createElement('div');
    var tmp_rq = rq;
    tmp_rq = tmp_rq.replace(/s(?:ort|)%3Ad(?:ate|)/,"");

    bang = (tmp_rq != rq) ? "!gyear " : "!g ";

    var tmp_related_link = '<a href="/?q='+bang+tmp_rq+'">Google</a> / <a href="/?q=!b '+tmp_rq+'">Bing</a> / <a href="/bang.html" onclick=this.href=\'#\';nbc();return false;>' + l('More') + '...</a>';

    div3.innerHTML = (
    	is_related ? l('Or try %s',tmp_related_link) : l('Try %s',tmp_related_link)
    );
    is_related ? YAHOO.util.Dom.setStyle(div3,'padding-top','15px') : YAHOO.util.Dom.setStyle(div3,'padding-top','7px');

    div2.appendChild(div3);

    div.appendChild(div2);

}

// Make wot.
function nrwot(wot) {
    var i,div,div2,rating,img,target,title;

    for (i in wot) {
	if (!i) continue;

	div = wot[i]['d'];
	if (!div) continue;

	rating = wot[i]['r'];
	if (!rating) continue;

	target = wot[i]['t'];
	if (!target) continue;

	// For debugging.
//	console.log(rating);

	div = d.getElementById(div);
	if (!div) continue;

	div2 = YAHOO.util.Dom.getElementsByClassName('icon_fav2','div',div);

	// For debugging.
//	console.log(div2);
//	console.log(div2.length);

	if (!div2.length) div2 = YAHOO.util.Dom.getElementsByClassName('icon_fav','div',div);

	// For debugging.
//	console.log(div2.length);

	if (!div2.length) continue;
	div2 = div2[0];
	if (!div2) continue;

	// For debugging.
//	console.log(div2);
//	console.log(target);

	title = '';
	if (rating<=2) title=l('Warning! Site could be harmful.');
	else if (rating>=4) title=l('Site has good reputation.');

	if (nur) img = nur('',title,'/wot/'+rating+'.png',16,16);
	if (img) {
	    link = d.createElement('a');
	    link.href = 'http://www.mywot.com/en/scorecard/' + target;
	    if (title) link.title = title;
	    link.appendChild(img);
	    link.onclick=function() {fl=1;};
	    if (kf=='w') div2.innerHTML='';
	    div2.appendChild(link);
	    YAHOO.util.Dom.setStyle(div2,'display','block');
	 }
    }
}


// Automatic results showing via scrolls.
function nrb(event,force) {
    var trc,object_top,near_end,near_end2,doc_height,doc_scroll,evt,i,div,div2;

    // For debugging.
    //alert(fs);
//    alert('test');
//    return false;
//    console.log(fs + ' ' + it + ' ' + rt);
//    console.log(event);
//    return false;

    if (fs) return false;
    fs=1;

    // For debugging.
//    alert(fs);

    doc_height = YAHOO.util.Dom.getDocumentHeight();
    doc_scroll = YAHOO.util.Dom.getDocumentScrollTop();
    nuv();

//    console.log(doc_height + ' ' + viewport_height);

    // Scroll to end.
    near_end = ( (doc_scroll+viewport_height) >= (doc_height-500) ) ? 1 : 0;

    // For debugging.
    //    alert(near_end);
    //    console.log(near_end);
    //    if (near_end) alert('near end');

    // Last more links almost showing.
    trc = d.getElementById('r1-'+(parseInt(r1c)-2));

    // For debugging.
    //    alert(trc);

    near_end2 = 0;
    if (trc) {
	object_top = YAHOO.util.Dom.getY(trc);

	// For debugging.
	//	alert(object_top);

	if ( object_top < (doc_scroll+viewport_height+20) ) near_end2 = 1;
    }

    // For debugging.
    //    if (fm) alert(fm.clientX+ ' '+fm.clientY);
    //    if (near_end2) alert('test');
    //    alert(fmx + ' ' + fmy);

    // Explicit use of scrollbar (not wheel).
    if (!force && fmx && fmy && fmx>(viewport_width-100) && fmy<(parseInt(viewport_height)-17) ) {

	// For debugging.
//	console.log("test");

	fs=0;
	return;
    }

    // For debugging.
    // alert(doc_height + ' ' + (doc_scroll+viewport_height))
    // alert(event.clientY+' '+parseInt(viewport_height-17));

    // Footer near in view.
    if (near_end || near_end2 || force) {

	// For debugging.
	//alert('test');
//	console.log(r1c);

	// Find last hidden one.
	for (i=parseInt(r1c)-1;i>=0;i--) {
	    div = d.getElementById("r1-"+i);
	    div2 = div.parentNode;

	    // For debugging.
//	    console.log(i);

	    if (YAHOO.util.Dom.getStyle(div2,"display")=='block') {

		// Doesn't work if no hidden result.
		//		nrv(d.getElementById("r1-"+parseInt(i+1)),1);
		//alert(i);
//		console.log(i);

		nrm(7,"r1-"+i);

		// If at bottom, scroll to useful area.
		// Maybe causing trouble.
		//		nrs(div);

		break;
	    }

	}


	// For debugging.
	//	alert('test');
    }

    // For debugging.
//    console.log("bottom");

    fs=0;
}

function loadCloudSettings(objectKey, continuationf) {
    var tx = new XMLHttpRequest();

    tx.onreadystatechange = function() {
        if (this.readyState == 4) { // state 4 == done
            // console.log("loadCloudSettings(): xmlhttprequest status " + tx.status);

            if (tx.status == 200) {
                var xp = JSON.parse(tx.responseText);
                // console.log(xp);

                for(var k in xp) {
                    // console.log("will set window[" + k + "] = '" + xp[k] + "'");
                    window[k] =  xp[k];
                    // console.log("setting cookie " + k.slice(1) + " to " + xp[k]);
                    YAHOO.util.Cookie.set(k.slice(1), xp[k], { expires: new Date("January 12, 2025") });
                }

                YAHOO.util.Cookie.set("objectKey", objectKey, { expires: new Date("January 12, 2025") });
            }
            // else {
            //     // key doesn't exist .. report to user or what?
            //     console.log("key '" + key + "' d.n.e, now what?");
            // }

            // continuation function
            continuationf();
        }
    };

    // console.log("requesting: /settings.js?key=" + objectKey);
    tx.open("GET", "/settings.js?key=" + objectKey);

    tx.send();
}

/* isDarkColor
 *
 * use Luma to decide if a color is perceptually dark
 *
 * see http://en.wikipedia.org/wiki/HSL_and_HSV#Lightness
 * for an explanation of the formula
 *
 * c: hex string of the form "#ffffff"
 */
var isDarkColor = function(c) {
  if (!c) return 0;

  var R, G, B, Y;

  R = parseInt(c.slice(1, 3), 16); // 255.0;
  G = parseInt(c.slice(3, 5), 16); // 255.0;
  B = parseInt(c.slice(5, 7), 16); // 255.0;

  Y = 0.3 * R + 0.59 * G + 0.11 * B;

  // console.log("isDarkColor: c: " + c + "; R,G,B: " + R + "," + G + "," + B + "; Y: " + Y);

  //return (Y < 0.5);
  return (Y < 127);
};

// CSS initliazation.
function nic() {
    var x,y,links,link,i,div,div2,diff,diff2,tmp,is_static;

    is_static = DDG.page_type;

    nuv();

    DDG.fix_browser_bugs();

    x=kh||YAHOO.util.Cookie.get("h");
    if (x) kurl+='&kh='+encodeURIComponent(x);
    if (x && x=='1' && !issl) {
	d.x.action='https://'+w.location.host;
    }

    x=ki||YAHOO.util.Cookie.get("i");
    if (x) kurl+='&ki='+encodeURIComponent(x);

    // For debugging.
//    console.log(x+' '+rt);

    if (x && x=='-1' && typeof(rt)!='undefined' && rt=='D') {
	YAHOO.util.Dom.setStyle('zero_click_wrapper','display','none');
	YAHOO.util.Dom.setStyle('zero_click_wrapper','visibility','hidden');
	YAHOO.util.Dom.setStyle('zero_click_header','display','none');
	YAHOO.util.Dom.setStyle('zero_click_header','visibility','hidden');
	YAHOO.util.Dom.setStyle('zero_click_topics','display','none');
	YAHOO.util.Dom.setStyle('zero_click_topics','visibility','hidden');
    }

    x=ks||YAHOO.util.Cookie.get("s");
    if (x) kurl+='&ks='+encodeURIComponent(x);
    tmp = '100';
    if (x=='s') tmp='85';
    else if (x=='m') tmp='91';
    else if (x=='l') tmp='108';
    else if (x=='t') tmp='115';
    if (x=='s' || x=='m' || x=='l' || x=='t') {
	YAHOO.util.Dom.setStyle('content','font-size',tmp+'%');
	YAHOO.util.Dom.setStyle('search_form_homepage','font-size',tmp+'%');
	YAHOO.util.Dom.setStyle('header_button','font-size',tmp+'%');
	YAHOO.util.Dom.setStyle('bang_wrapper','font-size',tmp+'%');
	YAHOO.util.Dom.setStyle('spacing_hidden_wrapper','font-size',tmp+'%');
	YAHOO.util.Dom.setStyle('side','font-size',tmp+'%');
    }
    if (x=='s') {
	YAHOO.util.StyleSheet(DDG.stylesheet).set('.results_links, .results_links_more, .results_category_more, .results_links_deep', {paddingTop: "6px",paddingBottom: "6px"}).
	    set('.results_links, .results_links_more, .results_category_more', {paddingTop: "6px",paddingBottom: "6px"}).
	    set('.results_zero_click, .results_zero_click_more', {paddingTop: "2px",paddingBottom: "2px"}).
	    enable();
    } else if (x=='m' || x=='l' || x=='t') {
	YAHOO.util.StyleSheet(DDG.stylesheet).set('.results_links, .results_links_more, .results_category_more, .results_links_deep', {paddingTop: "9px",paddingBottom: "9px"}).
	    set('.results_links, .results_links_more, .results_category_more', {paddingTop: "9px",paddingBottom: "9px"}).
	    set('.results_zero_click, .results_zero_click_more', {paddingTop: "2px",paddingBottom: "2px"}).
	    enable();
    }

    x=ka||YAHOO.util.Cookie.get("a");
    if (x) kurl+='&ka='+encodeURIComponent(x);

    if (x) {
	if (x=='a') y='Arial';
	else if (x=='c') y='Century Gothic';
	else if (x=='g') y='Georgia';
	else if (x=='t') y='Times';
	else if (x=='h') y='Helvetica';
	else if (x=='v') y='Verdana';
	else if (x=='b') y='Trebuchet MS';
	else if (x=='s') y='Serif';
	else if (x=='n') y='Sans-Serif';
	else if (x=='o') y='Tahoma';
	else if (x=='e') y='Segoe UI';
	else y=x;

	YAHOO.util.StyleSheet(DDG.stylesheet).
	    set('a', {fontFamily: y}).
	    enable();

    } else {
	YAHOO.util.Dom.setStyle('spacing_hidden_wrapper','font-family','"Segoe UI","Arial",sans-serif');
    }

    x=kt||YAHOO.util.Cookie.get("t");
    if (x) kurl+='&kt='+encodeURIComponent(x);
    if (x) {
	if (x=='a') y='Arial';
	else if (x=='c') y='Century Gothic';
	else if (x=='g') y='Georgia'
	else if (x=='t') y='Trebuchet MS';
	else if (x=='i') y='Times';
	else if (x=='h') y='Helvetica';
	else if (x=='v') y='Verdana';
	else if (x=='s') y='Serif';
	else if (x=='n') y='Sans-Serif';
	else if (x=='o') y='Tahoma';
	else if (x=='e') y='Segoe UI';
	else y=x;
	YAHOO.util.Dom.setStyle('search_form_input','font-family',y);
	YAHOO.util.Dom.setStyle('bang','font-family',y);

	YAHOO.util.StyleSheet(DDG.stylesheet).set('body', {fontFamily: y}).
	    set(".snippet, .snippet a, .url, .url a", "font-family: "+y+" !important;").
	    enable();
     }

    x=ky||YAHOO.util.Cookie.get("y");
    if (x) kurl+='&ky='+encodeURIComponent(x);
    if (x=='-1' || is_mobile) {
        ky=-1;
        YAHOO.util.StyleSheet(DDG.stylesheet).set('.highlight', {"background": "#FCFCFC none", cursor: "default"}).
	    enable();
    } else if (x == 'b') {
        YAHOO.util.StyleSheet(DDG.stylesheet).set('.highlight', {"background": "#eaf5fc none", cursor: "default"}).
	    set(".highlight", "border: 1px solid #b0d9f2 !important;").
	    enable();
    } else if (x == 'y') {
        YAHOO.util.StyleSheet(DDG.stylesheet).set('.highlight', {"background": "#fcf5aa none", cursor: "default"}).
	    set(".highlight", "border: 1px solid #d2df70 none;").
	    enable();
    } else if (x == 't') {
        YAHOO.util.StyleSheet(DDG.stylesheet).set('.highlight', {"background": "#fcf5ea none", cursor: "default"}).
	    set(".highlight", "border: 1px solid #f2d9b0 none;").
	    enable();
    } else if (x == 'p') {
        YAHOO.util.StyleSheet(DDG.stylesheet).set('.highlight', {"background": "#fceaf5 none", cursor: "default"}).
	    set(".highlight", "border: 1px solid #f2b0d9 none;").
	    enable();
    } else if (x == 'g') {
        YAHOO.util.StyleSheet(DDG.stylesheet).set('.highlight', {"background": "#e4f6b9 none", cursor: "default"}).
	    set(".highlight", "border: 1px solid #b8e478 none;").
	    enable();
    } else if (x) {
        YAHOO.util.StyleSheet(DDG.stylesheet).set('.highlight', {"background": x + " none", cursor: "default"}).
	    set(".highlight", "border: 1px solid "+x+" url(http://duckduckgo.com/'');").
        set('.search_suggestion:hover', {background:x} ).
	    enable();
    }

    x=kk||YAHOO.util.Cookie.get("k");
    if (x) kurl+='&kk='+encodeURIComponent(x);
    if (x!='-1' && !is_mobile) {
	if (is_static) YAHOO.util.Event.onDOMReady(setTimeout('nik(1)',250));
	else YAHOO.util.Event.onDOMReady(setTimeout('nik()',250));
    }

//    if (x!='-1' && x!='l' && !ip) {
    // Only show legend if specifically asked to.
    if (x=='s' && !is_mobile) {
	nsk();
    }
    if (x=='s' && !ip) nsh('keyboard_shortcuts_more');


    x=kf||YAHOO.util.Cookie.get("f");
    if (x) kurl+='&kf='+encodeURIComponent(x);
    if (!x || x=='1' || x=='fw' || x=='b' || rs) {
	YAHOO.util.StyleSheet(DDG.stylesheet).set('.icon_fav', {display: "block"}).
	    set('.icon_fav2', {display: "block"}).
	    set('.icon_category', {display: "block"}).
	    set('.icon_disambig', {display: "block"}).
	    enable();
    } else if (x=='1') {
	nur = null;
    }

    x=kc||YAHOO.util.Cookie.get("c");
    if (x) kurl+='&kc='+encodeURIComponent(x);

    if (x!='-1' && (!io || io11)) {
	YAHOO.util.Event.addListener(window, "scroll", nrb);
    } else if (x&&x=='-1') {

	// 2012.12.19 breaks going back to links on page 2 if off (via state).
	//	nrb=null;
    }

    x=kw||YAHOO.util.Cookie.get("w");
    if (x) kurl+='&kw='+encodeURIComponent(x);
    if (x=='w') {
	YAHOO.util.Dom.setStyle('header_content_wrapper','max-width','1200px');
	YAHOO.util.Dom.setStyle('header_content','max-width','1073px');
	YAHOO.util.Dom.setStyle('content_wrapper','max-width','1200px');
	YAHOO.util.Dom.setStyle('content','max-width','1082px');
	YAHOO.util.Dom.setStyle('links','max-width','1000px');
	YAHOO.util.Dom.setStyle('links_wrapper','max-width','1000px');
	YAHOO.util.Dom.setStyle('zero_click','max-width','990px');
	YAHOO.util.Dom.setStyle('zero_click_wrapper','max-width','990px');
	YAHOO.util.Dom.setStyle('side','max-width','900px');
	YAHOO.util.Dom.setStyle('side_wrapper','max-width','900px');
	YAHOO.util.Dom.setStyle('side_wrapper2','right','-115px');
	YAHOO.util.Dom.setStyle('search_form_input','width','581px');
	YAHOO.util.Dom.setStyle('search_form','width','688px');
    } else if (x=='s') {
	YAHOO.util.Dom.setStyle('header_content_wrapper','max-width','1500px');
	YAHOO.util.Dom.setStyle('header_content','max-width','1373px');
	YAHOO.util.Dom.setStyle('content_wrapper','max-width','1460px');
	YAHOO.util.Dom.setStyle('content','max-width','1382px');
	YAHOO.util.Dom.setStyle('links','max-width','1245px');
	YAHOO.util.Dom.setStyle('links_wrapper','max-width','1245px');
	YAHOO.util.Dom.setStyle('zero_click','max-width','1240px');
	YAHOO.util.Dom.setStyle('zero_click_wrapper','max-width','1240px');
	YAHOO.util.Dom.setStyle('side','max-width','1100px');
	YAHOO.util.Dom.setStyle('side_wrapper','max-width','1100px');
	YAHOO.util.Dom.setStyle('side_wrapper2','right','-130px');
	YAHOO.util.Dom.setStyle('search_form_input','width','781px');
	YAHOO.util.Dom.setStyle('search_form','width','888px');
    }
    if (x=='w'||x=='s') {
	YAHOO.util.Dom.setStyle('content','padding-left','62px');
	YAHOO.util.Dom.setStyle('header_content','padding-left','87px');
	YAHOO.util.Dom.setStyle('links','width','80%');
	YAHOO.util.Dom.setStyle('zero_click','width','80%');
    }

    x=ku||YAHOO.util.Cookie.get("u");
    if (x) kurl+='&ku='+encodeURIComponent(x);
    if (x=='1') {
	YAHOO.util.StyleSheet(DDG.stylesheet).set('a.large', {textDecoration: "underline"}).
	    enable();
    }

    x=kq||YAHOO.util.Cookie.get("q");
    if (x) kurl+='&kq='+encodeURIComponent(x);

    x=kv||YAHOO.util.Cookie.get("v");
    if (x) kurl+='&kv='+encodeURIComponent(x);

    x=ke||YAHOO.util.Cookie.get("e");
    if (x) kurl+='&ke='+encodeURIComponent(x);

    //    console.log('test');

    x=kj||YAHOO.util.Cookie.get("j");

    //    console.log(kj);
    //    console.log(x);

    if (ie6) x='w';
    if (x) {

	kurl+='&kj='+encodeURIComponent(x);

	if (x!='r3') {
	    YAHOO.util.Dom.setStyle('header','height','53px');
	    YAHOO.util.Dom.setStyle('header','border-bottom','none');
	    YAHOO.util.Dom.setStyle('search_form','border-bottom','0px');
	    YAHOO.util.Dom.setStyle('search_form_input','border','#888 solid 1px');
	    YAHOO.util.Dom.setStyle('search_form_input','border-right','0px');
	    YAHOO.util.Dom.setStyle('search_form_input_clear','border','#888 solid 1px');
	    YAHOO.util.Dom.setStyle('search_form_input_clear','border-right','0px');
	    YAHOO.util.Dom.setStyle('search_form_input_clear','border-left','0px');
	    YAHOO.util.Dom.setStyle('header_button','border','0px');
	    YAHOO.util.StyleSheet(DDG.stylesheet).set('#header_button_menu_wrapper a.header_button_menu_item', "text-shadow: none !important").
		enable();
	}

	if (x=='r') {
	    YAHOO.util.Dom.setStyle('header','background','url(http://duckduckgo.com//headerbg.v102.red.png) 0 0 repeat-x');
	    YAHOO.util.Dom.setStyle('header_button','background','#d31920');

	} else if (x=='r2') {
	    YAHOO.util.Dom.setStyle('header','background','url(http://duckduckgo.com//headerbg.v102.dred.png) 0 0 repeat-x');
	    YAHOO.util.Dom.setStyle('header_button','background','#bd232a');

	} else if (x=='b') {
	    YAHOO.util.Dom.setStyle('header','background','url(http://duckduckgo.com//headerbg.v102.lblue.png) 0 0 repeat-x');
	    YAHOO.util.Dom.setStyle('header_button','background','#aed7f3');

	} else if (x=='d') {
	    YAHOO.util.Dom.setStyle('header','background','url(http://duckduckgo.com//headerbg.v102.lgreen.png) 0 0 repeat-x');
	    YAHOO.util.Dom.setStyle('header_button','background','#bae57a');

	} else if (x=='b2') {
	    YAHOO.util.Dom.setStyle('header','background','url(http://duckduckgo.com//headerbg.v102.dblue.png) 0 0 repeat-x');
	    YAHOO.util.Dom.setStyle('header_button','background','#2e708e');

	} else if (x=='p') {
	    YAHOO.util.Dom.setStyle('header','background','url(http://duckduckgo.com//headerbg.v102.purple.png) 0 0 repeat-x');
	    YAHOO.util.Dom.setStyle('header_button','background','#8a4391');

	} else if (x=='g') {
	    YAHOO.util.Dom.setStyle('header','background','url(http://duckduckgo.com//headerbg.v102.green.png) 0 0 repeat-x');
	    YAHOO.util.Dom.setStyle('header_button','background','#09A940');

	} else if (x=='g2') {
	    YAHOO.util.Dom.setStyle('header','background','url(http://duckduckgo.com//headerbg.v102.dgreen.png) 0 0 repeat-x');
	    YAHOO.util.Dom.setStyle('header_button','background','#47a055');

	} else if (x=='o') {
	    YAHOO.util.Dom.setStyle('header','background','url(http://duckduckgo.com//headerbg.v102.orange.png) 0 0 repeat-x');
	    YAHOO.util.Dom.setStyle('header_button','background','#da7e46');

	} else if (x=='w') {
	    YAHOO.util.Dom.setStyle('header','background','#fff');
	    YAHOO.util.Dom.setStyle('header_logo','background','url(http://duckduckgo.com//assets/logo_header_white_2.v101.png)');
	    YAHOO.util.Dom.setStyle('header','border-bottom','none');
	    YAHOO.util.Dom.setStyle('header','box-shadow','none');
     
	} else if (x=='ct') { // gray
	    YAHOO.util.Dom.setStyle('header','background','url(http://duckduckgo.com//headerbg.v102.bgrey.png) 0 0 repeat-x');
	    YAHOO.util.Dom.setStyle('header_button','background','#313130');

	} else if (x=='kt') { // black
	    YAHOO.util.Dom.setStyle('header','background','url(http://duckduckgo.com//headerbg.v102.black.png) 0 0 repeat-x');
	    YAHOO.util.Dom.setStyle('header_button','background','#252525');	    

	} else if (x=='t') { // transparent
	    YAHOO.util.Dom.setStyle('header','background','transparent url(http://duckduckgo.com//white_or_transp.png) 0 0 repeat-x');
	    YAHOO.util.Dom.setStyle('header_button','background','none');	    

	} else if (x!='r3') {
	    YAHOO.util.Dom.setStyle('header','background', x);
	    YAHOO.util.Dom.setStyle('header_button','background', x);
	}

    }

    // Before ko but after kj so header looks right when displayed.
    x=kr||YAHOO.util.Cookie.get("r");
    if (x) kurl+='&kr='+encodeURIComponent(x);
    if (ie6) x='-1';
    if (x && (x=='-1' || x=='c')) {
        YAHOO.util.Dom.setStyle('header_button','display','none');
        YAHOO.util.Dom.setStyle('header_button_wrapper','display','none');
    }

    // After kr
    x=km||YAHOO.util.Cookie.get("m");
    if (x) kurl+='&km='+encodeURIComponent(x);
    if (x=='l') {
	YAHOO.util.Dom.setStyle('content','padding-left','20px');
	YAHOO.util.Dom.setStyle('content_wrapper','margin','0');
	YAHOO.util.Dom.setStyle('header_wrapper','margin','0');
	YAHOO.util.Dom.setStyle('header_content_wrapper','margin','0');
        YAHOO.util.Dom.setStyle('content','margin','0');
        YAHOO.util.Dom.setStyle('links_wrapper','margin','0');
        YAHOO.util.Dom.setStyle('zero_click_wrapper','margin','0');
        YAHOO.util.Dom.setStyle('header_content','margin','0');
	YAHOO.util.Dom.setStyle('header_content','padding-left','95px');
    }

    x=ko||YAHOO.util.Cookie.get("o");

    //    console.log(x);

    if (x) kurl+='&ko='+encodeURIComponent(x);
    if (ie6) x='s';
    if (!x || x!='-1') {

	//	console.log('test');

	YAHOO.util.Dom.setStyle('header_wrapper','display','block');
    }
    if (x && x=='s') {

	//	console.log('test');

	YAHOO.util.Dom.setStyle('header_wrapper','display','block');
	YAHOO.util.Dom.setStyle('header','position','absolute');
	YAHOO.util.Dom.setStyle('header_wrapper','position','absolute');
	if (ie6) {
	    YAHOO.util.Dom.setStyle('header','padding-top','0px');
	    YAHOO.util.Dom.setStyle('header','height','70px');
	    YAHOO.util.Dom.setStyle('header','width','700px');
	    YAHOO.util.Dom.setStyle('header','padding-left','23px');
	    YAHOO.util.Dom.setStyle('header_content_wrapper','padding-top','0');
	    YAHOO.util.Dom.setStyle('header_content','padding-top','0');
	}
    } else if (x && x=='-1') {

	//	console.log('test');

	// For some reason something else is setting this to block -- not sure what https://app.asana.com/0/137252944994/949452025112
	// So adding this explicit off here.
	YAHOO.util.Dom.setStyle('header_wrapper','display','none');

	YAHOO.util.Dom.setStyle('content','padding-top','0px');
	YAHOO.util.Dom.setStyle('side_wrapper2','top','0px');
	YAHOO.util.StyleSheet(DDG.stylesheet).set("#zero_click_wrapper", "padding-top:0px !important;").
	    enable();
    }

    x=kz||YAHOO.util.Cookie.get("z");
    if (x) kurl+='&kz='+encodeURIComponent(x);
    if ((!x || x=='1') && w.rad) {
	YAHOO.util.Dom.setStyle('zero_click_wrapper','display','block');
	YAHOO.util.Dom.setStyle('zero_click_wrapper','visibility','visible');
    } else if (x=='-1') {
	YAHOO.util.Dom.setStyle('zero_click_wrapper','display','none');
	YAHOO.util.Dom.setStyle('zero_click_wrapper','visibility','hidden');
	YAHOO.util.Dom.setStyle('zero_click_header','display','none');
	YAHOO.util.Dom.setStyle('zero_click_header','visibility','hidden');
	YAHOO.util.Dom.setStyle('zero_click_topics','display','none');
	YAHOO.util.Dom.setStyle('zero_click_topics','visibility','hidden');
	nra = function () {return false;};
	nra2 = function () {return false;};
    }

    x=kx||YAHOO.util.Cookie.get("x");

    //    console.log(x);

    if (x) kurl+='&kx='+encodeURIComponent(x);
    if (x && x!='r') {
//	YAHOO.util.StyleSheet(DDG.stylesheet).set(".url a", "color: " + x + " !important;").

	if (x=='g') x = '#0f5c17';
	else if (x=='b') x = '#10385d';
	else if (x=='o') x = '#d15d0d';
	else if (x=='p') x = '#732883';
	else if (x=='l') x = '#222222';
	else if (x=='e') x = '#777777';
	
	//	console.log(x);

	YAHOO.util.StyleSheet(DDG.stylesheet).set(".url, .url a", "color: " + x + " !important;").
	    enable();
    }

    x=kg||YAHOO.util.Cookie.get("g");
    if (x) kurl+='&kg='+encodeURIComponent(x);
    if (x=='p') {
      d.x.method='POST';
      d.title='DuckDuckGo';
    }

    x=kl||YAHOO.util.Cookie.get("l");
    if (x) kurl+='&kl='+encodeURIComponent(x);
    
    x=kp||YAHOO.util.Cookie.get("p");
    if (x) kurl+='&kp='+encodeURIComponent(x);

    x=kd||YAHOO.util.Cookie.get("d");
    if (x) kurl+='&kd='+encodeURIComponent(x);

    x=kn||YAHOO.util.Cookie.get("n");
    if (x) kurl+='&kn='+encodeURIComponent(x);

    x=kb||YAHOO.util.Cookie.get("b");
    if (x) kurl+='&kb='+encodeURIComponent(x);

    x=k1||YAHOO.util.Cookie.get("1");
    if (x) kurl+='&k1='+encodeURIComponent(x);
    if (x && x=='-1') {
	// Padding stays.
	YAHOO.util.Dom.setStyle('ads','height','0px')	
    }

    x=k2||YAHOO.util.Cookie.get("2");
    if (x) kurl+='&k2='+encodeURIComponent(x);

    x=k3||YAHOO.util.Cookie.get("3");
    if (x) kurl+='&k3='+encodeURIComponent(x);

    x=k4||YAHOO.util.Cookie.get("4");
    if (x) kurl+='&k4='+encodeURIComponent(x);

    x=k5||YAHOO.util.Cookie.get("5");
    if (x) kurl+='&k5='+encodeURIComponent(x);

    x=k6||YAHOO.util.Cookie.get("6");
    if (x) kurl+='&k6='+encodeURIComponent(x);
//    if (x) {
//	nrj('/id/dakwakddgdev.js?language='+k6);
//    }

    x=k7||YAHOO.util.Cookie.get("7");
    if (x && x!='ow') {
        if (x=='w') x = '#FFFFFF';

	//	console.log(x);

	YAHOO.util.StyleSheet(DDG.stylesheet).
            set('html,body,#side,#zero_click,.highlight_sponsored', {background: 'none'}).
            set('html,body,#side,#zero_click,.highlight_sponsored', {backgroundColor: x}).
	    set('#zero_click_abstract,#did_you_mean,.results_links,.cr3,.results_links_more,.results_category_more,.results_links_deep,.results_zero_click,.results_zero_click_more,.results_disambig,.links_zero_click_disambig,.results_disambig_more',{borderColor: x}).
	    set('.highlight_sponsored',"border-color: "+x+" !important").
	    set('.highlight',"border-color: "+x+" !important").
	    enable();

    }


    if (isDarkColor(x)) {
        // console.log('found dark background, setting search_suggestion background and hover');
        YAHOO.util.StyleSheet(DDG.stylesheet).set('.search_suggestion', {background: 'transparent none', border: '1px solid rgba(255,255,255,0.3)'}).
            // set('.search_suggestion:hover', {background: 'none rgba(255,255,255,0.2)'}).
            // set('.highlight', {border: '1px solid rgba(255,255,255,0.3) !important'}).
            enable();
    }


    if (x) kurl+='&k7='+encodeURIComponent(x);

    x=k8||YAHOO.util.Cookie.get("8");

    // For debugging.
    //    console.log(x);

    if (x && x!='g') {
	YAHOO.util.StyleSheet(DDG.stylesheet).set('html', {color: x}).
	    set(".snippet, .snippet a, .search_suggestion, .search_suggestion a, .links_menu, .links_menu a, #side", "color: "+x+" !important;").
	    enable();

	//	console.log(x);
	//	alert(x);
    }
    if (x) kurl+='&k8='+encodeURIComponent(x);

    x=k9||YAHOO.util.Cookie.get("9");
    if (x && x!='b') {
	YAHOO.util.StyleSheet(DDG.stylesheet).set('a, #header_button_menu_wrapper:hover a', {color: x}).
	    enable();
    }
    if (x) kurl+='&k9='+encodeURIComponent(x);

    x=kaa||YAHOO.util.Cookie.get("aa");
    if (x && x!='p') {
	YAHOO.util.StyleSheet(DDG.stylesheet).set('a:visited', {color: x}).
	    enable();
    }
    if (x) kurl+='&kaa='+encodeURIComponent(x);

    x=kab||YAHOO.util.Cookie.get("ab");
    if (x && x!='e') {
        if (x=='r') x = '#EE7777';
	YAHOO.util.StyleSheet(DDG.stylesheet).set('#zero_click,.search_suggestion', {borderColor: x}).
	    enable();
    }
    if (x) kurl+='&kab='+encodeURIComponent(x);

    x=kac||YAHOO.util.Cookie.get("ac");
    if (x) kurl+='&kac='+encodeURIComponent(x);

    x=kad||YAHOO.util.Cookie.get("ad");
    if (x) kurl+='&kad='+encodeURIComponent(x);

    x=kae||YAHOO.util.Cookie.get("ae");
    if (x) kurl+='&kae='+encodeURIComponent(x);

    x=kaf||YAHOO.util.Cookie.get("af");
    if (x) kurl+='&kaf='+encodeURIComponent(x);

    x=kag||YAHOO.util.Cookie.get("ag");
    if (x) kurl+='&kag='+encodeURIComponent(x);

    x=kah||YAHOO.util.Cookie.get("ah");
    if (x) kurl+='&kah='+encodeURIComponent(x);

    x=kai||YAHOO.util.Cookie.get("ai");
    if (x) kurl+='&kai='+encodeURIComponent(x);

    x=kaj||YAHOO.util.Cookie.get("aj");
    if (x) kurl+='&kaj='+encodeURIComponent(x);

    x=kak||YAHOO.util.Cookie.get("ak");
    if (x) kurl+='&kak='+encodeURIComponent(x);

    x=kal||YAHOO.util.Cookie.get("al");
    if (x) kurl+='&kal='+encodeURIComponent(x);

    x=kam||YAHOO.util.Cookie.get("am");
    if (x) kurl+='&kam='+encodeURIComponent(x);

    x=kan||YAHOO.util.Cookie.get("an");
    if (x) kurl+='&kan='+encodeURIComponent(x);

    x=kao||YAHOO.util.Cookie.get("ao");
    if (x) kurl+='&kao='+encodeURIComponent(x);

    x=kap||YAHOO.util.Cookie.get("ap");
    if (x) kurl+='&kap='+encodeURIComponent(x);

    x=kaq||YAHOO.util.Cookie.get("aq");
    if (x) kurl+='&kaq='+encodeURIComponent(x);

    x=kar||YAHOO.util.Cookie.get("ar");
    if (x) kurl+='&kar='+encodeURIComponent(x);

    x=kas||YAHOO.util.Cookie.get("as");
    if (x) kurl+='&kas='+encodeURIComponent(x);

    x=kat||YAHOO.util.Cookie.get("at");
    if (x) kurl+='&kat='+encodeURIComponent(x);

    x=kau||YAHOO.util.Cookie.get("au");
    if (x) kurl+='&kau='+encodeURIComponent(x);

    x=kav||YAHOO.util.Cookie.get("av");
    if (x) kurl+='&kav='+encodeURIComponent(x);

    x=kaw||YAHOO.util.Cookie.get("aw");
    if (x) kurl+='&kaw='+encodeURIComponent(x);

    x=kax||YAHOO.util.Cookie.get("ax");
    if (x) kurl+='&kax='+encodeURIComponent(x);

    x=kay||YAHOO.util.Cookie.get("ay");
    if (x) kurl+='&kay='+encodeURIComponent(x);

    x=kaz||YAHOO.util.Cookie.get("az");
    if (x) kurl+='&kaz='+encodeURIComponent(x);

    DDG.resize();

    // Give images a chance to load.
    nua('DDG.resize','',250);
    nua('DDG.resize','',1250);
}


// When bang opener is clicked.
function nbc(force_off) {
    var bangs,toppx,left,is_homepage,target;

    is_homepage = d.getElementById('search_form_homepage') ? 1 : 0;

    bangs = d.getElementById('bang');

    // For debugging.
//    alert('test');
//    alert(is_homepage);
//    alert(gs);
//    console.log(bangs);

    if (YAHOO.util.Dom.getStyle(bangs, 'display')=='none') {

	target = 'search_dropdown';
	if (is_homepage) target = 'search_dropdown_homepage';

	toppx = 0;
	if (ir || is || iw) toppx -= 2;
	if (is_homepage) toppx+=2;
	YAHOO.util.Dom.setStyle(bangs,'top',parseInt(YAHOO.util.Dom.getY(target)+37+toppx-YAHOO.util.Dom.getDocumentScrollTop())+'px');

	// For debugging.
	//	console.log(toppx);
	//	console.log(YAHOO.util.Dom.getY(target));
	//	console.log(YAHOO.util.Dom.getDocumentScrollTop());

	left = 153;
	if (bangs.options.length>100) left += 125;

	// For debugging.
//	console.log(target);
//	console.log(YAHOO.util.Dom.getX(target));
//	console.log(left);

	YAHOO.util.Dom.setStyle(bangs,'left',parseInt(YAHOO.util.Dom.getX(target)-left)+'px');
	bangs.selectedIndex=0;

	//	YAHOO.util.Dom.setStyle(bangs,'left','0');
	//	YAHOO.util.Dom.setStyle(bangs,'top','0');

	//	alert(left);
	//	alert(YAHOO.util.Dom.getStyle(bangs,'left'));

	// If you do this without timeout it searches and the second bang gets selected.
	setTimeout("YAHOO.util.Dom.setStyle('bang','display','block')",100);
	setTimeout('d.getElementById("bang").focus()',150);

	fb=1;
	fq=1;
    } else if (!fb || force_off) {
	fq=0;
	setTimeout("YAHOO.util.Dom.setStyle('bang','display','none')",200);
    }
}


// Put custom bangs into dropdown
function nbp () {
    var i,bang,bangs,cbangs,abangs,b_count;

    // For debugging.
//    alert(ip);

//    if (ie6 || ip || (kq && kq==-1)) {

    cbangs = YAHOO.util.Cookie.getSubs("!") || 0;
    bangs = d.getElementById('bang');

    if (bangs) {

	// Initial pop.
	b_count = 0;
	if (rl && rl!='us-en' && rl!='wt-wt') bangs.options.add(new Option('From any region','region:none'),b_count++);
	bangs.options.add(new Option(l('Special'),''),b_count++);
	bangs.options.add(new Option(l('Sort by date'),'!date'),b_count++);
	bangs.options.add(new Option(l("I'm feeling ducky"),'!'),b_count++);
	bangs.options.add(new Option(l('Try search on') + '...',''),b_count++);
	bangs.options.add(new Option('Amazon (!a)','!a'),b_count++);
	bangs.options.add(new Option(l('Images') + ' - Bing (!bi)','!bi'),b_count++);
	bangs.options.add(new Option(l('Images') + ' - Google (!gi)','!gi'),b_count++);
	bangs.options.add(new Option('Map (!m)','!m'),b_count++);
	bangs.options.add(new Option('News (!n)','!n'),b_count++);
	bangs.options.add(new Option('Wikipedia (!w)','!w'),b_count++);
	bangs.options.add(new Option('YouTube (!yt)','!yt'),b_count++);
	bangs.options.add(new Option(l('Show all'),''),b_count++);
	bangs.options.add(new Option(l('By category') + ' (!bang)','!bang'),b_count++);
	bangs.options.add(new Option(l('Alphabetically'),'more'),b_count++);
	bangs.size=b_count;

	if (cbangs) {

	    abangs = new Array();
	    for (bang in cbangs){

		// Allow these because going first means something.
		//	    if (bang=='a'||bang=='eb'||bang=='fb'||bang=='i'||bang=='m'||bang=='n'||bang=='so'||bang=='tw'||bang=='w'||bang=='yt'||bang=='date'||bang=='ducky') continue;
		if (bang=='date'||bang=='ducky'||bang=='bang') continue;
		if (grb.test(bang)) {
		    abangs[abangs.length]={name:bang, count:cbangs[bang]};
		}
	    }

	    abangs.sort(function (a,b){return b.count-a.count});

	    // For debugging.
	    //	console.log(abangs);

	    b_count = 0;
	    for (i=0;i<abangs.length;i++) {
		bang = abangs[i];
		bangs.options.add(new Option('!' + bang.name, '!' + bang.name),0+b_count);
		b_count++;

		// For debugging.
		//	    console.log(bang);

		if (b_count==5) break;
	    }
		/*
	    if (b_count) {
		bangs.options.add(new Option('-- Special --',''),0+b_count);
		b_count++;
	    }
		*/
	    // For debugging.
	    //	alert(bangs.size + ' ' + b_count);

	    bangs.size+=b_count;
	}
    }
}

// Record bangs
function nbr () {
    var re,re2,bang,b_count;

    if (d.x.q.value=='' || d.x.q.value==l('put search terms here')) {
	d.x.q.value=l('put search terms here');
	d.x.q.style.color='#AAAAAA';
	setTimeout('d.x.q.onclick();d.x.q.focus();',1000);
	return false;
    }

    re = new RegExp(' \\!([^\\s]+)$');
    re2 = new RegExp('^\\!([^\\s]+)');

    if (re.test(d.x.q.value) || re2.test(d.x.q.value)) {
	bang = RegExp.$1 || 0;

	// For debugging.
	//alert(bang);

	if (bang && grb.test(bang)) {

	    // For debugging.
	    //alert('test');
//	    console.log(bang);

	    b_count = YAHOO.util.Cookie.getSub('!',bang)||0;
	    b_count++;
	    if (kq=='1') YAHOO.util.Cookie.setSub('!', bang, b_count, { expires: new Date("January 12, 2025") });
	}
    }

    return true;
}

// When bang is clicked
function nbb (bangs,use_id) {
    var re,re2,bang,idx,items,b_count;

    // For debugging.
//    alert('test');

    re = new RegExp(' \\!([^\\s]*)\\s*$');
    re2 = new RegExp('^\\!([^\\s]+) ');
    idx = 0;

    // For debugging.
//    alert('test');

    // For debugging.
    if (re.test(d.x.q.value)) {
	bang = RegExp.$1 || '';
	idx = d.x.q.value.indexOf('!'+bang);
	if (idx) d.x.q.value = d.x.q.value.substring(0,idx-1);

    } else if (re2.test(d.x.q.value)) {
	d.x.q.value = '';
    }

    bang = '';
    if (use_id) bang = use_id;
    else bang = bangs.options[bangs.selectedIndex].value;

    if (bang=='more') {
	nrj('/bang.v117.js');
    } else if ((d.x.q.value!='' || bang=='!bang') && bang) {
	d.x.q.value+=' '+bang;
	setTimeout('nbr();d.x.submit()',250);
    } else if (bang) {
	d.x.q.value+=bang+' ';
	setTimeout('d.x.q.focus()',100);
    }
}

// Call back for bang more.
function nbm (items) {
    var bangs,item,target,is_homepage,b_count;

    bangs = d.getElementById('bang');

    is_homepage = d.getElementById('search_form_homepage') ? 1 : 0;

    // For debugging.
//    alert(items.length);
//    alert(bangs);
//    alert(bangs.options.length);

    b_count = bangs.options.length;

    for (item in items) {
	if (!items[item]) continue;
	bangs.options[bangs.length] = new Option(items[item]['s'] + ' (!' + items[item]['t'] + ')', '!' + items[item]['t']);
    }
   // bangs.options[bangs.selectedIndex].text = '----';
   // bangs.options[bangs.selectedIndex].value = ' ';
    bangs.size = 20;
	bangs.options.add(new Option('All !bangs',''),b_count++);
/*    YAHOO.util.Dom.setStyle(bangs,'width','300px');
    target = 'search_dropdown';
    if (is_homepage) target = 'search_dropdown_homepage';
    YAHOO.util.Dom.setStyle(bangs,'left',parseInt(YAHOO.util.Dom.getX(target)-278)+'px');
    bangs.scrollTop=parseInt(20*b_count);*/
}

// fixed position header messes up anchors so add padding.
function nuc (anchor) {
    var padding = '47';

    // For debugging.
//    alert('test');

    if (anchor.length==1) padding = '73';
    if (ko && (ko=='-1' || ko=='s')) padding='20';
    if (d.getElementById('zero_click')) padding= parseInt(padding) + parseInt(d.getElementById('zero_click').scrollHeight) - 40;

    // For debugging.
//    console.log(padding);
//    console.log(d.getElementById('zero_click').scrollHeight);

    YAHOO.util.Dom.setStyle('zero_click_abstract' + anchor,'padding-top',padding+'px');
}

// Scroll to top.
function nuo (x) {
    if (!x) x = 0;
    window.scroll(0,x);
}

// Opera waiting function.
function nipo(is_static) {
    var ddg_sheet_tmp;
    try {
	ddg_sheet_tmp = YAHOO.util.StyleSheet('DDGT');
	YAHOO.util.StyleSheet(ddg_sheet_tmp).set('.icon_fav', "float: left").enable();

	// If no error.
	nic(is_static); //css

    } catch (e) {
//	alert(e);
	setTimeout('nipo()',150);

    } finally {
          //do cleanup, etc here
    }
}

// Functions to run initially
function nip(is_static) {
    var iframe;

    DDG.page_type = is_static;

    // post frame.
    if (!is_static && ih5) {
	iframe = d.createElement("iframe");
	iframe.id='iframe_hidden';
	iframe.src='/post2.html';
	d.body.appendChild(iframe);
    }

    // For debugging.
    //    alert(ih5);

    // 2012.02.15 trying to see if this fixes glitches in settings not getting applied. https://duckduckgo.desk.com/agent/case/7038
    if ((io || ie) && !is_static) {
	nipo(is_static);
    } else {

        if ("key" in window) {
            loadCloudSettings(key, function() { nic(is_static); });
        }
        else
            nic(is_static); //css
    }

    if (is_static) {
	YAHOO.util.Event.addListener('search_form_input_homepage', 'keyup', DDG.clear_button_toggle);

    } else {

	if (nir) nir(); // results
	
	YAHOO.util.Event.onDOMReady(setTimeout('nis()',250)); // initial state

	setTimeout('nsl()',10000);

	YAHOO.util.Event.addListener(d, "mousemove", nkf);
	
	YAHOO.util.Event.addListener(d, "mouseup", ncg);
	YAHOO.util.Event.addListener(d, "keydown", nckd);
	YAHOO.util.Event.addListener(d, "keypress", nckp);
	YAHOO.util.Event.addListener(d, "keyup", ncku);

	YAHOO.util.Event.addListener('search_form_input', 'keyup', DDG.clear_button_toggle);
	YAHOO.util.Event.addListener('search_form_input_clear', 'click', DDG.clear_button);

	//	console.log('test');

    }
	YAHOO.util.Event.addListener(d, "mousedown", ncf);


    window.onresize = DDG.resize;


    // Add bangs.
    nbp();
	prettybang('on');	
}


//function testscroll () {
//    document.getElementById('header_wrapper').style.top = (window.pageYOffset + window.innerHeight - 25) + 'px';
//}


//function testscroll() {
//    if (nrb) setTimeout('nrb()',250);
//}

// Initialize font check.
function nif () {
    var font,has_smoothing,x;

    // For debugging.
//    alert('test');

    font = 'Arial';
    has_smoothing = 1;

    // from http://www.useragentman.com/blog/2009/11/29/how-to-detect-font-smoothing-using-javascript/
    if (typeof(screen.fontSmoothingEnabled) != "undefined") {
        has_smoothing = screen.fontSmoothingEnabled;
    } else {

        try {

            // Create a 35x35 Canvas block.
	    var canvasNode = document.createElement('canvas');
	    canvasNode.width = "35";
            canvasNode.height = "35"

	    // For debugging.
//	    alert('test canvas a');

            // We must put this node into the body, otherwise
            // Safari Windows does not report correctly.
	    canvasNode.style.display = 'none';
	    document.body.appendChild(canvasNode);
	    var ctx = canvasNode.getContext('2d');

	    // For debugging.
//	    alert('test canvas b');

            // draw a black letter 'O', 32px Arial.
	    ctx.textBaseline = "top";
	    ctx.font = "32px Arial";
	    ctx.fillStyle = "black";
	    ctx.strokeStyle = "black";

	    // For debugging.
//	    alert('test canvas c');
//	    alert(ctx.fillText);

	    if(ctx.mozMeasureText && !ctx.measureText) {
		ctx.__defineSetter__('font', function(x) { this.mozTextStyle = x;});
		ctx.__defineGetter__('font', function() { return this.mozTextStyle;});
	    }
	    if(ctx.mozMeasureText && !ctx.measureText) {
		ctx.measureText = function(text) { return {'width': this.mozMeasureText(text)}; };
	    }
	    if(ctx.mozPathText && !ctx.strokeText) {
		ctx.strokeText = function(text, x, y) {
		    this.translate(x, y);
		    this.mozPathText(text);
		    this.stroke();
            this.translate(-x, -y);
		};
	    }
	    if(ctx.mozDrawText && !ctx.fillText) {
		ctx.fillText = function(text, x, y) {
		    this.translate(x, y);
		    this.mozDrawText(text);
		    this.translate(-x, -y);
		};
	    }

	    // For debugging.
//	    alert(ctx.fillText);

	    // Breaks on firefox3 without the above.
	    ctx.fillText("O", 0, 0);

            // start at (8,1) and search the canvas from left to right,
            // top to bottom to see if we can find a non-black pixel.  If
            // so we return true.
	    var found = 0;

	    if (ctx.getImageData) {
		canvas_loop:
		for (var j = 8; j <= 32; j++) {
		    for (var i = 1; i <= 32; i++) {

			var imageData = ctx.getImageData(i, j, 1, 1).data;
			var alpha = imageData[3];

			if (alpha != 255 && alpha != 0) {
			    found = 1;

			    // For debugging.
//			    console.log("FOUND");

			    break canvas_loop;
			}

			// For debugging.
//			console.log(i);
		    }

		    // For debugging.
//		    console.log(j);
		}
	    }

            // didn't find any non-black pixels - return false.
	    has_smoothing = found ? 1 : 0;
        }
        catch (ex) {

	    // For debugging.
//	    alert('test canvas');

            // Something went wrong (for example, Opera cannot use the
            // canvas fillText() method.  Return null (unknown).
	    has_smoothing = 0;
        }
    }

    if (!has_smoothing) {

	// For debugging.
//	alert(has_smoothing);
//	alert(kt);

	x=YAHOO.util.Cookie.get("t");

	// For debugging.
//	alert(x);

	if (!x) {
	    YAHOO.util.Dom.setStyle('search_form_input','font-family',font);
	    YAHOO.util.Dom.setStyle('search_form_input_homepage','font-family',font);
	    YAHOO.util.Dom.setStyle('bang','font-family',font);
	    YAHOO.util.StyleSheet(DDG.stylesheet).set('body', {fontFamily: font}).
		enable();
	}
	x=YAHOO.util.Cookie.get("a");
	if (!x) {
	    YAHOO.util.Dom.setStyle('header_button_wrapper','font-family',font);
	    YAHOO.util.Dom.setStyle('special_page_header','font-family',font);
	    YAHOO.util.Dom.setStyle('zero_click_header','font-family',font);
	    YAHOO.util.Dom.setStyle('did_you_mean','font-family',font);
	    YAHOO.util.StyleSheet(DDG.stylesheet).set('zero_click_abstract', {fontFamily: font}).
		enable();
	}
    }
}
YAHOO.util.Event.onDOMReady(nif);

// For chrome history save bug.
if (ir) {
    window.onload=fnChromeLoad;
}
function fnChromeLoad(e) {
    irl=1;
}

// Generic skipArray for relevancy function.
// TODO 20120903 (caine): {region,r}:de, site:.de, site:<domain>, {inbody,b}:, {intitle,t}:, {filetype,f}:
// Also maybe do something specific on minus queries
DDG.skipArray = {};
DDG.skipArray['sort:date'] = 1;
DDG.skipArray['s:d'] = 1;
DDG.skipArray['!safeoff'] = 1;

DDG.grammarRE = new RegExp("[\\';,\\.]", "g");
DDG.splitRE = new RegExp("[\\s\\-]+");

DDG.getRelevants = function(p){
    //console.log("may I ask who's calling: "+arguments.callee.caller.toString());

    // (caine): 20130302
    // developers comparator function is required to assign a property of each candidate
    // object called comparable which is the string undergoing relevancy check in isRelevant

    if (p.num === undefined) {
	p.num = p.candidates.length;
    }

    var ret = [];
    var query = unescape(rq).replace("'", "");
    p.candidates = p.candidates.sort(p.comparator);

    for (var i = 0, candidate; candidate = p.candidates[i]; i++) {
	if (DDG.isRelevant(candidate.comparable, p.skipArray, p.minWordLength, p.strict)) {

	    // stop if we've met the number of candidates caller wants
	    if (i > p.num) {
		return ret;
	    } else {
		ret.push(candidate);
	    }

	}
    }

    return ret;
}

DDG.isRelevant = function(candidate, skipArray, minWordLength, strict) {
    //console.log("may I ask who's calling: "+arguments.callee.caller.toString());

    var query = unescape(rq).replace("'", "");
    return DDG.stringsRelevant(candidate, query, skipArray, minWordLength, strict);
}

DDG.stringsRelevant = function(s1, s2, skipArray, minWordLength, strict) {

  // TODO (caine+russell): remove this eventually.
  if ('Array' === typeof(skipArray)) {
      var skip;
      for (var i = 0, skipWord; skipWord = skipArray[i]; i++) {
	  skip[skipWord] = 1;
      }
      skipArray = skip;
      //console.log("skipArray was converted:", skipArray);
  }

  if (minWordLength === undefined) {
      minWordLength = 4;
  }

  // if the skip array isn't the default
  // make sure the defaults are added in.
  if (skipArray === undefined) {
      skipArray = DDG.skipArray;
  } else {
      for (var key in DDG.skipArray) {
	  // make sure the key comes from the object
	  // and not the prototype...
	  if (DDG.skipArray.hasOwnProperty(key)) {
	      skipArray[key] = 1;
	  }
      }
  }
  //console.log('DDG.stringsRelevant skipArray:', Object.keys(skipArray));
  //console.log('DDG.stringsRelevant minWordLength: '+minWordLength);

  // a few quicky alterations
  s1 = s1.replace(DDG.grammarRE, "");
  s2 = s2.replace(DDG.grammarRE, "");
  //console.log('DDG.stringsRelevant s1: '+s1);
  //console.log('DDG.stringsRelevant s2: '+s2);

  // support hyphenation & other stuff
  var split1 = s1.split(DDG.splitRE);
  var split2 = s2.split(DDG.splitRE);
  //console.log("split1: ",split1);
  //console.log("split2: ",split2);

  // TODO (caine): this is ugly...
  var candidate, comparator;
  if (strict) {
      if (split1.length > split2.length) {
	  candidate = split2;
	  comparator = split1;
      } else {
	  candidate = split1;
	  comparator = split2;
      }
  } else {
      if (split1.length > split2.length) {
	  candidate = split1;
	  comparator = split2;
      } else {
	  candidate = split2;
	  comparator = split1;
      }
  }
  //console.log("candidate: ",candidate);
  //console.log("comparator: ",comparator);

  var matches = {};
  var alreadyMatched = {};
  var numMatches = 0;
  var matchesLength = 0;

  // Fill matches object with comparators words.
  for (var i = 0; i < comparator.length; i++) {
    var word = comparator[i];

    if (!word || word.length < minWordLength || skipArray[word]) continue;

    var wordTip = word.substring(0, minWordLength).toLowerCase();
    matches[wordTip] = word;

    matchesLength++;
  }
  matches.length = matchesLength;
  //console.log('num things to match: '+matches.length);

  // Compare candidate words with what is in the matches object.
  for (var i = 0; i < candidate.length; i++) {
    var word = candidate[i];

    if (!word || word.length < minWordLength || skipArray[word]) continue;

    /*console.log('Title word: '+ word +
        ' ::: matches['+word.substring(0, minWordLength).toLowerCase()+']: ' +
        matches[word.substring(0, minWordLength).toLowerCase()]);*/

    var matchWord = word.substring(0, minWordLength).toLowerCase();
    if (!(matchWord in alreadyMatched) && matches[matchWord]) {
	alreadyMatched[matchWord] = 1;
        numMatches++;
    }
  }
  //console.log('numMatches: '+numMatches);
  //console.log('already matched keys: '+Object.keys(alreadyMatched));


  // basic validation heuristic.
  if (matches.length > 0 && matches.length <= 2 && numMatches == matches.length) {
      return true;
  } else if (matches.length > 2 && numMatches >= matches.length-1) {
      return true;
  }

  return false;
}

DDG.caineStrip = function(html)
{
    var tmp = document.createElement("DIV");
    tmp.innerHTML = html;
    return tmp.textContent || tmp.innerText;
}

DDG.getOrdinal = function(n){
    var s=["th","st","nd","rd"],
    v=n%100;
    return n+(s[(v-20)%10]||s[v]||s[0]);
}

String.prototype.trim = function() {
    return this.replace(/^\s+|\s+$/g,"");
}

function prettybang(status)
{
	if(!document.getElementById && !document.createTextNode){return;}
	
    // Classes for the link and the visible dropdown
	var dd_wrapid='bang_wrap'; // id to add/remove dynamically
	var dd_id='newbang';
	var dd_wrapclass='bangwrap'; 		// parent element
	var dd_close='hide'; // closed dropdown
	var dd_open='show';	// open dropdown
	
	var oldbang=document.getElementById('bang');

	if (status == 'on'){
		if(document.getElementById('search_form_input_homepage')){
			var searchfield=document.getElementById('search_form_input_homepage');
		}
		else {
			var searchfield=document.getElementById('search_form_input');
		}
		if(document.getElementById('search_dropdown_homepage')){
			var trigger=document.getElementById('search_dropdown_homepage');
		}
		else {
			var trigger=document.getElementById('search_dropdown');
		}
		trigger.onclick=function(){			
			DDG.toggle(dd_id);			
			return false;
		}			
		var replaceUL=document.createElement('ul');
		for(var j=0;j<oldbang.getElementsByTagName('option').length;j++)
		{
			var newli=document.createElement('li');				
			newli.v=oldbang.getElementsByTagName('option')[j].value;
			newli.elm=searchfield;
			newli.istrigger=trigger;
			if (!!newli.v ){ 
				var newa=document.createElement('a');
				newa.href='#'; 
				newa.appendChild(document.createTextNode(
				oldbang.getElementsByTagName('option')[j].text));
				newli.appendChild(newa);
			}
			else {
				newli.appendChild(document.createTextNode(
				oldbang.getElementsByTagName('option')[j].text));
				ts_addclass(newli,'header');
			}
			newli.onclick=function(){ 
				if (this.v=='more') {
				nrj('bang.v117.js');				
				prettybang('off');
				setTimeout("prettybang('on')", 150);	
				setTimeout("DDG.toggle('newbang', 1)", 200);				
				} else if (this.v=='!bang') {
				nbb(null, this.v);
				setTimeout("DDG.toggle('newbang', -1)", 200);
				} else {
				nbb(null, this.v);				
				DDG.toggle(dd_id);		
				return false;
				}								
			}	
			replaceUL.appendChild(newli);
		}
		replaceUL.setAttribute('id',dd_id);
		ts_addclass(replaceUL,dd_close);
		ts_addclass(replaceUL,'grp_modal');
		var div=document.createElement('div');
		div.appendChild(replaceUL);
		div.setAttribute('id',dd_wrapid);
		ts_addclass(div,dd_wrapclass);
		oldbang.parentNode.insertBefore(div,oldbang)
	}
	if (status == 'off'){
		if(document.getElementById('search_form_homepage')){
			var d=document.getElementById('search_form_homepage');
		}
		else {
			var d=document.getElementById('search_form');
		}		
		var remdiv = document.getElementById(dd_wrapid);
		d.removeChild(remdiv);
	}
	function ts_check(o,c)
	{
	 	return new RegExp('\\b'+c+'\\b').test(o.className);
	}	
	function ts_addclass(o,c)
	{
		if(!ts_check(o,c)){o.className+=o.className==''?c:' '+c;}
	}	
}
