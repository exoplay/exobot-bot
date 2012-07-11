spawn = require('child_process').spawn
querystring = require('querystring')

module.exports = (robot) ->
  robot.router.get "/hubot/say", (req, res) ->
    query = querystring.parse(req._parsedUrl.query)
    robot.send({}, query.message)

    robot.logger.debug "say-http: #{query.message}"

    res.end "Said #{query.message}"
