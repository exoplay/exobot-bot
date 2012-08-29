# Allows Hubot to talk back. Passive script.
cleverbot = require('cleverbot-node')

class ScoreKeeper
  constructor: (@robot) ->
    @cache = []
    @robot.brain.on 'loaded', =>
      if @robot.brain.data.scores
        @cache = @robot.brain.data.scores

  add: (user) ->
    user = user.toLowerCase()
    if not @cache[user] then @cache[user] = 0

    @cache[user]++
    @robot.brain.data.scores = @cache
    @cache[user]

  all: -> @cache

  scoreForUser: (user) -> 
    user = user.toLowerCase()
    @cache[user] or "User not found."

module.exports = (robot) ->
  scoreKeeper = new ScoreKeeper(robot)

  robot.hear /\+1(\s?(to|@)\s*)?\s?(.+)/i, (msg) ->
    name = msg.match[3].trim()
    newScore = scoreKeeper.add(name)

    msg.send "#{name} has #{newScore} points."

  robot.respond /score (for\s)?(.*)/i, (msg) ->
    name = msg.match[2].trim()
    score = scoreKeeper.scoreForUser(name)

    msg.send "#{name} has #{score} points."
