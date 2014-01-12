Backbone = require "backbone"
episodeCollection = require "./episodes"

module.exports = Backbone.Collection.extend
  initialize: ->
    @episodes =  new episodeCollection()
