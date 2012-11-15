class ScoreKeeper
  constructor: (@robot) ->
    @cache = { scoreLog: {}, scores: {} }

    @robot.brain.on 'loaded', =>
      @robot.brain.data.scores ||= {}
      @robot.brain.data.scoreLog ||= {}

      @cache.scores = @robot.brain.data.scores || {}
      @cache.scoreLog = @robot.brain.data.scoreLog || {}

  getUser: (user) ->
    @cache.scores[user] ||= 0
    user

  saveUser: (user, from) ->
    @saveScoreLog(user, from)
    @robot.brain.data.scores[user] = @cache.scores[user]
    @robot.brain.data.scoreLog[user] = @cache.scoreLog[user]
    @robot.brain.save()

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
    @cache.scoreLog[from] ||= {}
    @cache.scoreLog[from][user] = new Date()

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

    if @cache.scores["scoreLog"]
      delete @cache.scores["scoreLog"]
      delete @robot.brain.data.scores["scoreLog"]

    for name, score of @cache.scores
      tops.push(name: name, score: score)

    tops.sort((a,b) -> b.score - a.score).slice(0,amount)

module.exports = (robot) ->
  scoreKeeper = new ScoreKeeper(robot)

  robot.hear /([\w\s]+)([\W\S]*)?(\+\+)$/i, (msg) ->
    name = msg.match[1].trim().toLowerCase()
    from = msg.message.user.name.toLowerCase()

    newScore = scoreKeeper.add(name, from)

    if newScore? then msg.send "#{name} has #{newScore} points."

  robot.hear /([\w\s]+)([\W\S]*)?(\-\-)$/i, (msg) ->
    name = msg.match[1].trim().toLowerCase()
    from = msg.message.user.name.toLowerCase()

    newScore = scoreKeeper.subtract(name, from)
    if newScore? then msg.send "#{name} has #{newScore} points."

  robot.respond /score (for\s)?(.*)/i, (msg) ->
    name = msg.match[2].trim().toLowerCase()
    score = scoreKeeper.scoreForUser(name)

    msg.send "#{name} has #{score} points."

  robot.respond /top (\d+)/i, (msg) ->
    amount = msg.match[1] >> 0

    tops = scoreKeeper.top(amount)

    message = "\n``````````````````\nTOP #{tops.length}:\n"

    for i in [0..tops.length-1]
      message += "#{i+1}. #{tops[i].name} : #{tops[i].score}\n"

    message += "``````````````````"

    msg.send message
