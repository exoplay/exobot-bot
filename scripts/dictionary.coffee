# Allows Hubot to give word definitions.
#
 
module.exports = (robot) ->
  robot.respond /(what )? (is |are ) (.*)$/i, (msg) ->
    msgPhrase = "\"#{msg.match[1]}\""
  
    msg.http("http://glosbe.com/gapi/translate?")
      .query({
        from: eng
        dest: eng
        phrase: msgPhrase
        format: json
        pretty: true
      })
      .get() (err, res, body) ->
        if body
          if body.result == "ok"
            msg.send "#{msgPhrase} is: #{body.tuc[0].meanings[0].text}"
          else
            msg.send "I don't know anything about that."