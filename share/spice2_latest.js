(function() {
  var template = Handlebars.template, templates = Handlebars.templates = Handlebars.templates || {};
templates['SERP-default'] = template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [2,'>= 1.0.0-rc.3'];
helpers = helpers || Handlebars.helpers; data = data || {};
  var buffer = "", stack1, stack2, functionType="function", escapeExpression=this.escapeExpression, self=this;

function program1(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n            ";
  stack1 = helpers['if'].call(depth0, depth0.header1, {hash:{},inverse:self.program(4, program4, data),fn:self.program(2, program2, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n        ";
  return buffer;
  }
function program2(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n                <div id=\"zero_click_header\">\n                    <h1>";
  if (stack1 = helpers.header1) { stack1 = stack1.call(depth0, {hash:{},data:data}); }
  else { stack1 = depth0.header1; stack1 = typeof stack1 === functionType ? stack1.apply(depth0) : stack1; }
  buffer += escapeExpression(stack1)
    + "</h1>\n                    <div id=\"zero_click_plus_wrapper\" class=\"icon_zero_click_header\"><a id=\"zero_click_plus\" onclick=\"nra4()\" href=\"javascript:;\">&nbsp;</a></div>\n                </div>\n            ";
  return buffer;
  }

function program4(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n                ";
  if (stack1 = helpers.header2) { stack1 = stack1.call(depth0, {hash:{},data:data}); }
  else { stack1 = depth0.header2; stack1 = typeof stack1 === functionType ? stack1.apply(depth0) : stack1; }
  buffer += escapeExpression(stack1)
    + " "
    + "\n            ";
  return buffer;
  }

function program6(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n            <div id=\"zero_click_image\">\n                ";
  stack1 = helpers['if'].call(depth0, depth0.image_width, {hash:{},inverse:self.program(9, program9, data),fn:self.program(7, program7, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n            </div>\n        ";
  return buffer;
  }
function program7(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "                                        "
    + "\n                    <img class=\"img_zero_click\" src=\"";
  if (stack1 = helpers.get_image_url) { stack1 = stack1.call(depth0, {hash:{},data:data}); }
  else { stack1 = depth0.get_image_url; stack1 = typeof stack1 === functionType ? stack1.apply(depth0) : stack1; }
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\" width=\"";
  if (stack1 = helpers.image_width) { stack1 = stack1.call(depth0, {hash:{},data:data}); }
  else { stack1 = depth0.image_width; stack1 = typeof stack1 === functionType ? stack1.apply(depth0) : stack1; }
  buffer += escapeExpression(stack1)
    + "\" /> \n                ";
  return buffer;
  }

function program9(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n                    <img src=\"";
  if (stack1 = helpers.get_image_url) { stack1 = stack1.call(depth0, {hash:{},data:data}); }
  else { stack1 = depth0.get_image_url; stack1 = typeof stack1 === functionType ? stack1.apply(depth0) : stack1; }
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\" style=\"max-width:";
  if (stack1 = helpers.image_width) { stack1 = stack1.call(depth0, {hash:{},data:data}); }
  else { stack1 = depth0.image_width; stack1 = typeof stack1 === functionType ? stack1.apply(depth0) : stack1; }
  buffer += escapeExpression(stack1)
    + "\"/>\n                ";
  return buffer;
  }

function program11(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "<img style=\"display:inline-block; padding-right:3px;\" width=\"16px\" height=\"16px\" src=\"//icons.duckduckgo.com/i/";
  if (stack1 = helpers.domain) { stack1 = stack1.call(depth0, {hash:{},data:data}); }
  else { stack1 = depth0.domain; stack1 = typeof stack1 === functionType ? stack1.apply(depth0) : stack1; }
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += ".ico\" />";
  return buffer;
  }

function program13(depth0,data) {
  
  
  return "\n        <div class=\"clear\">&nbsp;</div>\n        ";
  }

  buffer += "<div id=\"zero_click\">\n    <div id=\"zero_click_wrapper2\">\n    \n        ";
  stack2 = helpers['if'].call(depth0, ((stack1 = depth0.forces),stack1 == null || stack1 === false ? stack1 : stack1.force_big_header), {hash:{},inverse:self.noop,fn:self.program(1, program1, data),data:data});
  if(stack2 || stack2 === 0) { buffer += stack2; }
  buffer += "\n\n        ";
  stack2 = helpers['if'].call(depth0, depth0.image_url, {hash:{},inverse:self.noop,fn:self.program(6, program6, data),data:data});
  if(stack2 || stack2 === 0) { buffer += stack2; }
  buffer += "\n\n        <div id=\"zero_click_abstract\" class=\"";
  if (stack2 = helpers.highlight) { stack2 = stack2.call(depth0, {hash:{},data:data}); }
  else { stack2 = depth0.highlight; stack2 = typeof stack2 === functionType ? stack2.apply(depth0) : stack2; }
  if(stack2 || stack2 === 0) { buffer += stack2; }
  buffer += "\" style=\"display:block;\">\n\n            "
    + "\n            "
    + "\n\n            <div>\n                <a class=\"zero_click_more_at_link\" href=\"";
  if (stack2 = helpers.source_url) { stack2 = stack2.call(depth0, {hash:{},data:data}); }
  else { stack2 = depth0.source_url; stack2 = typeof stack2 === functionType ? stack2.apply(depth0) : stack2; }
  if(stack2 || stack2 === 0) { buffer += stack2; }
  buffer += "\" onclick=\"fl=1;\"";
  if (stack2 = helpers.more_target) { stack2 = stack2.call(depth0, {hash:{},data:data}); }
  else { stack2 = depth0.more_target; stack2 = typeof stack2 === functionType ? stack2.apply(depth0) : stack2; }
  if(stack2 || stack2 === 0) { buffer += stack2; }
  buffer += ">";
  stack2 = helpers.unless.call(depth0, depth0.more_logo, {hash:{},inverse:self.noop,fn:self.program(11, program11, data),data:data});
  if(stack2 || stack2 === 0) { buffer += stack2; }
  if (stack2 = helpers.more) { stack2 = stack2.call(depth0, {hash:{},data:data}); }
  else { stack2 = depth0.more; stack2 = typeof stack2 === functionType ? stack2.apply(depth0) : stack2; }
  if(stack2 || stack2 === 0) { buffer += stack2; }
  buffer += "</a>\n            </div>\n        </div>\n\n        ";
  stack2 = helpers.unless.call(depth0, depth0.image_url, {hash:{},inverse:self.noop,fn:self.program(13, program13, data),data:data});
  if(stack2 || stack2 === 0) { buffer += stack2; }
  buffer += "\n    </div>\n</div>\n\n\n\n\n\n\n\n";
  return buffer;
  });
templates['text'] = template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [2,'>= 1.0.0-rc.3'];
helpers = helpers || Handlebars.helpers; data = data || {};
  var buffer = "", stack1, functionType="function", escapeExpression=this.escapeExpression, self=this;

function program1(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n    ";
  if (stack1 = helpers.text) { stack1 = stack1.call(depth0, {hash:{},data:data}); }
  else { stack1 = depth0.text; stack1 = typeof stack1 === functionType ? stack1.apply(depth0) : stack1; }
  buffer += escapeExpression(stack1)
    + "\n";
  return buffer;
  }

function program3(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n    ";
  stack1 = helpers['if'].call(depth0, depth0.header2, {hash:{},inverse:self.program(6, program6, data),fn:self.program(4, program4, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n";
  return buffer;
  }
function program4(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n        ";
  if (stack1 = helpers.header2) { stack1 = stack1.call(depth0, {hash:{},data:data}); }
  else { stack1 = depth0.header2; stack1 = typeof stack1 === functionType ? stack1.apply(depth0) : stack1; }
  buffer += escapeExpression(stack1)
    + "\n    ";
  return buffer;
  }

function program6(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n        ";
  if (stack1 = helpers.header1) { stack1 = stack1.call(depth0, {hash:{},data:data}); }
  else { stack1 = depth0.header1; stack1 = typeof stack1 === functionType ? stack1.apply(depth0) : stack1; }
  buffer += escapeExpression(stack1)
    + "\n    ";
  return buffer;
  }

  buffer += "\n<div>\n";
  stack1 = helpers['if'].call(depth0, depth0.text, {hash:{},inverse:self.program(3, program3, data),fn:self.program(1, program1, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n</div>\n";
  return buffer;
  });
})();
console.log("spice2.js");

/*
 *
 *  three types of spices:
 *
 *
 *  1. using a frame template
 *
 *      spice named template_<frame>.js, eg template_carousel.js
 *
 *      indicates that <frame> is the name of the frame template.
 *      We then load:
 *          /spice2/<frame>.js
 *          /spice2/<frame>.css
 *
 *  2. spice creates one item in the whole frame
 *      template.js
 *
 *  3. spice returns multiple items TODO
 *      - item array
 *      - template.js
 *
 *
 *  -------------------------------
 *
 *
 * TODO
 *
 * need to solve the problem of multiple spice and conflicting css
 *
 *
 *  templates are rendered and attached to a div we create
 *  - they never check or mess with an divs on the SERP, like #zero_click
 *
 *  that div is pushed to a display queue function
 *
 *  this display process is what then determines at the last second if it is to be displayed
 *
 *  if it could be re-rendered with an alternate template or even just hidden, we do it there.
 *
 *
 *  -------------------------------
 *
 *
 */

(function(env) {

var display_queue = [ ];

var Spice = {

spice_objects: [ ],

/*
 *  renders the body of the spice - no header, frame or "more at.." link.
 *  this can be done directly without this function but we register
 *  common handlers.
 */
render_body: function(obj, template_name) {

    if (Handlebars.templates.hasOwnProperty(template_name)) {
        return Handlebars.templates[template_name](obj);
    }
    
    return null;
},

/*
 * render
 *
 *
 * displays a zero click info, or abstract, box at the top of the SERP page.
 * successor to function nra()
 *
 * obj      : the object or list of objects to render
 * template : name of the template type for rendering
 *
 *
 */
render: function (obj) {
    var template_frame_outer; // zero click frame
    var template_frame_inner; // optional eg carousel
    var spice_body;           // rendered text from the spice, eg from the obj.template_normal template
    var div, div2, div3;      // temp pointers for div manipulation
    // var first_item = obj;     // FIXME
    var count=1;              // FIXME
    var is_stacked = false;
    var is_time;
    var img;
    var zero_click_wrapper = document.getElementById('zero_click_wrapper');

    if (!obj) return;


    // find the special cases for this source - see  `grep "force_" www-static/duckduck.js`
    // and save them in the given object for later
    obj.forces = Spice.get_forces(obj.source_name, obj);
    Spice.spice_objects.push(obj);

    first_item = Spice.spice_objects[0];

    console.log("Spice.render for spice_object #%d", Spice.spice_objects.length);

  /* setup */

    nuv();

    // Look for a force of the small version, e.g. yelp for http://yegg.duckduckgo.com/?q=oyster%20house
    // This is where it is bolted on an existing 0-click.
    var n_nux = _nux();
    is_stacked = (rt==='D' || n_nux);
    
    // TODO: zero_click_abstract_stacked
    // Abort if stacking and we already have a stack.
    if (is_stacked && $('zero_click_abstract_stacked').css('display')=='block')
        return false;

    /* the 'ddh' object allows plugins to change data for the built-in
     * templates from within template handlers, like source_url, see movie for an example
     * https://github.com/duckduckgo/zeroclickinfo-spice/blob/spice2/share/spice/movie/movie.js#L60-L66
     */

    if (obj.data && !obj.data.ddh) {
        obj.data.ddh = obj;
    }

/*
 *
 *  Find templates
 *
 */


    // To display time
    is_time = 0;
    // if (DDG.spice_force_time[first_item.s] || first_item.time) is_time = 1;
    // if (DDG.spice_force_time[first_item.source_name] || first_item.time) is_time = 1;

    /* TODO is_stacked ? obj.template_small : */
    // var template_name = obj.template_normal;
    // console.log("using template '%s'", template_name);


  /* outer template */


    // var template_frame = Handlebars.templates['default'];
    template_frame_outer = Handlebars.templates['SERP-default']; 

  /* find inner template, if any */
    
    if (obj.hasOwnProperty('template_frame')) {

        if ($(zero_click_wrapper).css("display") != "none") {
            console.log("might stack this, but not now");
            // TODO: decide here if we can do template_small
            return;
        }

        /* if stacked, should we continue to load the required resources? */
        loadAssets(obj.template_frame); // blocking sync load
        console.log("using inner template frame '%s'", obj.template_frame);
        template_frame_inner = Handlebars.templates[obj.template_frame];
    } else {
        console.log("using default template frame");
    }

    if (!template_frame_outer) {
        console.log("Spice.render: can't find the default frame template, blowing this joint");
        return;
    }



    obj.date = (new Date()).toString();


  /* remove pre-generated zero click structures so we can use a pure template approach
   *
   * TODO verify we haven't already done this before we remove it
   *   ...also if we do this and bail later, then what?
   */
    div = document.getElementById("zero_click");
    if (zero_click_wrapper && div) {
            console.log("zero_click_wrapper display is: '%s'", $(zero_click_wrapper).css("display"));

            if ($(zero_click_wrapper).css("display") != "none") {
                console.log("might stack this, but not now");
                return;
            }

        zero_click_wrapper.removeChild(div);
        console.log("removing existing #zero_click");
    }
    else console.log("can't find existing #zero_click in zero_click_wrapper ..?");

    div = null; // reset temp variable





/*  TODO
 *  Header types 
 *  0 - no header
 *  1 - inline header
 *  2 - big header
 *
 */



  /*
   * render spice body
   * or inner frame FIRST
   *
   * because it may set items used by the outer frame
   * such as the header or image
   *
   */

    if (template_frame_inner) {

        spice_body = template_frame_inner(obj);

    }
    else {

        // find a template function
        template_f = find_template(obj);

        // console.log("rendering normal spice body with template '%s'", template_name);

        if (template_f) {
            if (obj.data) {
                spice_body = template_f(obj.data);
            } else {
                console.log("have template function, but no 'data' element: rendering with the object itself.");
                spice_body = template_f(obj);
            }
        }
        else {
            console.log("no template function bail?");
            spice_body = '<div style="color:red">no result</div>';
        }
        
        // if (obj.data && template_name && Handlebars.templates.hasOwnProperty(template_name)) {
        //     spice_body = Handlebars.templates[template_name](obj.data);
        // } else {
        //     spice_body = '<div style="color:red">no result</div>';
        //     console.log("can't locate template '%s'", template_name);
        // }
    }

    // TODO: header stuff disabled
    // is_header = 0;
    // if (first_item.header1 && !is_stacked && !DDG.force_no_header[first_item.ssource_name]) {
    //     if (!is_time && (DDG.force_big_header[first_item.source_name] || first_item.force_big_header)) is_header = 2;
    //     else is_header = 1;
    // }


  /* domain, favicon */

    re = new RegExp('^.*?\/\/([^\/\?\:\#]+)');
    if (re.test(obj.source_url)) {
        obj.domain = RegExp.$1;
    }

    // if (DDG.force_favicon_domain[obj.source_name]) {
    //     obj.domain = DDG.force_favicon_domain[obj.source_name];
    // }
    if (obj.forces.force_favicon_domain)
        obj.domain = obj.forces.force_favicon_domain;

  /* setup object for outer template */

    if (!obj.more_target)
        obj.more_target = (kn && kn == '1') ? ' target="_blank"' : '';

    obj.highlight = 'highlight_zero_click_3 zero_click_snippet'; // TODO rules
    
  /*
   *
   * render frame
   *
   */

    console.log("rendering template_frame_outer");

    var newdv = document.createElement("div");
    newdv.innerHTML = template_frame_outer(obj);

    console.log("inserting rendered outer template");

    zero_click_wrapper.appendChild(newdv);


   /* make outer frame visible */

    /* this might not work due to timing - #zero_click_abstract might not exist yet */
    // if (obj.spice_render && obj.spice_render.length > 0)
    if (spice_body) {
        // div = d.getElementById("zero_click_abstract");
        // YAHOO.util.Dom.setStyle(div,'display','block');
        $("#zero_click_abstract").css('display', 'block');
    }


    if (spice_body) {
        // $(spice_body).prependTo("#zero_click_abstract");
        display_queue.push(spice_body);
        // $("#zero_click_abstract").append(spice_body);
    }


    if (display_spice()) {
        /* is there a special handler for this template frame ?
              eg spice specifies template_frame == "carousel" and we have loaded Spice.carousel
           for carousel this will insert the items AFTER the frame is rendered above.  */ 
        if (Spice[obj.template_frame]) {
            console.log("Spice.render calling special handler Spice.%s()", obj.template_frame);
            Spice[obj.template_frame](obj);
        }

    }

    /*
     * show zero click
     */

    $("#zero_click_wrapper").css({
        'display':'block',
        'visibility':'visible',
        'padding-top':'15px' });


    if (is_stacked) div = d.getElementById('zero_click_abstract_stacked');
    else div = null;

    /*
     * If stacked, add in a horizontal separator.
     * ki is check for meanings and kz is check for 0-click box settings.
     */

    // if ((rt=='D' || is_stacked) && (!ki || ki==1) && (!kz || kz==1)) {
    //     hr = d.createElement('hr');
    //     hr.id = 'zero_click_separator';
    //     YAHOO.util.Dom.addClass(hr,'horizontal_line');
    //     YAHOO.util.Dom.setStyle(hr,'width','100%');
    //     YAHOO.util.Dom.setStyle(hr,'clear','both');
    //     div.parentNode.insertBefore(hr,div);
    // }



    /*
     * Highlight shouldn't overlap image
     */
    if (viewport_width > 728) {
        tmp = YAHOO.util.Dom.getX('zero_click_image') - YAHOO.util.Dom.getX('zero_click_wrapper') - 50;

        if (isNaN && !isNaN(tmp)) {
            YAHOO.util.Dom.setStyle('zero_click_abstract','max-width',tmp+'px');
        }
    }
    else {
        YAHOO.util.Dom.setStyle('zero_click_abstract','max-width','100%');
    }


    // Add + or -

    div = d.getElementById('zero_click_wrapper2');
    div2 = d.getElementById('zero_click');

    // sh = $("#zero_click_wrapper2").prop("scrollHeight");

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



    DDG.resize();

    console.log("spice2: zci highlight is disabled");
    // $("#zero_click_abstract").hover(function() { $(this).toggleClass("highlight"); });

    console.log("spice2: zci scrolling is disabled");

    if (!obj.forces.force_no_fold) {
        Spice.add_scrolling(obj);
    }
}

};

/* template_map
 * generated by the server, defined in DDG::Util::SpiceT
 * maps template name to supporting js and css files.
 *
 * while these could be inferred, one of them might not exist
 * and it would be better to be able to skip it than get
 * a 404 Not Found error.
 */
Spice.template_map = JSON.parse(spice_templates);

var loadAssets = function(t) { //, f
    console.log("loadAssets for '%s'", t);
    if (Spice.template_map[t].css) {
        nrc('/spice2/' + t + "_" + Spice.template_map[t].css + ".css");
    }
    if (Spice.template_map[t].js) {
        var t2 = '/spice2/' + t + "_" + Spice.template_map[t].js + ".js";

        console.log("loadAssets getting '%s'", t2);
        $.ajax({
            type: "GET",
            url: t2,
            async:false,
            dataType: "script",
        }).done(function() {
            console.log("loadAssets for '%s' done", t2);
        });
    }
};

/* handlebars helpers */

/*
 * more
 */

Handlebars.registerHelper("more", function(s, options) {
    console.log("more helper");

    if (this.more_logo) {
        console.log("has more_logo");

        /* yes, this could be in the template */
        return l('More at %s', '<img src="/share/' + spice_sharedir + "/" + this.more_logo + '" alt="' + this.source_name  + '" style="display:inline-block"/>');
    }

    return l('More at %s', this.source_name);
});


// Handlebars.registerHelper("date", function() {
//     return (new Date()).toString();
// });


/* concat
 * a block iterator that separates elements with an item separator and a
 * conjunction for the last item.
 *
 * usage:
 *
 *   {{concat stuff sep="," conj="and"}}
 *       ...
 *   {{/concat}}
 *
 * examples: with {{#concat sep="," conj="and"}}
 * ['a']           gives  a
 * ['a', 'b']      gives  a and b
 * ['a', 'b', 'c'] gives  a, b and c
 */
Handlebars.registerHelper("concat", function(context, options) {
    console.log("concat helper for %o", context);
    console.log("options:", options);

    if (!context) return "";

    var sep = options.hash.sep || '';
    var conj = options.hash.conj || '';
    var len = context.length;
    var out = "";
    
    // some special cases
    if (len === 1) return options.fn(context[0]);
    if (len === 2) return options.fn(context[0]) + conj + options.fn(context[1]);
    if (len === 3) return options.fn(context[0]) + sep + " " + options.fn(context[1]) + conj + options.fn(context[2]);

    for (var i=0; i<len; i++){

        if (i == len - 1) out += sep + conj;
        else if (i>0) out+= sep + " "; // i is not zero

        out += options.fn(context[i]);
    }
    return out;
});

/*
 * condense
 * shorten a string with optional maxlen parameter
 * TODO: break on word boundary or call DDG.shorten instead
 *
 * usage:
 *
 *  {{condense stuff maxlen="135" truncation="..."}}
 *
 *  will output the value of stuff up to a maximum of 135 characters
 *  (not including the length of the truncation string)
 *  and append the truncation string.
 */
Handlebars.registerHelper("condense", function(s, params) {
        var maxlen;
        var trunc = params.hash.truncation || '...';
        
        if (params.hash.maxlen)
            maxlen = parseInt(params.hash.maxlen, 10);

        if (!s) return '';

        console.log("condense helper for '%s' len %d maxlen %d, params %o", s, s.length, maxlen, params);

        // this should break on a word boundary
        if (maxlen && s.length > maxlen) {
            console.log(" -> '%s'...", s.substring(0, maxlen));
            return s.substring(0, maxlen) + trunc;
        }

        return s;
});

/* loop
 * counts from zero to the value of obj, assuming obj is an object
 *
 * usage: {{#loop val}} ... {{/loop}}
 */
Handlebars.registerHelper("loop", function(obj, block) {

    var ret, data, max = obj < 100 ? obj : DDG_MAX_HB_LOOP;

    console.log("loop - from zero to %d", obj);

    /* provide index to inner block */
    if (block.data) {
        data = Handlebars.createFrame(block.data);
    }

    ret = "";

    for (var i=0; i<max; i++) {
        if (data) { data.index = i; data.max = max; }
        ret += block.fn(this, {data: data});
    }
    return ret;
});


/* each
 *
 * replaces the handlebars built-in each with limits
 *
 * usage:
 *
 *     {{#each from="2" to="5"}}
 *        ...
 *     {{/each}}
 *
 *  will limit the iteration to item indices 2, 3, 4
 *  (ie 'to' is exclusive)
 *
 *  both are optional
 *
 *  - if from is not given, defaults to 0
 *  - if to is not given, defaults to array (or object) length
 *
 */
Handlebars.registerHelper("each", function(context, options) {

    if (!context) return "";

    var from = +options.hash.from || 0,
        to = +options.hash.to || context.length,
        result = "";

    if (to > context.length) to = context.length;
    if (from < 0) from = 0;

    for(var i = from; i < to; i++) {
        result += options.fn(context[i]);
    }

    return result;
});

/* keys
 *
 * similar to each but for iterating over objects/associative arrays and accessing their
 * keys.
 *
 * evalutates contents with an object that has "key" and "value".
 *
 * usage
 *       {{#keys object}}
 *            {{key}} : {{value}}
 *       {{/keys}}
 *
 */
Handlebars.registerHelper("keys", function(obj, options) {
      var out = "";

      for (var k in obj) {
          out += options.fn({"key": k, "value": obj[k]});
      }

      return out;
});

Handlebars.registerHelper("image", Spice.image_url);

/* include
 * load the named template and apply it with the current context
 * this is better than 'partial' templates because you can include any template
 * you want and we don't have to precompile them in a special way.
 *
 * usage:
 *      {{include templatename}}
 */
Handlebars.registerHelper("include", function(template_name, params) {
    
    console.log("include for %o", template_name);
    if (Handlebars.templates.hasOwnProperty(template_name)) {
        return Handlebars.templates[template_name](this);
    }
    return "";
});

/*  bestResult {{{
 *
 *  determine the best object in the list
 *  list: array of objects
 *  isbetter: function to compare two objects
 *
 *  will not go beyond DDG.MAX_CANDIDATES
 *
 *  TODO: make sure isbetter is really a function and that list is really an array
 *
 */
var DDG_MAX_CANDIDATES = 1000;
var DDG_bestResult = function(candidates, comparison) {
    var best = candidates[0];

    var max = candidates.length;

    if (max > DDG_MAX_CANDIDATES) {
        max = DDG_MAX_CANDIDATES;
        // this fact should be logged
    }
    
    for (var i=0; i< max; i++) {
        best = comparison(best, candidates[i]);
    }

    return best;

}; // }}}

/* _nux
 * local substitute for nux() from duckduck.js
 *
 * returns true if there is a zero click header or abstract
 */
var _nux =  function() {

    if ($("#zero_click_heading").css('display') == 'block')
        return true;

    return ($("#zero_click_abstract").css('display') != 'none');

};

/*  display
 *
 *  insert the generated nodes into the DOM
 *
 *  we do a final check at this point as there may have already been some inserted.
 *
 *  the spice_objects array has the objects that have been considered
 *  in this function, if we're the first, then spice_objects.length == 1
 *
 */
var display_spice = function() {

    console.log('display_spice queue: %o', display_queue);

    // TODO: this whole thing is lame
    var nux_now = _nux();
    var is_stacked = false;
    var spice_div;

    if (display_queue.length === 0) {
        return false;
    }

    spice_body = display_queue.shift();

    /* is it possible that at this point we'll have the wrong thing to insert?
     * meaning, we instantiated a spice result with a large template, only now to
     * discover something is in its place that wasn't there when we checked before
     * instantiating the large template? if so, the we would have to re-render
     * the spice with a small template. */

    /* check again before we insert the nodes */
    // n_nux = _nux();
    
    // // Look for a force of the small version, e.g. yelp for http://yegg.duckduckgo.com/?q=oyster%20house
    // // This is where it is bolted on an existing 0-click.
    // is_stacked = ((rt==='D') || n_nux) //&& first_item.is_top // TODO first_item

    // // Abort if something is already displayed.
    // if (n_nux && (rt!=='D') && !is_stacked)
    //     return false;
    
    // // Abort if stacking and we already have a stack.
    // if (is_stacked && $('zero_click_abstract_stacked').css('display')=='block')
    //     return false;

    /* insert the spice */
    $("#zero_click_abstract").prepend(spice_body);

    /* make it visible */
    // $("#zero_click_wrapper").css('display', 'block');


    /*
     * more at   possibilities
     *
     *
     * 1. move more into a template. add it after spice_body.
     * 2. leave in place. prepend if not stacked, append if stacked.
     *
     */


    return true;
};

/*
 *  return text for a small version of a spice
 *
 *  we try:
 *
 *  1. template_small
 *  2. header1
 *  3. header2
 *
 */
var small = function(obj) {

    if (obj.hasOwnProperty(template_small)) {
        var tf = Handlebars.templates(obj.template_small);
    }

};

/* find_template
 * find a suitable template by examining the object given to Spice.render
 * returns a handlebars template function
 */
var find_template = function (o) {
    // if explicitly named
    if (o.template_normal && Handlebars.templates[o.template_normal])
        return Handlebars.templates[o.template_normal];

    if (o.template_normal) { console.log("find_template: template '%s' not found", o.template_normal); }
    else console.log("find_template: no template_normal named, checking for '%s'", spice_name);

    // if there is a template named after this spice
    if (Handlebars.templates[spice_name]) {
        return Handlebars.templates[spice_name];
    }
    else console.log("no template '%s', will use default 'text'", spice_name);

    // return default text-only template
    return Handlebars.templates.text;
}

/*
 * Add scrolling if needed.
 *
 * TODO
 */
Spice.add_scrolling = function(obj) {

    /* reasons to skip this */

    if (obj.forces.force_no_scroll) return;
    if (obj.force_no_fold) return;

    // if (is_stacked || obj.forces.force_no_scroll) //DDG.force_no_scroll[spice_objects[0].source_name])
    //     return;

    // if (obj.force_no_fold || !obj.source_name || obj.source_name.indexOf('Yummly')==-1)
    //     return;
     
    var div = d.getElementById('zero_click_wrapper2') || d.getElementById('zero_click_wrapper');

    /* apply rules for scrolling */

    if (div && div.scrollHeight > 150 && Spice.spice_objects.length == 1) {
        console.log("add_scrolling: > 150");
        $("#zero_click_wrapper2").css({
            "height":"125px",
            "overflow": "auto",
            "margin": "auto"});
        $("#zero_click").css({
            "padding-right": "0px",
            "padding-bottom": "5px"});
        $("#zero_click_plus_wrapper").css('padding-right','5px');
        $("#zero_click_abstract").css('margin-right','40px');
    } else if (div && div.scrollHeight > 125 && Spice.spice_objects.length > 1) {
        console.log("add_scrolling: more than one object");
        $("#zero_click_wrapper2").css({
            "height":"100px",
            "overflow": "auto",
            "margin": "auto"});
        $("#zero_click").css({
            "padding-right": "0px",
            "padding-bottom": "5px"});
        $("#zero_click_plus_wrapper").css('padding-right','5px');
        $("#zero_click_abstract").css('margin-right','40px');
    }
    else console.log("add_scrolling: no effect");
};



/* find the correct image */
Handlebars.registerHelper("get_image_url", function() {
    if (!this.image_url) return ""; // don't care

    if (this.forces.force_no_icon) return "";

    if (this.image_url.indexOf("http") === 0) return "/iu/?u=" + this.image_url;

    return this.image_url;
});


/* given a source, find the special cases for it, aka the forces that apply to it.
 * returns an object with the force-case values named after the various
 * DDG.force_ associative arrays.
 * this allows us to use them more directly in templates without all the if-then-else action. */
Spice.forces = [ 
    "force_time",
    "force_no_header",
    "force_no_icon",
    "force_no_fold",
    "force_favicon_domain",
    "force_favicon_url",
    "force_space_after",
    "force_big_header",
    "force_message",
    "force_no_scroll"];

/* find the special cases for a source
 * the object can override these */
Spice.get_forces = function(src, o) {
    var f, fval, these = { };

    for (i=0; i< Spice.forces.length; i++) {

        f = Spice.forces[i];
        fval = undefined;

        if (DDG["spice_" + f])    // built in checks
            fval = DDG["spice_" + f][src];

        if (o && o[f]) // override by also checking the object
            fval = o[f];

        if (fval)
            these[f] = fval;
    }

    console.log("Found forces: %o", these);

    return these;
};

/* TODO: this crap */
env.Spice = Spice;
env.DDG_bestResult = DDG_bestResult;


})(this);
