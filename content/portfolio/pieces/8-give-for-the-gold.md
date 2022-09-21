---
id: 8
title: 'Give for the Gold'
subtitle: 'Long-form story on multinational miners'
slug: 8-give-for-the-gold
date: 2011-04-11
published_url: '//adamhooper.com/portfolio/2011/give-for-the-gold/index.html'
image_html: '<div class="aspect-ratio-4-3"><iframe loading="lazy" src="http://adamhooper.com/portfolio/2011/give-for-the-gold"></iframe></div>'
---
##### For hacks


I wrote this piece to complete my Master of Journalism at Carleton University. I interviewed my main sources on the ground and didn't quote anything I didn't record. I employed one fixer in Kahama. I took pictures and filmed video myself.


##### For hackers


This is mainly a text story, so I edited it in OpenOffice (now LibreOffice). This was especially helpful for handling revisions.

I inserted invisible marks in the document corresponding to multimedia (for the final HTML) and citations (for fact-checking).

I wrote an XSLT script that converts the final `.odf` file into HTML. Multimedia elements are translated into raw `video` and `img` tags in the HTML.

Next, I wrote JavaScript to pluck the multimedia elements out of the main text flow, moving them to the side (or in the background). I tracked the user's scroll location to determine when multimedia elements should appear or disappear. (_Snowfall_ follows the same principle.)

The intent: keep the user focused on the story. The background and foreground images add context and back up the text.
