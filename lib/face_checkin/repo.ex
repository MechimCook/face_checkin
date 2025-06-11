defmodule FaceCheckin.Repo do
  use Ecto.Repo,
    otp_app: :face_checkin,
    adapter: Ecto.Adapters.Postgres
end
