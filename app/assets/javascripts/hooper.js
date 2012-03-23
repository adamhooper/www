$(function() {
	var $tags = $('#tags');
	if (!$tags.length) return;

	var $h3 = $tags.children('h3');
	var $ul = $tags.children('ul');

	var amount_to_hide = $ul.height();

	$tags.css('bottom', -amount_to_hide);

	$(window).load(function() {
		// Dunno why but Chrome and Firefox are wrong on "ready" event
		amount_to_hide = $ul.height();
		$tags.css('bottom', -amount_to_hide);
	});

	$tags.hover(function() {
		$tags.animate({bottom: 0}, {queue: false});
	}, function() {
		$tags.animate({bottom: -amount_to_hide}, {queue: false});
	});
	$tags.click(function() {
		amount_to_hide = 0;
		$tags.animate({bottom: 0});
	});
});
