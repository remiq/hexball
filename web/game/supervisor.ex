defmodule Hexball.Game.Supervisor do
	use Supervisor

	def start_link(opts \\ []) do
		Supervisor.start_link __MODULE__, :ok, opts
	end

	def init(:ok) do
		# TODO: how to add new worker runtime?
		children = [
			worker(Hexball.Game.Simulation, [[name: :single]])
		]
		supervise(children, strategy: :one_for_one)
	end

	def get_game(game_name) do
		:single
	end

end