$(document).ready(function() {
    console.log("Executing Duckpan.js...");
    var $script, name, content;

    // array of spice template <script>
    var hb_templates = $("script.duckduckhack_spice_template");

    // single goodie <script>
    var goodie = $("script.duckduckhack_goodie");

    // Check for any spice templates
    // grab their contents and name
    // compile and add named template
    // to global Handlebars obj
    if (hb_templates.length){
        console.log("Compiling Spice Templates")
        Handlebars.templates = Handlebars.templates || {};
        console.log("Handlebars.templates: ", Handlebars.templates);

        hb_templates.each(function(){
            $script = $(this);
            content = $script.html();
            name = $script.attr("name");
            Handlebars.templates[name] = Handlebars.compile(content);
            console.log("Compiled template: %s", name);
        });

        console.log("Finished compiling templates")
        console.log("Now Handlebars.templates: ", Handlebars.templates);
        return;
    }

    // Check for a goodie <script>
    // parse JSON contents and 
    // inject into page
    if (goodie.length){

        $script = $(goodie[0]);
        content = $script.html();
        name = $script.attr("name");

        var obj = $.parseJSON(content);
        
        $("#zero_click_abstract").show()
            .addClass("zero_click_answer")
            .before('<img class="icon_zero_click_answer" src="/icon16.png">')
            .html(obj.html || obj.answer); // Prefer HTML answer over plaintext

        if (obj.heading) {
            $("#zero_click_header").show()
            .text(obj.heading);
        }

        if (obj.image) {
            $("#zero_click_image").show()
                .html(  $("<img />").src(obj.image) );
        }

        $("#zero_click_wrapper").show()
            .css("visibility", "visible");

        console.log("Injected Goodie %s into page", name);
        return;
    }
});

