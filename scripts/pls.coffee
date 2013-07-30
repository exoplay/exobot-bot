module.exports = (robot) ->
  robot.respond /pls/i, (msg) ->
    msg.send('http://i.imgur.com/h62nUgj.gif')
