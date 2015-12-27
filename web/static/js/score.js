
export class Score extends React.Component {
  constructor(props) {
    super(props)
  }
  render() {
    return <g className="score">
      <text key="score-blue" x="6" y="16" className="score blue">{this.props.blue}</text>
      <text key="score-red" x="86" y="16" className="score red">{this.props.red}</text>
    </g>
  }
}
