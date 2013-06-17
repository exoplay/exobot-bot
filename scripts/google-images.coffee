# A way to interact with the Google Images API.
#
# image me <query>    - The Original. Queries Google Images for <query> and
#                       returns a random top result.
# animate me <query>  - The same thing as `image me`, except adds a few
#                       parameters to try to return an animated GIF instead.
# mustache me <url>   - Adds a mustache to the specified URL.
# mustache me <query> - Searches Google Images for the specified query and
#                       mustaches it.

http = require('http')
qs = require('querystring')

module.exports = (robot) ->
  dan_alternate = [
    "margaret thatcher"
  ]
  dan_arr = [
    "queen elizabeth"
    "prince charles"
    "lady diana"
    "The Duke of Edinburgh"
    "The Prince of Wales"
    "The Duchess of Cornwall"
    "The Duke of Cambridge"
    "The Duchess of Cambridge"
    "Prince Harry"
    "The Duke of York"
    "The Earl of Wessex"
    "The Countess of Wessex"
    "The Princess Royal"
    "The Duke of Gloucester"
    "The Duchess of Gloucester"
    "The Duke of Kent"
    "The Duchess of Kent"
    "Princess Alexandra"
    "Prince and Princess Michael of Kent"
  ]

  davide_arr = [
    "morning matsume"
    "akb48"
    "no3b"
  ]

  robot.respond /(image|img)( me)? (.*)/i, (msg) ->
    imageMe msg.match[3], (url) ->
      msg.send url

  robot.hear /one for dan/i, (msg) ->
    imageMe dan_alternate[Math.floor(Math.random() * dan_alternate.length)], (url) ->
      msg.send url

  robot.hear /one for davide/i, (msg) ->
    imageMe davide_arr[Math.floor(Math.random() * davide_arr.length)], (url) ->
      msg.send url

  robot.hear /one for dave/i, (msg) ->
    imageMe "fifth element scene", (url) ->
      msg.send url

  robot.respond /animate me (.*)/i, (msg) ->
    imageMe "animated #{msg.match[1]}", (url) ->
      msg.send url

  robot.respond /(?:mo?u)?sta(?:s|c)he?(?: me)? (.*)/i, (msg) ->
    imagery = msg.match[1]

    if imagery.match /^https?:\/\//i
      msg.send "#{mustachify}#{imagery}"
    else
      imageMe imagery, (url) ->
        msg.send "#{mustachify}#{url}"

  robot.hear /sws/i, (msg) ->
    imageMe "site:selleckwaterfallsandwich.tumblr.com", (url) ->
      msg.send url

  robot.respond /breadcat(s?)/i, (msg) ->
    imageMe "breadcat", (url) ->
      msg.send url

  robot.respond /spacecat(s?)/i, (msg) ->
    imageMe "site:omgcatsinspace.tumblr.com", (url) ->
      msg.send url

  robot.respond /spacedog(s?)/i, (msg) ->
    imageMe "site:fuckyeahdogsinspace.tumblr.com", (url) ->
      msg.send url

  robot.respond /tumblr (\w+)/i, (msg) ->
    imageMe "site:#{msg.match[1]}.tumblr.com", (url) ->
      msg.send url

  robot.on 'imageMe', (query, cb) ->
    imageMe(query, cb)

mustachify = "http://mustachify.me/?src="

imageMe = (query, cb) ->
  query = query.replace(/matt baker/gi, 'Nikola Tesla')
               .replace(/ben hughes/gi, 'Ryan Gosling')
               .replace(/davide/gi, 'businessman')
               .replace(/tobi/gi, 'Sean Connery')
               .replace(/topher/gi, 'Joseph Gordon-Levitt')
               .replace(/eric levine/gi, 'Google homepage')
               .replace(/regex/gi, 'satan')
               .replace(/allen kerr/gi, 'Freakazoid')

  query = qs.stringify(v: '1.0', rsz: '8', q: query)

  options =
    hostname: 'ajax.googleapis.com'
    path: "/ajax/services/search/images?#{query}"

  http.get options, (res) ->
    data = []

    if res.statusCode == 200
      res.on 'data', (chunk) ->
        data.push(chunk)

      res.on 'end', ->
        images = JSON.parse(data.join(''))
        images = images.responseData.results

        if images.length > 0
          image  = images[Math.floor(Math.random() * images.length)]
          cb "#{image.unescapedUrl}#.png"

