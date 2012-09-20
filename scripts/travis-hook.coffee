# Description:
#   "Travis CI alert hook"
#
# Configuration:
#   None
#
# Commands:
#   POST /hubot/travis?room=[roomname] [data]
#
# Authors:
#   ajacksified

querystring = require('querystring')
util    = require 'util'

module.exports = (robot) ->
  robot.router.post "/hubot/travis", (req, res) ->
    query = querystring.parse(req._parsedUrl.query)

    user =
      room: query.room

    robot.logger.info util.inspect(JSON.parse(req.body.payload))
    data = JSON.parse(req.body.payload)

    message = "
    -----------------\n
    #{data.status_message.toUpperCase()} <#{data.repository.name}> [#{data.commit}]\n
    Compare: #{data.compare_url}\n
    Committed by #{data.committer_name} at #{data.committed_at}\n
    -----------------"

    res.end "Said #{message}"
    robot.send(user, message)
