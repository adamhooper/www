//=require vendor/jquery-1.10.2

$.fn.stretch_background = () ->
  $body = $(this)

  url = $body.css('background-image').replace(/^url\(("|')?|("|')?\);?$/g, '') || false
  return if !url || url == 'none'

  $div = $('<div class="stretch-background"><img/></div>')
  $img = $div.children()
  $img.attr('src', url)
  $img.css({
    padding: 0,
    margin: 0,
    display: 'block',
    position: 'absolute',
    zIndex: 1,
    '-ms-interpolation-mode': 'bicubic',
    width: 'auto',
    height: '100%',
    right: 0
  })
  $div.css({
    overflow: 'hidden',
    width: '100%',
    height: '100%',
    zIndex: -1,
    position: 'fixed',
    top: 0,
    left: 0
  })

  resizeAction = () ->
    height = $(window).height
    $div.css('height', height)

  $(window).on('resize', resizeAction)
  resizeAction()

  $('body').append($div)

$ ->
  #$('body').stretch_background()
