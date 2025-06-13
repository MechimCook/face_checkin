defmodule FaceCheckin.ProfileFace do
  use Ecto.Schema
  import Ecto.Changeset

  schema "profiles_faces" do
    field :face_pic, :binary
    belongs_to :profile, FaceCheckin.Profile
    belongs_to :face, FaceCheckin.Face
    timestamps()
  end

  def changeset(profile_face, attrs) do
    profile_face
    |> cast(attrs, [:profile_id, :face_pic, :face_id])
    |> validate_required([:profile_id, :face_pic, :face_id])
  end
end
