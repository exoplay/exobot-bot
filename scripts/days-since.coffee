# Generates commands to track days since an event
#
# it's been <number> days since <event> - Set the day when the event happened
# <event> on <date> - Set the date the event happened (yyyy-mm-dd)
# how long since <event>? - Display the number of days since the event
# when was/is/did <event>?

module.exports = (robot) ->
  robot.respond /(.*?) on ((19|20)\d\d[- /.](0[1-9]|1[012])[- /.](0[1-9]|[12][0-9]|3[01]))$/, (msg) ->
    event = msg.match[1]
    date = new Date(msg.match[2])
    robot.brain.data.days_since ||= {}
    robot.brain.data.days_since[event] = date
    msg.send "okay, " + event + " on " + msg.match[2]

  robot.respond /it's been (\d+) days since\s+(.*?)[.?!]?$/i, (msg) ->
    date = new Date
    date.setTime(date.getTime() - (parseInt(msg.match[1])*1000*24*60*60))
    robot.brain.data.days_since ||= {}
    robot.brain.data.days_since[msg.match[2]] = date
    msg.send "okay, it's been " + msg.match[1] + " days since " + msg.match[2]

  robot.respond /how long (since|until)\s+(.*?)\??$/i, (msg) ->
    if robot.brain.data.days_since && robot.brain.data.days_since[msg.match[2]]
      date = robot.brain.data.days_since[msg.match[2]]
      days_since = Math.floor((new Date - date.getTime()) / (1000*24*60*60))

      if days_since > 0
        msg.send "it's been " + days_since + " days since " + msg.match[2]
      else if days_since == 0
        msg.send msg.match[2] + " is today!"
      else
        msg.send (days_since*-1) + " days until " + msg.match[2]
    else
      msg.send "I don't recall that event"

  robot.respond /when (was|is|did|does)?\s+(.*?)$/i, (msg) ->
    if robot.brain.data.days_since && robot.brain.data.days_since[msg.match[2]]
      date = robot.brain.data.days_since[msg.match[2]]
      days_since = Math.floor((new Date - date.getTime()) / (1000*24*60*60))

      word = "was"
      word = "is" if days_since < 0

      msg.send msg.match[2] + " " + word + " " + date.toLocaleDateString()
    else
      msg.send "I don't recall that event"
