defmodule FaceCheckin.FacialRecognition do
  @moduledoc """
  Face detection and cropping using Evision.
  """

  @cascade_path Path.join([
    :code.priv_dir(:evision),
    "share/opencv4/haarcascades/haarcascade_frontalface_default.xml"
  ])

  @doc """
  Detects faces in the given image path and returns a list of cropped face images as binaries.
  """
  def detect_and_crop_faces(image_path) do
    mat = Evision.imread(image_path)
    cascade = Evision.CascadeClassifier.cascadeClassifier(@cascade_path)
    faces = Evision.CascadeClassifier.detectMultiScale(cascade, mat)

    Enum.map(faces, fn {x, y, w, h} ->
      face_mat = Evision.Mat.roi(mat, {x, y, w, h})
      jpeg = case Evision.imencode(".jpg", face_mat) do
        bin -> bin
        bin when is_binary(bin) -> bin
      end
      jpeg
    end)
  end

  @doc """
  Detects faces and returns the rectangles.
  """
  def detect_faces(image_path) do
    mat = Evision.imread(image_path)
    cascade = Evision.CascadeClassifier.cascadeClassifier(@cascade_path)
    Evision.CascadeClassifier.detectMultiScale(cascade, mat)
  end
end
