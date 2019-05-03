defmodule DynamicSchemaWeb.Schema do
  @moduledoc """
  Main GraphQL schema module
  """

  use Absinthe.Schema

  alias DynamicSchemaWeb.CustomObjectsResolver

  # this is the query entry point to our app
  query do
    field :all_objects, list_of(:object) do
      resolve(&CustomObjectsResolver.all_objects/3)
    end
  end

  @desc "An error encountered trying to persist input"
  object :object do
    field(:data, :json)
  end

  # object :custom do
  #   field(:title, :string)
  #   field(:count, :integer)
  # end

  scalar :json do
    parse(fn input ->
      case Jason.decode(input.value) do
        {:ok, result} -> result
        _ -> :error
      end
    end)

    serialize(&Jason.encode!/1)
  end
end
