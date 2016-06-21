{job} = require '../../jobs/stop-scanning'

describe 'StopScanning', ->
  context 'when given a valid message', ->
    beforeEach (done) ->
      @connector =
        stopScanning: sinon.stub().yields null
      message = {}
      @sut = new job {@connector}
      @sut.do message, (@error) =>
        done()

    it 'should not error', ->
      expect(@error).not.to.exist

    it 'should call connector.stopScanning', ->
      expect(@connector.stopScanning).to.have.been.called
