defmodule Hexball.Game.Simulation do
	use GenServer

	@update_ms 50
	@intent2accel 0.1
	@maxdx 3

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
		player = process_player	player
		IO.inspect player
		process_players(state, rest, acc ++ [player])
	end

	defp process_players(state, [], acc) do
		state = Dict.put state, :players, acc
		state
	end

	defp process_player(player) do
		player
		|> process_move
		|> process_boundaries
		# process_colisions?
	end

	defp process_move(object) do
		%{
			object |
			x: object[:x] + object[:dx],
			dx: maxd(object[:dx] + object[:ix] * @intent2accel),
			y: object[:y] + object[:dy],
			dy: maxd(object[:dy] + object[:iy] * @intent2accel)
		}
	end

	defp process_boundaries(object) do
		%{x: x, y: y} = object
		if x < 5 || x > 95 do
			object = flip_dx(object)
		end
		if y < 5 || y > 45 do
			object = flip_dy(object)
		end
		object
	end

	defp flip_dx(object) do
		%{object | dx: -1 * object[:dx]}
	end

	defp flip_dy(object) do
		%{object | dy: -1 * object[:dy]}
	end

	defp maxd(x) do
		Float.round(1.0 * max(min(x, @maxdx), -@maxdx), 2)
	end

	@doc """
	Spawns new user
	"""
	defp gen_user(user_id) do
		player = %{
			user_id: user_id,
			x: 0, y: 0, # position
			dx: 1, dy: 0.5, # velocity
			ix: 0, iy: 0, kick: 0, # intention to move
			team: :red
		}
		player = %{player | x: 25, y: 25}
		# TODO: check if position is not in use
		player
	end

end