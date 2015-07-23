app = require 'ampersand-app'
_ = require 'lodash'
Router = require './router'
MainView = require './views/main'

# Extends our main app singleton
app.extend
  router: new Router

  init: ->
    # Create and attach our main view
    @mainView = new MainView
      el: document.getElementById('main')

    # this kicks off our backbutton tracking (browser history)
    # and will cause the first matching handler in the router
    # to fire.
    @router.history.start { pushState: true }

  # This is a helper for navigating around the app.
  # this gets called by a global click handler that handles
  # all the <a> tags in the app.
  # it expects a url pathname for example: "/costello/settings"
  navigate: (page) ->
    url = if page.charAt(0) is '/' then page.slice(1) else page
    @router.history.navigate url, {trigger: true}


$(document).foundation()
$ ->
  _.bind(app.init, app)()
