defmodule FaceCheckin.FacesTest do
  use FaceCheckin.DataCase

  alias FaceCheckin.Faces

  describe "faces" do
    alias FaceCheckin.Face

    import FaceCheckin.FacesFixtures

    @invalid_attrs %{name: nil, face_encoding: nil, checked_in: nil}

    test "list_faces/0 returns all faces" do
      face = face_fixture()
      assert Faces.list_faces() == [face]
    end

    test "get_face!/1 returns the face with given id" do
      face = face_fixture()
      assert Faces.get_face!(face.id) == face
    end

    test "create_face/1 with valid data creates a face" do
      valid_attrs = %{name: "some name", face_encoding: "some face_encoding", checked_in: true}

      assert {:ok, %Face{} = face} = Faces.create_face(valid_attrs)
      assert face.name == "some name"
      assert face.face_encoding == "some face_encoding"
      assert face.checked_in == true
    end

    test "create_face/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Faces.create_face(@invalid_attrs)
    end

    test "update_face/2 with valid data updates the face" do
      face = face_fixture()
      update_attrs = %{name: "some updated name", face_encoding: "some updated face_encoding", checked_in: false}

      assert {:ok, %Face{} = face} = Faces.update_face(face, update_attrs)
      assert face.name == "some updated name"
      assert face.face_encoding == "some updated face_encoding"
      assert face.checked_in == false
    end

    test "update_face/2 with invalid data returns error changeset" do
      face = face_fixture()
      assert {:error, %Ecto.Changeset{}} = Faces.update_face(face, @invalid_attrs)
      assert face == Faces.get_face!(face.id)
    end

    test "delete_face/1 deletes the face" do
      face = face_fixture()
      assert {:ok, %Face{}} = Faces.delete_face(face)
      assert_raise Ecto.NoResultsError, fn -> Faces.get_face!(face.id) end
    end

    test "change_face/1 returns a face changeset" do
      face = face_fixture()
      assert %Ecto.Changeset{} = Faces.change_face(face)
    end
  end
end
