defmodule FaceCheckin.FacialRecognitionTest do
  use ExUnit.Case, async: true
  alias FaceCheckin.FacialRecognition

  describe "compare_encodings/2" do
    test "returns 0 for identical vectors" do
      v = Enum.to_list(1..128)
      assert FacialRecognition.compare_encodings(v, v) == 0.0
    end

    test "returns correct Euclidean distance" do
      v1 = [1.0, 2.0, 3.0]
      v2 = [4.0, 6.0, 3.0]
      assert FacialRecognition.compare_encodings(v1, v2) == :math.sqrt(9 + 16 + 0)
    end
  end

  describe "extract_encoding/1" do
    test "returns nil for empty or invalid image" do
      assert FacialRecognition.extract_encoding(<<>>) == nil
    end
  end

  describe "find_best_match/1" do
    test "returns :no_match for empty input" do
      assert FacialRecognition.find_best_match([]) == :no_match
    end

    # You can add more tests here with mocks/stubs for extract_encoding and list_faces_grouped_by_profile_id
  end
end
