# Description:
#   "Stripe alert hook"
#
# Configuration:
#   None
#
# Commands:
#   POST /hubot/stripe
#
# Authors:
#   ajacksified

querystring = require('querystring')
util    = require 'util'

module.exports = (robot) ->
  robot.router.post "/hubot/stripe", (req, res) ->
    query = querystring.parse(req._parsedUrl.query)

    user =
      room: query.room

    robot.logger.info req.body.payload
    robot.logger.info "----^---^---^---^---^---^"
    robot.logger.info util.inspect(JSON.parse(req.body.payload))

    data = JSON.parse(req.body.payload)

    if data.object.object == "charge"
      message = "
      ----STRIPE----\n
      RECIEVED #{data.object.currency} #{parseFloat(data.object.amount/100).toFixed(2)}\n
      ----STRIPE----"

      res.end "Said #{message}"
      robot.send(user, message)
