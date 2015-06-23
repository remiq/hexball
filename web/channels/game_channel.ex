defmodule Hexball.GameChannel do
	use Phoenix.Channel
	alias Hexball.Game.Supervisor
	alias Hexball.Game.Simulation

	def join("game:" <> game_id, _auth_msg, socket) do
		# FUTURE: private games, tournaments should be started with token distributed by web; alt: channel for private/tournaments
		IO.inspect "Anonymous player joined game: " <> game_id
		game = Supervisor.get_game(game_id)
		user_id = Simulation.join(game, socket)
		socket = assign(socket, :user, user_id)
		{:ok, socket}
	end

	@doc """
	Message from player containing vectors and "kick" status
	"""
	def handle_in("move:" <> game_id, data, socket) do
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

	def handle_in(msg, data, socket) do
		IO.inspect "Unhandled message: " <> msg
		{:noreply, socket}
	end

	@doc """
	Sends game data (players/ball positions and vectors)
	"""
	def handle_out("state", payload, socket) do
		#IO.inspect payload
		push socket, "state", payload
		{:noreply, socket}
	end

	# TODO: model using timer should broadcast! state to every player

end