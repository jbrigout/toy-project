defmodule BehaleWeb.SessionsController do
  use BehaleWeb, :controller
  alias Behale.{Members, Sessions}

  def create(conn, %{"memberId" => member_id, "id" => session_id, "day" => date}) do
    with {:ok, date} <- Date.from_iso8601(date) do
      :ok = Sessions.plan_session(member_id, session_id, date)
      render_json(conn, :ok)
    else
      _ ->
        render_json(conn, %{
          status: :error,
          reason: "Expected day parameter to be passed as a string yyyy-mm-dd"
        })
    end
  end

  def complete(conn, %{"memberId" => member_id, "id" => session_id}) do
    :ok = Sessions.complete_session(member_id, session_id)
    render_json(conn, :ok)
  end

  defp render_json(conn, data) do
    conn
    |> Plug.Conn.put_resp_header("content-type", "application/json; charset=utf-8")
    |> Plug.Conn.send_resp(200, Poison.encode!(data, pretty: true))
  end
end
