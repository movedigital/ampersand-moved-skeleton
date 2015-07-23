PageView = require './base'
templates = require '../templates'

module.exports = PageView.extend
  pageTitle: '404 - Not Found'
  template: templates.pages.notFound
