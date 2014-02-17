$(document).ready(function() {
    console.log("Executing Duckpan.js...");
    var $script, name, content;

    // array of spice template <script>
    var hb_templates = $("script.duckduckhack_spice_template");

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
});

