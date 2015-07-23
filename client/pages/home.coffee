PageView = require './base'
templates = require '../templates'

module.exports = PageView.extend
  pageTitle: 'Home'
  template: templates.pages.home
