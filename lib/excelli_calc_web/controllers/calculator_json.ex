defmodule ExcelliCalcWeb.CalculatorJSON do

  def calculate(%{"result" => result}) do
    %{data: %{result: result}}
  end

  def history(%{"history" => history}) do
    %{data: Enum.map(history, fn h -> h end)}
  end
end
