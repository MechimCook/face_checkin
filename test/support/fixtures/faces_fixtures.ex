defmodule FaceCheckin.FacesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `FaceCheckin.Faces` context.
  """

  @doc """
  Generate a face.
  """
  def face_fixture(attrs \\ %{}) do
    {:ok, face} =
      attrs
      |> Enum.into(%{
        checked_in: true,
        face_encoding: "some face_encoding",
        name: "some name"
      })
      |> FaceCheckin.Faces.create_face()

    face
  end
end
