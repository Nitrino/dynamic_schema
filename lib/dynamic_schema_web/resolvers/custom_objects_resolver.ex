defmodule DynamicSchemaWeb.CustomObjectsResolver do
  @moduledoc """
  Resolver for Owner queries
  """
  alias DynamicSchema.CustomObjects

  def all_objects(_root, _args, _info) do
    # objects = CustomObjects.list_objects()
    {:ok,
     [
       %{data: %{first_name: "Petr", last_name: "Stepchenko", age: 27, phone: "+79208457152"}},
       %{data: %{first_name: "Albert", last_name: "Inshtein", age: 27, phone: "+79208400000"}}
     ]}
  end
end
