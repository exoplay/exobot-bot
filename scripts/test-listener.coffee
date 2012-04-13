module.exports = (robot) ->
  robot.router.get "/hubot/version", (req, res) ->
    res.end robot.version
