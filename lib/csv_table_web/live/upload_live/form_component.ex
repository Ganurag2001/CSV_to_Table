defmodule CsvTableWeb.UploadLive.FormComponent do
  use CsvTableWeb, :live_component

  alias CsvTable.CsvUpload

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage upload records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="upload-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:age]} type="text" label="Age" />
        <.input field={@form[:email]} type="text" label="Email" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Upload</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{upload: upload} = assigns, socket) do
    changeset = CsvUpload.change_upload(upload)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"upload" => upload_params}, socket) do
    changeset =
      socket.assigns.upload
      |> CsvUpload.change_upload(upload_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"upload" => upload_params}, socket) do
    save_upload(socket, socket.assigns.action, upload_params)
  end

  defp save_upload(socket, :edit, upload_params) do
    case CsvUpload.update_upload(socket.assigns.upload, upload_params) do
      {:ok, upload} ->
        notify_parent({:saved, upload})

        {:noreply,
         socket
         |> put_flash(:info, "Upload updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_upload(socket, :new, upload_params) do
    case CsvUpload.create_upload(upload_params) do
      {:ok, upload} ->
        notify_parent({:saved, upload})

        {:noreply,
         socket
         |> put_flash(:info, "Upload created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
