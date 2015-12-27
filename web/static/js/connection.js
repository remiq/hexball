import {Socket} from 'phoenix'

export class Connection {
  constructor(stream, game_id) {
    let socket = new Socket("/socket", {
      logger: ((kind, msg, data) => { this.log(`${kind}: ${msg}`, data) })
    })
    socket.connect({})
    socket.onOpen( ev => this.log("OPEN", ev) )
    socket.onError( ev => this.log("ERROR", ev) )
    socket.onClose( e => this.info("Brak połączenia."))

    var chan = socket.channel("game:" + game_id, {})
    chan.join().receive("ignore", () => this.log("auth error"))
               .receive("ok", () => this.info("Połączono."))
               .after(10000, () => this.log("Connection interruption"))
    chan.onError(e => this.log("something went wrong", e))
    chan.onClose(e => this.log("channel closed", e))

    chan.on('state', msg => stream.doState(msg))
    stream.onMove((ev, msg) => chan.push('move', msg))
  }
  info(msg) {
    // console.log(msg)
  }
  log(a, b) {
    // console.log(a, b)
  }
}
