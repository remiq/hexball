defmodule Hexball.Mixfile do
  use Mix.Project

  def project do
    [app: :hexball,
     version: "0.0.1",
     elixir: "~> 1.0",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     aliases: aliases,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [mod: {Hexball, []},
     applications: [:phoenix, :phoenix_html, :cowboy, :logger,
                    :phoenix_ecto, :postgrex]]
  end

  # Specifies which paths to compile per environment
  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  # Specifies your project dependencies
  #
  # Type `mix help deps` for examples and options
  defp deps do
    [{:phoenix, "~> 1.1"},
     {:phoenix_ecto, "~> 1.1"},
     {:postgrex, ">= 0.0.0"},
     {:phoenix_html, "~> 2.2"},
     {:phoenix_live_reload, "~> 1.0", only: :dev},
     {:exrm, "~> 0.19"},
     {:cowboy, "~> 1.0"}]
  end

  defp aliases do
    [
      brunch: &brunch/1,
      rsync: &rsync/1,
      r: ["brunch", "phoenix.digest", "release", "rsync"]
    ]
  end

  def brunch(_args) do
    {stdout, _status} = System.cmd "brunch", ["b"]
    IO.puts stdout
  end

  defp rsync(_args) do
    conf = project()
    app_name = Atom.to_string conf[:app]
    version = conf[:version]
    IO.puts "Sending release to remote server"
    {stdout, _status} = System.cmd("rsync", [ "-Pravdtze", "ssh",
      "rel/#{app_name}/releases/#{version}/#{app_name}.tar.gz",
      "root@mc0:/home/kyon/#{app_name}/releases/#{version}/"])
    IO.puts stdout
  end

end
