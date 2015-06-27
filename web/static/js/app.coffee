Phoenix = require "phoenix"
Player = require "web/static/js/player"
console.log Player

K_LEFT = 37
K_UP = 38
K_RIGHT = 39
K_DOWN = 40
K_Z = 90
K_X = 88
K_SPACE = 32
GAME = "one"

App =
	chan: null
	player: null

	connect: () ->
		App.player = new Player(App)
		socket = new Phoenix.Socket("/ws")
		socket.connect()
		App.chan = chan = socket.chan "game:" + GAME, {}
		chan.join()
			.receive("ok", ()->
				console.log("Connected.")
				chan.on("state", App.handle_gamestate)
				)

	handle_keys: (w) ->
		w.onkeydown = (k) ->
			console.log k.keyCode
			mi = App.player.move_intent
			switch k.keyCode
				when K_UP then mi(0, -1, 0, 0)
				when K_DOWN then mi(0, 1, 0, 0)
				when K_LEFT then mi(-1, 0, 0, 0)
				when K_RIGHT then mi(1, 0, 0, 0)
				when K_Z then mi(0, 0, 0, 1)
				when K_X then mi(0, 0, 1, 0)
			
		w.onkeyup = (k) ->
			mi = App.player.move_intent
			switch k.keyCode
				when K_UP then mi(0, 1, 0, 0)
				when K_DOWN then mi(0, -1, 0, 0)
				when K_LEFT then mi(1, 0, 0, 0)
				when K_RIGHT then mi(-1, 0, 0, 0)
				when K_Z then mi(0, 0, 0, -1)
				when K_X then mi(0, 0, -1, 0)
		
	handle_gamestate: (game_state) ->
		#console.log game_state.players
		#$('#p1').attr('cx', game_state.x)
		React.render(
			React.createElement(StateEl, {state: game_state}),
			document.getElementById('state')
		);

	move_send: (player_state) ->
		#console.log player_state
		App.chan.push "move:" + GAME, player_state
		#console.log player_state


App.connect()
App.handle_keys(window)
window.App = App

PlayerEl = React.createClass _ =
	displayName: 'player'
	render: () ->
		React.createElement 'circle', _ =
			cx: this.props.data.x,
			cy: this.props.data.y,
			r: this.props.data.r,
			className: 'player ' + this.props.data.team

ScoreEl = React.createClass _ =
	render: () ->
		React.createElement 'g', {className: "score"}, [
			React.createElement 'text', {
				key: "score-blue", x: 6, y: 16, 
				className: "score blue"
				}, this.props.score.blue
			React.createElement 'text', {
				key: "score-red", x: 86, y: 16, 
				className: "score red"
				}, this.props.score.red
		]

StateEl = React.createClass _ =
	render: () ->
		score = React.createElement ScoreEl, {className: "scores", score: this.props.state.score}
		children = (React.createElement(PlayerEl, {data: data, key: user_id}) for user_id, data of this.props.state.players)
		objects = React.createElement 'g', {className: "objects"}, children
		React.createElement 'g', {className: "state"}, [score, objects]

		
			

