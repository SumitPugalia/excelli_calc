defmodule ExcelliCalc.Users do

  def create_table() do
    statement = "CREATE TABLE users (id text, user_name text, password text, PRIMARY KEY(id));"
    case Xandra.execute(Process.whereis(:xandra_connection), statement, _params = []) do
      {:ok, %Xandra.SchemaChange{effect: "CREATED"}} -> IO.puts("created users table")
      {:error, %Xandra.Error{reason: :already_exists}} -> IO.puts("users table already exists")
      error -> raise error
    end
  end

  def create_index() do
    statement = "CREATE INDEX ON users (user_name);"
    case Xandra.execute(Process.whereis(:xandra_connection), statement, _params = []) do
      {:ok, %Xandra.SchemaChange{effect: "UPDATED"}} -> IO.puts("created index on users table")
      {:error, %Xandra.Error{reason: :invalid}} -> IO.puts("index on users table already exists")
      error -> raise error
    end

    statement = "CREATE INDEX ON users (password);"
    case Xandra.execute(Process.whereis(:xandra_connection), statement, _params = []) do
      {:ok, %Xandra.SchemaChange{effect: "UPDATED"}} -> IO.puts("created index on users table")
      {:error, %Xandra.Error{reason: :invalid}} -> IO.puts("index on users table already exists")
      error -> raise error
    end
  end

  def seed() do
    statement = "insert into users (id, user_name, password) VALUES ('ebc15f51-1620-495e-9b9c-4f6a61b9af1b', 'sumit', 'sumit');"
    {:ok, %Xandra.Void{}} = Xandra.execute(Process.whereis(:xandra_connection), statement, _params = [])

    statement = "insert into users (id, user_name, password) VALUES ('abc15f51-1620-495e-9b9c-4f6a61b9af1b', 'aman', 'aman');"
    {:ok, %Xandra.Void{}} = Xandra.execute(Process.whereis(:xandra_connection), statement, _params = [])
  end

  def fetch_user(user_id) do
    with {:ok, prepared} <- Xandra.prepare(Process.whereis(:xandra_connection), "SELECT * FROM users WHERE user_id = ? ALLOW FILTERING;"),
     {:ok, %Xandra.Page{} = page} <- Xandra.execute(Process.whereis(:xandra_connection), prepared, [_user_id = user_id]),
     do: Enum.to_list(page) |> List.first()
  end

  def fetch_user(user_name, password) do
    with {:ok, prepared} <- Xandra.prepare(Process.whereis(:xandra_connection), "SELECT * FROM users WHERE user_name = ? and password = ? ALLOW FILTERING;"),
     {:ok, %Xandra.Page{} = page} <- Xandra.execute(Process.whereis(:xandra_connection), prepared, [_user_name = user_name, _password = password]),
     do: Enum.to_list(page) |> List.first()
  end
end
