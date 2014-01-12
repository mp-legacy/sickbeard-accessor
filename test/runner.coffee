fs = require 'fs'
path = require 'path'
http = require 'http'
exec = require('child_process').exec
spawn = require('child_process').spawn;
phantom = require 'phantom'

tmpFolderPath = path.resolve(__dirname,"tmp")
sickbeardStarted = false
startedTries = 0
timeoutOnTries = 10
sickBeardProcess = undefined

prepareTmp = (tmpPath, cb) ->
  exec "rm -rf #{tmpPath}", (error, stdout, stderr) ->
    console.log error, stdout, stderr
    exec "mkdir #{tmpPath}", (error, stdout, stderr) ->
      console.log error, stdout, stderr
      cb()




cloneSickBeard = (tmpPath,cb) ->
  exec "wget -O #{tmpPath}/development.zip http://github.com/midgetspy/Sick-Beard/archive/development.zip", (error, stdout, stderr) ->
    console.log error, stdout, stderr
    exec "unzip #{tmpPath}/development.zip -d #{tmpPath}", (error, stdout, stderr) ->
      console.log error, stdout, stderr
      cb()

spinSickBeard = (sb_path,cb) ->
  childProc = spawn("python",["#{sb_path}/SickBeard.py", "-d", "--nolaunch"])
  cb(childProc)


prepareTmp tmpFolderPath, ->
  cloneSickBeard tmpFolderPath, ->
    spinSickBeard path.resolve(tmpFolderPath,"Sick-Beard-development"), (childProc) ->
      sickBeardProcess = childProc
      waitForBoot()


waitForBoot = (cb) ->
  console.log "\n\n\n\n"
  console.log "waiting for boot, try #{startedTries}"
  if startedTries == timeoutOnTries
    killService()
    return

  heartbeatCall = http.get "http://localhost:8081", (res) =>
    sickbeardStarted = true
    runTests()

  heartbeatCall.on 'error', (e) ->
    startedTries += 1
    setTimeout waitForBoot, 1000

killService = ->
  console.log "\n -- killService -- \n "
  sickBeardProcess.kill()

#cloneSickBeard tmpFolderPath, (err, repo) ->
#  console.log err,repo

runTests = ->
  console.log "\n -- running tests -- \n "

  extractApiKey ->


    console.log "\n -- done running tests -- \n"
#    killService()

extractApiKey = ->
  phantom.create (ph) ->
    ph.createPage (page) ->
      page.open "http://localhost:8081/config/general/", (status) ->
        page.evaluate ->
          $("#launch_browser").attr("checked",false)
          $("#version_notify").attr("checked",false)
          $("#use_api").attr("checked",true)
          $("#generate_new_apikey").click()
          setTimeout 1000, ->
            $(".config_submitter").click()
            setTimeout 4000, ->
              console.log "closing page"
              ph.exit();
