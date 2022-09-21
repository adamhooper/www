---
id: 5
title: 'Drugs from the United States'
subtitle: 'Seizures of drugs from the United States into Canada'
slug: 5-drugs-from-the-united-states
date: 2013-03-27
published_url: 'http://www.cbc.ca/news/interactives/cbsa-border-seizures/index.html'
image_html: '<iframe loading="lazy" src="https://www.cbc.ca/news2/interactives/cbsa-border-seizures/iframe/index.html" width="780" height="700" scrolling="no"></iframe>'
---
##### For hacks


As published on CBC: "Over the last six years, the Canada Border Services Agency has seized billions of dollars worth of drugs at border points across Canada. The map below uses data from a CBSA database to show seizures of drugs originating in the United States at Canadian land-border crossings, ports, airports and mail centres."

The data was [requested by David McKie](http://www.cbc.ca/newsblogs/politics/inside-politics-blog/2013/03/post-15.html).

I admit I felt personally motivated by this story: I grew up near the U.S. border and I've always been fascinated by life on the edge. I hope to inspire others in the same way.

This is really a big bunch of "Top 10" lists: choose a drug and whether to sort by value or number of drug seizures, and we'll list the top border crossings. I personally like it as a game: I take some border crossings I know and try to find the drug for which they'll rank the highest possible.

I designed the animated-rectangles chart on my own, then I realized it was a bit more innovative than I'd thought. I explained it to editors as akin to [a Slate story on gun deaths](http://www.slate.com/articles/news_and_politics/crime/2012/12/gun_death_tally_every_american_gun_death_since_newtown_sandy_hook_shooting.html). It was also a bit like all those D3 force-directed graphs ([example](http://www.nytimes.com/interactive/2012/02/13/us/politics/2013-budget-proposal-graphic.html)) I'd seen of late.

The hardest part was geocoding. David McKie and I entered the latitude and longitude of every single border crossing.

Another hard part was determining the sizes of dots and rectangles. A seizure's value can vary from $1 to $1 billion. I experimented with several exponential and logarithmic scales.


##### For hackers


I'm fed up with [EPSG:3587](http://wiki.openstreetmap.org/wiki/EPSG:3857), the map projection that Google Maps and other web maps use. It skews Canada terribly.

So I generated a custom SVG map, using PostGIS and map data from public Canadian and American websites. It uses [EPSG:3348](http://spatialreference.org/ref/epsg/3348/), the projection Statistics Canada recommends. All the dots are SVG `<circle>` elements with `data-location=[permalink]` attributes.

The IE8 support came through [SVGWeb](https://code.google.com/p/svgweb/).

But an SVG map means we can't use an existing mapping library. I had to code a custom zoom function, custom panning, and so on. It's tricky and not much fun, but I feel this map projection contributes to the story.
