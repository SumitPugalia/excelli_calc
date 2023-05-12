defmodule ExcelliCalc.Calculator do
  def perform(lvalue, rvalue, "+"), do: {:ok, Decimal.add(lvalue, rvalue)}
  def perform(lvalue, rvalue, "-"), do: {:ok, Decimal.sub(lvalue, rvalue)}
  def perform(lvalue, rvalue, "*"), do: {:ok, Decimal.mult(lvalue, rvalue)}
  def perform(lvalue, rvalue, "/"), do: {:ok, Decimal.div(lvalue, rvalue)}
  def perform(_lvalue, _rvalue, operator), do: {:error, "unsupported #{operator}"}
end
