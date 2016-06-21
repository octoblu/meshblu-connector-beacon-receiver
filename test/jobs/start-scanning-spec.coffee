{job} = require '../../jobs/start-scanning'

describe 'StartScanning', ->
  context 'when given a valid message', ->
    beforeEach (done) ->
      @connector =
        startScanning: sinon.stub().yields null
      message = {}
      @sut = new job {@connector}
      @sut.do message, (@error) =>
        done()

    it 'should not error', ->
      expect(@error).not.to.exist

    it 'should call connector.startScanning', ->
      expect(@connector.startScanning).to.have.been.called
