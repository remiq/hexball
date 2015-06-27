defmodule Hexball.Game.Collision do
  alias Hexball.Game.State

  @kick_strength 3

  def process(state) do
    process(state, Map.to_list(State.players(state)), [])
  end

  def process(state, [player|rest], processed) do
    {player, rest} = check(player, rest, [])
    process(state, rest, processed ++ [player])
  end

  def process(state, [], processed) do
    State.set(state, :players, keywords_to_map(processed))
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

  def check(player, [], acc) do
    {_, %{team: team}} = player
    {boundaries(team, player), acc}
  end

  defp boundaries(:ball, {user_id, object}) do
    {
      user_id, 
      %{object |
          x: max(min(object[:x], 100-5), 5),
          y: max(min(object[:y], 50-5), 5)
      }
    }
  end

  defp boundaries(_, {user_id, player}) do
    {
      user_id, 
      %{player |
          x: max(min(player[:x], 100-2.5), 2.5),
          y: max(min(player[:y], 50-2.5), 2.5)
      }
    }
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

  defp keywords_to_map(keywords) do
    Enum.into keywords, %{}
  end

end