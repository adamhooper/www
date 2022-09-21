---
id: 2
title: 'CensusFile'
subtitle: 'Zoom in on your block'
slug: 2-censusfile
date: 2012-05-29
published_url: 'http://censusfile.adamhooper.com'
image_html: '<iframe loading="lazy" src="http://censusfile.adamhooper.com" width="960" height="650" scrolling="no"></iframe>'
---
##### For hacks


Which statistics are interesting, and which are boring?

It really depends on the story. As published for OpenFile (before it went offline), our story was "compare your block with your friend's".

I later revamped the interactive, making it easier to use, expecting that I would sell it to a publication and we could work a new story together. Alas, no sale happened. If you'd like to publish a census map, please contact me and we can formulate a story.

In the meantime, the most interesting feature is certainly the zooming. The statistics are divided by block.



##### For hackers


Perhaps you'd better stick to the source code, at https://github.com/adamhooper/censusfile.

I'll summarize:

* Just like Google, this interactive presents data in tiles.
* Those tiles are JSON objects with lots of data: vector representations of regions, bitmaps of hit regions (to detect what region you're hovering over), and statistics for each region on the tile.
* The web server builds these tiles from two sets of information: a 35GB database of polygons, and a 100MB database of statistics. The 35GB database is uploaded ahead of time; the 100MB database takes about five minutes to generate and upload, so it can go live on the day the data is released.
* The client is extremely-heavily optimized, so it works in Internet Explorer 8. For instance, the client skips parsing the JSON tile data and instead deals with small pieces of it, using regular expressions.
