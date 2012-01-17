# Players online in OL games.
#
# onlines <game> - Returns amount of current players online.
#                  Valid 'game' options: neflaria
#
getOnlines = (url, game, msg) ->
  msg.http(url).get() (err, res, body) -> 
    msg.send("There are " + body.trim() + " players currently on " + game + ".")


module.exports = (robot) ->
  robot.respond /onlines (.*)/i, (msg) ->
    query = msg.match[1].toLowerCase()

    response = "Invalid game."

    switch query
      when "neflaria" then getOnlines("http://web1.neflaria.com/api/onlines.php", "Neflaria", msg)

