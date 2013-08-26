//= require vendor/jquery-1.10.2

$ ->
  $('details').on 'open click', -> # click for Chrome; open for polyfill
    $('[data-src]', this).each ->
      src = this.getAttribute('data-src')
      this.setAttribute('src', src)
      this.removeAttribute('data-src')
