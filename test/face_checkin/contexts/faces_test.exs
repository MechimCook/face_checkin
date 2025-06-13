defmodule FaceCheckin.FacesTest do
  use FaceCheckin.DataCase

  alias FaceCheckin.Faces
  alias FaceCheckin.Face

  @valid_attrs %{encoded_face: "some_encoding"}
  @update_attrs %{encoded_face: "updated_encoding"}
  @invalid_attrs %{encoded_face: nil}

  test "list_faces/0 returns all faces" do
    {:ok, face} = Faces.create_face(@valid_attrs)
    assert Faces.list_faces() == [face]
  end

  test "get_face!/1 returns the face with given id" do
    {:ok, face} = Faces.create_face(@valid_attrs)
    assert Faces.get_face!(face.id) == face
  end

  test "create_face/1 with valid data creates a face" do
    assert {:ok, %Face{} = face} = Faces.create_face(@valid_attrs)
    assert face.encoded_face == "some_encoding"
  end

  test "create_face/1 with invalid data returns error changeset" do
    assert {:error, %Ecto.Changeset{}} = Faces.create_face(@invalid_attrs)
  end

  test "update_face/2 with valid data updates the face" do
    {:ok, face} = Faces.create_face(@valid_attrs)
    assert {:ok, %Face{} = face} = Faces.update_face(face, @update_attrs)
    assert face.encoded_face == "updated_encoding"
  end

  test "update_face/2 with invalid data returns error changeset" do
    {:ok, face} = Faces.create_face(@valid_attrs)
    assert {:error, %Ecto.Changeset{}} = Faces.update_face(face, @invalid_attrs)
    assert face == Faces.get_face!(face.id)
  end

  test "delete_face/1 deletes the face" do
    {:ok, face} = Faces.create_face(@valid_attrs)
    assert {:ok, %Face{}} = Faces.delete_face(face)
    assert_raise Ecto.NoResultsError, fn -> Faces.get_face!(face.id) end
  end

  test "change_face/1 returns a face changeset" do
    {:ok, face} = Faces.create_face(@valid_attrs)
    assert %Ecto.Changeset{} = Faces.change_face(face)
  end
end
