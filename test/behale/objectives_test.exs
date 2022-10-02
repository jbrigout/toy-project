defmodule Behale.ObjectivesTest do
  use ExUnit.Case
  use PropCheck
  alias Behale.{Objectives, Members}

  property "Points are earned for completing an objective", [:verbose] do
    {:ok, member_id} = Members.create_member("name", nil)

    forall objective in oneof(Objectives.objectives()) do
      %{points: points} = Members.member_by_id(member_id)
      :ok = Objectives.complete_objective(member_id, objective)
      %{points: updated_points} = Members.member_by_id(member_id)
      equals(updated_points, points + Objectives.reward(objective))
    end
  end
end
