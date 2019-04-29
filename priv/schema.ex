defmodule DinamicSchemaWeb.Schema do
  @moduledoc """
  Main GraphQL schema module
  """

  use Absinthe.Schema

  alias DinamicSchemaWeb.CustomObjectsResolver

  import_types(__MODULE__.CustomTypes)

  # this is the query entry point to our app
  query do
    field :all_objects, list_of(:object) do
      resolve(&CustomObjectsResolver.all_objects/3)
    end
  end

  @desc "An error encountered trying to persist input"
  object :object do
    field(:data, :custom)
  end
end
