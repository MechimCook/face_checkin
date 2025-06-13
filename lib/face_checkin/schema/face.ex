defmodule FaceCheckin.Face do
  use Ecto.Schema
  import Ecto.Changeset

  schema "faces" do
    field :encoded_face, :string
    has_many :profiles_faces, FaceCheckin.ProfileFace
    timestamps()
  end

  def changeset(face, attrs) do
    face
    |> cast(attrs, [:encoded_face])
    |> validate_required([:encoded_face])
  end
end
