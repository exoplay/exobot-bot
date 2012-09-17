cool = ["superb",
        "great",
        "awesome",
        "stellar",
        "rad"]

story = ["tale",
         "narrative",
         "account",
         "anecdote",
         "spiel"]

bro = ["broski",
       "broheim",
       "broner",
       "brosef",
       "brody",
       "brah",
       "bronie",
       "brother"]


module.exports = (robot) ->
  robot.hear /cool[\s+]story[\s+]bro/i, (msg) ->
    msg.send(cool[(Math.random() * cool.length) >> 0] + " " + story[(Math.random() * story.length) >> 0] + " " + bro[(Math.random() * bro.length) >> 0])
