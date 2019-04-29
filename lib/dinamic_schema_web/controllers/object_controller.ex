defmodule DinamicSchemaWeb.ObjectController do
  use DinamicSchemaWeb, :controller

  alias DinamicSchema.CustomObjects
  alias DinamicSchema.CustomObjects.Object

  import Phoenix.LiveView.Controller

  def index(conn, _params) do
    # objects = CustomObjects.list_objects()
    live_render(conn, DinamicSchemaWeb.CustomObjectView, session: %{})
    # render(conn, "index.html", objects: objects)
  end

  def new(conn, _params) do
    changeset = CustomObjects.change_object(%Object{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"object" => object_params}) do
    case CustomObjects.create_object(object_params) do
      {:ok, object} ->
        conn
        |> put_flash(:info, "Object created successfully.")
        |> redirect(to: Routes.object_path(conn, :show, object))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    object = CustomObjects.get_object!(id)
    render(conn, "show.html", object: object)
  end

  def edit(conn, %{"id" => id}) do
    object = CustomObjects.get_object!(id)
    changeset = CustomObjects.change_object(object)
    render(conn, "edit.html", object: object, changeset: changeset)
  end

  def update(conn, %{"id" => id, "object" => object_params}) do
    object = CustomObjects.get_object!(id)

    case CustomObjects.update_object(object, object_params) do
      {:ok, object} ->
        conn
        |> put_flash(:info, "Object updated successfully.")
        |> redirect(to: Routes.object_path(conn, :show, object))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", object: object, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    object = CustomObjects.get_object!(id)
    {:ok, _object} = CustomObjects.delete_object(object)

    conn
    |> put_flash(:info, "Object deleted successfully.")
    |> redirect(to: Routes.object_path(conn, :index))
  end
end
