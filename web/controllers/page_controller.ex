defmodule Hexball.PageController do
  use Hexball.Web, :controller

  plug :action

  def index(conn, _params) do
    render conn, "index.html"
  end
end
