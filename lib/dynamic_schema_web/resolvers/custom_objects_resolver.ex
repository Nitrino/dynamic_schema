defmodule DynamicSchemaWeb.CustomObjectsResolver do
  @moduledoc """
  Resolver for Owner queries
  """
  alias DynamicSchema.CustomObjects

  def all_objects(_root, _args, _info) do
    # objects = CustomObjects.list_objects()
    {:ok, [%{data: %{count: 2, title: "new title"}}]}
  end
end
