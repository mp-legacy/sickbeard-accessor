(function() {
  var Backbone, episodeCollection;

  Backbone = require("backbone");

  episodeCollection = require("./episodes");

  module.exports = Backbone.Collection.extend({
    initialize: function() {
      return this.episodes = new episodeCollection();
    }
  });

}).call(this);
