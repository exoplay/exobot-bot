# Description
#   Searches Yelp API to find you things.
#
# Dependencies:
#   "yelp": "0.1.1"
#
# Configuration:
#   HUBOT_YELP_CONSUMER_KEY=key 
#   HUBOT_YELP_CONSUMER_SECRET=secret 
#   HUBOT_YELP_TOKEN=token 
#   HUBOT_YELP_TOKEN_SECRET=token_secret
#
# Commands:
#   hubot <yelp me [thing] near [location]> - performs yelp query. yelp me lunch in san francisco
#
# Notes:
#   Sign up for a Yelp token and add configuration.
#   http://www.yelp.com/developers/getting_started/api_access
#
# Author:
#   ajacksified

_ = require("underscore")

yelp = require("yelp").createClient(
  consumer_key: process.env.HUBOT_YELP_CONSUMER_KEY
  consumer_secret: process.env.HUBOT_YELP_CONSUMER_SECRET
  token: process.env.HUBOT_YELP_TOKEN
  token_secret: process.env.HUBOT_YELP_TOKEN_SECRET
)

yelpMe = (msg, query, callback) ->
  yelp.search query, (error, data) ->
    callback(data) unless error

formatResults = (parameters, data) ->
  if data.businesses.length > 0
    # if we have a name match in the first few, use that. Otherwise, go random.
    business = _.find(_.first(data.businesses, 3), (business, index) ->
      r = new RegExp(parameters.term, "i")
      r.test(business.name)
    ) || data.businesses[(Math.random() * data.businesses.length) >> 0]

    return "#{business.name} [#{business.rating} ★ by #{business.review_count}]\n#{business.url}\nhttps://www.google.com/maps?q=#{encodeURI(business.location.address)}\nCategories: #{business.categories.join(",")}"
  else
    return "Nothing found :("


module.exports = (robot) ->
  robot.respond /yelp( me)? (.*) (in|around|near) (.*)/i, (msg) ->
    parameters = { term: msg.match[2], location: msg.match[4] }
    yelpMe msg, parameters, (data) ->
      msg.send(formatResults(parameters, data))

  robot.respond /lunch( me)?/i, (msg) ->
    parameters = { term: 'lunch', location: '94103' }
    yelpMe msg, parameters, (data) ->
      msg.send(formatResults(term, location, data))

