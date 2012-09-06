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
url = require('url')

module.exports = (robot) ->
  robot.router.post "/hubot/travis", (req, res) ->
    query = querystring.parse(req._parsedUrl.query)

    user = {}
    user.room = query.room if query.room
    user.type = query.type if query.type

    data = req.body

    build_environments =
       1: "Lua",
       2: "Luajit"

    message = "
    -----------------\n
    #{data.status_message.toUpperCase()} on #{build_environments[data.matrix[0].number.split(".")[1]]} <#{data.repository.name}> [#{data.commit}]\n
    Compare: #{data.compare_url}\n
    Committed by #{data.committer_name} at #{data.committed_at}\n
    -----------------"

    robot.send(user, message)

    res.end message
