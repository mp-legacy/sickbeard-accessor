request = require 'request'
sbAccessor = require '../../lib/main'
assert = require("assert")

describe "#fetchAll", ->
  @timeout(10000);
  before (done) ->
    addShow 170551,done

  beforeEach ->
    @sbInstance = new sbAccessor("http://localhost:8081","TEST")
    @showsCollection = undefined

  it "fetches Shows from SickBeard", (done) ->
    @sbInstance.fetchAll (err,showsCollection) ->
      assert.equal err, null
      done()

  it "the returned collection contains one item", (done) ->
    @sbInstance.fetchAll (err,showsCollection) ->
      assert.equal showsCollection.length, 1
      done()



addShow = (tvdbid,cb) ->
  constructedUrl = "http://localhost:8081/api/TEST/"
  params =
    "cmd": "show.addnew"
    "tvdbid": tvdbid
  request.get { url: constructedUrl, json: true, qs: params}, (err, code, response) ->
    console.log response
    setTimeout cb, 3000
