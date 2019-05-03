defmodule DynamicSchemaWeb.PageController do
  use DynamicSchemaWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
