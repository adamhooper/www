function withoutAnimations(callback) {
  var oldOff = $.fx.off;
  $.fx.off = true;
  callback();
  $.fx.off = oldOff;
}

function FigureDirectory(elem, classes) {
  this.$elem =  $(elem);
  this.classes = classes;

  this.init();
}

$.extend(FigureDirectory.prototype, {
  init: function() {
    this.classSelector = new RegExp('\\b(' + this.classes.join('|') + ')\\b');
    this.findFigures();
    this.cloneFigures();
  },

  findFigures: function() {
    var figures = this.originalFigures = [];
    var lastFigures = [];

    var _this = this;
    this.$elem.children().each(function() {
      var element = this;
      if (element.nodeName.toUpperCase() == 'FIGURE') {
        if (!_this.classes || _this.classSelector.test(element.className)) {
          figures.push(element);
          lastFigures.push(element);
        }
      } else {
        if (lastFigures.length && lastFigures[0]._figureDirectory_focusElement === undefined) {
          $(lastFigures).each(function() {
            this._figureDirectory_focusElement = element;
          });
        }
        lastFigures = [];
      }
    });
  },

  cloneFigures: function() {
    var clones = this.clonedFigures = [];

    $.each(this.originalFigures, function() {
      var $clone = $(this).clone();
      var clone = $clone[0];
      clone._figureDirectory_original = this;
      clones.push(clone);
    });
  },

  getFocusFigure: function(clonedFigure) {
    if (clonedFigure._figureDirectory_original) {
      return clonedFigure._figureDirectory_original;
    }
    return clonedFigure;
  },

  getFocusElement: function(figure) {
    var originalFigure = this.getFocusFigure(figure);
    return originalFigure._figureDirectory_focusElement;
  }
});

function BackgroundTracker($container, $scrollable, backgroundDirectory) {
  this.$container = $container;
  this.$scrollable = $scrollable;

  this.$focusBackground1 = $('<div class="background1"></div>');
  this.$focusBackground2 = $('<div class="background2"></div>');
  var css = {
    position: 'fixed',
    backgroundPosition: 'center',
    top: 0,
    left: 0,
    bottom: 0,
    right: 0
  };
  this.$focusBackground1.css(css);
  this.$focusBackground2.css(css);

  this.$container.prepend(this.$focusBackground2);
  this.$container.prepend(this.$focusBackground1);

  this.backgroundDirectory = backgroundDirectory;

  this.init();
}

$.extend(BackgroundTracker.prototype, {
  init: function() {
    this.attach();
    this.handleResize();
    this.handlePositionChange();
  },

  attach: function() {
    var _this = this;

    $(window).resize(function() {
      _this.handleResize();
      _this.handlePositionChange();
    });
    $(window).scroll(function() {
      _this.handlePositionChange();
    });
  },

  handleResize: function() {
    this.margin = parseFloat(this.$container.find('p:eq(0)').css('marginTop'));
  },

  handlePositionChange: function() {
    var y1 = $(window).scrollTop();
    var y2 = y1 + $(window).height();

    var focusFigure = this.backgroundDirectory.clonedFigures[0];
    var nextFigure = undefined;
    var nextFigureTop = undefined;

    var _this = this;
    $.each(this.backgroundDirectory.clonedFigures, function() {
      var clone = this;
      var focusElement = _this.backgroundDirectory.getFocusElement(clone);

      var top = $(focusElement).offset().top;
      if (top > y1) {
        nextFigure = clone;
        nextFigureTop = top - _this.margin / 2;
        return false;
      }
      focusFigure = clone;

      return true;
    });

    this.setFocusFigure(focusFigure);
    if (nextFigureTop >= y2 || nextFigure == focusFigure) {
      nextFigure = undefined;
      nextFigureTop = undefined;
    }
    this.setNextFigure(nextFigure);

    this.refreshBackgroundSizes(nextFigureTop);
  },

  setFocusFigure: function(figure) {
    if (this.focusFigure == figure) return;

    this.focusFigure = figure;
    var $img = $(figure).find('img');
    this.$focusBackground1.css({
      backgroundImage: 'url(' + $img.attr('src') + ')'
    });
  },

  setNextFigure: function(figure) {
    if (this.nextFigure == figure) return;

    this.nextFigure = figure;
    if (!figure) {
      this.$focusBackground1.css({ top: 0, bottom: 0 });
      this.$focusBackground2.hide();
    } else {
      var $img = $(figure).find('img');
      this.$focusBackground2.css({
        backgroundImage: 'url(' + $img.attr('src') + ')'
      });
      this.$focusBackground2.show();
    }
  },

  calculateBackgroundSize: function(img) {
    var $img = $(img);
    var w = $img.attr('width');
    var h = $img.attr('height');

    var viewWidth = $(window).width();
    var viewHeight = $(window).height();

    if (w * viewHeight > h * viewWidth) {
      return 'auto 100%';
    } else {
      return '100% auto';
    }
  },

  refreshBackgroundSizes: function(nextFigureTop) {
    var $img1 = $(this.focusFigure).find('img');
    var newBackgroundSize1 = this.calculateBackgroundSize($img1);
    if (newBackgroundSize1 != this.backgroundSize1) {
      this.backgroundSize1 = newBackgroundSize1;
      this.$focusBackground1.css({ backgroundSize: newBackgroundSize1 });
    }

    if (this.nextFigure) {
      var $img2 = $(this.nextFigure).find('img');
      var newBackgroundSize2 = this.calculateBackgroundSize($img2);
      if (newBackgroundSize2 != this.backgroundSize2) {
        this.backgroundSize2 = newBackgroundSize2;

        this.$focusBackground2.css({ backgroundSize: this.backgroundSize2 });
      }

      var y = $(window).scrollTop();
      var splitY = nextFigureTop - y; // relative to screen
      var h = $(window).height(); // always >= splitY
      if (splitY != this.splitY || this.windowHeight != h) {
        this.splitY = splitY;
        this.windowHeight = h;

        this.$focusBackground1.css({ top: splitY - h, bottom: h - splitY });
        this.$focusBackground2.css({ top: splitY, bottom: - splitY });
      }
    }
  }
});

