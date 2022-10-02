defmodule Behale.Sessions do
  alias Behale.{Objectives, Repo}

  def plan_session(member_id, session_id, date) when is_binary(member_id) do
    Repo.insert_session(member_id, %{
      id: session_id,
      date: date,
      completed: false,
      type: :planned
    })

    Objectives.complete_objective(member_id, :session_planned)
  end

  def complete_session(member_id, nil) when is_binary(member_id) do
    Repo.insert_session(member_id, %{
      id: Ecto.UUID.generate(),
      date: Date.utc_today(),
      completed: true,
      type: :adhoc
    })

    Objectives.complete_objective(member_id, :adhoc_session_completed)
    :ok
  end

  def complete_session(member_id, session_id) when is_binary(member_id) do
    Repo.update_session(member_id, session_id, %{completed: true})
    Objectives.complete_objective(member_id, :planed_session_completed)
  end

  ## allow updates for member points
  def update_member(member_id, %{points: points} = updates)
      when is_binary(member_id) and is_number(points),
      do: Repo.update_member(member_id, updates)

  ## allow updates for member goal
  def update_member(member_id, %{goal: goal} = updates)
      when is_binary(member_id) and 3 <= goal and goal <= 10,
      do: Repo.update_member(member_id, updates)
end
