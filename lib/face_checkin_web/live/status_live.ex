defmodule FaceCheckinWeb.StatusLive do
  use Phoenix.LiveView
  alias FaceCheckin.Profiles

  def mount(_params, _session, socket) do
    {:ok, assign(socket, profiles: Profiles.list_profiles())}
  end

  def handle_event("toggle_checked_in", %{"id" => id}, socket) do
    profile = Profiles.get_profile!(id)
    {:ok, _} = Profiles.update_profile(profile, %{checked_in: !profile.checked_in})
    {:noreply, assign(socket, profiles: Profiles.list_profiles())}
  end
end
