defmodule Hexball.Game.Supervisor do
	use Supervisor

	def start_link(opts \\ []) do
		Supervisor.start_link __MODULE__, :ok, opts
	end

	def init(:ok) do
		# TODO: how to add new worker runtime?
		children = [
			worker(Hexball.Game.Simulation, [[name: Hexball.Game.Simulation]])
		]
		supervise(children, strategy: :one_for_one)
	end

	def get_game(_game_name) do
		Hexball.Game.Simulation
	end

end