defmodule FaceCheckinWeb.FaceController do
  use FaceCheckinWeb, :controller

  alias FaceCheckin.Faces
  alias FaceCheckin.Face

  def index(conn, _params) do
    profiles_with_faces = FaceCheckin.ProfileFaces.list_profile_faces_with_name_and_pic
    |> IO.inspect(label: "Profiles with Faces")

    render(conn, :index, profiles_with_faces: profiles_with_faces)
  end

  def new(conn, _params) do
    changeset = Faces.change_face(%Face{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"face" => face_params}) do
    case Faces.create_face(face_params) do
      {:ok, face} ->
        conn
        |> put_flash(:info, "Face created successfully.")
        |> redirect(to: ~p"/faces/#{face}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    face = Faces.get_face!(id)
    render(conn, :show, face: face)
  end

  def edit(conn, %{"id" => id}) do
    face = Faces.get_face!(id)
    changeset = Faces.change_face(face)
    render(conn, :edit, face: face, changeset: changeset)
  end

  def update(conn, %{"id" => id, "face" => face_params}) do
    face = Faces.get_face!(id)

    case Faces.update_face(face, face_params) do
      {:ok, face} ->
        conn
        |> put_flash(:info, "Face updated successfully.")
        |> redirect(to: ~p"/faces/#{face}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, face: face, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    face = Faces.get_face!(id)
    {:ok, _face} = Faces.delete_face(face)

    conn
    |> put_flash(:info, "Face deleted successfully.")
    |> redirect(to: ~p"/faces")
  end

  def status(conn, _params) do
    {checked_in, checked_out} =
      Faces.list_faces()
      |> Enum.split_with(& &1.checked_in)

    render(conn, "status.html", checked_in: checked_in, checked_out: checked_out)
  end
end
