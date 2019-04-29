defmodule DinamicSchema.CustomObjectsTest do
  use DinamicSchema.DataCase

  alias DinamicSchema.CustomObjects

  describe "objects" do
    alias DinamicSchema.CustomObjects.Object

    @valid_attrs %{data: %{}, struct: %{}}
    @update_attrs %{data: %{}, struct: %{}}
    @invalid_attrs %{data: nil, struct: nil}

    def object_fixture(attrs \\ %{}) do
      {:ok, object} =
        attrs
        |> Enum.into(@valid_attrs)
        |> CustomObjects.create_object()

      object
    end

    test "list_objects/0 returns all objects" do
      object = object_fixture()
      assert CustomObjects.list_objects() == [object]
    end

    test "get_object!/1 returns the object with given id" do
      object = object_fixture()
      assert CustomObjects.get_object!(object.id) == object
    end

    test "create_object/1 with valid data creates a object" do
      assert {:ok, %Object{} = object} = CustomObjects.create_object(@valid_attrs)
      assert object.data == %{}
      assert object.struct == %{}
    end

    test "create_object/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = CustomObjects.create_object(@invalid_attrs)
    end

    test "update_object/2 with valid data updates the object" do
      object = object_fixture()
      assert {:ok, %Object{} = object} = CustomObjects.update_object(object, @update_attrs)
      assert object.data == %{}
      assert object.struct == %{}
    end

    test "update_object/2 with invalid data returns error changeset" do
      object = object_fixture()
      assert {:error, %Ecto.Changeset{}} = CustomObjects.update_object(object, @invalid_attrs)
      assert object == CustomObjects.get_object!(object.id)
    end

    test "delete_object/1 deletes the object" do
      object = object_fixture()
      assert {:ok, %Object{}} = CustomObjects.delete_object(object)
      assert_raise Ecto.NoResultsError, fn -> CustomObjects.get_object!(object.id) end
    end

    test "change_object/1 returns a object changeset" do
      object = object_fixture()
      assert %Ecto.Changeset{} = CustomObjects.change_object(object)
    end
  end
end
