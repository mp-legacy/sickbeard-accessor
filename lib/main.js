(function() {
  var SBapi, SickBeard, collections, models, _;

  collections = require("./collections");

  models = require("./models");

  SBapi = require("./api");

  _ = require("underscore");

  SickBeard = (function() {
    function SickBeard(SBpath, APIkey) {
      this.api = new SBapi(SBpath, APIkey);
    }

    SickBeard.prototype.fetchAll = function(cb) {
      return this.api.fetchAllShows(function(err, showsJSON) {
        var showsCollection;
        if (err != null) {
          cb(err, null);
        }
        showsCollection = new collections.shows();
        _.each(_.values(showsJSON.data), function(showJSON) {
          return showsCollection.add(new models.Show(showJSON));
        });
        return cb(null, showsCollection);
      });
    };

    return SickBeard;

  })();

  module.exports = SickBeard;

}).call(this);
