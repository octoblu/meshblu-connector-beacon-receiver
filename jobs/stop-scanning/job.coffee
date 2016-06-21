http = require 'http'

class StopScanning
  constructor: ({@connector}) ->
    throw new Error 'StopScanning requires connector' unless @connector?

  do: (message, callback) =>
    @connector.stopScanning callback

module.exports = StopScanning
