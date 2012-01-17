twss = require('twss');

module.exports = (robot) ->
  robot.hear /(.*)/i, (msg) ->
    if ((Math.random() * 100) >> 0) == 1
      if twss.is(msg.match[1])
        msg.send "that's what she said!"
