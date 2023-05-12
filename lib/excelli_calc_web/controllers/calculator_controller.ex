defmodule ExcelliCalcWeb.CalculatorController do
  use ExcelliCalcWeb, :controller

  action_fallback ExcelliCalcWeb.FallbackController

  def calculate(conn, %{"lvalue" => lvalue, "rvalue" => rvalue, "operator" => operator}) do
    user_id = conn.assigns.user_id
    with user when not is_nil(user) <- ExcelliCalc.Users.fetch_user(user_id),
      {:ok, result} <- ExcelliCalc.Calculator.perform(lvalue, rvalue, operator) |> IO.inspect(),
      :ok <- ExcelliCalc.History.store(user_id, lvalue, rvalue, operator, result |> Decimal.to_string()) do
        conn |> put_status(:ok) |> render(:calculate, %{"result" => result |> Decimal.to_string()})
    end
  end

  def calculate(_conn, _), do: {:error, :bad_request}

  def history(conn, _params) do
    user_id = conn.assigns.user_id
    with user when not is_nil(user) <- ExcelliCalc.Users.fetch_user(user_id),
      result <- ExcelliCalc.History.fetch_history(user_id) do
        conn |> put_status(:ok) |> render(:history, %{"history" => result})
    end
  end
end
