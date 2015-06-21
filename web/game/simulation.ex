defmodule Hexball.Game.Simulation do
	use GenServer

	@on_load :reseed_generator

	def start_link(opts \\ []) do
		GenServer.start_link __MODULE__, :ok, opts
	end

	def reseed_generator do
		:random.seed :erlang.now
		:ok
	end

	@doc """
	Adds new player to game and returns their ID.
	"""
	def join(_server) do
		# TODO: reseed is in different process?
		:random.seed :erlang.now
		:random.uniform
	end

	@doc """
	Adds user's intent to move
	"""
	def move(server, user) do

	end

	# TODO: add periodical simulation step execution
	# TODO: add state broadcasting after step

end