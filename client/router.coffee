app = require 'ampersand-app'
Router = require 'ampersand-router'
HomePage = require './pages/home'
NotFoundPage = require './pages/not-found'

module.exports = Router.extend
  routes:
    '': 'home'
    '(*path)': 'catchAll'

  # ------- ROUTE HANDLERS ---------
  home: ->
    app.trigger 'page', new HomePage

  catchAll: ->
    app.trigger 'page', new NotFoundPage
