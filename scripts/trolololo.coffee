https = require('https')

options =
  hostname: 'api.imgur.com'
  path: '/3/album/pTXm0'
  headers:
    'Authorization': "Client-ID #{process.env.HUBOT_IMGUR_CLIENT_ID}"

module.exports = (robot) ->
  robot.hear /trol.*/i, (msg) ->
    data = []

    https.get(options, (res) ->
      if res.statusCode == 200
        res.on 'data', (chunk) ->
          data.push(chunk)

        res.on 'end', () ->
          parsedData = JSON.parse(data.join(''))
          images = parsedData.data.images
          image = images[parseInt(Math.random() * images.length)]

          msg.send(image.link)
    )

