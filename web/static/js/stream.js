export class Stream {
  constructor() {
    this.stream = $('#body')
  }

  doState(msg) {
    this.stream.trigger('state', msg)
  }
  onState(fun) {
    this.stream.on('state', fun)
  }
  doMove(msg) {
    this.stream.trigger('move', msg)
  }
  onMove(fun) {
    this.stream.on('move', fun)
  }
}