function Gallery($container, $scrollable, figureDirectory) {
  this.$container = $container;
  this.$scrollable = $scrollable;
  this.figureDirectory = figureDirectory;
  this.minFigureWidth = 250;
  this.maxFiguresPerRow = 3;

  this.galleryOverlay = new GalleryOverlay($('body'), figureDirectory);

  this.init();
}

$.extend(Gallery.prototype, {
  init: function() {
    this.createAside();
    this.refreshVisibleFigures(true);
    this.attach();
  },

  createAside: function() {
    var $aside = this.$aside = $('<aside class="gallery"></aside>');

    var _this = this;
    $.each(this.figureDirectory.clonedFigures, function() {
      var clone = this;
      var $clone = $(this);

      $clone.append('<a href="#" class="zoom">zoom</a>');

      clone.id = _this.generateIdForFigure($clone);

      $clone.attr('title', $clone.find('figcaption').text());
      $aside.append(clone);
    });

    this.$container.append($aside);

    $('aside.gallery figure').live('click', function(e) {
      e.preventDefault();
      _this.galleryOverlay.open(this);
    });

    this.refreshSize();
  },

  generateIdForFigure: function($figure) {
    var type = 'img';

    var src;
    if ($figure.hasClass('img')) {
      src = $figure.find('img').attr('src');
    } else {
      src = $figure.find('source').attr('src');
    }

    var basename = src.split('/').pop().split('.')[0];

    var id = undefined;
    var n = 0;

    while (id === undefined) {
      var maybe = type + '-' + basename + (n === 0 ? '' : ('-' + n));
      if (!document.getElementById(maybe)) {
        id = maybe;
      }
      n++;
    }

    return id;
  },

  calculateNumFiguresPerRow: function() {
    var asideWidth = this.$aside.width();
    var nFigures = Math.floor(asideWidth / this.minFigureWidth);
    if (nFigures > this.maxFiguresPerRow) {
      nFigures = this.maxFiguresPerRow;
    }

    return nFigures;
  },

  calculateFigureWidth: function() {
    var asideWidth = this.$aside.width();
    var nFigures = this.calculateNumFiguresPerRow();

    var $aFigure = $(this.figureDirectory.clonedFigures[0]);
    var marginWidth = $aFigure.outerWidth(true) - $aFigure.outerWidth(false);

    return Math.floor((asideWidth - (nFigures + 1) * marginWidth) / nFigures);
  },

  refreshSize: function() {
    var articleWidth = this.$container.children('article').width();
    this.$aside.css('left', articleWidth);

    var figureWidth = this.calculateFigureWidth();
    this.$aside.find('figure').width(figureWidth);

    this.refreshVisibleFigures(true);
  },

  refreshVisibleFigures: function(force) {
    if (force) {
      this.figuresBefore = [null];
      this.figuresAfter = [null];
      this.figuresHere = [null];
    }

    var y1 = $(window).scrollTop();
    var y2 = y1 + $(window).height();

    var figuresBeforeObject = {};
    var figuresAfterObject = {};

    var _this = this;
    $.each(this.figureDirectory.clonedFigures, function() {
      var clone = this;
      var element = _this.figureDirectory.getFocusElement(clone);
      var $element = $(element);
      var top = $element.offset().top;
      var bottom = top + $element.outerHeight();

      if (y1 > bottom) {
        figuresBeforeObject[clone.id] = true;
      } else if (y2 < top) {
        figuresAfterObject[clone.id] = true;
      }
    });

    var $aFigure = $(this.figureDirectory.originalFigures[0]);
    var xBefore = - $aFigure.outerWidth(true);
    var xAfter = this.$aside.outerWidth();

    /* Make (ordered) Arrays of figures that need to move */
    var figuresForBefore = [];
    var figuresForHere = [];
    var figuresForAfter = [];
    var figuresBeforeSet = this.getSetFromArray(this.figuresBefore);
    var figuresAfterSet = this.getSetFromArray(this.figuresAfter);
    var animatedFigurePositions = {};
    $(this.figureDirectory.clonedFigures).each(function() {
      var clone = this;
      var position = $(clone).position();

      if (figuresBeforeObject[clone.id]) {
        if (position.left == xBefore) return;
        figuresForBefore.push(clone);
      } else if (figuresAfterObject[clone.id]) {
        if (position.left == xAfter) return;
        figuresForAfter.push(clone);
      } else {
        figuresForHere.push(clone);
      }

      animatedFigurePositions[clone.id] = position;
    });

    if (figuresForAfter.length != this.figuresAfter.length
        || (figuresForAfter.length > 0
          && figuresForAfter[0] != this.figuresAfter[0])) {
      /* Animate all "after" figures to the right; then ignore them */
      $(figuresForAfter).each(function() {
        var clone = this;
        if (figuresAfterSet[clone.id]) return;
        var $clone = $(clone);
        var position = animatedFigurePositions[clone.id];
        $clone.css({
          position: 'absolute',
          left: position.left,
          top: position.top
        });
        $clone.stop(true);
        $clone.animate({ left: xAfter, opacity: 0 }, 'slow');
      });

      this.figuresAfter = $.map(figuresForAfter, function(c) { return c.id });
    }

    if (figuresForBefore.length != this.figuresBefore.length
        || (figuresForBefore.length > 0
          && figuresForBefore[0] != this.figuresBefore[0])) {
      /* Animate away the "before" figures */
      $(figuresForBefore).each(function() {
        var clone = this;
        if (figuresBeforeSet[clone.id]) return;
        var $clone = $(clone);
        var position = animatedFigurePositions[clone.id];
        $clone.css({
          position: 'absolute',
          left: position.left,
          top: position.top
        });
        $clone.stop(true);
        $clone.animate({ left: xBefore, top: 0, opacity: 0 }, 'slow');
      });

      this.figuresBefore = $.map(figuresForBefore, function(c) { return c.id });
    }

    var nFiguresForHereChanged = (figuresForHere.length != this.figuresHere.length);

    if (figuresForHere.length != this.figuresHere.length
        || (figuresForHere.length > 0
          && figuresForHere[0] != this.figuresHere[0])) {
      /* Place each "here" figure relatively and animate from original to final position */

      var figuresForHereFinalPositions = {};
      $(figuresForHere).each(function() {
        var clone = this;

        var $clone = $(clone);
        $clone.stop(true);
        $clone.css({ position: 'relative', left: 0, top: 0 });

        var originalPosition = animatedFigurePositions[clone.id];
        var finalPosition = $(clone).position();

        if (originalPosition.left == xBefore) {
          originalPosition.top = 0;
        } else if (originalPosition.left == xAfter) {
          originalPosition.top = finalPosition.top;
        }

        $clone.css({
          left: originalPosition.left - finalPosition.left,
          top: originalPosition.top - finalPosition.top
        });

        $clone.animate({ left: 0, top: 0, opacity: 1 }, 'slow');
      });

      this.figuresHere = $.map(figuresForHere, function(c) { return c.id });
    }

    /*
     * Results (immediately):
     * - all absolutely-positioned figures are off-screen
     * - all on-screen figures are relatively positioned
     * 
     * Results (when animations finish):
     * - all on-screen figures have left/top of 0
     * - all off-screen figures have left of xBefore or xAfter
     */

    if (nFiguresForHereChanged) {
      this.$aside.stop(true);

      var figureHeight = this.$aside.children().outerHeight(true);
      var marginHeight = parseInt($(this.figureDirectory.clonedFigures[0]).css('marginTop'), 10);
      var nFiguresPerRow = this.calculateNumFiguresPerRow();
      var height = Math.ceil(figuresForHere.length / nFiguresPerRow) * figureHeight + marginHeight;

      var windowHeight = $(window).height() - $('footer').height();
      while (height > windowHeight) {
        height -= figureHeight;
      }

      if (height < figureHeight + marginHeight) {
        height = figureHeight + marginHeight;
      }

      var opacity = figuresForHere.length === 0 ? 0 : 1;
      this.$aside.animate({ opacity: opacity, height: height}, 'slow');
    }
  },

  getSetFromArray: function(array) {
    var set = {};

    $.each(array, function() {
      set[this] = true;
    });

    return set;
  },

  attach: function() {
    var _this = this;

    $(window).resize(function() {
      withoutAnimations(function() {
        _this.refreshSize();
      });
    });
    $(window).scroll(function() {
      _this.refreshVisibleFigures();
    });
  }
});

