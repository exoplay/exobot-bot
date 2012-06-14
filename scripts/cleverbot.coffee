# cleverbot - now twice as clever

cleverbot = require('cleverbot-node')

module.exports = (robot) ->
  c = new cleverbot()

  robot.respond /c (.*)/i, (msg) ->
    data = msg.match[1].trim()
    c.write(data, (c) => msg.send(c.message))
