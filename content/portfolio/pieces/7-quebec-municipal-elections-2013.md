---
id: 7
title: 'Quebec Municipal Elections 2013'
subtitle: 'Election results for your postal code'
slug: 7-quebec-municipal-elections-2013
date: 2013-11-04
published_url: 'http://www.montrealgazette.com/news/Interactive+charge+your+area/9120074/story.html'
image_html: '<iframe width="480" height="500" loading="lazy" src="https://mtl-election.s3.amazonaws.com/index.html"></iframe>'
---
##### For hacks


There isn't much journalistic depth here, but I did conduct interviews with government technicians to ensure all would go as planned on election night.

The data:

* Municipal results from [Municipal Affairs](http://donnees.electionsmunicipales.gouv.qc.ca/)
* Montreal results from the City of Montreal (hosted on a media-only FTP server, because they were afraid of denial of service if too many people requested the file at once)
* Provincial shapes from [Statistics Canada](http://www12.statcan.gc.ca/census-recensement/2011/geo/bound-limit/bound-limit-2011-eng.cfm)
* Montreal shapes from the [City of Montreal](http://www.donnees.gouv.qc.ca/)


##### For hackers


The neat tricks here:

* Google Fusion Tables is quick-and-dirty.
* Fusion Tables doesn't highlight a polygon when you click on it. My solution: bake out each region as its own TopoJSON-encoded flat file. When the user clicks a region, Fusion Tables reports the region's ID, the app fetches the TopoJSON for that ID, and the app draws a polygon on top of the Google Map.
* Looking up electoral regions by postal code was very difficult. The City of Montreal outputs a list of all addresses in the city and their city-specific regions. And sometimes in Canada, the first three digits of a postal code map exclusively to a single municipality. But if a postal code isn't in Montreal and its first three digits don't map to one municipality, I'd need to find a latitude/longitude with Google's Geocoder service, then find the region that point is in with Google's Fusion Tables API. (Why not _always_ use Google's geocoder? Because there's a quota.)
* Since this was all flat files, it was easy to host and update on Amazon S3.

Source code: [https://github.com/adamhooper/quebec-municipal-elections-2013](https://github.com/adamhooper/quebec-municipal-elections-2013)
