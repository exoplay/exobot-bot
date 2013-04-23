# Description:
#   Give or take away points. Keeps track and even prints out graphs.
#
# Dependencies:
#   "underscore": ">= 1.0.0"
#   "clark": "0.0.6"
#
# Configuration:
#
# Commands:
#   <name>++
#   <name>--
#   hubot score <name>
#   hubot top <amount>
#   hubot bottom <amount>
#   GET http://<url>/hubot/scores[?name=<name>][&direction=<top|botton>][&limit=<10>]
#
# Author:
#   ajacksified


_ = require("underscore")
clark = require("clark")
querystring = require('querystring')

class ScoreKeeper
  constructor: (@robot) ->
    @robot.brain.data.scores ||= {}
    @robot.brain.data.scoreLog ||= {}

    @cache =
      scores: @robot.brain.data.scores
      scoreLog: @robot.brain.data.scoreLog

    @robot.brain.on 'connected', =>
      @robot.brain.data.scores ||= {}
      @robot.brain.data.scoreLog ||= {}

      @cache.scores = @robot.brain.data.scores || {}
      @cache.scoreLog = @robot.brain.data.scoreLog || {}
      @cache.mostRecentlyUpdated = @robot.brain.data.mostRecentlyUpdated || ""

  getUser: (user) ->
    @cache.scores[user] ||= 0
    user

  saveUser: (user, from) ->
    @saveScoreLog(user, from)
    @robot.brain.data.scores[user] = @cache.scores[user]
    @robot.brain.data.scoreLog[user] = @cache.scoreLog[user]
    @robot.brain.emit('save', @robot.brain.data)
    @robot.brain.data.mostRecentlyUpdated = @cache.mostRecentlyUpdated

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

  scoreForUser: (user) -> 
    user = @getUser(user)
    @cache.scores[user]

  saveScoreLog: (user, from) ->
    unless typeof @cache.scoreLog[from] == "object"
      @cache.scoreLog[from] = {}

    @cache.scoreLog[from][user] = new Date()
    @cache.mostRecentlyUpdated = user

  mostRecentlyUpdated: ->
    @cache.mostRecentlyUpdated

  isSpam: (user, from) ->
    @cache.scoreLog[from] ||= {}

    if !@cache.scoreLog[from][user]
      return false

    dateSubmitted = @cache.scoreLog[from][user]

    date = new Date(dateSubmitted)
    messageIsSpam = date.setSeconds(date.getSeconds() + 30) > new Date()

    if !messageIsSpam
      delete @cache.scoreLog[from][user] #clean it up

    messageIsSpam

  validate: (user, from) ->
    user != from && user != "" && !@isSpam(user, from)

  length: () ->
    @cache.scoreLog.length

  top: (amount) ->
    tops = []

    for name, score of @cache.scores
      tops.push(name: name, score: score)

    tops.sort((a,b) -> b.score - a.score).slice(0,amount)

  bottom: (amount) ->
    all = @top(@cache.scores.length)
    all.sort((a,b) -> b.score - a.score).reverse().slice(0,amount)

  normalize: (fn) ->
    scores = {}

    _.each(@cache.scores, (score, name) ->
      scores[name] = fn(score)
      delete scores[name] if scores[name] == 0
    )

    @cache.scores = scores
    @robot.brain.data.scores = scores
    @robot.brain.emit 'save'

module.exports = (robot) ->
  scoreKeeper = new ScoreKeeper(robot)

  robot.hear /^(\+\+|\-\-)$/i, (msg) ->
    from = msg.message.user.name.toLowerCase()
    lastPhrase = scoreKeeper.mostRecentlyUpdated()

    unless lastPhrase == ""
      score = if msg.match[1] == "++"
                scoreKeeper.add(lastPhrase, from)
              else
                scoreKeeper.subtract(lastPhrase, from)

      if score?
        msg.send "#{lastPhrase} has #{score} points."
        robot.emit "plus-one", { name: lastPhrase, direction: msg.match[1] }

  robot.hear /([\w\s']+)([\W\S]*)?(\+\+)$/i, (msg) ->
    name = msg.match[1].trim().toLowerCase()
    from = msg.message.user.name.toLowerCase()

    newScore = scoreKeeper.add(name, from)

    if newScore?
      msg.send "#{name} has #{newScore} points."
      robot.emit "plus-one", { name: name, direction: "++" }

  robot.hear /([\w\s]+)([\W\S]*)?(\-\-)$/i, (msg) ->
    name = msg.match[1].trim().toLowerCase()
    from = msg.message.user.name.toLowerCase()

    newScore = scoreKeeper.subtract(name, from)

    if newScore? 
      msg.send "#{name} has #{newScore} points."
      robot.emit "plus-one", { name: name, direction: "--" }

  robot.respond /score (for\s)?(.*)/i, (msg) ->
    name = msg.match[2].trim().toLowerCase()
    score = scoreKeeper.scoreForUser(name)

    msg.send "#{name} has #{score} points."

  robot.respond /(top|bottom) (\d+)/i, (msg) ->
    amount = parseInt(msg.match[2])
    message = []

    tops = scoreKeeper[msg.match[1]](amount)

    for i in [0..tops.length-1]
      message.push("#{i+1}. #{tops[i].name} : #{tops[i].score}")

    if(msg.match[1] == "top")
      graphSize = Math.min(tops.length, Math.min(amount, 20))
      message.splice(0, 0, clark(_.first(_.pluck(tops, "score"), graphSize)))

    msg.send message.join("\n")

  robot.router.get "/hubot/normalize-points", (req, res) ->
    scoreKeeper.normalize((score) ->
      if score > 0
        score = score - Math.ceil(score / 10)
      else if score < 0
        score = score - Math.floor(score / 10)

      score
    )

    res.end JSON.stringify('done')

  robot.router.get "/hubot/scores", (req, res) ->
    query = querystring.parse(req._parsedUrl.query)

    if query.name
      obj = {}
      obj[query.name] = scoreKeeper.scoreForUser(query.name)
      res.end JSON.stringify(obj)
    else
      direction = query.direction || "top"
      amount = query.limit || 10

      tops = scoreKeeper[direction](amount)

      res.end JSON.stringify(tops)

