defmodule FaceCheckin.ProfileFacesTest do
  use FaceCheckin.DataCase

  alias FaceCheckin.ProfileFaces
  alias FaceCheckin.ProfileFace

  setup do
    {:ok, profile} = FaceCheckin.Profiles.create_profile(%{name: "Test", checked_in: true})
    {:ok, face} = FaceCheckin.Faces.create_face(%{encoded_face: "abc", profile_id: profile.id})
    %{profile: profile, face: face}
  end

  @valid_attrs %{face_pic: <<1, 2, 3>>}
  @update_attrs %{face_pic: <<4, 5, 6>>}
  @invalid_attrs %{face_pic: nil, profile_id: nil, face_id: nil}

  test "list_profile_faces/0 returns all profile_faces", %{profile: profile, face: face} do
    {:ok, pf} =
      ProfileFaces.create_profile_face(
        Map.merge(@valid_attrs, %{profile_id: profile.id, face_id: face.id})
      )

    assert ProfileFaces.list_profile_faces() == [pf]
  end

  test "get_profile_face!/1 returns the profile_face with given id", %{
    profile: profile,
    face: face
  } do
    {:ok, pf} =
      ProfileFaces.create_profile_face(
        Map.merge(@valid_attrs, %{profile_id: profile.id, face_id: face.id})
      )

    assert ProfileFaces.get_profile_face!(pf.id) == pf
  end

  test "create_profile_face/1 with valid data creates a profile_face", %{
    profile: profile,
    face: face
  } do
    attrs = Map.merge(@valid_attrs, %{profile_id: profile.id, face_id: face.id})
    assert {:ok, %ProfileFace{} = pf} = ProfileFaces.create_profile_face(attrs)
    assert pf.face_pic == <<1, 2, 3>>
    assert pf.profile_id == profile.id
    assert pf.face_id == face.id
  end

  test "create_profile_face/1 with invalid data returns error changeset", %{
    profile: profile,
    face: face
  } do
    attrs = Map.merge(@invalid_attrs, %{profile_id: profile.id, face_id: face.id})
    assert {:error, %Ecto.Changeset{}} = ProfileFaces.create_profile_face(attrs)
  end

  test "update_profile_face/2 with valid data updates the profile_face", %{
    profile: profile,
    face: face
  } do
    {:ok, pf} =
      ProfileFaces.create_profile_face(
        Map.merge(@valid_attrs, %{profile_id: profile.id, face_id: face.id})
      )

    assert {:ok, %ProfileFace{} = pf} = ProfileFaces.update_profile_face(pf, @update_attrs)
    assert pf.face_pic == <<4, 5, 6>>
  end

  test "update_profile_face/2 with invalid data returns error changeset", %{
    profile: profile,
    face: face
  } do
    {:ok, pf} =
      ProfileFaces.create_profile_face(
        Map.merge(@valid_attrs, %{profile_id: profile.id, face_id: face.id})
      )

    assert {:error, %Ecto.Changeset{}} = ProfileFaces.update_profile_face(pf, @invalid_attrs)
    assert pf == ProfileFaces.get_profile_face!(pf.id)
  end

  test "delete_profile_face/1 deletes the profile_face", %{profile: profile, face: face} do
    {:ok, pf} =
      ProfileFaces.create_profile_face(
        Map.merge(@valid_attrs, %{profile_id: profile.id, face_id: face.id})
      )

    assert {:ok, %ProfileFace{}} = ProfileFaces.delete_profile_face(pf)
    assert_raise Ecto.NoResultsError, fn -> ProfileFaces.get_profile_face!(pf.id) end
  end

  test "change_profile_face/1 returns a profile_face changeset", %{profile: profile, face: face} do
    {:ok, pf} =
      ProfileFaces.create_profile_face(
        Map.merge(@valid_attrs, %{profile_id: profile.id, face_id: face.id})
      )

    assert %Ecto.Changeset{} = ProfileFaces.change_profile_face(pf)
  end
end
