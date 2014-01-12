## Node & Backbone accessors for Sick-Beard V0.0.1

* * *

[![Build Status](https://travis-ci.org/MaxPresman/sickbeard-accessor.png)](https://travis-ci.org/MaxPresman/sickbeard-accessor)

### What Does it Do?
Fetches data off sick-beard installation and parses it into a backbone collection and models, which are then passed back in a callback.

In this version the following methods are supported:

* Shows
  * Fetch All Shows

### How to Use?
```coffeescript
  sbAccessor = require("sickbeard-accessor")
  sbInstance = sbAccessor("http://localhost:8081",<your_api_key>)

  ##lets fetch all the shows
  sbInstance.fetchAll (err, showsCollection) ->
    #error: will bubble up if something is wrong with sick-beard
    #showsCollection: will contain a backbone collection with all the shows that are currently present
```


### Tests
  setup some grunt and run
 ```
    grunt test
 ```
