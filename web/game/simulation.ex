defmodule Hexball.Game.Simulation do
	use GenServer
	alias Hexball.Game.Collision

	@update_ms 50
	@intent2accel 0.1
	@maxdx 10
	@deaccel 0.9

	def start_link(opts \\ []) do
		GenServer.start_link __MODULE__, :ok, opts
	end

	def init(:ok) do
		:timer.send_after(100, :step)
		# TODO: add game_id?
		{:ok, %{
			players: %{ball: gen_ball}
			#:ball
			#:score
			}}
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
		user = gen_user(user_id)
		players = Dict.put state[:players], user_id, user
		state = Dict.put state, :players, players 
		{:noreply, state}
	end

	def handle_cast({:leave, user_id}, state) do
		players = Dict.delete(state[:players], user_id)
		{:noreply, Dict.put(state, :players, players)}
	end

	def handle_cast({move, user_id, input}, state) do
		player = process_intent state[:players][user_id], input
		players = Dict.put state[:players], user_id, player
		{:noreply, %{state | players: players}}
	end

	def handle_info(:step, state) do
		state = process_step(state)		
		Hexball.Endpoint.broadcast! "game:one", "state", state
		:timer.send_after(@update_ms, :step)
		{:noreply, state}
	end

	defp get_player(state, user_id) do
		Dict.get state[:players], user_id
	end

	defp process_intent(player, input) do
		%{player | 
			ix: input["x"], 
			iy: input["y"],
			kick: input["k"]
		}
	end

	@doc """
	Executes step in simulation
	"""
	defp process_step(state) do
		state
		|> process_players
		|> Collision.process
	end

	defp process_players(state) do
		players = Enum.reduce Dict.get(state, :players), %{},
			fn {user_id, player}, acc -> Dict.put(acc, user_id, process_player(player)) end
		%{state | players: players}
	end

	def process_collisions(state) do
		# foreach player A
			# foreach player B
				# is_collision(A,B)
					# 
	end

	defp process_player(player) do
		player
		|> process_move
		|> process_boundaries
	end

	defp process_move(object) do
		%{
			object |
			x: object[:x] + object[:dx],
			dx: maxd((object[:dx] + object[:ix] * @intent2accel) * object[:deaccel]),
			y: object[:y] + object[:dy],
			dy: maxd((object[:dy] + object[:iy] * @intent2accel) * object[:deaccel])
		}
	end

	defp process_boundaries(object) do
		# TODO: move to Collision
		%{x: x, y: y} = object
		if x < 2 || x > 98 do
			object = flip(object, :dx)
		end
		if y < 2 || y > 48 do
			object = flip(object, :dy)
		end
		object
	end

	defp flip(object, attr) do
		Dict.put object, attr, -object[attr]
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
			r: 2, team: team_random,
			deaccel: 0.9
		}
		player = %{player | x: 25, y: 25}
		# TODO: check if position is not in use
		player
	end

	defp team_random do
		case :random.uniform(2) do
			1 -> :red
			2 -> :blue
		end
	end

	defp gen_ball do
		%{
			user_id: 'ball',
			x: 50, y: 25,
			dx: 0, dy: 0,
			ix: 0, iy: 0, kick: 0,
			r: 1, team: :ball,
			deaccel: 0.99
		}
	end

end