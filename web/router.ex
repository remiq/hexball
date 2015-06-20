defmodule Hexball.Router do
  use Hexball.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Hexball do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  socket "/ws", Hexball do
    channel "game:*", GameChannel
  end

  # Other scopes may use custom stacks.
  # scope "/api", Hexball do
  #   pipe_through :api
  # end
end
