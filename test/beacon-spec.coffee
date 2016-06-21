Beacon = require '../src/beacon'

describe.only 'Beacon', ->
  beforeEach ->
    @sut = new Beacon broadcastProximityChange: true

    @sut._emit = sinon.stub()

  describe '->update', ->
    beforeEach (done) ->
      options =
        rssi: -53
        proximity: 'near'
      @sut.update options, done

    it 'should set @beacon', ->
      expect(@sut.beacon).to.deep.equal rssi: -53, proximity: 'near'

    it 'should update the rssi', ->
      expect(@sut.rssi).to.equal -53

    it 'should update the proximity', ->
      expect(@sut.proximity).to.equal 'near'

    it 'should call _emit', ->
      expect(@sut._emit).to.have.been.calledWith 'data', rssi: -53, proximity: 'near'
