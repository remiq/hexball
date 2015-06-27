defmodule Hexball.Game.Endgame do
	alias Hexball.Game.State

	def process(state) do
		ball = State.ball(state)
		cond do
			ball[:x] == 5 && ball[:y] >= 20 && ball[:y] <= 30 ->
				score(state, :red)
			ball[:x] == 95 && ball[:y] >= 20 && ball[:y] <= 30 ->
				score(state, :blue)
			:else -> state
		end
	end

	defp score(state, team) do
		score = Dict.put(state[:score], team, Dict.get(state[:score], team) + 1)
		players = State.players(state)
		%{state |
			score: score,
			players: %{players |
				ball: State.gen_ball
			}
			# TODO: put players on their places?
		}

	end

end