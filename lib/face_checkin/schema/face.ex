defmodule FaceCheckin.Face do
  use Ecto.Schema
  import Ecto.Changeset

  schema "faces" do
    field :encoded_face, :string
    belongs_to :profile, FaceCheckin.Profile
    has_many :profiles_faces, FaceCheckin.ProfileFace
    timestamps()
  end

  def changeset(face, attrs) do
    face
    |> cast(attrs, [:encoded_face, :profile_id])
    |> validate_required([:encoded_face, :profile_id])
  end
end
