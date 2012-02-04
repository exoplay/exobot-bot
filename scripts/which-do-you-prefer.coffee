# Which does exobot like best?
#
# which do you (like|like best|prefer): <thing> or <thing> [.. or <thing> to infinity]?

module.exports = (robot) ->
  robot.respond /which do you (like|like best|prefer):? (.*)$/i, (msg) ->
    split = msg.match[2].split(" or ")
    msg.send("I #{msg.match[1]} #{split[(Math.random() * split.length) >> 0]} .")
