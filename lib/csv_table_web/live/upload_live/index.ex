defmodule CsvTableWeb.UploadLive.Index do
  use CsvTableWeb, :live_view

  alias CsvTable.Importer
  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:parsed_rows, [])
     |> assign(:imported_customers, [])
     |> assign(:sample_customers, [])
     |> assign(:uploaded_files, [])
     |> allow_upload(:sample_csv, accept: ~w(.csv), max_entries: 1)}
  end

  @impl true
  def handle_event("reset", params, socket) do
    params |> IO.inspect(label: "this is new stuff.")

    {:noreply,
     socket
     |> assign(:parsed_rows, [])
     |> assign(:imported_customers, [])
     |> assign(:sample_customers, [])
     |> assign(:uploaded_files, [])}
  end

  def handle_event("validate", params, socket) do
    params |> IO.inspect(label: "validate params ")
    {:noreply, socket}
  end

  def handle_event("parse", _, socket) do
    parsed_rows =
      parse_csv(socket)
      |> IO.inspect(label: "parsed csv------")

    {
      :noreply,
      socket
      |> assign(:parsed_rows, parsed_rows)
      |> assign(:sample_customers, Importer.preview(parsed_rows))
      |> assign(:uploaded_files, [])
    }
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
    |> IO.inspect(label: "parse_csv - consume uploaded netries ")
  end
end
