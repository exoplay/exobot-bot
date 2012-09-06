# Description:
#   "Travis CI alert hook"
#
# Configuration:
#   None
#
# Commands:
#   POST /hubot/travis [data]
#
# Authors:
#   ajacksified

querystring = require('querystring')
util    = require 'util'

module.exports = (robot) ->
  robot.router.post "/hubot/travis", (req, res) ->
    query = querystring.parse(req._parsedUrl.query)

    user =
      room: query.room || "ol-dev@conference.talk.exoplay.net"

    robot.logger.info util.inspect(JSON.parse(req.body.payload))
    data = JSON.parse(req.body.payload)

    build_environments =
       1: "Lua",
       2: "Luajit"

    message = "
    -----------------\n
    #{data.status_message.toUpperCase()} on #{build_environments[data.matrix[0].number.split(".")[1]]} <#{data.repository.name}> [#{data.commit}]\n
    Compare: #{data.compare_url}\n
    Committed by #{data.committer_name} at #{data.committed_at}\n
    -----------------"

    res.end "Said #{message}"
    robot.send(user, message)
