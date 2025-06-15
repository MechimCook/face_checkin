defmodule FaceCheckin.FacialRecognition do
  @moduledoc """
  Face detection and cropping using Evision.
  """
  @threshold 0.6

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

    faces
    |> Enum.map(fn {x, y, w, h} ->
      face_mat = Evision.Mat.roi(mat, {x, y, w, h})
      case Evision.imencode(".jpg", face_mat) do
        bin when is_binary(bin) -> bin
        _ -> nil
      end
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

  @doc """
  Finds the best matching profile for the given cropped face image.
  """
  def find_best_match([cropped_face | _]) do
    captured_encoding = extract_encoding(cropped_face)

    faces_by_profile =
      FaceCheckin.Faces.list_faces_grouped_by_profile_id()

    {best_profile_id, best_score} =
      faces_by_profile
      |> Enum.map(fn {profile_id, faces} ->
        scores =
          Enum.map(faces, fn face ->
            compare_encodings(captured_encoding, face.encoding)
          end)

        {profile_id, Enum.min(scores)}
      end)
      |> Enum.min_by(fn {_id, score} -> score end, fn -> {nil, 1.0} end)

    if best_score < @threshold do
      best_profile_id
    else
      :no_match
    end
  end

  def find_best_match([]), do: :no_match

  @doc """
  Extracts the facial encoding from the cropped face JPEG image.
  """
  def extract_encoding(cropped_face_jpeg) do
    tmp = Path.join(System.tmp_dir!(), "face-#{System.unique_integer()}.jpg")
    File.write!(tmp, cropped_face_jpeg)
    script_path = Path.expand("assets/face_encode.py", File.cwd!())
    python_path = Path.expand("venv312/bin/python", File.cwd!())
    {output, exit_code} = System.cmd(python_path, [script_path, tmp])

    if exit_code != 0 do
      nil
    else
      output
      |> String.trim()
      |> case do
        "" -> nil
        csv ->
          try do
            csv |> String.split(",") |> Enum.map(&String.to_float/1)
          rescue
            _ -> nil
          end
      end
    end
  end

  @doc """
  Placeholder: Compares two encodings using Euclidean distance.
  Replace with real comparison logic later.
  """
  def compare_encodings(enc1, enc2) do
    # Assume both are lists of floats of the same length
    enc1
    |> Enum.zip(enc2)
    |> Enum.map(fn {a, b} -> :math.pow(a - b, 2) end)
    |> Enum.sum()
    |> :math.sqrt()
  end
end
