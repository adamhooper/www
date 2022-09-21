---
id: 4
title: 'Drugs from around the world'
subtitle: 'Origin and types of drugs seized at the Canadian border'
slug: 4-drugs-from-around-the-world
date: 2013-03-27
published_url: 'http://www.cbc.ca/news/interactives/cbsa-international-seizures/index.html'
image_html: '<iframe loading="lazy" src="https://www.cbc.ca/news2/interactives/cbsa-international-seizures/iframe/index.html" width="780" height="658" scrolling="no"></iframe>'
---
##### For hacks


As published: "A database compiled by the Canada Border Services Agency tracks illegal goods and contraband seized at border points in Canada, including more than $5.5 billion worth of drugs over the past six years."

This map supported [great](http://www.cbc.ca/news/canada/british-columbia/story/2013/03/27/pol-busted-at-the-border-drug-seizures-cbsa.html) [stories] (http://www.cbc.ca/news/politics/story/2013/03/27/pol-border-drug-seizures-china-gbh.html) written by David McKie related to [the data he acquired](http://www.cbc.ca/newsblogs/politics/inside-politics-blog/2013/03/post-15.html) via access-to-information requests.

It's great to know where illegal drugs are coming from. This map shows where the ones we _know_ of are coming from, and that's a start.


##### For hackers


D3 doesn't support IE8, so I had to get clever.

I used [a rough SVG/VML abstraction layer](https://github.com/adamhooper/censusfile/blob/master/app/assets/javascripts/paper.js.coffee) which I had originally used in CensusFile. It's like [Raphaël](http://raphaeljs.com/) but an order of magnitude faster. (It has far fewer features.)

I figured out the centroid of every Canadian province and every country. I downloaded a pretty map image, and I reverse-engineered its exact projection.

The rest was easy. Each line is a VML or SVG line between two coordinates (determined by the projection). Every time the selection changes, the lines' colour and thickness change to match.
