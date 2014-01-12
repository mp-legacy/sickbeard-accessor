request = require "request"

class API
  constructor: (@host, @key) ->
    @constructedUrl = @host + "/api/" + @key + "/"

  fetchAllShows: (cb) ->
    params =
      cmd: "shows"
    request.get { url: @constructedUrl, json: true, qs: params}, (err, code, response) ->
      cb(err,response)

module.exports = API