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
			players: [], # player positions and intentions. Map?
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

	# TODO: add periodical simulation step execution
	# TODO: add state broadcasting after step

	def handle_cast({:join, socket}, state) do
		# TODO: randomize player team / position
		# TODO: add to state
		#state = Dict.put(state, :socket, socket)
		#state = Dict.put(state, :players, state[:players] ++ [user])
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
		if state[:left] do
			state = Dict.put(state, :x, state[:x] + 1)
		else
			state = Dict.put(state, :x, state[:x] - 1)
		end
		if state[:x] > 50 do
				state = Dict.put(state, :left, false)
		end
		if state[:x] < 1 do
				state = Dict.put(state, :left, true)
		end
		state
	end

end