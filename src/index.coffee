_               = require 'lodash'
{EventEmitter}  = require 'events'
debug           = require('debug')('meshblu-connector-beacon:index')
BeaconManager   = require './beacon-manager'

class Connector extends EventEmitter
  constructor: ->
    @beacon = new BeaconManager
    @beacon.on 'data', @_onData

  isOnline: (callback) =>
    callback null, running: true

  clearBeacons: (callback) =>
    @beacon.clearBeacons callback

  close: (callback) =>
    debug 'on close'
    callback()

  _onData: (data) =>
    @emit 'message', {devices: ["*"], data}

  startScanning: (callback) =>
    @beacon.startScanning callback

  stopScanning: (callback) =>
    @beacon.stopScanning callback

  onConfig: (device={}, callback=->) =>
    { @options } = device
    debug 'on config', @options
    fields = [
      'timeout'
      'rssiDelta'
      'scanImmediately'
      'broadcastProximityChange'
      'broadcastRssiChange'
      'uuid'
      'major'
      'minor'
    ]
    config = _.pick @options, fields
    @beacon.connect config, callback

  start: (device, callback) =>
    debug 'started'
    @onConfig device, callback

module.exports = Connector
