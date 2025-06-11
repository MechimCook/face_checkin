defmodule FaceCheckin.Faces.Face do
  use Ecto.Schema
  import Ecto.Changeset

  schema "faces" do
    field :name, :string
    field :face_encoding, :string
    field :checked_in, :boolean, default: false

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(face, attrs) do
    face
    |> cast(attrs, [:name, :face_encoding, :checked_in])
    |> validate_required([:name, :face_encoding, :checked_in])
  end
end
