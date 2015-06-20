import {Socket} from "phoenix"

let arena = $('#arena');

let socket = new Socket("/ws")
socket.connect()
let chan = socket.chan("game:one", {})
chan.join().receive("ok", chan => {
  console.log("Success!")
})

let App = {
}

export default App
