---
id: 6
title: 'CritterFile'
subtitle: 'Animal rescues in Toronto'
slug: 6-critterfile
date: 2013-05-31
published_url: 'http://www.thestar.com/news/gta/critterfile.html'
image_html: '<iframe loading="lazy" src="https://d1wy5vfm86wlvw.cloudfront.net/critterfile/index.html" width="990" height="562"></iframe>'
---
##### For hacks


As published: "This six-year interactive map by Adam Hooper and Momoko Price shows where and how animals get into trouble in Toronto."

Momoko Price got a boatload of data from the Toronto Wildlife Centre. I fetched lots of images from Wikipedia (and I included the licenses and sources). We worked together to bring the data to the Star and help with editorial coverage.

The result was a big [set of stories in the Toronto Star](http://www.thestar.com/news/gta/critter_file.html).

The overarching theme is discovery: we want you to discover all this stuff you never knew was happening in your backyard. We chose a magnifying-glass analogy.


##### For hackers


We had too many data points to put on the map, and I always wanted to try a heatmap, so I started with that. I customized [heatmap.js](http://www.patrick-wied.at/static/heatmapjs/) for speed. I used [PhantomJS](http://phantomjs.org/) to generate PNG files for IE8. I wrote a funky JSON compression library (which I haven't open-sourced yet) to make the 17,000 data points manageable.

The map is a custom one. My goal was to keep colour and text away from the map, because they detract from the overlaid heatmap. I used [TileMill](http://www.mapbox.com/tilemill/) with OpenStreetMap data. I wrote a custom stylesheet and some custom PostGIS queries to get the road labels just right.

On to the magnifying glass: I rendered the map at three different zoom levels. (It isn't divided into tiles like Google Maps.) When you zoom in, the appropriate map is scaled and placed in the appropriate position. Then the base heatmap, which is an HTML `<canvas>` (or in IE8's case, an `<img>`) is copied, scaled and positioned to fit on top of the rectangle.

Every time the selection changes (that includes every time the magnifying glass is moved), a bunch of datasets are recomputed for the right-hand sidebar. There are lots and lots of optimizations, so it's smooth even on IE8.
