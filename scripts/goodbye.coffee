module.exports = (robot) ->
  robot.hear /(bye|later|see y(ou|a)|take care),?\s(.*)/i, (msg) ->
    if robot.name.toLowerCase() == msg.match[3].toLowerCase()
      msg.send(goodbye(msg.message.user.name))

goodbye = (name) ->
  goodbyes[(Math.random() * goodbyes.length) >> 0].replace(/{name}/, name);

goodbyes = [
  "Bye, {name}.",
  "Later, {name}.",
  "Take care, {name}."
]

