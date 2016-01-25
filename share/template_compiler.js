(function(env) {

	// grab original Spice.failed to be called later
	var oldSpiceFailed = Spice.failed;

	// Create div to collect our warnings
	$("#message").removeClass("is-hidden").append('<div id="spice-errors"></div>');

	// define new Spice.failed which calls the original
	// and then notifies devs on the frontend
	env.Spice.failed = function (ia) {

		// First call original Spice.failed()
		oldSpiceFailed(ia);

		if (!ia){
			console.log('[ERROR] Spice.failed() called without specifying Spice ID.');
		}

		var errorMsg = 'Spice.failed() called by Spice with ID "' + ia + '".',
			$errorDiv = $('<div>').attr("class", "msg msg--warning").text(errorMsg);

		// Alert on frontend
		$('#spice-errors').append($errorDiv);

		// Alert in Console - just to be safe
		console.log('[NOTICE] ' + errorMsg);
	}
}(this));


$(document).ready(function() {

	var $script, name, content;

	DDG.duckpan = true;

	// array of IA template <script>
	var hb_templates = $('script.duckduckhack_ia_template'),
		goodie_scripts = $('.duckpan-run-on-ready'),
		toCall = [];

	// Check for any IA templates
	// grab their contents and name
	// compile and add named template
	// to global Handlebars obj
	if (hb_templates.length) {
		console.log('Compiling IA Templates');
		hb_templates.each(function() {
			var $script = $(this),
				content = $script.html(),
				iaName = $script.attr('ia-name'),
				templateName = $script.attr('template-name');

			if ($script.attr('is-ct-self') === '1'){
				toCall.push(iaName);
			}

			if (!DDH.hasOwnProperty(iaName)) {
				DDH[iaName] = {};
			}

			DDH[iaName][templateName] = Handlebars.compile(content);

			console.log('Compiled template: ', iaName + '_' + templateName);
		});

		console.log('Finished compiling templates')
		console.log('Now DDH obj: ', DDH);
	}

	if (hb_templates.length || goodie_scripts.length) {

		// Need to wait a little for page JS to finish
		// modifying the DOM
		setTimeout(function(){
			$.each(toCall, function(i, name){
				var cbName = 'ddg_spice_' + name;
				console.log('Executing: ' + cbName);
				if (typeof window[cbName] == 'function'){
					window[cbName]();
				}
			});

			// Execute JavaScript Goodies
			console.log("Executing Goodies");
			for (var i=0; i<goodie_scripts.length; i++) {
				var s = goodie_scripts[i].innerHTML.replace(/\/\*|\*\/$/g,'');
				console.log("Adding Goodie: " + $(goodie_scripts[i]).attr('ia-id'));
				eval(s);
			}
		}, 100);

		return;
	}
});
