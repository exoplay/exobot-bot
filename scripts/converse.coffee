# Allows Hubot to talk back. Passive script.

class Messages
  constructor: (@robot) ->
    @cache = []
    @robot.brain.on 'loaded', =>
      if @robot.brain.data.messages
        @cache = @robot.brain.data.messages

  nextMessageNum: ->
    maxMessageNum = if @cache.length then Math.max.apply(Math,@cache.map (n) -> n.num) else 0
    maxMessageNum++
    maxMessageNum

  add: (messageText) ->
    message = {num: @nextMessageNum(), message: messageText}

    if(@cache.length) > 5000
      @cache = @cache.slice(@cache.length - 5000, @cache.length)

    @cache.push message
    @robot.brain.data.messages = @cache
    messageText

  all: -> @cache

  random: -> @cache[(Math.random() * (@cache.length - 1)) >> 0]

  buildRandomMessage: ->
    amountOfMessages = ((Math.random() * 4) >> 0) + 2

    message = while amountOfMessages -= 1
      messageParts = @random().message.split(" ")
      startingPoint = (Math.random() * messageParts.length) >> 0
      messageParts[startingPoint...messageParts.length].join(" ")

    message.join(" ").replace(/((\.|\!|\?)*)(?!$)/,'')

  retrieveLast: (amount) ->
    if amount > 15 then amount = 15

    @cache[(@cache.length-amount)...(@cache.length)]

module.exports = (robot) ->
  messages = new Messages(robot)

  chance = 100

  # History command
  robot.respond /history (.*)/i, (msg) ->
    amount = msg.match[1].trim()

    message = for i, obj of messages.retrieveLast(amount) 
      "#{i}. #{obj.message}"

    msg.send(message.join("\r\n"))

  # General conversation
  robot.hear /(.*)/i, (msg) ->
    if(msg.match[1].toLowerCase().indexOf(robot.name.toLowerCase()) > 0)
      chance /= 5

    messages.add msg.match[1]

    if messages.nextMessageNum() > 100
      if ((Math.random() * chance) >> 0) == 0
        msg.send messages.buildRandomMessage()

    if msg.match[1].toLowerCase() == "rebooting exobot"
      msg.send "OHGOD NO PLEASE NO"

  chance = 10

  # OL faces
  robot.hear /^u[m]+(.*)$/i, (msg) ->
    if ((Math.random() * chance) >> 0) == 0
      msg.send "http://i.imgur.com/rgkc6.png"

  robot.hear /^(rite|right)\??$/i, (msg) ->
    if ((Math.random() * chance) >> 0) == 0
      msg.send "http://i.imgur.com/LKcKt.png"

  robot.hear /^soon(\.*)$/i, (msg) ->
    if ((Math.random() * chance) >> 0) == 0
      msg.send "http://i.imgur.com/huYAB.png"

  robot.hear /^not bad(\.?)$/i, (msg) ->
    if ((Math.random() * chance) >> 0) == 0
      msg.send "http://i.imgur.com/0COAu.png"

  robot.hear /^quite(\.?)$/i, (msg) ->
    if ((Math.random() * chance) >> 0) == 0
      msg.send "http://i.imgur.com/0uhyH.png"

  robot.hear /^wat(\.?)$/i, (msg) ->
    if ((Math.random() * chance) >> 0) == 0
      msg.send "http://i.imgur.com/UBhAX.png"
