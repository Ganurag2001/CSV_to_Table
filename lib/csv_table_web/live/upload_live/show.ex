defmodule CsvTableWeb.UploadLive.Show do
  use CsvTableWeb, :live_view

  alias CsvTable.CsvUpload

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:upload, CsvUpload.get_upload!(id))}
  end

  defp page_title(:show), do: "Show Upload"
  defp page_title(:edit), do: "Edit Upload"
end
