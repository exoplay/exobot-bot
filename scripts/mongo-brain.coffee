# Description:
#   Replaces default `redis-brain` with MongoDB one. Useful
#   to those who wants to have persistence on completely free
#   Heroku account.
#
# Dependencies:
#   "mongodb": "*"
#   "underscore" "*"
#
# Configuration:
#   MONGODB_USERNAME
#   MONGODB_PASSWORD
#   MONGODB_HOST
#   MONGODB_PORT
#   MONGODB_DB
#
# Commands:
#   None
#
# Author:
#   ajacksified

mongodb = require "mongodb"
Server = mongodb.Server
Collection = mongodb.Collection
Db = mongodb.Db

module.exports = (robot) ->
  user = process.env.MONGODB_USERNAME || "admin"
  pass = process.env.MONGODB_PASSWORD || ""
  host = process.env.MONGODB_HOST || "localhost"
  port = process.env.MONGODB_PORT || "27017"
  dbname = process.env.MONGODB_DB || "hubot"

  server = new Server(host, port, { })
  db = new Db(dbname, server, { w: 1, native_parser: true })

  db.open((err, client) ->
    throw err if err

    db.authenticate(user, pass, (err, success) ->
      throw err if err

      collection = new Collection(client, 'hubot_storage')

      collection.find().limit(1).toArray((err, results) ->
        if results?.length > 0
          robot.brain.mergeData(results[0])
        else
          robot.brain.mergeData({})
      )

      robot.brain.on('save', (data) ->
        if data?
          collection.save(data, (err) ->
            console.warn err if err?
            robot.brain.mergeData(data) unless err?
          )
      )
    )
  )


