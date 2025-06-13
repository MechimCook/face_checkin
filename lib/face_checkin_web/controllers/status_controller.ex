defmodule FaceCheckinWeb.StatusController do
  use FaceCheckinWeb, :controller

  def status(conn, _params) do
    profiles = FaceCheckin.Profiles.list_profiles()
    render(conn, :status, profiles: profiles)
  end
end
