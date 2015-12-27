defmodule Hexball.GameSocket do
  use Phoenix.Socket

  channel "game:*", Hexball.GameChannel

  transport :websocket, Phoenix.Transports.WebSocket,
    check_origin: false
  transport :longpoll, Phoenix.Transports.LongPoll,
      check_origin: false

  def connect(_, socket) do
    IO.inspect socket
    {:ok, socket}
  end

  def id(_socket), do:
    nil
end
