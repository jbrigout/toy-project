defmodule Behale.Members do
  alias Behale.Repo

  def create_member(name, goal) when is_number(goal) or is_nil(goal),
    do: Repo.insert_member(%{name: name, goal: goal, sessions: [], points: 0})

  def member_by_id(member_id) when is_binary(member_id),
    do: Repo.get_member(member_id)

  ## allow updates for member points
  def update_member(member_id, %{points: points} = updates)
      when is_binary(member_id) and is_number(points),
      do: Repo.update_member(member_id, updates)

  ## allow updates for member goal
  def update_member(member_id, %{goal: goal} = updates)
      when is_binary(member_id) and 3 <= goal and goal <= 10,
      do: Repo.update_member(member_id, updates)
end
