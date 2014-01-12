fs = require 'fs'
path = require 'path'
git = require 'nodegit'

tmpFolderPath = path.resolve(__dirname,"tmp")

prepareTmp = (tmpPath) ->
  if fs.existsSync(tmpPath) then fs.rmdirSync tmpPath
  fs.mkdirSync tmpPath

cloneSickBeard = (tmpPath,callback) ->
  git.Repo.clone "https://github.com/midgetspy/Sick-Beard.git", tmpPath, null, callback


prepareTmp(tmpFolderPath)
cloneSickBeard tmpFolderPath, (err, repo) ->
  console.log err,repo