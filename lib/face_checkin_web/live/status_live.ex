defmodule FaceCheckinWeb.StatusLive do
  use Phoenix.LiveView
  alias FaceCheckin.Profiles

  def mount(_params, _session, socket) do
    profiles = Profiles.list_profiles()
    socket =
      socket
      |> allow_upload(:avatar, accept: ~w(.jpg .jpeg .png), max_entries: 1)
      |> assign(:profiles, profiles)
      |> assign(:show_modal, false)
      |> assign(:modal_profile_id, nil)
    {:ok, socket}
  end

  def handle_event("toggle_checked_in", %{"id" => id}, socket) do
    profile = Profiles.get_profile!(id)
    {:ok, _} = Profiles.update_profile(profile, %{checked_in: !profile.checked_in})
    {:noreply, assign(socket, profiles: Profiles.list_profiles())}
  end

  def handle_event("open_modal", %{"id" => id}, socket) do
    {:noreply, assign(socket, show_modal: true, modal_profile_id: id)}
  end

  def handle_event("close_modal", _params, socket) do
    {:noreply, assign(socket, show_modal: false, modal_profile_id: nil)}
  end

  def handle_event("save_pic", %{"id" => id}, socket) do
    consume_uploaded_entries(socket, :avatar, fn %{path: path}, _entry ->
      {:ok, image_binary} = File.read(path)
      profile = Profiles.get_profile!(id)
      Profiles.update_profile(profile, %{profile_pic: image_binary})
      :ok
    end)

    socket =
      socket
      |> assign(:profiles, Profiles.list_profiles())
      |> assign(:show_modal, false)
      |> assign(:modal_profile_id, nil)

    {:noreply, socket}
  end

  def handle_event("validate", _params, socket) do
    {:noreply, socket}
  end
end
