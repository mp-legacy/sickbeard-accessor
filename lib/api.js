(function() {
  var API, request;

  request = require("request");

  API = (function() {
    function API(host, key) {
      this.host = host;
      this.key = key;
      this.constructedUrl = this.host + "/api/" + this.key + "/";
    }

    API.prototype.fetchAllShows = function(cb) {
      var params;
      params = {
        cmd: "shows"
      };
      return request.get({
        url: this.constructedUrl,
        json: true,
        qs: params
      }, function(err, code, response) {
        return cb(err, response);
      });
    };

    return API;

  })();

  module.exports = API;

}).call(this);
