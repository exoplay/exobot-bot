# Which does exobot like best?
#
# which do you (like|like best|prefer): <thing> or <thing> [.. or <thing> to infinity]?

module.exports = (robot) ->
  robot.respond /(which )?do you (like|like best|prefer)[:,\s]? (.*)$/i, (msg) ->
    split = msg.match[3].split(" or ")
    thing = split[(Math.random() * split.length) >> 0]

    if thing[thing.length-1] == '?' then thing = thing[0..thing.length-2]

    msg.send("I #{msg.match[2]} #{thing}.")
