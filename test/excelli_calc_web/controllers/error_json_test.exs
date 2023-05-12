defmodule ExcelliCalcWeb.ErrorJSONTest do
  use ExcelliCalcWeb.ConnCase, async: true

  test "renders 404" do
    assert ExcelliCalcWeb.ErrorJSON.render("404.json", %{}) == %{errors: %{detail: "Not Found"}}
  end

  test "renders 500" do
    assert ExcelliCalcWeb.ErrorJSON.render("500.json", %{}) ==
             %{errors: %{detail: "Internal Server Error"}}
  end
end
