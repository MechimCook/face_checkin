defmodule FaceCheckin.FacesTest do
  use FaceCheckin.DataCase

  alias FaceCheckin.Faces
  alias FaceCheckin.Face

  setup do
    {:ok, profile} = FaceCheckin.Profiles.create_profile(%{id: 1, name: "Test", checked_in: false})
    %{profile: profile}
  end

  @update_attrs %{encoded_face: "updated_encoding"}
  @invalid_attrs %{encoded_face: nil, profile_id: 1}

  test "list_faces/0 returns all faces", %{profile: profile} do
    valid_attrs = %{encoded_face: "some_encoding", profile_id: profile.id}
    {:ok, face} = Faces.create_face(valid_attrs)
    assert Faces.list_faces() == [face]
  end

  test "get_face!/1 returns the face with given id", %{profile: profile} do
    valid_attrs = %{encoded_face: "some_encoding", profile_id: profile.id}
    {:ok, face} = Faces.create_face(valid_attrs)
    assert Faces.get_face!(face.id) == face
  end

  test "create_face/1 with valid data creates a face", %{profile: profile} do
    valid_attrs = %{encoded_face: "some_encoding", profile_id: profile.id}
    assert {:ok, %Face{} = face} = Faces.create_face(valid_attrs)
    assert face.encoded_face == "some_encoding"
    assert face.profile_id == profile.id
  end

  test "create_face/1 with invalid data returns error changeset" do
    assert {:error, %Ecto.Changeset{}} = Faces.create_face(@invalid_attrs)
  end

  test "update_face/2 with valid data updates the face", %{profile: profile} do
    valid_attrs = %{encoded_face: "some_encoding", profile_id: profile.id}
    {:ok, face} = Faces.create_face(valid_attrs)
    assert {:ok, %Face{} = face} = Faces.update_face(face, @update_attrs)
    assert face.encoded_face == "updated_encoding"
  end

  test "update_face/2 with invalid data returns error changeset", %{profile: profile} do
    valid_attrs = %{encoded_face: "some_encoding", profile_id: profile.id}
    {:ok, face} = Faces.create_face(valid_attrs)
    assert {:error, %Ecto.Changeset{}} = Faces.update_face(face, @invalid_attrs)
    assert face == Faces.get_face!(face.id)
  end

  test "delete_face/1 deletes the face", %{profile: profile} do
    valid_attrs = %{encoded_face: "some_encoding", profile_id: profile.id}
    {:ok, face} = Faces.create_face(valid_attrs)
    assert {:ok, %Face{}} = Faces.delete_face(face)
    assert_raise Ecto.NoResultsError, fn -> Faces.get_face!(face.id) end
  end

  test "change_face/1 returns a face changeset", %{profile: profile} do
    valid_attrs = %{encoded_face: "some_encoding", profile_id: profile.id}
    {:ok, face} = Faces.create_face(valid_attrs)
    assert %Ecto.Changeset{} = Faces.change_face(face)
  end
end
