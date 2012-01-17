twss = require('twss');

module.exports = (robot) ->
  robot.hear /(.*)/i, (msg) ->
    twss.threshold = 0.75;

    if twss.is(msg.match[1])
      if ((Math.random() * 75) >> 0) == 1
        msg.send "that's what she said!"
