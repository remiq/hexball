defmodule Hexball.GameChannel do
	use Phoenix.Channel
	alias Hexball.Game.Supervisor
	alias Hexball.Game.Simulation

	intercept ["state"]

	def join("game:" <> game_id, _auth_msg, socket) do
		# FUTURE: private games, tournaments should be started with token distributed by web; alt: channel for private/tournaments
		IO.inspect "Anonymous player joined game: " <> game_id
		game = Supervisor.get_game(game_id)
		user_id = Simulation.join(game, socket.assigns.user_name)
		IO.inspect user_id
		socket = assign(socket, :user, user_id)
		socket = assign(socket, :game, game)
		{:ok, socket}
	end

	def terminate(_reason, socket) do
		user_id = socket.assigns[:user]
		game = socket.assigns[:game]
		IO.inspect "Player leaving: " <> user_id
		Simulation.leave(game, user_id)
	end

	@doc """
	Message from player containing vectors and "kick" status
	"""
	def handle_in("move", data, socket) do
		game_id = "one"
		#IO.inspect "received move"
		#IO.inspect data
		#%{"x" => ix, "y" => iy, "k" => kick} = data
		game = Supervisor.get_game (game_id)
		user_id = socket.assigns[:user]
		Simulation.move(game, user_id, data)

		# TEST
		#broadcast! socket, "state", %{"test" => "true"}
		{:noreply, socket}
	end

	def handle_in(msg, _data, socket) do
		IO.inspect "Unhandled message: " <> msg
		{:noreply, socket}
	end

	@doc """
	Sends game data (players/ball positions and vectors)
	"""
	def handle_out("state", payload, socket) do
		# i'll probably need to use state:{game_id} and filter
		# by socket.game
		#IO.inspect payload
		push socket, "state", payload
		{:noreply, socket}
	end

	# TODO: model using timer should broadcast! state to every player

end
