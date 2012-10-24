# Forgetful? Add reminders.
#
# remind me in <time> to <action>    - Set a reminder in <time> to do an <action>
#                                      <time> is in the format 1 day, 2 hours, 5 minutes etc
#                                      Time segments are optional, as are commas

class Reminders
  constructor: (@robot) ->
    @cache = []
    @current_timeout = null

    @robot.brain.on 'loaded', =>
      if @robot.brain.data.reminders
        @cache = @robot.brain.data.reminders
        @queue()

  add: (reminder) ->
    @cache.push reminder
    @cache.sort (a, b) -> a.due - b.due
    @robot.brain.data.reminders = @cache
    @queue()

  removeFirst: ->
    reminder = @cache.shift()
    @robot.brain.data.reminders = @cache
    return reminder

  queue: ->
    clearTimeout @current_timeout if @current_timeout
    if @cache.length > 0
      now = new Date().getTime()
      @removeFirst() until @cache.length is 0 or @cache[0].due > now
      if @cache.length > 0
        trigger = =>
          reminder = @removeFirst()
          youstr = "you"

          if reminder.for.name != reminder.from.name
            youstr = reminder.from.name

          @robot.send reminder.for, "#{reminder.for.name}, #{youstr} asked me to remind you to #{reminder.action}"
          @queue()
        @current_timeout = setTimeout trigger, @cache[0].due - now

class Reminder
  constructor: (@for, @from, @time, @action) ->
    if typeof(@time) == "string"
      @time.replace(/^\s+|\s+$/g, '')

      periods =
        weeks:
          value: 0
          regex: "weeks?"
        days:
          value: 0
          regex: "days?"
        hours:
          value: 0
          regex: "hours?|hrs?"
        minutes:
          value: 0
          regex: "minutes?|mins?"
        seconds:
          value: 0
          regex: "seconds?|secs?"

      for period of periods
        pattern = new RegExp('^.*?([\\d\\.]+)\\s*(?:(?:' + periods[period].regex + ')).*$', 'i')
        matches = pattern.exec(@time)
        periods[period].value = parseInt(matches[1]) if matches

      @due = new Date().getTime()
      @due += ((periods.weeks.value * 604800) + (periods.days.value * 86400) + (periods.hours.value * 3600) + (periods.minutes.value * 60) + periods.seconds.value) * 1000
    else
      @due = @time

  dueDate: ->
    if typeof @due == "string"
      dueDate = new Date @due
    else
      dueDate = @due

    dueDate.toLocaleString()

module.exports = (robot) ->
  reminders = new Reminders robot

  robot.respond /remind (.*) in ((?:(?:\d+) (?:weeks?|days?|hours?|hrs?|minutes?|mins?|seconds?|secs?)[ ,]*(?:and)? +)+)to (.*)/i, (msg) ->
    target = { name: msg.match[1], room: msg.message.user.room }
    you = msg.message.user

    targetstr = target.name

    time = msg.match[2]
    action = msg.match[3]

    if target.name == "me" || target.name == you.name
      target = msg.message.user
      targetstr = "you"

    reminder = new Reminder target, you, time, action
    reminders.add reminder

    msg.send "I'll remind #{targetstr} to #{action} on #{reminder.dueDate()}"

  robot.respond /remind (.*) (on|at) (.*) to (.*)/i, (msg) ->
    target = { name: msg.match[1], room: msg.message.user.room }
    you = msg.message.user

    targetstr = target.name

    time = msg.match[3]
    action = msg.match[4]

    if target.name == "me" || target.name == you.name
      target = msg.message.user
      targetstr = "you"

    reminder = new Reminder target, you, new Date(time), action
    reminders.add reminder

    msg.send "I'll remind #{targetstr} to #{action} on #{reminder.dueDate()}"

