defmodule DynamicSchema.CustomObjects do
  @moduledoc """
  The CustomObjects context.
  """

  import Ecto.Query, warn: false
  alias DynamicSchema.Repo

  alias DynamicSchema.CustomObjects.Struct

  def get_struct do
    Repo.all(Struct) |> Enum.at(0)
  end

  def update_struct(table_name, schema) do
    struct = Repo.one(from c in Struct, where: ^table_name == c.table_name)
    new_struct = Ecto.Changeset.change(struct, schema: schema)
    result = Repo.update(new_struct)

    generate_type_files(table_name)
    generate_schema()
    reload_schema()

    result
  end

  def generate_type_files(table_name \\ "custom_users") do
    struct = Repo.one(from c in Struct, where: ^table_name == c.table_name)

    body =
      Phoenix.View.render_to_string(
        DynamicSchemaWeb.TypeView,
        "base",
        module_name: Macro.camelize(table_name),
        schema: struct.schema,
        object_name: table_name
      )

    path =
      types_path
      |> Path.join("#{table_name}.ex")

    File.write!(path, body)
  end

  def generate_schema do
    types =
      Repo.all(from c in Struct, select: c.table_name)
      |> Enum.map(fn type -> {type, Macro.camelize(type)} end)
      |> Map.new()

    body =
      Phoenix.View.render_to_string(
        DynamicSchemaWeb.TypeView,
        "schema",
        types: types
      )

    File.write!(schema_path, body)
  end

  def reload_schema do
    Path.wildcard(types_path <> "/*.ex")
    |> Enum.map(&Code.eval_file/1)

    Code.eval_file(schema_path)
  end

  defp graph_ql_path do
    :code.priv_dir(:dynamic_schema) |> Path.join("graph_ql")
  end

  defp schema_path do
    graph_ql_path |> Path.join("schema.ex")
  end

  defp types_path do
    graph_ql_path |> Path.join("types")
  end
end
