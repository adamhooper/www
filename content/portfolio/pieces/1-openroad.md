---
id: 1
title: 'OpenRoad'
subtitle: 'Shows the bicycle accidents along your route'
slug: 1-openroad
date: 2012-05-02
published_url: 'http://openroad.adamhooper.com'
image_html: '<iframe loading="lazy" src="http://openroad.adamhooper.com" width="960" height="950"></iframe>'
---
##### For hacks


At OpenFile, six editors, Craig Silverman and I filed access-to-information requests in six cities for all the geo-located bicycle accidents we could get.

We wanted to make them into a story. So we found the stories that matter to you: your commute, your visits to friends' places, and your trips to the movies.

You keep your story; we add context.

This was published for OpenFile, whose website has since disappeared. I am hosting a private copy that only has Toronto data.



##### For hackers


* Google Maps provides the directions.
* When we get them back, we feed them to a custom Python server.
* The Python server simplifies the line a bit, then queries a PostGIS database for points closest to the line.
* We cluster the points and present them.
* We use Google Fusion Tables for the "View city-wide accidents" feature.

Source code: https://github.com/adamhooper/openroad
