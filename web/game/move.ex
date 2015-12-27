defmodule Hexball.Game.Move do
	alias Hexball.Game.State

	@intent2accel 0.1
	@maxdx 10
	@deaccel 0.9

	def process(state) do
		process(state, Map.to_list(State.players(state)), [])
	end

	def process(state, [player|rest], processed) do
		{user_id, player} = player
		player = process_player(player)
		process(state, rest, processed ++ [{user_id, player}])
	end

	def process(state, [], processed) do
		State.set(state, :players, keywords_to_map(processed))
	end

	# -- OLD
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
	# -- /OLD


	defp keywords_to_map(keywords) do
    	Enum.into keywords, %{}
  	end
end
