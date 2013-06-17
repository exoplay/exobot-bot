# Description:
#   He's on fire!
#
# Dependencies:
#   None
#   ...but listens for "plus-one" emittances from the plus-one module
#
# Configuration:
#   None
#
# Commands:
#   None

onFireImages =
  TALLDUNK: 'http://f.cl.ly/items/1M0G0P2n37433b3X1o3Q/onfire-mod.gif'
  LONGDUNK: 'http://f.cl.ly/items/1H2k0X453C1N201D3H2s/onfire-turbo.gif'

onFireThresholds =
  FROZEN: -1
  COOLING_DOWN: 0
  HEATING_UP: 2
  ON_FIRE: 3
  GIF_TALLDUNK: 4
  GIF_LONGDUNK: 5

# Track who has a streak going
STREAK_USER = null
STREAK_SCORE = 0

scoreModifiers = 
  "++": (score) -> return score + 1
  "--": (score) -> return score - 1

module.exports = (robot) ->
  # Listen to the plus-one module to emit increments
  robot.on "plus-one", (user) ->
    username = user.name

    if username is STREAK_USER
      # Extend user's streak
      STREAK_SCORE = scoreModifiers[user.direction](STREAK_SCORE)
    else
      # Start new streak (and clear old user's)
      STREAK_USER = username
      STREAK_SCORE = 1

    # The order of these thresholds is important, of course, because
    # we are trading in janky if-else trees here. Yay
    envelope = { room: 382258 } # Nerds

    # First the message (at each point between thresholds)
    if STREAK_SCORE is onFireThresholds.FROZEN
      robot.send envelope, "#{username}'s frozen!"
    else if STREAK_SCORE is onFireThresholds.COOLING_DOWN
      robot.send envelope, "#{username} is cooling down..."

    else if STREAK_SCORE >= onFireThresholds.ON_FIRE
      robot.send envelope, "#{username}'s on fire!"
    else if STREAK_SCORE >= onFireThresholds.HEATING_UP
      robot.send envelope, "#{username} is heating up..."

    # Then an image (only at each discrete point threshold, to mitigate spam)
    if STREAK_SCORE is onFireThresholds.GIF_LONGDUNK
      robot.send envelope, onFireImages.LONGDUNK
    else if STREAK_SCORE is onFireThresholds.GIF_TALLDUNK
      robot.send envelope, onFireImages.TALLDUNK