function GalleryOverlay($body, figureDirectory) {
  this.$body = $body;
  this.figureDirectory = figureDirectory;
}

$.extend(GalleryOverlay.prototype, {
  init: function() {
    this.attach();
  },

  attach: function() {
    var _this = this;
    $(window).resize(function() {
      withoutAnimations(function() {
        _this.calculateAspectRatio();
        _this.refreshFigureSize();
      });
    });
  },

  open: function(figure) {
    if (!this.$overlay) {
      this.createOverlay();
    }

    this.setFigure(figure);

    if (this.$overlay.css('display') == 'none') {
      this.$overlay.css({
        opacity: 0,
        display: 'block'
      });
      this.$overlayBackground.css({
        opacity: 0,
        display: 'block'
      });
      this.$overlayBackground.animate({ opacity: 1 });
      this.$overlay.animate({ opacity: 1 });
    }
  },

  createOverlay: function() {
    if (this.$overlay) return;

    var $b = this.$overlayBackground = $('<div class="gallery-overlay-background"></div>');
    this.$body.append($b);

    var _this = this;
    $b.click(function(e) {
      e.preventDefault();
      _this.close();
    });

    var $o = this.$overlay = $('<div class="gallery-overlay"><a href="#" class="close">close</a></div>');

    $o.find('a').click(function(e) {
      e.preventDefault();
      _this.close();
    });

    this.$body.append($o);
  },

  setFigure: function(figure) {
    console.log(figure);
    var originalFigure = this.figureDirectory.getFocusFigure(figure);
    console.log(originalFigure);
    var index = this.figureDirectory.originalFigures.indexOf(originalFigure);
    console.log(index);
    this.setIndex(index);
  },

  setIndex: function(index) {
    var figure = this.figureDirectory.originalFigures[index];

    var $clone = $(figure).clone();
    var clone = $clone[0];

    clone.originalFigure = figure;

    this.$overlay.find('figure').remove();
    this.$overlay.append(clone);

    this.refreshFigureSize();
  },

  calculateAspectRatio: function() {
    var width = this.$overlay.width();
    var height = this.$overlay.height() - this.$overlay.find('figcaption').height();
    this.aspectRatio = width / height;
  },

  refreshFigureSize: function() {
    if (!this.aspectRatio) this.calculateAspectRatio();
    var $figure = this.$overlay.children('figure');
    var originalFigure = $figure[0].originalFigure;
    var ow = $(originalFigure).width();
    var oh = $(originalFigure).height();
    var oRatio = ow / oh;

    var $obj = $figure.find('img, video');

    if (oRatio >= this.aspectRatio) {
      $obj.css({ width: '100%', height: 'auto' });
    } else {
      $obj.css({ width: 'auto', height: '100%' });
    }
  },

  close: function() {
    this.$overlay.stop(true);
    this.$overlayBackground.animate({ opacity: 0 }, function() {
      $(this).css({ display: 'none' });
    });
    this.$overlay.animate({ opacity: 0 }, function() {
      $(this).css({ display: 'none' });
    });
  }
});

