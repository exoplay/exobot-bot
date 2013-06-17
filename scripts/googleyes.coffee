http = require('http')
qs = require('querystring')

module.exports = (robot) ->
  robot.respond /googleyes (.*)/i, (msg) ->
    robot.emit 'imageMe', msg.match[1], (image) ->
      if image
        query = qs.stringify(url: image)

        options =
          hostname: 'googleyesanda.musta.ch'
          path: "/upload?#{query}"
          method: 'GET'

        req = http.request options, (res) ->
          msg.send res.headers.location

        req.setTimeout(60 * 1000)
        req.end()
