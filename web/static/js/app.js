import {Connection} from 'web/static/js/connection'
import {Player} from 'web/static/js/player'
import {Players} from 'web/static/js/players'
import {Score} from 'web/static/js/score'
import {Stream} from 'web/static/js/stream'

export class App extends React.Component {
  constructor(props) {
    super(props)
    this.stream = new Stream()
    this.connection = new Connection(this.stream, props.game_id)
    this.player = new Player(this.stream)
    this.state = {
      score: {blue: 0, red: 0},
      players: []
    }

    this.onState = this.onState.bind(this)
    this.stream.onState(this.onState)
    this.handle_keys = this.handle_keys.bind(this)
    this.handle_keys(window)
  }
  handle_keys(w) {
    w.onkeydown = this.player.onkeydown
    w.onkeyup = this.player.onkeyup
  }
  move_send(player_state) {
    this.stream.doMove(player_state)
  }
  onState(ev, msg) {
    this.setState(msg)
  }
  render() {
    return <g className="state">
      <Score blue={this.state.score.blue} red={this.state.score.red} />
      <Players players={this.state.players} />
    </g>
  }
  static start(game_id) {
    ReactDOM.render(<App game_id={game_id} />,
      document.getElementById('state'))
  }
}
