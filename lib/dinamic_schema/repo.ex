defmodule DinamicSchema.Repo do
  use Ecto.Repo,
    otp_app: :dinamic_schema,
    adapter: Ecto.Adapters.Postgres
end
