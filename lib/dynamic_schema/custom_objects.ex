defmodule DynamicSchema.CustomObjects do
  @moduledoc """
  The CustomObjects context.
  """

  import Ecto.Query, warn: false
  alias DynamicSchema.Repo

  alias DynamicSchema.CustomObjects.Object
  alias DynamicSchema.CustomObjects.Struct

  @doc """
  Returns the list of objects.

  ## Examples

      iex> list_objects()
      [%Object{}, ...]

  """
  def list_objects do
    Repo.all(Object)
  end

  def get_struct do
    Repo.all(Struct) |> Enum.at(0)
  end

  def add_field(table_name, name, type) do
    struct = Repo.one(from c in Struct, where: c.table_name == "custom_users")
    new_schema = Map.put_new(struct.schema, name, type)
    new_struct = Ecto.Changeset.change(struct, schema: new_schema)
    Repo.update(new_struct)
  end

  def update_struct(table_name, schema) do
    struct = Repo.one(from c in Struct, where: ^table_name == c.table_name)
    new_struct = Ecto.Changeset.change(struct, schema: schema)
    Repo.update(new_struct)
  end

  def generate_type_files do
    table_name = "custom_users"
    struct = Repo.one(from c in Struct, where: ^table_name == c.table_name)

    body =
      Phoenix.View.render_to_string(
        DynamicSchemaWeb.TypeView,
        "base",
        module_name: Macro.camelize(table_name),
        schema: struct.schema
      )

    path =
      :code.priv_dir(:dynamic_schema)
      |> Path.join("types")
      |> Path.join("#{table_name}.ex")

    File.write!(path, body)
  end

  @doc """
  Gets a single object.

  Raises `Ecto.NoResultsError` if the Object does not exist.

  ## Examples

      iex> get_object!(123)
      %Object{}

      iex> get_object!(456)
      ** (Ecto.NoResultsError)

  """
  def get_object!(id), do: Repo.get!(Object, id)

  @doc """
  Creates a object.

  ## Examples

      iex> create_object(%{field: value})
      {:ok, %Object{}}

      iex> create_object(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_object(attrs \\ %{}) do
    %Object{}
    |> Object.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a object.

  ## Examples

      iex> update_object(object, %{field: new_value})
      {:ok, %Object{}}

      iex> update_object(object, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_object(%Object{} = object, attrs) do
    object
    |> Object.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Object.

  ## Examples

      iex> delete_object(object)
      {:ok, %Object{}}

      iex> delete_object(object)
      {:error, %Ecto.Changeset{}}

  """
  def delete_object(%Object{} = object) do
    Repo.delete(object)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking object changes.

  ## Examples

      iex> change_object(object)
      %Ecto.Changeset{source: %Object{}}

  """
  def change_object(%Object{} = object) do
    Object.changeset(object, %{})
  end
end
