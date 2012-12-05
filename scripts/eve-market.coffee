# Description:
#   None
#
# Dependencies:
#   "accounting": "0.3.2"
#   "xml2json": "0.3.2"
#
# Configuration:
#   None
#
# Commands:
#   hubot marketstat <item> [in <region>] - item market information
#
# Author:
#   ajacksified

parser = require('xml2json')
accounting = require('accounting')

itemIDCache = {
  'tritanium': { typeID: 34, typeName: 'Tritanium' }
}

regionIDCache = {
  "aridia": 10000054
  "black rise": 10000069
  "branch": 10000055
  "cache": 10000007
  "catch": 10000014
  "cloud ring": 10000051
  "cobalt edge": 10000053
  "curse": 10000012
  "deklein": 10000035
  "delve": 10000060
  "derelik": 10000001
  "detorid": 10000005
  "devoid": 10000036
  "domain": 10000043
  "esoteria": 10000039
  "essence": 10000064
  "etherium reach": 10000027
  "everyshore": 10000037
  "fade": 10000046
  "feythabolis": 10000056
  "fountain": 10000058
  "geminate": 10000029
  "genesis": 10000067
  "great wildlands": 10000011
  "heimatar": 10000030
  "immensea": 10000025
  "impass": 10000031
  "insmother": 10000009
  "kador": 10000052
  "khanid": 10000049
  "kor-azor": 10000065
  "lonetrek": 10000016
  "malpais": 10000013
  "metropolis": 10000042
  "molden heath": 10000028
  "oasa": 10000040
  "omist": 10000062
  "outer passage": 10000021
  "outer ring": 10000057
  "paragon soul": 10000059
  "period basis": 10000063
  "perrigen falls": 10000066
  "placid": 10000048
  "providence": 10000047
  "pure blind": 10000023
  "querious": 10000050
  "scalding pass": 10000008
  "sinq laison": 10000032
  "solitude": 10000044
  "stain": 10000022
  "syndicate": 10000041
  "tash-murkon": 10000020
  "tenal": 10000045
  "tenerifis": 10000061
  "the bleak lands": 10000038
  "the citadel": 10000033
  "the forge": 10000002
  "the kalevala expanse": 10000034
  "the spire": 10000018
  "tribute": 10000010
  "vale of the silent": 10000003
  "venal": 10000015
  "verge vendor": 10000068
  "wicked creek": 10000006
}

module.exports = (robot) ->
  robot.respond /marketstat (.*)\sin\s(.*)$/i, (msg) ->
    itemQuery = msg.match[1].trim().toLowerCase()

    locationQuery =msg.match[2].trim().toLowerCase()
    location = regionIDCache[locationQuery]

    if location
      loadItemData(msg, itemQuery, (itemData) ->
        if itemData
          loadMarketData(msg, itemData, location, (marketData, itemData) ->
            if marketData && itemData
              msg.send "[#{itemData.typeName} Median values in #{locationQuery}] Buy: #{accounting.formatNumber(marketData.buy.median)} / Sell: #{accounting.formatNumber(marketData.sell.median)}"
            else
              msg.send "I couldn't find that item (#{itemQuery})."
          )
        else
          msg.send "I couldn't find that item (#{itemQuery})."
      )
    else
      msg.send "I couldn't find that location (#{locationQuery})."

loadItemData = (msg, itemQuery, cb) ->
  return cb(itemIDCache[itemQuery]) if itemIDCache[itemQuery]

  msg.http('http://util.eveuniversity.org/xml/itemLookup.php')
    .query(name: itemQuery)
    .get() (err, res, body) ->
      try
        itemData = parser.toJson(body, { object: true }).itemLookup
        itemIDCache[itemQuery] = itemData
        cb(itemData)
      catch e
        cb()

loadMarketData = (msg, itemData, location, cb) ->
  msg.http('http://api.eve-central.com/api/marketstat')
    .query(typeid: itemData.typeID, regionlimit: location)
    .get() (err, res, body) ->
      try
        cb(parser.toJson(body, { object: true }).evec_api.marketstat.type, itemData)
      catch e
        cb()
