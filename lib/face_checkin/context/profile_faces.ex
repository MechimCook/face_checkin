defmodule FaceCheckin.ProfileFaces do
  @moduledoc "The ProfileFaces context."

  import Ecto.Query, warn: false
  alias FaceCheckin.Repo
  alias FaceCheckin.ProfileFace

  def list_profile_faces, do: Repo.all(ProfileFace)

  def get_profile_face!(id), do: Repo.get!(ProfileFace, id)

  def create_profile_face(attrs \\ %{}) do
    %ProfileFace{}
    |> ProfileFace.changeset(attrs)
    |> Repo.insert()
  end

  def update_profile_face(%ProfileFace{} = pf, attrs) do
    pf
    |> ProfileFace.changeset(attrs)
    |> Repo.update()
  end

  def delete_profile_face(%ProfileFace{} = pf), do: Repo.delete(pf)

  def change_profile_face(%ProfileFace{} = pf, attrs \\ %{}) do
    ProfileFace.changeset(pf, attrs)
  end
end
