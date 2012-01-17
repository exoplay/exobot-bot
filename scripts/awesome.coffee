# put back the table

module.exports = (robot) ->
  robot.hear /awesome/i, (msg) ->
    if ((Math.random() * 20) >> 0) == 1
      msg.send(':awesome:')

