http = require 'http'

class ClearBeacons
  constructor: ({@connector}) ->
    throw new Error 'ClearBeacons requires connector' unless @connector?

  do: (message, callback) =>
    @connector.clearBeacons callback

module.exports = ClearBeacons
