defmodule FaceCheckinWeb.FaceControllerTest do
  use FaceCheckinWeb.ConnCase

  import FaceCheckin.FacesFixtures

  @create_attrs %{name: "some name", face_encoding: "some face_encoding", checked_in: true}
  @update_attrs %{name: "some updated name", face_encoding: "some updated face_encoding", checked_in: false}
  @invalid_attrs %{name: nil, face_encoding: nil, checked_in: nil}

  describe "index" do
    test "lists all faces", %{conn: conn} do
      conn = get(conn, ~p"/faces")
      assert html_response(conn, 200) =~ "Listing Faces"
    end
  end

  describe "new face" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/faces/new")
      assert html_response(conn, 200) =~ "New Face"
    end
  end

  describe "create face" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/faces", face: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/faces/#{id}"

      conn = get(conn, ~p"/faces/#{id}")
      assert html_response(conn, 200) =~ "Face #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/faces", face: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Face"
    end
  end

  describe "edit face" do
    setup [:create_face]

    test "renders form for editing chosen face", %{conn: conn, face: face} do
      conn = get(conn, ~p"/faces/#{face}/edit")
      assert html_response(conn, 200) =~ "Edit Face"
    end
  end

  describe "update face" do
    setup [:create_face]

    test "redirects when data is valid", %{conn: conn, face: face} do
      conn = put(conn, ~p"/faces/#{face}", face: @update_attrs)
      assert redirected_to(conn) == ~p"/faces/#{face}"

      conn = get(conn, ~p"/faces/#{face}")
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{conn: conn, face: face} do
      conn = put(conn, ~p"/faces/#{face}", face: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Face"
    end
  end

  describe "delete face" do
    setup [:create_face]

    test "deletes chosen face", %{conn: conn, face: face} do
      conn = delete(conn, ~p"/faces/#{face}")
      assert redirected_to(conn) == ~p"/faces"

      assert_error_sent 404, fn ->
        get(conn, ~p"/faces/#{face}")
      end
    end
  end

  defp create_face(_) do
    face = face_fixture()
    %{face: face}
  end
end
