defmodule ExcelliCalcWeb.LoginController do
  use ExcelliCalcWeb, :controller

  action_fallback ExcelliCalcWeb.FallbackController

  def login(conn, %{"username" => username, "password" => password}) do
    case ExcelliCalc.Users.fetch_user(username, password) do
      nil ->  {:error, :not_found}
      user -> conn |> put_status(:ok) |> render(:user, user)
    end
  end

  def login(_conn, _), do: {:error, :bad_request}
end
