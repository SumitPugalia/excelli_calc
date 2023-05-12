defmodule ExcelliCalc.History do

  def create_table() do
    statement = "CREATE TABLE history (user_id text, lvalue text, rvalue text, operator text, result text, created_at int, PRIMARY KEY (user_id, created_at));"
    case Xandra.execute(Process.whereis(:xandra_connection), statement, _params = []) do
      {:ok, %Xandra.SchemaChange{effect: "CREATED"}} -> IO.puts("created history table")
      {:error, %Xandra.Error{reason: :already_exists}} -> IO.puts("history table already exists")
      error -> raise error
    end
  end

  def fetch_history(user_id) do
    with {:ok, prepared} <- Xandra.prepare(Process.whereis(:xandra_connection), "SELECT * FROM history WHERE user_id = ?"),
     {:ok, %Xandra.Page{} = page} <- Xandra.execute(Process.whereis(:xandra_connection), prepared, [_user_id = user_id]),
     do: page |> Enum.to_list() |> Enum.map(fn h -> Map.delete(h, "user_id") end) |> Enum.sort_by(&(&1["created_at"]), :desc)
  end

  def store(user_id, lvalue, rvalue, operator, result) do
    statement = "insert into history (user_id, lvalue, rvalue, operator, result, created_at) VALUES ('#{user_id}', '#{lvalue}', '#{rvalue}', '#{operator}', '#{result}', #{System.os_time(:second)});"
    {:ok, %Xandra.Void{}} = Xandra.execute(Process.whereis(:xandra_connection), statement, _params = [])
    :ok
  end
end
