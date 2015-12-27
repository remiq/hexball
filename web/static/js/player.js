
const K_LEFT = 37
const K_UP = 38
const K_RIGHT = 39
const K_DOWN = 40
const K_Z = 90
const K_X = 88
const K_SPACE = 32

export class Player {
  constructor(stream) {
    this.ix = 0
    this.iy = 0
    this.kick = 0
    this.pass = 0
    this.stream = stream
    this.state = this.state.bind(this)
    this.move_intent = this.move_intent.bind(this)
    this.move_send = this.move_send.bind(this)
    this.onkeydown = this.onkeydown.bind(this)
    this.onkeyup = this.onkeyup.bind(this)
    this.state = this.state.bind(this)
  }
  state() {
    return {
       x: this.ix
      ,y: this.iy
      ,k: this.kick
      ,p: this.pass
    }
  }
  move_intent(x, y, k, p) {
    if (this.ix != x) {
      this.ix += x
      this.ix = Math.min(Math.max(this.ix, -1), 1)
      this.move_send(this.state())
    }
    if (this.iy != y) {
      this.iy += y
      this.iy = Math.min(Math.max(this.iy, -1), 1)
      this.move_send(this.state())
    }
    if (this.kick != k) {
      this.kick += k
      this.kick = Math.min(Math.max(this.kick, 0), 1)
      this.move_send(this.state())
    }
    if (this.pass != p) {
      this.pass += p
      this.pass = Math.min(Math.max(this.pass, 0), 1)
      this.move_send(this.state())
    }
  }
  move_send(state) {
    this.stream.doMove(state)
  }
  onkeydown(k) {
    let move_intent = this.move_intent
    switch (k.keyCode) {
      case K_UP:
        move_intent(0, -1, 0, 0)
        break;
      case K_DOWN:
        move_intent(0, 1, 0, 0)
        break;
      case K_LEFT:
        move_intent(-1, 0, 0, 0)
        break;
      case K_RIGHT:
        move_intent(1, 0, 0, 0)
        break;
      case K_Z:
        move_intent(0, 0, 0, 1)
        break;
      case K_X:
        move_intent(0, 0, 1, 0)
        break;
    }
  }
  onkeyup(k) {
    let move_intent = this.move_intent
    switch (k.keyCode) {
      case K_UP:
        move_intent(0, 1, 0, 0)
        break;
      case K_DOWN:
        move_intent(0, -1, 0, 0)
        break;
      case K_LEFT:
        move_intent(1, 0, 0, 0)
        break;
      case K_RIGHT:
        move_intent(-1, 0, 0, 0)
        break;
      case K_Z:
        move_intent(0, 0, 0, -1)
        break;
      case K_X:
        move_intent(0, 0, -1, 0)
        break;
    }
  }
}
