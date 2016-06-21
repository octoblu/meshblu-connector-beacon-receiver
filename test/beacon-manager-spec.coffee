_ = require 'lodash'
BeaconManager = require '../src/beacon-manager'

describe 'BeaconManager', ->
  beforeEach ->
    @sut = new BeaconManager
    {@Bleacon} = @sut

  describe '->connect', ->
    beforeEach ->
      @Bleacon.stopScanning = sinon.stub()
      @Bleacon.startScanning = sinon.stub()
      @Bleacon.clearBeacons = sinon.stub()

    context 'without uuid', ->
      beforeEach (done) ->
        options =
          scanImmediately: true
        @sut.connect options, done

      it 'should stopScanning', ->
        expect(@Bleacon.stopScanning).to.have.been.called

      it 'should startScanning', ->
        expect(@Bleacon.startScanning).to.have.been.calledWith undefined, undefined, undefined

    context 'when uuid is set', ->
      beforeEach (done) ->
        options =
          scanImmediately: true
          uuid: 'the-uuid'
          major: 0
          minor: 0

        @sut.connect options, done

      it 'should stopScanning', ->
        expect(@Bleacon.stopScanning).to.have.been.called

      it 'should startScanning', ->
        expect(@Bleacon.startScanning).to.have.been.calledWith 'the-uuid', 0, 0

  describe '->startScanning', ->
    beforeEach (done) ->
      @sut.startScanning done

    it 'should call Bleacon.startScanning', ->
      expect(@Bleacon.startScanning).to.have.been.called

  describe '->stopScanning', ->
    beforeEach (done) ->
      @sut.stopScanning done

    it 'should call Bleacon.stopScanning', ->
      expect(@Bleacon.stopScanning).to.have.been.called

  describe '->clearBeacons', ->
    beforeEach (done) ->
      @beacon =
        close: sinon.stub().yields null
      @sut.beacons = [@beacon]
      @sut.clearBeacons done

    it 'should call beacon.close', ->
      expect(@beacon.close).to.have.been.called

  describe '->onDiscover', ->
    context 'the first time', ->
      beforeEach (done) ->
        @Bleacon.once 'discover', => done()
        @Bleacon.emit 'discover', {}

      it 'should add the beacon to the list', ->
        expect(@sut.beacons.length).to.equal 1

    context 'the second time for the same device', ->
      beforeEach (done) ->
        @Bleacon.once 'discover', => done()
        @Bleacon.emit 'discover', uuid: 'hi'

      beforeEach (done) ->
        @Bleacon.once 'discover', => done()
        @Bleacon.emit 'discover', uuid: 'hi'

      it 'should add only one beacon to the list', ->
        expect(@sut.beacons.length).to.equal 1

    context 'the second time for a different device', ->
      beforeEach (done) ->
        @Bleacon.once 'discover', => done()
        @Bleacon.emit 'discover', uuid: 'hi'

      beforeEach (done) ->
        @Bleacon.once 'discover', => done()
        @Bleacon.emit 'discover', uuid: 'hi', major: 1

      it 'should add the beacon to the list', ->
        expect(@sut.beacons.length).to.equal 2

  describe '->_onData', ->
    beforeEach (done) ->
      @sut.emit = sinon.stub()
      @rawBeacon =
        uuid: 'the-uuid'
        major: 'mr-major-sir'
        minor: 'a-minor'
        measuredPower: 0
        rssi: 1
        accuracy: 2
        proximity: 'near'

      @Bleacon.once 'discover', =>
        @beacon = _.first @sut.beacons
        done()
      @Bleacon.emit 'discover', @rawBeacon

    beforeEach (done) ->
      @beacon.once 'data', => done()
      @beacon.emit 'data', @rawBeacon

    it 'should emit data', ->
      data =
        uuid: 'the-uuid'
        major: 'mr-major-sir'
        minor: 'a-minor'
        measuredPower: 0
        rssi: 1
        accuracy: 2
        proximity: 'near'
      expect(@sut.emit).to.have.been.calledWith 'data', data
