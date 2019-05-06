defmodule DynamicSchemaWeb.ObjectController do
  use DynamicSchemaWeb, :controller

  alias DynamicSchema.CustomObjects
  alias DynamicSchema.CustomObjects.Object

  import Phoenix.LiveView.Controller

  def index(conn, _params) do
    DynamicSchema.CustomObjects.reload_schema()

    # objects = CustomObjects.list_objects()
    live_render(conn, DynamicSchemaWeb.CustomObjectView, session: %{})
    # render(conn, "index.html", objects: objects)
  end
end
