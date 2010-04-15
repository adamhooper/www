// http://kimili.com/journal/flexible-scalable-background-image
var flexiBackground = function(){

	/**
	 CONFIGURATION:
	 Define the size of our background image
	*/
	var bgImageSize = {
		width : 1023,
		height : 646
	};

	/**
	  Declare and define variables
	  */
	var $window,
	    $body,
	    imageID = "expando",
	    $bgImage, $wrapper, img, url, imgAR;

	/**
	  Are we dealing with ie6?
	  */
	var ie6 = ($.browser.msie && parseInt($.browser.version, 10) <= 6);

	/**
	  Set up the action that happens on resize
	  */
	var resizeAction = function() {
		var win = {
			height : $window.height(),
			 width : $window.width()
		};

		$bgImage.css('right', 0);

		// Need to fix the height of the wrapper for IE6
		if (ie6) {
			$wrapper.css('height', win.height);
		}
	};

	return {

		/*
		   Sets up the basic functionality
		   */
		initialize : function() {

		     // No need for any of this if the screen isn't bigger than the background image
		     if (screen.availWidth <= bgImageSize.width || screen.availHeight <= bgImageSize.height) {
			     return;
		     }

		     // Grab elements we'll reference throughout
		     $window = $(window);
		     $body = $('body');

		     // Parse out the URL of the background image and drop out if we don't have one
		     url = $body.css('background-image').replace(/^url\(("|')?|("|')?\);?$/g, '') || false;
		     if (!url || url === "none" || url === "") {
			     return;
		     }

		     // Get the aspect ratio of the image
		     imgAR = bgImageSize.width / bgImageSize.height;

		     // Create a new image element
		     $bgImage = $('<img />')
			     .attr('src', url)
			     .attr('id', imageID);

		     // Create a wrapper and append the image to it.
		     // The wrapper ensures we don't get scrollbars.
		     $wrapper = $('<div></div>')
			     .css({
					     'overflow' : 'hidden',
					     'width' : '100%',
					     'height' : '100%',
					     'z-index' : '-1'
					     })
			     .append($bgImage)
			     .appendTo($body);

		     // IE6 Doesn't do position: fixed, so let's fake it out.
		     // We'll apply a class which gets used in the CSS to emulate position: fixed
		     // Otherwise, we'll simply used position: fixed.
		     if (ie6) {
			     $wrapper.addClass('ie6fixed');
		     } else {
			     $wrapper.css({
					     'position' : 'fixed',
					     'top' : 0,
					     'left' : 0
					     });
		     }

		     // Set up a resize listener to add/remove classes from the body
		     $window.bind('resize', resizeAction);

		     // Set it up by triggering a resize
		     $window.trigger('resize');
	     }
	};
}();

$(document).ready(flexiBackground.initialize);
