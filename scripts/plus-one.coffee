# Allows Hubot to talk back. Passive script.
cleverbot = require('cleverbot-node')

class ScoreKeeper
  constructor: (@robot) ->
    @cache = []
    @robot.brain.on 'loaded', =>
      if @robot.brain.data.scores
        @cache = @robot.brain.data.scores

  getUser: (user) ->
    if not @cache[user] then @cache[user] = 0
    user

  saveUser: (user) ->
    @robot.brain.data.scores = @cache
    @cache[user]

  add: (user) ->
    user = @getUser(user)
    @cache[user]++
    @saveUser(user)

  subtract: (user) ->
    user = @getUser(user)
    @cache[user]--
    @saveUser(user)

  all: -> @cache

  scoreForUser: (user) -> 
    user = @getUser(user)
    @cache[user]

module.exports = (robot) ->
  scoreKeeper = new ScoreKeeper(robot)

  robot.hear /(.+)(\+\+)/i, (msg) ->
    name = msg.match[1].trim().toLowerCase()

    if name != msg.message.user.name.toLowerCase()
      newScore = scoreKeeper.add(name)
      msg.send "#{name} has #{newScore} points."

  robot.hear /(.+)(\-\-)/i, (msg) ->
    name = msg.match[1].trim().toLowerCase()

    if name != msg.message.user.name.toLowerCase()
      newScore = scoreKeeper.subtract(name)
      msg.send "#{name} has #{newScore} points."

  robot.respond /score (for\s)?(.*)/i, (msg) ->
    name = msg.match[2].trim().toLowerCase()
    score = scoreKeeper.scoreForUser(name)

    msg.send "#{name} has #{score} points."
