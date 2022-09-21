---
id: 3
title: 'Social images at Vatican City'
subtitle: 'A pilgrim''s-eye view of the papal conclave'
slug: 3-social-images-at-vatican-city
date: 2013-03-11
published_url: 'http://www.cbc.ca/news/interactives/conclave13/index.html'
image_html: '<iframe loading="lazy" src="https://www.cbc.ca/news2/interactives/conclave13/map.html" width="940" height="585" scrolling="no"></iframe>'
---
##### For hacks


CBC was covering the 2013 papal conclave and wanted something fresh. Twitter and Instagram are very fresh indeed.

We stylized an artsy map of the Vatican and added every geocoded picture we could find. We sprinkled in some geocoded tweets and vines to make sure there was always plenty of content.

We found that most tweets and Instagram posts surrounding Vatican City aren't actually geocoded. But we also found that the small fraction of users who geocode their tweets and images created plenty of content to keep the site fresh--especially when the pope was announced.



##### For hackers


I was as much a director as a programmer for this project.

My primary objective was training and we had a tight deadline. I proposed the architecture and coded some programming-heavy bits, but CBC's multimedia team wrote half of the JavaScript and much of the stylesheet (with my help).

My trickiest contributions were:

* The clock (no kidding). I customized [Walltime](https://github.com/sproutsocial/walltime-js) to get it just right without requiring a half-megabyte download.
* Placing the icons correctly. I used [Affinity](https://github.com/clockwork189/Affinity) to make the math easy: the developer enters a few points for which we know both the latitude/longitude and x/y coordinates, and the library creates a formula to find accurate x/y coordinates for any other latitude/longitude points using an affine transform. It's accurate enough; and it made it easy for us to change angles and sizes right up to the deadline.
* Clustering icons. I used [Leaflet](http://leafletjs.com/) and [Leaflet.markerclusterer](https://github.com/Leaflet/Leaflet.markercluster) with some special glue so the slideshow would expand and collapse clusters properly.
* Making it reusable. After the deadline, I refactored the interactive so that the CBC multimedia team can make new social media maps using just an HTML page and a new image.
