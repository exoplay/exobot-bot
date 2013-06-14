# Description:
#   None
#
# Dependencies:
#   None
#
# Configuration:
#   HUBOT_IMGUR_CLIENT_ID
#
# Commands:
#   deal with it
#   /clap
#   /not bad
#   /popcorn
#   /haters(? gonna hate)
#   /wut|wat|what
#   /upvote
#   /downvote
#   /dance
#
# Author:
#   ajacksified


https = require('https')

options =
  hostname: 'api.imgur.com'
  path: '/3/album/'
  headers:
    'Authorization': "Client-ID #{process.env.HUBOT_IMGUR_CLIENT_ID}"

albums =
  dealWithIt: "K21Ft"
  clap: "NzuZS"
  notBad: "LoNV2"
  popcorn: "LPRbU"
  haters: "yGacg"
  wut: "ywmyw"
  upvote: "fG58m"
  downvote: "ixZeK"
  dance: "wy22z"

getGif = (album, cb) ->
  data = []
  options.path = options.path + albums[album]

  https.get options, (res) ->
    if res.statusCode == 200
      res.on 'data', (chunk) ->
        data.push(chunk)

      res.on 'end', ->
        parsedData = JSON.parse(data.join(''))
        images = parsedData.data.images
        image = images[parseInt(Math.random() * images.length)]

        cb(image.link)

module.exports = (robot) ->
  robot.hear /deal with it/i, (msg) ->
    getGif 'dealWithIt', (link) ->
      msg.send(link)

  robot.respond /clap/i, (msg) ->
    getGif 'clap', (link) ->
      msg.send(link)

  robot.respond /not\s?bad/i, (msg) ->
    getGif 'notBad', (link) ->
      msg.send(link)

  robot.respond /popcorn/i, (msg) ->
    getGif 'popcorn', (link) ->
      msg.send(link)

  robot.respond /haters( gonna hate)?/i, (msg) ->
    getGif 'haters', (link) ->
      msg.send(link)

  robot.respond /w(a|u|ha)t/i, (msg) ->
    getGif 'wut', (link) ->
      msg.send(link)

  robot.respond /up\s?vote/i, (msg) ->
    getGif 'upvote', (link) ->
      msg.send(link)

  robot.respond /down\s?vote/i, (msg) ->
    getGif 'downvote', (link) ->
      msg.send(link)

  robot.respond /dance/i, (msg) ->
    getGif 'dance', (link) ->
      msg.send(link)



