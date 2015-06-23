defmodule Hexball.Game.Simulation do
	use GenServer

	@update_ms 50

	def start_link(opts \\ []) do
		GenServer.start_link __MODULE__, :ok, opts
	end

	def init(:ok) do
		:random.seed :erlang.now
		:timer.send_after(100, :step)
		# TODO: add game_id?
		{:ok, %{
			players: [],
			x: 0,
			left: true
			#:ball
			#:score
			}}
	end

	@doc """
	Adds new player to game and returns their ID.
	"""
	def join(server, socket) do
		user_id = :random.uniform
		GenServer.cast(server, {:join, user_id})
		user_id
	end

	@doc """
	Adds user's intent to move
	"""
	def move(server, user) do

	end

	def handle_cast({:join, user_id}, state) do
		user = gen_user(user_id)
		state = Dict.put state, :players, state[:players] ++ [user] 
		{:noreply, state}
	end

	def handle_info(:step, state) do
		state = process_step(state)		
		Hexball.Endpoint.broadcast! "game:one", "state", state
		:timer.send_after(@update_ms, :step)
		{:noreply, state}
	end

	@doc """
	Executes step in simulation
	"""
	defp process_step(state) do
		# foreach object
		players = Dict.get state, :players
		state = process_players(state, players, [])
		state
	end

	defp process_players(state, [player|rest], acc) do
		x = Dict.get player, :x

		if state[:left] do
			x = x + 1
		else
			x = x - 1
		end
		if x > 50 do
				state = Dict.put(state, :left, false)
		end
		if x < 1 do
				state = Dict.put(state, :left, true)
		end
		player = Dict.put player, :x, x
		process_players(state, rest, acc ++ [player])
	end

	defp process_players(state, [], acc) do
		state = Dict.put state, :players, acc
		state
	end

	@doc """
	Spawns new user
	"""
	defp gen_user(user_id) do
		player = %{
			user_id: user_id,
			x: 0, y: 0, # position
			dx: 0, dy: 0, # velocity
			ix: 0, iy: 0, kick: 0, # intention to move
			team: :red
		}
		player = %{player | x: 25, y: 25}
		# TODO: check if position is not in use
		player
	end

end