# Allows Hubot to talk back. Passive script.
cleverbot = require('cleverbot-node')

class ScoreKeeper
  constructor: (@robot) ->
    @cache = { scoreLog: {}, scores: {} }
    @robot.brain.on 'loaded', =>
      if @robot.brain.data.scores
        @cache.scores = @robot.brain.data.scores || {}
        @cache.scoreLog = @robot.brain.data.scoreLog || {}

  getUser: (user) ->
    if not @cache.scores[user] then @cache.scores[user] = 0
    user

  saveUser: (user, from) ->
    @robot.brain.data.scores = @cache
    @saveScoreLog(user, from)
    @cache.scores[user]

  add: (user, from) ->
    if @validate(user, from)
      user = @getUser(user)
      @cache.scores[user]++
      @saveUser(user, from)

  subtract: (user, from) ->
    if @validate(user, from)
      user = @getUser(user)
      @cache.scores[user]--
      @saveUser(user, from)

  all: -> @cache

  scoreForUser: (user) -> 
    user = @getUser(user)
    @cache.scores[user]

  saveScoreLog: (user, from) ->
    unless @cache.scoreLog[from] then @cache.scoreLog[from] = {}

    @cache.scoreLog[from][user] = new Date()

  isSpam: (user, from) ->
    unless @cache.scoreLog[from] then @cache.scoreLog[from] = {}

    if !@cache.scoreLog[from][user]
      return false

    @cache.scoreLog[from][user].setMinutes(@cache.scoreLog[from][user].getMinutes() + 5) > new Date()

  validate: (user, from) ->
    user != from && user != "" && !@isSpam(user, from)

module.exports = (robot) ->
  scoreKeeper = new ScoreKeeper(robot)

  robot.hear /([\w\s]+)([\W\S]*)?(\+\+)$/i, (msg) ->
    name = msg.match[1].trim().toLowerCase()
    from = msg.message.user.name.toLowerCase()

    newScore = scoreKeeper.add(name)

    if newScore? then msg.send "#{name} has #{newScore} points."

  robot.hear /([\w\s]+)([\W\S]*)?(\-\-)$/i, (msg) ->
    name = msg.match[1].trim().toLowerCase()
    from = msg.message.user.name.toLowerCase()

    newScore = scoreKeeper.subtract(name)
    if newScore? then msg.send "#{name} has #{newScore} points."

  robot.respond /score (for\s)?(.*)/i, (msg) ->
    name = msg.match[2].trim().toLowerCase()
    score = scoreKeeper.scoreForUser(name)

    msg.send "#{name} has #{score} points."
