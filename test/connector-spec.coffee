Connector = require '../'

describe 'Connector', ->
  beforeEach (done) ->
    @sut = new Connector
    {@beacon} = @sut
    @beacon.connect = sinon.stub().yields null
    options =
      scanImmediately: true
    @sut.start {options}, done

  afterEach (done) ->
    @sut.close done

  describe '->isOnline', ->
    it 'should yield running true', (done) ->
      @sut.isOnline (error, response) =>
        return done error if error?
        expect(response.running).to.be.true
        done()

  describe '->onConfig', ->
    it 'should call beacon.connect', ->
      options =
        scanImmediately: true

      expect(@beacon.connect).to.have.been.calledWith options

  describe '->startScanning', ->
    beforeEach (done) ->
      @beacon.startScanning = sinon.stub().yields null
      @sut.startScanning done

    it 'should call beacon.startScanning', ->
      expect(@beacon.startScanning).to.have.been.called

  describe '->stopScanning', ->
    beforeEach (done) ->
      @beacon.stopScanning = sinon.stub().yields null
      @sut.stopScanning done

    it 'should call beacon.stopScanning', ->
      expect(@beacon.stopScanning).to.have.been.called

  describe '->clearBeacons', ->
    beforeEach (done) ->
      @beacon.clearBeacons = sinon.stub().yields null
      @sut.clearBeacons done

    it 'should call beacon.clearBeacons', ->
      expect(@beacon.clearBeacons).to.have.been.called

  describe '->_onData', ->
    beforeEach (done) ->
      @sut.emit = sinon.spy()
      data =
        uuid: 'the-uuid'
        major: 'mr-major-sir'
        minor: 'a-minor'
        measuredPower: 0
        rssi: 1
        accuracy: 2
        proximity: 'near'
      @beacon.once 'data', => done()
      @beacon.emit 'data', data

    it 'should emit message', ->
      data =
        uuid: 'the-uuid'
        major: 'mr-major-sir'
        minor: 'a-minor'
        measuredPower: 0
        rssi: 1
        accuracy: 2
        proximity: 'near'
      expect(@sut.emit).to.have.been.calledWith 'message', {devices: ['*'], data}
