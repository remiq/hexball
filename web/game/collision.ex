defmodule Hexball.Game.Collision do

  def process(state) do
    players = Dict.get(state, :players)
    process(state, Map.to_list(players), [])
  end

  def process(state, [player|rest], processed) do
    # {user_id, data} = player
    {player, rest} = check(player, rest, [])
    process(state, rest, processed ++ [player])
  end

  def process(state, [], processed) do
    %{state | players: Enum.into(processed, %{})}
  end

  def check(a, [b|rest], acc) do
    if is_collided(a, b) do
      {uida, a} = a
      {uidb, b} = b
      {a, b} = {
        # this looks bad
        {uida, %{a | dx: b[:dx], dy: b[:dy]}}, 
        {uidb, %{b | dx: a[:dx], dy: a[:dy]}}
        # if kick, add additional velocity
      }
    end
    check(a, rest, acc ++ [b])
  end

  def check(a, [], acc) do
    {a, acc}
  end

  defp is_collided(a, b) do
    {_uid1, a} = a
    {_uid2, b} = b
    # pitagoras triangle
    dx = :erlang.abs(a[:x] - b[:x])
    dy = :erlang.abs(a[:y] - b[:y])
    dist = :math.sqrt(:math.pow(dx, 2) + :math.pow(dy, 2))

    (a[:r] + b[:r]) >= dist
  end

end