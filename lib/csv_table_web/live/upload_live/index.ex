defmodule CsvTableWeb.UploadLive.Index do
  use CsvTableWeb, :live_view

  alias CsvTable.Importer
  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      Todos.subscribe(socket.assigns.scope)
    end

    lists = Todos.active_lists(socket.assigns.scope, 20)

    {:ok,
     socket
     |> assign(:parsed_rows, [])
     |> assign(:imported_customers, [])
     |> assign(:sample_customers, [])
     |> assign(:uploaded_files, [])
     |> assign(page: 1, per_page: 20)
     |> paginate_logs(1)
     |> allow_upload(:sample_csv, accept: ~w(.csv), max_entries: 1)}
  end

  @impl true
  def handle_event("reset", _params, socket) do
    {:noreply,
     socket
     |> assign(:parsed_rows, [])
     |> assign(:imported_customers, [])
     |> assign(:sample_customers, [])
     |> assign(:uploaded_files, [])}
  end

  def handle_event("validate", _params, socket) do
    {:noreply, socket}
  end

  def handle_event("parse", _, socket) do
    parsed_rows = parse_csv(socket)

    {
      :noreply,
      socket
      |> assign(:parsed_rows, parsed_rows)
      |> assign(:sample_customers, Importer.preview(parsed_rows))
      |> assign(:uploaded_files, [])
    }
  end

  def handle_event("top", _, socket) do
    {:noreply, socket |> put_flash(:info, "You reached the top") |> paginate_logs(1)}
  end

  def handle_event("next-page", _, socket) do
    {:noreply, paginate_logs(socket, socket.assigns.page + 1)}
  end

  def handle_event("prev-page", %{"_overran" => true}, socket) do
    {:noreply, paginate_logs(socket, 1)}
  end

  def handle_event("prev-page", _, socket) do
    if socket.assigns.page > 1 do
      {:noreply, paginate_logs(socket, socket.assigns.page - 1)}
    else
      {:noreply, socket}
    end
  end

  defp paginate_logs(socket, new_page) when new_page >= 1 do
    socket.assigns |> IO.inspect(label: "This is socket assigns")
    %{per_page: per_page, page: cur_page, scope: scope} = socket.assigns
    logs = ActivityLog.list_user_logs(scope, offset: (new_page - 1) * per_page, limit: per_page)

    {logs, at, limit} =
      if new_page >= cur_page do
        {logs, -1, per_page * 3 * -1}
      else
        {Enum.reverse(logs), 0, per_page * 3}
      end

    case logs do
      [] ->
        socket
        |> assign(end_of_timeline?: at == -1)
        |> stream(:activity_logs, [])

      [_ | _] = logs ->
        socket
        |> assign(end_of_timeline?: false)
        |> assign(page: if(logs == [], do: cur_page, else: new_page))
        |> stream(:activity_logs, logs, at: at, limit: limit)
    end
  end

  defp parse_csv(socket) do
    consume_uploaded_entries(socket, :sample_csv, fn %{path: path}, _entry ->
      rows =
        path
        |> File.stream!()
        |> CSV.decode!(headers: true)
        |> Enum.to_list()

      {:ok, rows}
    end)
    |> List.flatten()
  end
end
