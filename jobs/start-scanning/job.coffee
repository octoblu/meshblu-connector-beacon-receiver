http = require 'http'

class StartScanning
  constructor: ({@connector}) ->
    throw new Error 'StartScanning requires connector' unless @connector?

  do: (message, callback) =>
    @connector.startScanning callback

module.exports = StartScanning
