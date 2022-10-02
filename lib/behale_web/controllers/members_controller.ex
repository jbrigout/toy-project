defmodule BehaleWeb.MembersController do
  use BehaleWeb, :controller
  alias Behale.Members

  def create(conn, %{"name" => name, "goal" => goal}) do
    {:ok, member_id} = Members.create_member(name, goal)
    render_json(conn, %{member_id: member_id})
  end

  def update_goal(conn, %{"memberId" => member_id, "goal" => goal}) do
    :ok = Members.update_member(member_id, %{goal: goal})
    render_json(conn, :ok)
  end

  def points(conn, %{"id" => member_id}) do
    %{points: points} = Members.member_by_id(member_id)
    render_json(conn, points)
  end

  defp render_json(conn, data) do
    conn
    |> Plug.Conn.put_resp_header("content-type", "application/json; charset=utf-8")
    |> Plug.Conn.send_resp(200, Poison.encode!(data, pretty: true))
  end
end
