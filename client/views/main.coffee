app = require 'ampersand-app'
dom = require 'ampersand-dom'
_ = require 'lodash'
View = require 'ampersand-view'
ViewSwitcher = require 'ampersand-view-switcher'
localLinks = require 'local-links'
templates = require '../templates'

module.exports = View.extend
  template: templates.main
  autoRender: true
  events:
    'click a[href]': 'handleLinkClick'

  initialize: ->
    # this marks the correct nav item selected
    @listenTo app, 'page', @handleNewPage

  render: ->
    # main renderer
    @renderWithTemplate @

    # init and configure our page switcher
    @pageSwitcher = new ViewSwitcher @queryByHook('page-container'),
      show: (newView, oldView) ->
        # it's inserted and rendered for me
        document.scrollTop = 0
        # add a class specifying it's active
        dom.addClass newView.el, 'active'
        # store an additional reference, just because
        app.currentPage = newView

    return @

  handleNewPage: (view) ->
    # tell the view switcher to render the new one
    @pageSwitcher.set(view)
    # mark the correct nav item selected
    @updateActiveNav()

  handleLinkClick: (e) ->
    # This module determines whether a click event is
    # a local click (making sure the for modifier keys, etc)
    # and dealing with browser quirks to determine if this
    # event was from clicking an internal link. That we should
    # treat like local navigation.
    localPath = localLinks.pathname(e)
    if localPath
      e.preventDefault()
      app.navigate localPath

  updateActiveNav: ->
    path = window.location.pathname.slice(1)
    @queryAll('.nav a[href]').forEach (aTag) ->
      aPath = aTag.pathname.slice(1)
      if !aPath and !path or aPath and path.indexOf(aPath) == 0
        dom.addClass aTag.parentNode, 'active'
      else
        dom.removeClass aTag.parentNode, 'active'
