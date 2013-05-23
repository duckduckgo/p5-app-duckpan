$(document).ready(function(){    
    console.log("Compiling Handlebars templates!");
    var script, html;
    var scripts = $("script.duckduckhack_template");
    var templates = Handlebars.templates = Handlebars.templates || {};
    console.log("Handlebars.templates: ", Handlebars.templates);
    for (var i = 0; i < scripts.length; i++){
	script = scripts[i];
	html = $(script).html();
	name = $(script).attr("name");
	Handlebars.templates[name] = Handlebars.compile(html);
	console.log("Compiled template: %s", name);
    }
    console.log("Finished compiling templates")
    console.log("Now Handlebars.templates: ", Handlebars.templates);
});
