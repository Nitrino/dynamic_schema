defmodule DynamicSchema.Repo.Migrations.CreateCastomObjectStructs do
  use Ecto.Migration

  def change do
    create table(:castom_object_structs) do
      add :schema, :map
      add :table_name, :string

      timestamps()
    end
  end
end
