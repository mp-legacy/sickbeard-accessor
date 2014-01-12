collections = require "./collections"
models = require "./models"
SBapi = require "./api"
_ = require "underscore"

class SickBeard

  constructor: (SBpath, APIkey) ->
    @api = new SBapi(SBpath, APIkey)


  fetchAll: (cb) ->
    @api.fetchAllShows (err, showsJSON) ->
      if err? then cb(err, null)

      showsCollection = new collections.shows()
      _.each _.values(showsJSON.data), (showJSON) ->
        showsCollection.add new models.Show(showJSON)

      cb(null, showsCollection)




module.exports = SickBeard