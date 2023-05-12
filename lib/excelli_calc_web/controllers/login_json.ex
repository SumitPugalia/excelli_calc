defmodule ExcelliCalcWeb.LoginJSON do

  def user(user) do
    %{data: data(user)}
  end

  defp data(%{"id" => user_id}) do
    %{
      user_id: user_id
    }
  end
end
