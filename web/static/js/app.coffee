Phoenix = require "phoenix"
Player = require "web/static/js/player"
console.log Player

K_LEFT = 37
K_UP = 38
K_RIGHT = 39
K_DOWN = 40
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
			mi = App.player.move_intent
			switch k.keyCode
				when K_UP then mi(0, 1)
				when K_DOWN then mi(0, -1)
				when K_LEFT then mi(-1, 0)
				when K_RIGHT then mi(1, 0)
			
		w.onkeyup = (k) ->
			mi = App.player.move_intent
			switch k.keyCode
				when K_UP then mi(0, -1)
				when K_DOWN then mi(0, 1)
				when K_LEFT then mi(1, 0)
				when K_RIGHT then mi(-1, 0)
		
	handle_gamestate: (game_state) ->
		console.log game_state.players[0]
		#$('#p1').attr('cx', game_state.x)
		React.render(
			React.createElement(PlayerEl, {data: game_state.players[0]}),
			document.getElementById('state')
		);

	move_send: (player_state) ->
		console.log player_state
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
			r: 5



