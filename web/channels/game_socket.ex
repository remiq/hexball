defmodule Hexball.GameSocket do
  use Phoenix.Socket

  channel "game:*", Hexball.GameChannel

  transport :websocket, Phoenix.Transports.WebSocket,
    check_origin: false
  transport :longpoll, Phoenix.Transports.LongPoll,
      check_origin: false

  def connect(%{"game_id" => game_id, "user_name" => user_name}, socket) do
    assigns = socket.assigns
      |> Dict.put(:game_id, game_id)
      |> Dict.put(:user_name, user_name)
    {:ok, %{socket | assigns: assigns}}
  end

  def id(_socket), do:
    nil
end
