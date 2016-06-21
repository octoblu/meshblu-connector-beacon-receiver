Beacon = require '../src/beacon'

describe.only 'Beacon', ->
  beforeEach ->
    options =
      broadcastProximityChange: true
      broadcastRssiChange: true
      rssiDelta: 5
    @sut = new Beacon options
    @sut._emit = sinon.stub()

  afterEach (done) ->
    @sut.close done

  describe '->update', ->
    context 'the first update', ->
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

    context 'the second update, with rssi in the delta', ->
      beforeEach (done) ->
        options =
          rssi: -53
          proximity: 'near'
        @sut.update options, done

      beforeEach (done) ->
        options =
          rssi: -50
          proximity: 'near'
        @sut.update options, done

      it 'should set @beacon', ->
        expect(@sut.beacon).to.deep.equal rssi: -50, proximity: 'near'

      it 'should not update the rssi', ->
        expect(@sut.rssi).to.equal -53

      it 'should not update the proximity', ->
        expect(@sut.proximity).to.equal 'near'

      it 'should call _emit once', ->
        expect(@sut._emit).to.have.been.calledWith 'data', rssi: -53, proximity: 'near'

    context 'the second update, with rssi outside the delta', ->
      beforeEach (done) ->
        options =
          rssi: -53
          proximity: 'near'
        @sut.update options, done

      beforeEach (done) ->
        options =
          rssi: -30
          proximity: 'near'
        @sut.update options, done

      it 'should set @beacon', ->
        expect(@sut.beacon).to.deep.equal rssi: -30, proximity: 'near'

      it 'should update the rssi', ->
        expect(@sut.rssi).to.equal -30

      it 'should not update the proximity', ->
        expect(@sut.proximity).to.equal 'near'

      it 'should call _emit', ->
        expect(@sut._emit).to.have.been.calledWith 'data', rssi: -53, proximity: 'near'
        expect(@sut._emit).to.have.been.calledWith 'data', rssi: -30, proximity: 'near'

    context 'the second update, with proxmity change', ->
      beforeEach (done) ->
        options =
          rssi: -53
          proximity: 'near'
        @sut.update options, done

      beforeEach (done) ->
        options =
          rssi: -53
          proximity: 'immediate'
        @sut.update options, done

      it 'should set @beacon', ->
        expect(@sut.beacon).to.deep.equal rssi: -53, proximity: 'immediate'

      it 'should not update the rssi', ->
        expect(@sut.rssi).to.equal -53

      it 'should update the proximity', ->
        expect(@sut.proximity).to.equal 'immediate'

      it 'should call _emit once', ->
        expect(@sut._emit).to.have.been.calledWith 'data', rssi: -53, proximity: 'immediate'

  describe '->is', ->
    beforeEach (done) ->
      options =
        uuid: 'the-uuid'
        major: 'mr-major-sir'
        minor: 'a-minor'
      @sut.update options, done

    context 'when matching', ->
      it 'should return true', ->
        beacon =
          uuid: 'the-uuid'
          major: 'mr-major-sir'
          minor: 'a-minor'
        expect(@sut.is beacon).to.be.true

    context 'when uuid is different', ->
      it 'should return false', ->
        beacon =
          uuid: 'other-uuid'
          major: 'mr-major-sir'
          minor: 'a-minor'
        expect(@sut.is beacon).to.be.false

    context 'when major is different', ->
      it 'should return false', ->
        beacon =
          uuid: 'the-uuid'
          major: 'mrs-major-maam'
          minor: 'a-minor'
        expect(@sut.is beacon).to.be.false

    context 'when minor is different', ->
      it 'should return false', ->
        beacon =
          uuid: 'the-uuid'
          major: 'mr-major-sir'
          minor: 'b-flat'
        expect(@sut.is beacon).to.be.false
