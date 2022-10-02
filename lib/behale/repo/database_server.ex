defmodule Behale.DatabaseServer do
  use GenServer

  @name __MODULE__

  def start_link(_), do: GenServer.start_link(__MODULE__, [], name: @name)

  def insert(member_id, updates) do
    GenServer.call(@name, {:insert, member_id, updates})
  end

  def lookup(member_id) do
    GenServer.call(@name, {:lookup, member_id})
  end

  def init(_) do
    :ets.new(@name, [:set, :protected, :named_table])

    {:ok, []}
  end

  def handle_call({:insert, member_id, updates}, _from, state) do
    updated_member =
      case :ets.lookup(@name, member_id) do
        [] -> updates
        [{_id, member}] -> Map.merge(member, updates)
      end

    :ets.insert(@name, {member_id, updated_member})
    {:reply, {:ok, member_id}, state}
  end

  def handle_call({:lookup, member_id}, _from, state) do
    member = :ets.lookup(@name, member_id)

    {:reply, member, state}
  end
end
