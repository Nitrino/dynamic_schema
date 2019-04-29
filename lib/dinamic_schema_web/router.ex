defmodule DinamicSchemaWeb.Router do
  use DinamicSchemaWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Phoenix.LiveView.Flash
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", DinamicSchemaWeb do
    pipe_through :browser

    get "/", PageController, :index

    resources "/objects", ObjectController
  end

  # Other scopes may use custom stacks.
  scope "/" do
    pipe_through :api

    forward("/api", Absinthe.Plug,
      schema: DinamicSchemaWeb.Schema,
      json_codec: Jason
    )

    forward("/graphiql", Absinthe.Plug.GraphiQL,
      schema: DinamicSchemaWeb.Schema,
      json_codec: Jason,
      context: %{pubsub: DinamicSchemaWeb.Endpoint}
    )
  end
end
