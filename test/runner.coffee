fs = require 'fs'
path = require 'path'
http = require 'http'
exec = require('child_process').exec
spawn = require('child_process').spawn
request = require 'request'
Mocha = require('mocha')
_ = require 'underscore'

tmpFolderPath = path.resolve(__dirname,"tmp")
integrationTestPath = path.resolve __dirname, "integration"
unitTestPath = path.resolve __dirname, "unit"


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
  childProc = spawn("python",["#{sb_path}/SickBeard.py", "--nolaunch"])
  cb(childProc)


prepareTmp tmpFolderPath, ->
  cloneSickBeard tmpFolderPath, ->
    spinSickBeard path.resolve(tmpFolderPath,"Sick-Beard-development"), (childProc) ->
      sickBeardProcess = childProc
      writeSettings()
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

writeSettings = ->
  testConfig = fs.readFileSync path.resolve(__dirname,"config.test.ini")
  fs.writeFileSync path.resolve(tmpFolderPath,"Sick-Beard-development/config.ini"), testConfig


killService = ->
  console.log "\n -- killService -- \n "
  sickBeardProcess.kill("SIGKILL")


runTests = ->
  console.log "\n -- running tests -- \n "

  mocha = new Mocha;
  integrationTests = _.filter fs.readdirSync(integrationTestPath), (fileName) -> fileName.substr(-7) == '.coffee';
  unitTests = _.filter fs.readdirSync(unitTestPath), (fileName) -> fileName.substr(-7) == '.coffee';

  _.each integrationTests, (integrationTest) -> mocha.addFile path.join(integrationTestPath,integrationTest)
  _.each unitTests, (unitTest) -> mocha.addFile path.join(unitTestPath, unitTest)

  setupSBpaths ->

    mocha.run (failures) ->
      console.log "\n -- done running tests -- failures #{failures} -- \n"
      killService()
      process.exit (if failures == 0 then 0 else 1)

setupSBpaths = (cb) ->
  constructedUrl = "http://localhost:8081/api/TEST/"
  params =
    "cmd": "sb.addrootdir"
    "location": tmpFolderPath
  request.get { url: constructedUrl, json: true, qs: params}, (err, code, response) ->
    setTimeout cb,3000