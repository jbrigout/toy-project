defmodule Behale.Objectives do
  alias Behale.Members
  require Logger

  def objectives() do
    [
      :session_planned,
      :adhoc_session_completed,
      :planed_session_completed,
      :weekly_session_goal_reached
    ]
  end

  def reward(:session_planned), do: 3
  def reward(:adhoc_session_completed), do: 5
  def reward(:planed_session_completed), do: 10
  def reward(:weekly_session_goal_reached), do: 50

  def complete_objective(member_id, :weekly_session_goal_reached) when is_binary(member_id) do
    %{points: points} = Members.member_by_id(member_id)

    :ok =
      Members.update_member(member_id, %{points: points + reward(:weekly_session_goal_reached)})

    :ok
  end

  def complete_objective(member_id, objective) when is_binary(member_id) do
    with true <- objective in objectives(),
         %{points: points, sessions: sessions, goal: goal} <- Members.member_by_id(member_id) do
      :ok = Members.update_member(member_id, %{points: points + reward(objective)})
      # check if session exists
      count =
        sessions
        |> Enum.filter(&(&1.completed and current_week?(&1.date)))
        |> length()

      if count == goal do
        Logger.warn("count ISO")
        complete_objective(member_id, :weekly_session_goal_reached)
      else
        :ok
      end

      :ok
    else
      false -> {:error, :invalid_objective}
      error -> {:error, error}
    end
  end

  def current_week?(date) do
    Date.diff(date, Date.beginning_of_week(Date.utc_today())) >= 0 and
      Date.diff(Date.end_of_week(Date.utc_today()), date) >= 0
  end
end
