defmodule DinamicSchema.CustomObjects.Object do
  use Ecto.Schema
  import Ecto.Changeset

  schema "objects" do
    field :data, :map
    field :struct, :map

    timestamps()
  end

  @doc false
  def changeset(object, attrs) do
    object
    |> cast(attrs, [:struct, :data])
    |> validate_required([:struct, :data])
  end
end
