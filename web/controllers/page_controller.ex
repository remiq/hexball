defmodule Hexball.PageController do
  use Hexball.Web, :controller

  def index(conn, _params) do
    render conn, "index.html",
    %{
      room: "one",
      name: "anon"
    }
  end

  def room(conn, %{"room" => room}) do
    render conn, "index.html", %{
      room: room,
      name: "anon"
    }
  end

  def room_with_name(conn, %{"room" => room, "name" => name}) do
    render conn, "index.html", %{
      room: room,
      name: name
    }
  end
end
