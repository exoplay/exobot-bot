twss = require('twss');

module.exports = (robot) ->
  robot.hear /(.*)/i, (msg) ->
    if twss.is(msg.match[1])
      if ((Math.random() * 50) >> 0) == 1
        msg.send "that's what she said!"
