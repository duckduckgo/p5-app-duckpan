$(document).ready(function() 

	var $script, name, content;

	DDG.duckpan = true;

	// array of spice template <script>
	var hb_templates = $("script.duckduckhack_spice_template");

	// Check for any spice templates
	// grab their contents and name
	// compile and add named template
	// to global Handlebars obj
	if (hb_templates.length) {
		console.log("Compiling Spice Templates")
		Spice = Spice || {};
		hb_templates.each(function() {
			$script = $(this);
			content = $script.html();
			spiceName = $script.attr("spice-name");
			templateName = $script.attr("template-name");

			if (!Spice.hasOwnProperty(spiceName)) {
				Spice[spiceName] = {};
			}

			Spice[spiceName][templateName] = env.Handlebars.compile(content);

			console.log("Compiled template: ", spiceName+"_"+templateName);
		});

		console.log("Finished compiling templates")
		console.log("Now Spice obj: ", Spice);
		return;
	}
});