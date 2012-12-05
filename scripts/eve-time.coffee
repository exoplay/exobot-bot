# Description:
#   Time in eve
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot evetime
#
# Author:
#   ajacksified

module.exports = (robot) ->
  robot.respond /evetime/i, (msg) ->
    date = new Date()
    msg.send("EVEtime is #{date.toGMTString()}")
