defmodule DinamicSchema.CustomObjects.Struct do
  use Ecto.Schema
  import Ecto.Changeset

  schema "castom_object_structs" do
    field :schema, :map
    field :table_name, :string

    timestamps()
  end

  @doc false
  def changeset(struct, attrs) do
    struct
    |> cast(attrs, [:schema, :table_name])
    |> validate_required([:schema, :table_name])
  end
end