function AboutHandler($body, $link, $contents) {
  this.$body = $body;
  this.$link = $link;
  this.$contents = $contents;

  this.init();
}

$.extend(AboutHandler.prototype, {
  init: function() {
    this.attach();
  },

  attach: function() {
    var _this = this;
    this.$link.click(function(e) {
      e.preventDefault();
      _this.open();
    });
  },

  open: function() {
    this.createOverlay();

    this.$overlay.stop(true);

    if (this.$overlay.css('display') == 'none') {
      this.$overlay.css({
        opacity: 0,
        display: 'block'
      });
      this.$overlayBackground.css({
        opacity: 0,
        display: 'block'
      });
    }
    this.$overlayBackground.animate({ opacity: 1 });
    this.$overlay.animate({ opacity: 1 });
  },

  createOverlay: function() {
    if (this.$overlay) return;

    var $b = this.$overlayBackground = $('<div class="about-overlay-background"></div>');
    this.$body.append($b);

    var _this = this;
    $b.click(function(e) {
      e.preventDefault();
      _this.close();
    });

    var $o = this.$overlay = $('<div class="about-overlay"><a href="#" class="close">close</a></div>');

    $o.find('a').click(function(e) {
      e.preventDefault();
      _this.close();
    });

    $o.append(this.$contents.children().clone());
    this.$body.append($o);
  },

  close: function() {
    this.$overlay.stop(true);
    this.$overlayBackground.animate({ opacity: 0 }, function() {
      $(this).css({ display: 'none' });
    });
    this.$overlay.animate({ opacity: 0 }, function() {
      $(this).css({ display: 'none' });
    });
  }
});

