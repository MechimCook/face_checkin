defmodule FaceCheckin.Profile do
  use Ecto.Schema
  import Ecto.Changeset

  schema "profiles" do
    field :name, :string
    field :profile_pic, :binary
    field :status, :string, default: "out"
    has_many :profiles_faces, FaceCheckin.ProfileFace
    timestamps()
  end

  def changeset(profile, attrs) do
    profile
    |> cast(attrs, [:name, :profile_pic, :status])
    |> validate_required([:name])
  end
end
