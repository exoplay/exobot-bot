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

default_location = process.env.HUBOT_YELP_DEFAULT_LOCATION

yelpMe = (msg, query, callback) ->
  query.category_filter ?= "restaurants"
  query.radius_filter ?= 600

  yelp.search query, (error, data) ->
    callback(data) unless error

formatResults = (parameters, data, randomize) ->
  randomize ?= true

  if data.businesses.length > 0
    # if we have a name match in the first few, use that. Otherwise, go random.
    unless randomize
      business = _.find(_.first(data.businesses, 4), (business, index) ->
        r = new RegExp(parameters.term, "i")
        r.test(business.name)
      )

    if not business then business = data.businesses[(Math.random() * data.businesses.length) >> 0]

    stars = ('★' for i in [0...parseInt(business.rating)]).join('')

    if(business.rating > parseInt(business.rating)) then stars += '☆'

    return "#{business.name} #{stars}\n#{business.url}\nhttps://www.google.com/maps?q=#{encodeURI(business.location.address)}\nCategories: #{business.categories.join(",")}"
  else
    return "Nothing found :("


module.exports = (robot) ->
  robot.respond /yelp( me)? (.*) (in|around|near)?\s?(.*)?/i, (msg) ->
    parameters = { term: msg.match[2], location: msg.match[4] || default_location }
    yelpMe msg, parameters, (data) ->
      msg.send(formatResults(parameters, data, false))

  robot.respond /lunch( me)?/i, (msg) ->
    parameters =
      term: 'lunch'
      location: default_location

    yelpMe msg, parameters, (data) ->
      msg.send(formatResults(parameters, data))

  robot.respond /coffee( me)?/i, (msg) ->
    parameters =
      term: 'coffee'
      location: default_location
      category_filter: 'coffee'

    yelpMe msg, parameters, (data) ->
      msg.send(formatResults(parameters, data))

  robot.respond /dinner( me)?/i, (msg) ->
    parameters =
      term: 'dinner'
      location: default_location

    yelpMe msg, parameters, (data) ->
      msg.send(formatResults(parameters, data))

  robot.respond /breakfast( me)?/i, (msg) ->
    parameters =
      term: 'breakfast'
      location: default_location

    yelpMe msg, parameters, (data) ->
      msg.send(formatResults(parameters, data))

