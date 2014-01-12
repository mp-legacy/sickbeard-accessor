SickBeard = require("./main")

SBinstance = new SickBeard("http://10.0.1.90:8081","efe05b2ac14ac313347a469eed60a46f")

SBinstance.fetchAll (err, showsCollection) ->
  console.log showsCollection