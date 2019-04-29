defmodule DinamicSchemaWeb.PageController do
  use DinamicSchemaWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
