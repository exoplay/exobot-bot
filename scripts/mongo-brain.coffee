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

  error = (err) ->
    console.log "==MONGO BRAIN UNAVAILABLE==\n==SWITCHING TO MEMORY BRAIN=="
    console.log err
    robot.brain.emit 'loaded', {}

  server = new Server(host, port, { })
  db = new Db(dbname, server, { w: 1, native_parser: true })

  db.open((err, client) ->
    if err
      error(err)
    else
      db.authenticate(user, pass, (err, success) ->
        if err
          error(err)
        else
          collection = new Collection(client, 'hubot_storage')

          collection.find().limit(1).toArray((err, results) ->
            if results
              robot.brain.data = results[0]
              robot.brain.emit 'loaded', results[0]
            else
              robot.brain.emit 'loaded', {}
          )

          robot.brain.on('save', (data) ->
            collection.save(data, (err) ->
              console.warn err if err?
            )
          )
        )
      )

