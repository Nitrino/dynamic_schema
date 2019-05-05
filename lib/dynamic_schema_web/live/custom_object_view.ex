defmodule DynamicSchemaWeb.CustomObjectView do
  use Phoenix.LiveView

  alias DynamicSchema.CustomObjects

  def render(assigns) do
    ~L"""
    <form phx-submit="submit">
      <table>
        <thead>
          <tr>
            <th>Name</th>
            <th>Type</th>
          </tr>
        </thead>
        <tbody>
          <%= for {{name, type}, counter} <- Enum.with_index(@schema) do %>
            <tr>
              <td><%= name %></td>
              <td><%= type %></td>
              <td><button phx-click="remove_field" phx-value=<%= name %>>Remove</button></td>
            </tr>
          <% end %>
          <tr>
            <td>
              <input type="text" name="name" autofocus />
            </td>
            <td>
              <select name="type">
                <option value="string">String</option>
                <option value="integer">Integer</option>
              </select>
            </td>
            <td>
              <button type="submit">Add row</button>
            </td>
          </tr>
        </tbody>
      </table>
    </form>

    <h4>Database schema:</h4>
    <pre>
      <%= inspect(@schema) %>
    </pre>

    <h4>Absinthe types:</h4>
    <pre>
      <%= inspect(@queries) %>
    </pre>
    """
  end

  def mount(session, socket) do
    send(self(), {:get, nil})
    {:ok, assign(socket, schema: %{}, queries: get_queries())}
  end

  def handle_event("submit", %{"name" => name, "type" => type}, socket) do
    schema = socket.assigns.schema |> Map.merge(%{name => type})
    update_schema(schema, socket)
  end

  def handle_event("remove_field", name, socket) do
    schema = socket.assigns.schema |> Map.delete(name)
    update_schema(schema, socket)
  end

  def handle_info({:get, _filter}, socket) do
    struct = CustomObjects.get_struct()

    {:noreply,
     assign(socket, schema: struct.schema, table_name: struct.table_name, queries: get_queries())}
  end

  defp update_schema(schema, socket) do
    case CustomObjects.update_struct(socket.assigns.table_name, schema) do
      {:ok, struct} ->
        {:noreply,
         assign(socket,
           schema: struct.schema,
           table_name: struct.table_name,
           queries: get_queries()
         )}

      {:error, changeset} ->
        raise "oops"
    end
  end

  def get_queries do
    custom_users_object =
      DynamicSchemaWeb.Schema
      |> Absinthe.Schema.used_types()
      |> Enum.filter(fn object -> object.identifier == :custom_users end)

    case custom_users_object do
      [] -> []
      object -> get_types_from_absinthe_object(object)
    end
  end

  defp get_types_from_absinthe_object(object) do
    object
    |> Enum.at(0)
    |> Map.get(:fields)
    |> Enum.filter(fn {key, val} -> key |> Atom.to_string() |> String.at(0) != "_" end)
    |> Enum.map(fn {key, val} -> {key, val.type} end)
    |> Map.new()
  end
end
