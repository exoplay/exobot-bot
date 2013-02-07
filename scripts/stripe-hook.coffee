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

    if req.body.type == 'charge.succeeded'
      message = "----STRIPE----\nRECIEVED #{req.body.data.object.currency} #{parseFloat(req.body.data.object.amount/100).toFixed(2)}\n(https://manage.stripe.com/payments/#{req.body.data.object.id})\n----STRIPE----"
      res.end "Said #{message}"
      robot.send(user, message)
