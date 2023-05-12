defmodule ExcelliCalc.Migration do

  alias ExcelliCalc.{History, Users}

  def run() do
    statement = "CREATE KEYSPACE excelli WITH REPLICATION = { 'class' : 'NetworkTopologyStrategy', 'replication_factor' : 3 } AND DURABLE_WRITES = true;"
    case Xandra.execute(Process.whereis(:xandra_connection), statement, _params = []) do
      {:ok, %Xandra.SchemaChange{effect: "CREATED"}} -> IO.puts("created keyspace")
      {:error, %Xandra.Error{reason: :already_exists}} -> IO.puts("keyspace already exists")
      error -> IO.puts(error)
    end

    statement = "use excelli;"
    {:ok, %Xandra.SetKeyspace{}} = Xandra.execute(Process.whereis(:xandra_connection), statement, _params = [])
    IO.puts("set excelli as keyspace")

    Users.create_table()
    Users.create_index()
    Users.seed()

    History.create_table()
  end
end
