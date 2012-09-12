yelp = require("yelp").createClient(
  consumer_key: process.env.HUBOT_YELP_CONSUMER_KEY
  consumer_secret: process.env.HUBOT_YELP_CONSUMER_SECRET
  token: process.env.HUBOT_YELP_TOKEN
  token_secret: process.env.HUBOT_YELP_TOKEN_SECRET
)

yelpMe = (msg, query, callback) ->
  yelp.search query, (error, data) ->
    callback(data) unless error

module.exports = (robot) ->
  robot.respond /yelp( me)? (.*) (in|around|near) (.*)/i, (msg) ->
    yelpMe msg, { term: msg.match[2], location: msg.match[4] }, (data) ->
      if data.businesses.length > 0
        business = data.businesses[(Math.random() * data.businesses.length) >> 0]
        template = "#{business.name} has rating of #{business.rating}/5 by #{business.review_count} people. It's at #{business.location.address}. Categories: #{business.categories.join(",")}. #{business.url}"
        msg.send template
      else
        msg.send "Nothing found :("
