---
id: 3
title: 'Optimizing jQuery-based JavaScript'
slug: 3-optimizing-jquery-based-javascript
date: 2009-02-10T23:48:10Z
---

I write this article as much for internal use as for others. Its target
audience is competent jQuery users who need their code to run faster.

[jQuery](http://jquery.com) is fantastic, but its documentation does
little to distinguish best practices from worst. In particular, jQuery
supports very-slow and very-fast ways to do the same thing. What follows
is a collection of my notes during two days dedicated to optimizing a
large, JavaScript-intensive website.

### Before You Begin

Before you begin to optimize, *do not optimize*. Only optimize:

-   When somebody complains;
-   When you think somebody is only not-complaining out of courtesy;
-   When you suspect somebody is about to complain; or
-   When you have implemented all functionality and you want additional
    bragging rights

Why? Because optimizing early is a waste of time: you are not able to
guess where the bottlenecks are. Trust me.

Also, bottlenecks may be slightly different on different web browsers.

Okay, disclaimer out of the way, here is where your bottlenecks may be.

### Step 1: Define Metrics and Targets

Do not optimize until you have metrics and targets. A fair metric is,
for instance, “how long it takes `$(document).ready()` to run, in
milliseconds.” A fair target depends on your worldview; 50ms might sound
good for some pages. Different projects or optimization sessions may
call for different metrics. Every metric needs a unit (usually
“milliseconds”).

In our particular project, we invoke `$(document).ready()` in two
places: either from an “initializer JavaScript” file or in `<script>`
tags. Any code we run is within `$(document).ready()`. Since each file
implements a different feature, we decided to measure each file’s delay
separately so we could determine, feature-by-feature, whether to
optimize or scrap our functionality.

### Step 2: Measure

Design some way to quickly measure all your metrics.

[Firebug](http://getfirebug.com) has a very useful “Profile” mode which
is simple enough to use. We wrapped our code like this:


    if (window.console) window.console.profile("path/to/file.js");
    [ ... code to profile ... ]
    if (window.console) window.console.profileEnd();

For non-Firefox browsers, we added some pseudo-profiling code which will
`alert()` a list of metrics after the page has loaded. This lets us at
least verify our work, though it does not help with the actual work like
Firebug’s profiling data does.


    if (!window.console || !window.console.profile) {
      window.PROFILES = [];
      window.console = {
        profile: function(name) {
          window.PROFILE_NAME = name;
          window.PROFILE_TIME = new Date();
        },
        profileEnd: function() {
          window.PROFILES.push(window.PROFILE_NAME + ': ' + (new Date() - window.PROFILE_TIME) + 'ms');
        }
      };
      $(window).load(function() {
        // Ensure we finish $(document).ready() first....
        window.setTimeout(function() {
          if (window.PROFILES.length) {
            alert("Profiled:\
    \
    " + window.PROFILES.join("\
    "));
          }
        }, 100);
      });
    }

### Step 3: Profile

For our particular website, because we use Firebug for our metrics
anyway, profiling in Firefox amounts to loading our web page. We can see
which functions are slow, which functions are called too many times, and
which functions are not worth investigating.

The slowdowns generally fall into some basic categories, and the
solutions are often transferrable site-wide.

### Step 4: Optimize

#### Speed Up jQuery Selectors

Selectors come in varying flavours:

-   ID-based selectors, such as `$("#foo")`. These are blindingly fast.
-   Element-based selectors, such as `$("input")`. These are fast, but
    slower depending on what element you use. `$("label")` will probably
    be faster than $`("div")` if you use more `div`s than `label`s.
-   Class-based selectors, such as `$(".foo")`. These are less fast but
    more versatile.
-   Attribute-based selectors, such as `$("[name=bar]")`, and virtual
    selectors, such as `$(':input')`. These are painfully slow.

If `jQuery.find()` is dragging you down, your first order of business is
to move your selectors up the above list. If you are using `$(":input")`
on your entire site during page load, the browser needs to walk the
entire DOM tree; change that to an element-based selector such as
`$("button, input, select, textarea")` and the search will be an order
of magnitude faster. If you are dealing with a unique element on the
page, consider giving it an ID and selecting with that.

It is worth explicitly mentioning: avoid writing selectors without
either element names or IDs. In other words, never use `$(".foo")` when
you can write `$("div.foo")` instead.

These rules apply for compound selectors, too. For instance, rewrite
`$(".foo .bar")` as `$("div.foo div.bar")`.

##### Remove Selectors

If your selectors are still too slow, you may be able to remove them
altogether. For instance, if we start with code like this:


    $('div.geo').each(function() {
      var $geo = $(this);
      var lat = parseFloat($geo.children('div.latitude').text());
      var lng = parseFloat($geo.children('div.longitude').text());
      var image_path = $geo.children('div.image_path').text();
      // ...
    });

Because there were so many calls to `$geo.children()` in our website
(with maybe 75 `$geo` elements on a page), these selectors were
excessively slow. The rewrite was not too painful:


    $('div.geo').each(function() {
      var $geo = $(this);
      var lat, lng, image_path;
      $geo.children().each(function() {
        var c = this.className;
        if (/\blatitude\b/.test(c)) {
          lat = parseFloat($(this).text());
        } else if (/\blongitude\
    /.test(c)) {
          lng = parseFloat($(this).text());
        } else if (/\bimage_path\b/.test(c)) {
          image_path = $(this).text();
        }
      });
      // ...
    });

By eliminating all the excess selectors, we sped up our code by 40%.

Notice, by the way, an interesting tidbit from the above code:


    $element.hasClass('foo'); // slow
    /\bfoo\b/.test($element[0].className); // fast

This optimization works when hasClass() is being called very frequently
on a jQuery object which we are sure holds exactly one DOM element.

##### Cache Selectors

If you have code like this:


    $('div.foo div.bar div.baz1').something();
    $('div.foo div.bar div.baz2').somethingElse();
    $('div.foo div.bar div.baz3').somethingElseEntirely();

Consider rewriting to this:


    var $bar = $('div.foo div.bar');
    $bar.find('div.baz1').something();
    $bar.find('div.baz2').somethingElse();
    $bar.find('div.baz3').somethingElseEntirely();

##### Add Redundant Selector Elements

Imagine your page is divided into `#header`, `#page`, and `#footer`.
Also, imagine `#header` contains a significant portion of the
website—maybe 1/5 of it. Then, changing `$("div.foo")` to
`$("#page div.foo")` may, in some cases, give you a 20% speed boost.
Check this with your profiler. (Hopefully you’re scraping the bottom of
the barrel at this point, as we are talking of 1ms-2ms differences
here….)

##### Upgrade to jQuery 1.3

While jQuery 1.3 has some regressions compared with 1.2.6, it boasts a
rewritten selector engine with a noticeable performance improvement. The
above rules almost certainly apply anyway.

#### Avoid DOM Manipulation

DOM manipulation is slow. For instance, imagine a calendar written like
this:


    var $calendar = $('<table></table>');
    for (var i = 0; i < 6; i++) {
      var $tr = $('<tr></tr>');
      for (var j = 0; j < 7; j++) {
        $tr.append('<td></td>');
      }
      $calendar.append($tr);
    }

Yes, it’s pretty, but it is impractical. You will have to rewrite it to
something more pragmatic, such as:


    var $calendar = $('<table><tr><td><td>...</tr><tr>...</tr>...</table>');

##### (Except When Escaping User Input)

In general, a good portion of DOM manipulation can be circumvented. The
speedups are enormous, but make sure you escape user-supplied HTML
portions through jQuery’s interfaces.

That is, do not do this:


    var $calendar = $('<table class="' + $('input.calendar_name').text() + '"><tr>...</table>');

…because a quotation mark in the `$('input.calendar_name').text()` would
lead to unpredictable results. Use jQuery’s `attr()`, `text()`, and
`html()` when dealing with strings which may be partially or fully
constructed by your end user’s input.

##### Push Static Stuff to the Server Side

We use [semantic HTML](http://en.wikipedia.org/wiki/HTML#Semantic_HTML)
on our particular website, so it seems horrendous to us to write
multi-column lists on the server side. Idealists as we were, we served
our navigation menus in pristene HTML `ul` elements, relying upon a
jQuery plugin to split the menus into smaller sub-lists as they were
received by the client. Our profiler reported this splitting code as
taking 130ms (DOM manipulations are expensive). We caved and split the
menus on the server side, removing all that JavaScript altogether.

#### Manipulate the DOM Directly

jQuery’s DOM manipulation methods are brilliant, but they present some
overhead. For instance, imagine an unoptimized method to create an
“excerpt” of text which fits within a certain bounds, working something
like this (untested) jQuery plugin:


    jQuery.fn.excerpt = function(max_height) {
      return $(this).each(function() {
        var $e = $(this);
        var words = $e.text().split('\s*');
        var longest_fitting_string = '';
        var cur_string = '';
        for (var i = 0; i < words.length; i++) {
          cur_string = cur_string + ' ' + words[i];
          $e.text(cur_string);
          if ($e.height() > max_height) {
            break;
          } else {
            longest_fitting_string = cur_string;
          }
        }
        $e.text(longest_fitting_string);
      });
    };

This method is terribly slow: in particular, `$e.text()` and
`$e.height()` eat up too much time, as they are called dozens or
hundreds of times in the loop.

Because we know there is exactly one element in our inner loop and we
assume the element only contains text, we can replace
`$e.text(cur_string)` with the following:


    $e[0].firstChild.nodeValue = cur_string;

Likewise, we can use similar assumptions to transform
`$e.height() > max_height` into the following:


    $e[0].offsetHeight > max_height

These will make the `excerpt()` function many times faster than before
(but, frankly, still not enough to use in a production website).

Many aspects of jQuery are surprisingly slow. `css()`, `show()`,
`hide()`, and `hasClass()` spring to mind immediately, as they are so
easy to replicate with similar, yet much faster, behaviour. If you are
calling jQuery methods in a loop your profiler highlights, consider
using direct DOM manipulation, as long as you are certain you are not
relying upon some of the wonderful guarantees jQuery gives you.

#### Reimplement Algorithms

Computer science geeks excel here. Using the above `excerpt()` code as a
typical example, we can generally say that many algorithms are slower
than they need to be: not because of their tiny details (such as using
`$e.text()` instead of `$e[0].firstChild.nodeValue`), but because they
go about things the wrong way.

I left this optimization for the end for two reasons: it is often
time-consuming; and my readership is likely divided between the camp who
have done this already and the camp who do not know how. Basically, this
is the “computer science” aspect of JavaScript coding.

Improving the [running time](http://en.wikipedia.org/wiki/Running_time)
of algorithms can be fun, and the profiler will drop hints when it is
necessary. For instance, the profiler will show us that `excerpt()` is
still too slow. A savvy computer scientist may then rewrite it to use a
more clever heuristic, possibly based on a binary search, to eliminate
90% of the calls to `$e.text()` in typical calls to `excerpt()`.

Optimizing in this manner is often (usually?) more effective than
circumventing jQuery, and it leaves legible code. It works particularly
well if you coded using [Test-driven
development](http://en.wikipedia.org/wiki/Test-driven_development) since
rewriting algorithms will often break them.

### Step 5: Test

Ensure you did not break anything. There are many, many things you could
have broken. Hopefully you unit-test your code….

### Step 6: Repeat

Engineering is all about steps. Depending on your allocated time,
shifting priorities, and mood, after optimizing you should return to one
of the following steps:

-   Return to Step 5 (Test)
-   Return to Step 4 (Optimize)
-   Return to Step 3 (Profile)
-   Return to Step 2 (Measure)
-   Return to Step 1 (Define Metrics and Targets)
-   Return to Step 0 (Do Not Optimize)
