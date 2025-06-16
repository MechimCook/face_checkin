defmodule FaceCheckin.Faces do
  @moduledoc "The Faces context."

  import Ecto.Query, warn: false
  alias FaceCheckin.Repo
  alias FaceCheckin.Face

  def list_faces, do: Repo.all(Face)

  def get_face!(id), do: Repo.get!(Face, id)

  def create_face(attrs \\ %{}) do
    %Face{}
    |> Face.changeset(attrs)
    |> Repo.insert()
  end

  def update_face(%Face{} = face, attrs) do
    face
    |> Face.changeset(attrs)
    |> Repo.update()
  end

  def delete_face(%Face{} = face), do: Repo.delete(face)

  def change_face(%Face{} = face, attrs \\ %{}) do
    Face.changeset(face, attrs)
  end

  def list_faces_grouped_by_profile_id do
    Face
    |> Repo.all()
    |> Enum.group_by(& &1.profile_id)
  end
end
