# Integrates with memegenerator.net
#
# Y U NO <text>              - Generates the Y U NO GUY with the bottom caption
#                              of <text>
#
# I don't always <something> but when i do <text> - Generates The Most Interesting man in the World
#
# <text> ORLY?               - Generates the ORLY? owl with the top caption of <text>
#
# <text> (SUCCESS|NAILED IT) - Generates success kid with the top caption of <text>
#
# <text> ALL the <things>    - Generates ALL THE THINGS
#
# <text> TOO DAMN <high> - Generates THE RENT IS TOO DAMN HIGH guy
#
# Good news everyone! <news> - Generates Professor Farnsworth
#
# khanify <text> - TEEEEEEEEEEEEEEEEEXT!
#
# Not sure if <text> or <text> - Generates Futurama Fry
#
# Yo dawg <text> so <text> - Generates Yo Dawg
#
# One does not simply <text> - Generates "one does not simply" 
#
# Scumbag <name> <text> - Generates Scumbag Steve
#
# What if I told you <text> - Generates Morpheus
#
# Prepare yourself <text> - Generates Ned
#
# Oh robot.name <text> - Generates Meme Dad
#
# Am I the only one around here <text> - Generates that





module.exports = (robot) ->
  nerdSays = (name, imageID, gif) ->
    regexStr = "(?:THE )*(?:(?:#{name[0]}[^ ]+ )?#{name} SAYS) (.+)(?:\\s?(?:\\/|,)\\s?)(.+)"
    robot.hear new RegExp(regexStr,  'i'), (msg) ->
      imgPath = "#{imageID}.#{if gif? then "gif" else "jpg"}"
      shittyNerdMemeGen msg, imgPath, msg.match[1], msg.match[2], (url) ->
        msg.send url

  robot.respond /Y U NO (.+)/i, (msg) ->
    caption = msg.match[1] || ""

    memeGenerator msg, 2, 166088, "Y U NO", caption, (url) ->
      msg.send url

  robot.respond /(I DON'?T ALWAYS .*) (BUT WHEN I DO,? .*)/i, (msg) ->
    memeGenerator msg, 74, 2485, msg.match[1], msg.match[2], (url) ->
      msg.send url

  robot.respond /(.*)(O\s?RLY\??.*)/i, (msg) ->
    memeGenerator msg, 920, 117049, msg.match[1], msg.match[2], (url) ->
      msg.send url

  robot.respond /(.*)(SUCCESS|NAILED IT.*)/i, (msg) ->
    memeGenerator msg, 121, 1031, msg.match[1], msg.match[2], (url) ->
      msg.send url

  robot.respond /(.*) (ALL the .*)/i, (msg) ->
    memeGenerator msg, 6013, 1121885, msg.match[1], msg.match[2], (url) ->
      msg.send url

  robot.hear /(.*) (\w+\sTOO DAMN .*)/i, (msg) ->
    memeGenerator msg, 998, 203665, msg.match[1], msg.match[2], (url) ->
      msg.send url

  robot.hear /(GOOD NEWS EVERYONE[,.!]?) (.*)/i, (msg) ->
    memeGenerator msg, 1591, 112464, msg.match[1], msg.match[2], (url) ->
      msg.send url

  robot.respond /khanify (.*)/i, (msg) ->
    memeGenerator msg, 6443, 1123022, "", khanify(msg.match[1]), (url) ->
      msg.send url

  robot.hear /(NOT SURE IF .*) (OR .*)/i, (msg) ->
    memeGenerator msg, 305, 84688, msg.match[1], msg.match[2], (url) ->
      msg.send url

  robot.hear /(YO DAWG .*) (SO .*)/i, (msg) ->
    memeGenerator msg, 79, 108785, msg.match[1], msg.match[2], (url) ->
      msg.send url

  robot.hear /(ONE DOES NOT SIMPLY) (.*)/i, (msg) ->
    memeGenerator msg, 689854, 3291562, msg.match[1], msg.match[2], (url) ->
      msg.send url

  robot.respond /(SCUMBAG\s\w*) (.*)/i, (msg) ->
    memeGenerator msg, 142, 366130, msg.match[2], "", (url) ->
      msg.send url

  robot.hear /(WHAT IF I TOLD YOU) (.*)/i, (msg) ->
    memeGenerator msg, 1118843, 4796874, msg.match[1], msg.match[2], (url) ->
      msg.send url

  robot.hear /(PREPARE YOURSELF[,.!]?) (.*)/i, (msg) ->
    memeGenerator msg, 414926, 2295701, msg.match[1], msg.match[2], (url) ->
      msg.send url

  robot.hear /^(OH EXOBOT[,.!]?) (.*)/i, (msg) ->
    memeGenerator msg, 1128592, 4831367, msg.match[1], msg.match[2], (url) ->
      msg.send url

  robot.respond /(BILL GATES|WINDOWS) (.*)/i, (msg) ->
    memeGenerator msg, 1508045, 6221098, msg.match[1], msg.match[2], (url) ->
      msg.send url

  robot.hear /(AM I THE ONLY ONE AROUND HERE) (.*)/i, (msg) ->
    memeGenerator msg, 953639, 4240352, msg.match[1], msg.match[2], (url) ->
      msg.send url

  robot.hear /(.*) AND I'M JUST SITTING HERE (.*)/i, (msg) ->
    memeGenerator msg, 244535, 1823664, msg.match[1], "and I'm just sitting here " + msg.match[2], (url) ->
      msg.send url


  nerdSays "DREW", "http://i.imgur.com/LKcKt.png"
  nerdSays "BRENT", "http://i.imgur.com/KSz8M.png"
  nerdSays "JACK", "http://i.imgur.com/0uhyH.png"
  nerdSays "CURT", "http://i.imgur.com/UBhAX.png"
  nerdSays "DAVE", "http://i.imgur.com/rgkc6.png"
  nerdSays "NEFLARIA", "http://i.imgur.com/rDBPQ.png"
  nerdSays "DANNY", "http://i.imgur.com/tK8oe.png"
  nerdSays "CHRIS", "http://i.imgur.com/TtVIj.png"

QS = require "querystring"
shittyNerdMemeGen = (msg, img_path, top_text, bottom_text, callback) ->
  data =
    url: img_path,
    top: top_text,
    bottom: bottom_text
  msg.http('http://lit-fjord-1022.herokuapp.com/gen')
    .post(QS.stringify(data)) (err, res, body) ->
      result = JSON.parse(body)['url']
      if result?
        callback result
      else
        msg.reply "I'm sorry Dave, I can't generate that image."

memeGenerator = (msg, generatorID, imageID, text0, text1, callback) ->
  username = process.env.HUBOT_MEMEGEN_USERNAME
  password = process.env.HUBOT_MEMEGEN_PASSWORD
  preferredDimensions = process.env.HUBOT_MEMEGEN_DIMENSIONS

  unless username? and password?
    msg.send "MemeGenerator account isn't setup. Sign up at http://memegenerator.net"
    msg.send "Then ensure the HUBOT_MEMEGEN_USERNAME and HUBOT_MEMEGEN_PASSWORD environment variables are set"
    return

  msg.http('http://version1.api.memegenerator.net/Instance_Create')
    .query
      username: username,
      password: password,
      languageCode: 'en',
      generatorID: generatorID,
      imageID: imageID,
      text0: text0,
      text1: text1
    .get() (err, res, body) ->
      result = JSON.parse(body)['result']
      if result? and result['instanceUrl']? and result['instanceImageUrl']? and result['instanceID']?
        instanceID = result['instanceID']
        instanceURL = result['instanceUrl']
        msg.http(instanceURL).get() (err, res, body) ->
          # Need to hit instanceURL so that image gets generated
          if preferredDimensions?
            callback "http://images.memegenerator.net/instances/#{preferredDimensions}/#{instanceID}.jpg"
          else
            # Hardcode this because the Meme Generator API lies about the actual instance image URL
            callback "http://images.memegenerator.net/instances/400x/#{instanceID}.jpg"
      else
        msg.reply "Sorry, I couldn't generate that image."

khanify = (msg) ->
  msg = msg.toUpperCase()
  vowels = [ 'A', 'E', 'I', 'O', 'U' ]
  index = -1
  for v in vowels when msg.lastIndexOf(v) > index
    index = msg.lastIndexOf(v)
  "#{msg.slice 0, index}#{Array(10).join msg.charAt(index)}#{msg.slice index}!!!!!"


