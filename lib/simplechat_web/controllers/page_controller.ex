defmodule SimplechatWeb.PageController do
  use SimplechatWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def chat(conn, _params) do
    render(conn, "chat.html")
  end
end
