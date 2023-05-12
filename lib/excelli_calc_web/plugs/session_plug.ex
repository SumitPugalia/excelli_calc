defmodule ExcelliCalcWeb.Plugs.SessionPlug do
  import Plug.Conn

  def init(opts) do
    opts
  end

  def call(conn, _opts) do
    user_id = conn |> get_req_header("authorization") |> List.first()
    if is_nil(user_id) do
      conn |> send_resp(401, Jason.encode!(%{message: "invalid token"})) |> halt()
    else
      conn |> assign(:user_id, user_id)
    end
  end
end
