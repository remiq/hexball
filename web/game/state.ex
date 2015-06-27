defmodule Hexball.Game.State do

	def create(game_id) do
		%{
			game_id: game_id,
			players: %{ball: gen_ball},
			score: %{
				blue: 0,
				red: 0
			}
		}
	end

	def ball(state), do: state[:players][:ball]

	@doc """
	Retrieves list of players from state.
	"""
	def players(state), do: Dict.get(state, :players)

	@doc """
	Saves list of players into state
	"""
	def set(state, :players, players), do: %{state | players: players}

	def player(state, user_id), do: state[:players][user_id]

	def add_player(state, user_id) do
		user = gen_user(user_id)
		update_player(state, user_id, user)
	end

	def update_player(state, user_id, user) do
		%{state |
			players: Dict.put(state[:players], user_id, user)
		}
	end

	def delete_player(state, user_id) do
		%{state |
			players: Dict.delete(state[:players], user_id)
		}
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
		# TODO: pick team
		# TODO: spawn based on team
		# TODO: check if position is not in use
		player = %{player | x: 25, y: 25}
		player
	end

	defp team_random do
		case :random.uniform(2) do
			1 -> :red
			2 -> :blue
		end
	end

	def gen_ball do
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