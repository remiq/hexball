defmodule Hexball.GameChannel do
	use Phoenix.Channel

	def join("game:" <> game_id, _auth_msg, socket) do
		# FUTURE: private games, tournaments should be started with token distributed by web; alt: channel for private/tournaments
		IO.inspect "Anonymous player joined game: " <> game_id
		{:ok, socket}
	end

	@doc """
	Message from player containing vectors and "kick" status
	"""
	def handle_in("move", %{"dx" => dx, "dy" => dy, "kick" => kick}, socket) do
		# TODO: feed data to model
		# TODO: this changes vector, not moves. If I send same message, nothing will change in the same simulation tick.
		{:noreply, socket}
	end

	@doc """
	Sends game data (players/ball positions and vectors)
	"""
	def handle_out("state", payload, socket) do
		push socket, "state", payload
		{:noreply, socket}
	end

	# TODO: model using timer should broadcast! state to every player

end