defmodule DynamicSchema.Repo.Migrations.CreateObjects do
  use Ecto.Migration

  def change do
    create table(:objects) do
      add :struct, :map
      add :data, :map

      timestamps()
    end
  end
end