function BackgroundHandler($body, $link, backgroundTracker) {
  this.$body = $body;
  this.$link = $link;
  this.backgroundTracker = backgroundTracker;

  this.init();
}

$.extend(BackgroundHandler.prototype, {
  init: function() {
    this.attach();
  },

  attach: function() {
    var _this = this;
    this.$link.click(function(e) {
      e.preventDefault();
      _this.open();
    });
  },

  open: function() {
    if (!this.$overlay) {
      this.createOverlay();
    }
    if (this.$overlay.css('display') != 'none') {
      this.close();
      return;
    }

    this.refreshOverlay();

    this.$overlay.css({
      opacity: 0,
      display: 'block'
    });
    this.$overlayBackground.css({
      opacity: 0,
      display: 'block'
    });
    this.$overlayBackground.animate({ opacity: 1 });
    this.$overlay.animate({ opacity: 1 });
  },

  createOverlay: function() {
    if (this.$overlay) return;

    var $b = this.$overlayBackground = $('<div class="background-overlay-background"></div>');
    this.$body.append($b);

    var _this = this;
    $b.click(function(e) {
      e.preventDefault();
      _this.close();
    });

    var $o = this.$overlay = $('<div class="background-overlay"><a href="#" class="close">close</a></div>');

    $o.find('a').click(function(e) {
      e.preventDefault();
      _this.close();
    });

    this.$body.append($o);
  },

  refreshOverlay: function() {
    var focusFigure = this.backgroundTracker.focusFigure;
    this.$overlay.find('figure').remove();
    this.$overlay.append($(focusFigure).clone());
  },

  close: function() {
    this.$overlay.stop(true);
    this.$overlayBackground.animate({ opacity: 0 }, function() {
      $(this).css({ display: 'none' });
    });
    this.$overlay.animate({ opacity: 0 }, function() {
      $(this).css({ display: 'none' });
    });
  }
});

$(function() {
  var $scrollable = $(window);
  var $body = $('body');
  var $article = $('article');

  var figureDirectory = new FigureDirectory($article, [ 'img', 'video' ]);
  var backgroundDirectory = new FigureDirectory($article, [ 'background' ]);

  withoutAnimations(function() {
    var backgroundTracker = new BackgroundTracker($body, $scrollable, backgroundDirectory);
    var gallery = new Gallery($body, $scrollable, figureDirectory);
    var about = new AboutHandler($body, $("dt.about>a"), $("dd.about"));
    var backgroundLink = new BackgroundHandler($body, $('dt.background>a'), backgroundTracker);
  });
});
