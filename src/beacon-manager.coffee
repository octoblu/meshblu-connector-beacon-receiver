_              = require 'lodash'
{EventEmitter} = require 'events'
async          = require 'async'
Bleacon        = require '@octoblu/bleacon'
Beacon         = require './beacon'

class BeaconManager extends EventEmitter
  constructor: ->
    # Hook for testing
    @Bleacon = Bleacon
    @beacons = []
    @Bleacon.on 'discover', @_onDiscover

  clearBeacons: (callback) =>
    async.each @beacons, (beacon, done) =>
      beacon.close done
    , =>
      @beacons = []
      callback()

  connect: (options, callback) =>
    {
      @timeout
      @rssiDelta
      @scanImmediately
      @broadcastProximityChange
      @broadcastRssiChange
      @uuid
      @major
      @minor
    } = options

    tasks = [ @clearBeacons, @stopScanning ]
    tasks.push @startScanning if @scanImmediately

    async.series tasks, callback

  startScanning: (callback) =>
    @Bleacon.startScanning @uuid, @major, @minor
    callback()

  stopScanning: (callback) =>
    @Bleacon.stopScanning()
    callback()

  _onData: (data) =>
    { uuid, major, minor, measuredPower, rssi, accuracy, proximity } = data
    @emit 'data', { uuid, major, minor, measuredPower, rssi, accuracy, proximity }

  _findBeacon: (data) =>
    _.find @beacons, (beacon) =>
      beacon.is data

  _onDiscover: (data) =>
    beacon = @_findBeacon data
    return beacon.update data if beacon?

    beacon = new Beacon {beacon: data, @broadcastProximityChange, @broadcastRssiChange, @rssiDelta, @timeout}
    beacon.on 'data', @_onData
    @beacons.push beacon

module.exports = BeaconManager
