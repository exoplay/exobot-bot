# Description:
#   Returns title and description when links are posted
#
# Dependencies:
#   "jsdom": "0.2.15"
#
# Configuration:
#   None
#
# Commands:
#   http(s)://<site> - prints the title and meta description for sites linked.
#
# Authors:
#   ajacksified

jsdom = require('jsdom')

module.exports = (robot) ->

  robot.hear /(http(?:s?):\/\/(\S*))/i, (msg) ->
    url = msg.match[1]

    unless url.match(/\.(png|jpg|jpeg|gif|txt|zip|tar\.bz|js|css)/) # filter out some common files from trying
      jsdom.env(
        html: url
        scripts: [
          'http://code.jquery.com/jquery-1.9.1.min.js'
        ]
        done: (errors, window) ->
          unless errors
            $ = window.$
            title = $('title').text()
            description = $('meta[name=description]').attr("content") || ""
            description = "\n" + description if description

            if title
              msg.send "#{title}#{description}"
        )
