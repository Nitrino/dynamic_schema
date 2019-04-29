defmodule DinamicSchemaWeb.CustomObjectView do
  use Phoenix.LiveView

  alias DinamicSchema.CustomObjects

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

    <pre >
      <%= inspect(@schema) %>
    </pre>
    """
  end

  def mount(session, socket) do
    send(self(), {:get, nil})
    {:ok, assign(socket, schema: %{})}
  end

  def handle_event("get", _, socket) do
    get_schema(socket)
  end

  def handle_event("submit", %{"name" => name, "type" => type}, socket) do
    schema = socket.assigns.schema |> Map.merge(%{name => type})
    update_schema(schema, socket)
  end

  def handle_event("remove_field", data, socket) do
    schema = socket.assigns.schema |> Map.delete(data)
    update_schema(schema, socket)
  end

  def handle_info({:get, _filter}, socket) do
    get_schema(socket)
  end

  defp update_schema(schema, socket) do
    case CustomObjects.update_struct(socket.assigns.table_name, schema) do
      {:ok, struct} ->
        {:noreply, assign(socket, schema: struct.schema, table_name: struct.table_name)}

      {:error, changeset} ->
        raise "oops"
    end
  end

  defp get_schema(socket) do
    struct = CustomObjects.get_struct()
    {:noreply, assign(socket, schema: struct.schema, table_name: struct.table_name)}
  end

  defp convert_inputs_to_schema(fields) do
    fields
    |> Enum.map(fn {key, field} -> {field["name"], field["type"]} end)
    |> Map.new()
  end
end
