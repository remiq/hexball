defmodule Hexball.Game.Simulation do
	use GenServer
	alias Hexball.Game.Collision
	alias Hexball.Game.State
	alias Hexball.Game.Move

	@update_ms 50

	def start_link(opts \\ []) do
		GenServer.start_link __MODULE__, :ok, opts
	end

	def init(:ok) do
		:timer.send_after(100, :step)
		{:ok, State.create("one")}
	end

	@doc """
	Adds new player to game and returns their ID.
	"""
	def join(server) do
		:random.seed :erlang.now # this looks bad
		user_id = Float.to_string(:random.uniform)
		GenServer.cast(server, {:join, user_id})
		user_id
	end

	@doc """
	Removes player from game
	"""
	def leave(server, user_id) do
		GenServer.cast(server, {:leave, user_id})
	end

	@doc """
	Adds user's intent to move
	"""
	def move(server, user_id, data) do
		GenServer.cast server, {:move, user_id, data}
	end

	def handle_cast({:join, user_id}, state) do
		{:noreply, State.add_player(state, user_id)}
	end

	def handle_cast({:leave, user_id}, state) do
		{:noreply, State.delete_player(state, user_id)}
	end

	def handle_cast({:move, user_id, input}, state) do
		player = process_intent(State.player(state, user_id), input)
		{:noreply, State.update_player(state, user_id, player)}
	end

	def handle_info(:step, state) do
		state = process_step(state)		
		Hexball.Endpoint.broadcast! "game:" <> state[:game_id], "state", state
		:timer.send_after(@update_ms, :step)
		{:noreply, state}
	end

	defp process_intent(player, input) do
		%{player | 
			ix: input["x"], 
			iy: input["y"],
			kick: input["k"]
		}
	end

	defp process_step(state) do
		state
		|> Move.process
		|> Collision.process
	end





end