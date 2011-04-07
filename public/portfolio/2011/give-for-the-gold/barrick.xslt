<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:images="http://adamhooper.com/xslt/extension"
    xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0"
    xmlns:text="urn:oasis:names:tc:opendocument:xmlns:text:1.0"
    xmlns:xlink="http://www.w3.org/1999/xlink"
    exclude-result-prefixes="images office text xlink">

  <xsl:output method="html"
      encoding="utf-8"
      indent="yes"
      omit-xml-declaration="yes"
      doctype-public="XSLT-compat"
      />
  <xsl:strip-space elements="*"/>

  <xsl:template match="/">
    <xsl:for-each select="office:document">
      <html>
        <head>
          <title><xsl:value-of select="office:body/office:text/text:h[position()=1]"/></title>
          <link rel="stylesheet" type="text/css" href="style.css" />
          <xsl:comment><![CDATA[[if lt IE 9]>
            <script type="text/javascript">
// html5shiv MIT @rem remysharp.com/html5-enabling-script
// iepp v1.6.2 MIT @jon_neal iecss.com/print-protector
/*@cc_on(function(m,c){var z="abbr|article|aside|audio|canvas|details|figcaption|figure|footer|header|hgroup|mark|meter|nav|output|progress|section|summary|time|video";function n(d){for(var a=-1;++a<o;)d.createElement(i[a])}function p(d,a){for(var e=-1,b=d.length,j,q=[];++e<b;){j=d[e];if((a=j.media||a)!="screen")q.push(p(j.imports,a),j.cssText)}return q.join("")}var g=c.createElement("div");g.innerHTML="<z>i</z>";if(g.childNodes.length!==1){var i=z.split("|"),o=i.length,s=RegExp("(^|\\s)("+z+")",
"gi"),t=RegExp("<(/*)("+z+")","gi"),u=RegExp("(^|[^\\n]*?\\s)("+z+")([^\\n]*)({[\\n\\w\\W]*?})","gi"),r=c.createDocumentFragment(),k=c.documentElement;g=k.firstChild;var h=c.createElement("body"),l=c.createElement("style"),f;n(c);n(r);g.insertBefore(l,
g.firstChild);l.media="print";m.attachEvent("onbeforeprint",function(){var d=-1,a=p(c.styleSheets,"all"),e=[],b;for(f=f||c.body;(b=u.exec(a))!=null;)e.push((b[1]+b[2]+b[3]).replace(s,"$1.iepp_$2")+b[4]);for(l.styleSheet.cssText=e.join("\n");++d<o;){a=c.getElementsByTagName(i[d]);e=a.length;for(b=-1;++b<e;)if(a[b].className.indexOf("iepp_")<0)a[b].className+=" iepp_"+i[d]}r.appendChild(f);k.appendChild(h);h.className=f.className;h.innerHTML=f.innerHTML.replace(t,"<$1font")});m.attachEvent("onafterprint",
function(){h.innerHTML="";k.removeChild(h);k.appendChild(f);l.styleSheet.cssText=""})}})(this,document);@*/
            </script>
          <![endif]]]></xsl:comment>
          <xsl:comment><![CDATA[[if gte IE 7]>
            <style type="text/css">
              img { -ms-interpolation-mode: bicubic; }
            </style>
          <![endif]]]></xsl:comment>
        </head>
        <xsl:for-each select="office:body">
          <body>
            <xsl:for-each select="office:text">
              <article>
                <xsl:apply-templates/>
              </article>
            </xsl:for-each>
            <footer>
              <dl>
                <dt class="background"><a href="#">Background</a></dt>
                <dd class="background"></dd>
                <dt class="about"><a href="#">About</a></dt>
                <dd class="about">
                  <h2>About the project</h2>
                  <p><a href="http://adamhooper.com">Adam Hooper</a> researched, wrote and produced this story to complete the requirements for his master of journalism degree at <a href="http://carleton.ca">Carleton University</a>.</p>
                  <h3>Journalistic method</h3>
                  <ul>
                    <li>Interviews: the author conducted interviews in Canada in early 2010, in person in Tanzania in July, and in Canada and by telephone until January 2011. The author thanks those who consented to appear in this piece and those who spent their valuable time sharing background information. He apologizes to the many outspoken contributors whose voices don't appear here.</li>
                    <li>Photography: the author shot all pictures with a Nikon D5000 with stock 18-55mm VR lens.</li>
                    <li>Videography: the author captured video using the same Nikon D5000.</li>
                    <li>Integrity: Barrick Tanzania granted the author a chartered flight, a night's accommodation and two days' worth of meals so he could join a portion of the media tour described in the story. Such gifts are standard in Tanzania's cash-strapped media circles but typically fall outside North American ethical standards. The author believes it was impossible to understand Barrick's impact without joining part of the five-day tour, and he partook as briefly as possible to minimize the conflict of interest.</li>
                    <li>Supervision: <a href="http://www2.carleton.ca/sjc/cu-survey-centre/the-research-team/chris-waddell/">Christopher Waddell</a> guided the author's research and edited the story.</li>
                  </ul>
                  <h3>Web method</h3>
                  <p>This web page as an experiment in online journalism. Here is the rationale behind some less-obvious design decisions:</p>
                  <ul>
                    <li>The author employed HTML5 and CSS3 to use modern features such as semitransparent overlays and easy-to-code video components. The website is incompatible with some out-of-date web browsers, most notably Microsoft Internet Explorer 6.</li>
                    <li>The author and editor wrote and revised with regular word processors; a computer program turned the document into this web page using <a href="barrick.xslt">an XSLT transform</a> and <a href="gen_barrick_html.py">some Python code</a>.</li>
                    <li>Text spacing follows <a href="http://24ways.org/2006/compose-to-a-vertical-rhythm">a vertical rhythm</a>, meaning the heights of all headings, margins and lines of text are multiples of one universal line height.</li>
                    <li>The text column stays thin even when the web browser window is widened. This makes it easier to read and leaves room for a picture gallery. The resulting page height lends itself to backgrounds that scroll along with the text.</li>
                    <li>All photographs are cropped three-quarters as tall as they are wide, for consistency.</li>
                    <li>The web browser downloads images at a higher-than-necessary resolution then shrinks them. That way the user can resize the browser window or change the text size and the images will stretch to match.</li>
                  </ul>
                  <h3>Copyright</h3>
                  <p>All pictures, video and text are protected by copyright and may only be reproduced with permission. Where not otherwise specified, Adam Hooper is the sole copyright holder.</p>
                  <xsl:for-each select="office:text/text:bibliography">
                    <xsl:call-template name="bibliography"/>
                  </xsl:for-each>
                  <xsl:for-each select="office:text/text:p[@text:style-name='Bibliography_20_Heading']">
                    <xsl:call-template name="index"/>
                  </xsl:for-each>
                </dd>
              </dl>
            </footer>
          </body>
        </xsl:for-each>
        <script type="text/javascript" src="jquery-1.4.4.min.js"></script>
        <script type="text/javascript" src="js.js"></script>
      </html>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="text:p">
    <xsl:for-each select="text:reference-mark">
      <xsl:call-template name="figure" />
    </xsl:for-each>
    <xsl:choose>
      <xsl:when test="@text:style-name = 'Bibliography_20_Heading'"/>
      <xsl:when test="@text:style-name = 'Bibliography_20_1'"/>
      <xsl:otherwise>
        <p><xsl:apply-templates/></p>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="text:h">
    <xsl:for-each select="text:reference-mark">
      <xsl:call-template name="figure" />
    </xsl:for-each>
    <xsl:choose>
      <xsl:when test="@text:style-name = 'Title'">
        <h1><xsl:apply-templates/></h1>
      </xsl:when>
      <xsl:when test="@text:style-name = 'Subtitle'">
        <p class="author"><xsl:apply-templates/></p>
      </xsl:when>
      <xsl:when test="@text:style-name = 'Marginalia'"/>
      <xsl:when test="@text:outline-level = '1'">
        <h1><xsl:apply-templates/></h1>
      </xsl:when>
      <xsl:when test="@text:outline-level = '2'">
        <h2><xsl:apply-templates/></h2>
      </xsl:when>
      <xsl:when test="@text:outline-level = '3'">
        <h3><xsl:apply-templates/></h3>
      </xsl:when>
      <xsl:when test="@text:outline-level = '4'">
        <h4><xsl:apply-templates/></h4>
      </xsl:when>
      <xsl:otherwise>
        <h5><xsl:apply-templates/></h5>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="bibliography">
    <h3><xsl:value-of select="text:index-body/text:index-title/text:p"/></h3>
    <xsl:apply-templates/>
  </xsl:template>
  <xsl:template match="text:bibliography-source"/>
  <xsl:template match="text:index-body">
    <ul class="index">
      <xsl:for-each select="text:p">
        <xsl:call-template name="index-entry"/>
      </xsl:for-each>
    </ul>
  </xsl:template>
  <xsl:template name="index-entry">
    <li><xsl:apply-templates/></li>
  </xsl:template>

  <xsl:template name="index">
    <h3><xsl:apply-templates/></h3>
    <xsl:for-each select="following-sibling::text:*[1][self::text:p]">
      <ul class="index">
        <xsl:call-template name="recursive-index-entry"/>
      </ul>
    </xsl:for-each>
  </xsl:template>
  <xsl:template name="recursive-index-entry">
    <li><xsl:apply-templates/></li>
    <xsl:for-each select="following-sibling::text:*[1][self::text:p[@text:style-name='Bibliography_20_1']]">
      <xsl:call-template name="recursive-index-entry"/>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="text:note"/>
  <xsl:template match="text:bibliography-mark"/>
  <xsl:template match="text:bibliography"/>

  <xsl:template name="figure">
    <xsl:variable name="type" select="substring-before(@text:name, ':')"/>
    <xsl:choose>
      <xsl:when test="$type = 'img'">
        <xsl:variable name="caption" select="substring-after(@text:name, ' ')"/>
        <xsl:variable name="basename" select="substring-after(substring-before(@text:name, ' '), ':')"/>
        <xsl:variable name="path" select="concat('images/large/', $basename, '.jpg')"/>
        <xsl:variable name="width" select="images:image-width($path)"/>
        <xsl:variable name="height" select="images:image-height($path)"/>
        <figure class="img">
          <div>
            <img src="{$path}" width="{$width}" height="{$height}"/>
          </div>
          <figcaption><xsl:value-of select="$caption"/></figcaption>
        </figure>
      </xsl:when>
      <xsl:when test="$type = 'background'">
        <xsl:variable name="caption" select="substring-after(@text:name, ' ')"/>
        <xsl:variable name="basename" select="substring-after(substring-before(@text:name, ' '), ':')"/>
        <xsl:variable name="path" select="concat('images/background/', $basename, '.jpg')"/>
        <xsl:variable name="width" select="images:image-width($path)"/>
        <xsl:variable name="height" select="images:image-height($path)"/>
        <figure class="background">
          <img src="{$path}" width="{$width}" height="{$height}"/>
          <figcaption><xsl:value-of select="$caption"/></figcaption>
        </figure>
      </xsl:when>
      <xsl:when test="$type = 'video'">
        <xsl:variable name="caption" select="substring-after(@text:name, ' ')"/>
        <xsl:variable name="basename" select="substring-after(substring-before(@text:name, ' '), ':')"/>
        <xsl:variable name="basename_path" select="concat('video/', $basename)"/>
        <xsl:variable name="path_jpg" select="concat($basename_path, '.jpg')"/>
        <xsl:variable name="path_mp4" select="concat($basename_path, '.mp4')"/>
        <xsl:variable name="path_webm" select="concat($basename_path, '.webm')"/>
        <xsl:variable name="path_ogg" select="concat($basename_path, '.ogg')"/>
        <xsl:variable name="width" select="images:image-width($path_jpg)"/>
        <xsl:variable name="height" select="images:image-height($path_jpg)"/>
        <figure class="video">
          <div>
            <video width="{$width}" height="{$height}" poster="{$path_jpg}" controls="controls" preload="none">
              <source type="video/mp4" src="{$path_mp4}"/>
              <source type="video/webm" src="{$path_webm}"/>
              <source type="video/ogg" src="{$path_ogg}"/>
              <object width="{$width}" height="{$height}" type="application/x-shockwave-flash" data="video/flashmediaelement.swf">
                <param name="movie" value="video/flashmediaelement.swf"/>
                <param name="flashvars" value="controls=true&amp;poster={$path_jpg}&amp;file={$path_mp4}"/>
                <img src="{$path_jpg}" width="{$width}" height="{$height}" title="Couldn't play video on this web browser"/>
              </object>
            </video>
          </div>
          <figcaption><xsl:value-of select="$caption"/></figcaption>
        </figure>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="text:span">
    <xsl:choose>
      <xsl:when test="@text:style-name = 'Internet_20_link'">
        <a>
          <xsl:attribute name="href"><xsl:apply-templates/></xsl:attribute>
          <xsl:apply-templates/>
        </a>
      </xsl:when>
      <xsl:when test="@text:style-name = 'Citation'">
        <em><xsl:apply-templates/></em>
      </xsl:when>
      <xsl:when test="@text:style-name = 'Emphasis'">
        <em><xsl:apply-templates/></em>
      </xsl:when>
      <xsl:otherwise>
        <span><xsl:apply-templates/></span>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
