View = require 'ampersand-view'
# _ = require 'lodash'
# key = require 'keymaster'

module.exports = View.extend
  # register keyboard handlers
  registerKeyboardShortcuts: ->
    # var self = this;
    # _.each(this.keyboardShortcuts, function (value, k) {
    #     // register key handler scoped to this page
    #     key(k, self.cid, _.bind(self[value], self));
    # });
    # key.setScope(this.cid);
  unregisterKeyboardShortcuts: ->
    # key.deleteScope(this.cid);
