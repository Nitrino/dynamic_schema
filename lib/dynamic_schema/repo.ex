defmodule DynamicSchema.Repo do
  use Ecto.Repo,
    otp_app: :dynamic_schema,
    adapter: Ecto.Adapters.Postgres
end
