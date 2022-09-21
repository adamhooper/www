---
id: 6
title: 'HTML Namespacing in Rails'
slug: 6-html-namespacing-in-rails
date: 2009-07-10T21:53:00Z
---

CSS is a nightmare. In Rails, [Sass](http://sass-lang.com) makes it more
bearable, but class naming is always frustrating: you must pick a
convention before your project starts and follow it religiously, or your
CSS rules will soon find themselves being applied way too liberally.
Even with strict conventions, reality soon outpaces theory and your CSS
directory becomes a mess.

In Rails, the truly annoying bit is the contrast with partials: CSS is a
mess, but partials are organized so nicely. Why not organize your CSS to
line up with your partials?

No more excuses. Here is a solution, fully functional and documented:
[HTML Namespacing](http://github.com/adamh/html_namespacing).

HTML namespacing automatically annotates your HTML partials with special
`class` attributes, and it lets you write Sass files with rules
automatically scoped to those classes. Should you feel the need, you can
even scope JavaScript files to those classes.

How? By using parallel directory structures. In your Rails framework,
you can create a convention to tie the following files together
automatically:

-   `app/views/foos/_foo.html.haml`: specifies the HTML
-   `app/stylesheets/views/foos/_foo.sass`: specifies the CSS
-   `app/javascripts/views/foos/_foo.js`: specifies the JavaScript

(I will probably be releasing a Rails plugin to ease JavaScript
inclusion within the next month. And though HTML namespacing could apply
to any web framework, my particular implementation is Rails-only.)

HTML namespacing is especially helpful when working in a team:
nomenclature decisions are mostly handled automatically, and every
developer knows where to put each CSS rule and line of JavaScript.

Give [HTML namespacing](http://github.com/adamh/html_namespacing) a try.
It is easy to integrate into existing projects, and it can save you
headaches.
