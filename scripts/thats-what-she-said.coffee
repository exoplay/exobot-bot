twss = require('twss');

module.exports = (robot) ->
  robot.hear /(.*)/i, (msg) ->
    twss.threshold = 0.85;

    if twss.is(msg.match[1])
      if ((Math.random() * 150) >> 0) == 1
        msg.send "that's what she said!"
