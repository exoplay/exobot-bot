greets = [
  "Hey",
  "Hi",
  "Hello",
  "Yo",
  "Sup"
]

module.exports = (robot) ->
  regexp = new RegExp("(" + greets.join("|") + "),?\\s" + robot.name + "(.|!)?", "i")

  robot.hear regexp, (msg) ->
    msg.send(greet(msg.message.user.name))

greet = (name) ->
  greets[(Math.random() * greets.length) >> 0] + ", " + name;
