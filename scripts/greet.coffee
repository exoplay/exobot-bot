module.exports = (robot) ->
  robot.hear /(hi|hello|hey|yo),?\s(.*)/i, (msg) ->
    console.log("heard")
    if robot.name.toLowerCase() == msg.match[2].toLowerCase()
      msg.send(greet(msg.message.user.name))

greet = (name) ->
  greets[(Math.random() * greets.length) >> 0].replace(/{name}/, name);

greets = [
  "Hey, {name}.",
  "Hi, {name}.",
  "Hello, {name}."
]
