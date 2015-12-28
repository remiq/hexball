
export class Players extends React.Component {
  constructor(props) {
    super(props)
  }
  renderPlayer(p) {
    let d = p.data
    let className = "player " + d.team
    let transform = "translate(" + d.x + "," + d.y + ")"
    let text = <g />
    if (d.team != 'ball') {
      let textStyle = {
        fontSize: 2
      }
      text = <text x="-2" y="5" style={textStyle}>{d.name}</text>
    }

    return <g key={p.key} transform={transform} >
      <circle cx="0" cy="0" r={d.r} className={className} />
      {text}
    </g>
  }
  render() {
    let players_arr = []
    let players_map = (k) => {
      players_arr.push({
        data: this.props.players[k],
        key: k
      })
    }
    Object.keys(this.props.players).forEach(players_map)
    let players = players_arr.map(this.renderPlayer)
    return <g>{players}</g>
  }
}
