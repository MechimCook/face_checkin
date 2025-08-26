defmodule FaceCheckin.ProfileFaces do
  @moduledoc "The ProfileFaces context."

  import Ecto.Query, warn: false

  alias Ecto.Multi
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

  def list_profile_faces_with_name_and_pic do
    from(p in FaceCheckin.Profile,
      left_join: pf in assoc(p, :profiles_faces),
      group_by: [p.id, p.name],
      select: %{
        profile_name: p.name,
        face_pics: fragment("array_remove(array_agg(?), NULL)", pf.face_pic)
      }
    )
    |> FaceCheckin.Repo.all()
  end

  def create_face_and_profile_face(attrs) do
    Multi.new()
    |> Multi.insert(:face, %FaceCheckin.Face{
      profile_id: attrs.profile_id,
      encoded_face: attrs.encoded_face
    })
    |> Multi.insert(:profile_face, fn %{face: face} ->
      %ProfileFace{
        profile_id: attrs.profile_id,
        face_id: face.id,
        face_pic: attrs.face_pic
      }
    end)
    |> Repo.transaction()
  end
end
