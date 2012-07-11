spawn = require('child_process').spawn
querystring = require('querystring')

module.exports = (robot) ->
  robot.router.get "/hubot/say", (req, res) ->
    query = querystring.parse(req._parsedUrl.query)
    robot.send({ room: query.room, type: query.type || 'groupchat' }, query.message)

    res.end "Said #{query.message}"
