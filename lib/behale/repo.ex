defmodule Behale.Repo do
  alias Behale.DatabaseServer

  def insert_member(member) when is_map(member),
    do: DatabaseServer.insert(Ecto.UUID.generate(), member)

  def update_member(member_id, updates) when is_binary(member_id) and is_map(updates) do
    {:ok, _} = DatabaseServer.insert(member_id, updates)
    :ok
  end

  def get_member(member_id) when is_binary(member_id) do
    [{_, member}] = DatabaseServer.lookup(member_id)
    member
  end

  def insert_session(member_id, session) do
    %{sessions: sessions} = get_member(member_id)
    update_member(member_id, %{sessions: [session | sessions]})
    :ok
  end

  def update_session(member_id, session_id, updates) do
    %{sessions: sessions} = get_member(member_id)

    sessions =
      Enum.map(sessions, fn
        %{id: ^session_id} = session -> Map.merge(session, updates)
        session -> session
      end)

    update_member(member_id, %{sessions: sessions})
  end
end
