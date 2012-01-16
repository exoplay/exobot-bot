# slap <name> around with a large trout 

module.exports = (robot) ->
  robot.respond /slap\s(.*)/i, (msg) ->
    name = msg.match[1].trim()
    response = '*slaps ' + name + ' around with a large trout*'

    msg.send(response)

