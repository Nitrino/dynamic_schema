defmodule DynamicSchemaWeb.Schema.CustomType do
  use Absinthe.Schema.Notation

  object :custom do
    field(:title, :string)
    field(:count, :integer)
  end
end
