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
          <%= for {{field, type}, counter} <- Enum.with_index(@schema) do %>
            <tr>
              <td><input type="text" name="struct[<%= counter %>][name]" value="<%= field %>" readonly /></td>
              <td><input type="text" name="struct[<%= counter %>][type]" value="<%= type %>" readonly /></td>
            </tr>
          <% end %>
          <tr>
              <td>
                <input type="text" name="struct[<%= Enum.count(@schema) + 1 %>][name]" autofocus />
              </td>
              <td>
                <select name="struct[<%= Enum.count(@schema) + 1 %>][type]">
                  <option value="string">String</option>
                  <option value="integer">Integer</option>
                </select>
              </td>
          </tr>

        </tbody>
      </table>
      <button type="submit">Add row</button>
    </form>

    <pre>
      <%= inspect(@schema) %>
    </pre>
    """
  end

  def mount(session, socket) do
    send(self(), {:get, "all"})
    {:ok, assign(socket, schema: %{})}
  end

  def handle_event("get", _, socket) do
    update_schema(socket)
  end

  def handle_event("submit", %{"struct" => fields}, socket) do
    schema = convert_inputs_to_schema(fields)

    case CustomObjects.update_struct(socket.assigns.table_name, schema) do
      {:ok, struct} ->
        {:noreply, assign(socket, schema: struct.schema, table_name: struct.table_name)}

      {:error, changeset} ->
        raise "oops"
    end
  end

  def handle_info({:get, _filter}, socket) do
    update_schema(socket)
  end

  defp update_schema(socket) do
    struct = CustomObjects.get_struct()
    {:noreply, assign(socket, schema: struct.schema, table_name: struct.table_name)}
  end

  defp convert_inputs_to_schema(fields) do
    fields
    |> Enum.map(fn {key, field} -> {field["name"], field["type"]} end)
    |> Map.new()
  end
end
