defmodule DynamicSchemaWeb.ObjectControllerTest do
  use DynamicSchemaWeb.ConnCase

  alias DynamicSchema.CustomObjects

  @create_attrs %{data: %{}, struct: %{}}
  @update_attrs %{data: %{}, struct: %{}}
  @invalid_attrs %{data: nil, struct: nil}

  def fixture(:object) do
    {:ok, object} = CustomObjects.create_object(@create_attrs)
    object
  end

  describe "index" do
    test "lists all objects", %{conn: conn} do
      conn = get(conn, Routes.object_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Objects"
    end
  end

  describe "new object" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.object_path(conn, :new))
      assert html_response(conn, 200) =~ "New Object"
    end
  end

  describe "create object" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.object_path(conn, :create), object: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.object_path(conn, :show, id)

      conn = get(conn, Routes.object_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Object"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.object_path(conn, :create), object: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Object"
    end
  end

  describe "edit object" do
    setup [:create_object]

    test "renders form for editing chosen object", %{conn: conn, object: object} do
      conn = get(conn, Routes.object_path(conn, :edit, object))
      assert html_response(conn, 200) =~ "Edit Object"
    end
  end

  describe "update object" do
    setup [:create_object]

    test "redirects when data is valid", %{conn: conn, object: object} do
      conn = put(conn, Routes.object_path(conn, :update, object), object: @update_attrs)
      assert redirected_to(conn) == Routes.object_path(conn, :show, object)

      conn = get(conn, Routes.object_path(conn, :show, object))
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, object: object} do
      conn = put(conn, Routes.object_path(conn, :update, object), object: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Object"
    end
  end

  describe "delete object" do
    setup [:create_object]

    test "deletes chosen object", %{conn: conn, object: object} do
      conn = delete(conn, Routes.object_path(conn, :delete, object))
      assert redirected_to(conn) == Routes.object_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.object_path(conn, :show, object))
      end
    end
  end

  defp create_object(_) do
    object = fixture(:object)
    {:ok, object: object}
  end
end
