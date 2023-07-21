defmodule CsvTableWeb.UserLive.Index do
  use CsvTableWeb, :live_view

  alias CsvTable.Accounts
  alias CsvTable.Accounts.User

  import CsvTable.Repo

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :donwload_completed, false)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit User")
    |> assign(:user, Accounts.get_user!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New User")
    |> assign(:user, %User{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Users")
    |> assign(:user, nil)
  end

  @impl true
  def handle_info({CsvTableWeb.UserLive.FormComponent, {:saved, user}}, socket) do
    {:noreply, stream_insert(socket, :users, user)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    user = Accounts.get_user!(id)
    {:ok, _} = Accounts.delete_user(user)

    {:noreply, stream_delete(socket, :users, user)}
  end


  @impl true
  def render(assigns) do
  ~H"""
  <%= if @donwload_completed do %>
   <div class="notification">Download is completed </div>
  <% end %>
  <button 
  phx-click="don">
  Download All</button>
  """
  end

  @impl true
  def handle_event("don", params, socket) do

   data = CsvTable.Repo.all(CsvTable.Accounts.User)

   dataset = Enum.join(for user <- data do "#{user.name}, #{user.age}, #{user.email}" end, "\n")

   csv_content = "name,age,email\n #{dataset}"

   params |> IO.inspect(label: "This is params")

   File.write!("output.csv", csv_content)

    {:noreply, assign(socket, :donwload_completed, true)}
  end

end
