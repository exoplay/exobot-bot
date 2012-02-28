# ol faces

module.exports = (robot) ->
  robot.hear /^u[m]+(.*)$/i, (msg) ->
    msg.send "http://i.imgur.com/rgkc6.png"

  robot.hear /^(rite|right)\??$/i, (msg) ->
    msg.send "http://i.imgur.com/LKcKt.png"

  robot.hear /^soon(\.*)$/i, (msg) ->
    msg.send "http://i.imgur.com/huYAB.png"

  robot.hear /^not bad(\.?)$/i, (msg) ->
    msg.send "http://i.imgur.com/0COAu.png"
