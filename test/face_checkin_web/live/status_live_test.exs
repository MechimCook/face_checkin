defmodule FaceCheckinWeb.StatusLiveTest do
  use FaceCheckinWeb.ConnCase
  import Phoenix.LiveViewTest

  alias FaceCheckin.Profiles

  setup %{conn: conn} do
    # Insert a profile for testing
    {:ok, profile} = Profiles.create_profile(%{name: "Test", checked_in: false})
    {:ok, conn: conn, profile: profile}
  end

  test "mounts and renders", %{conn: conn} do
    {:ok, _view, html} = live(conn, "/")
    assert html =~ "Test"
  end

  test "toggles auto capture pause", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/")
    assert render(view) =~ "Pause Auto Capture"
    render_click(element(view, "button[phx-click=\"toggle_auto_capture_pause\"]"))
    assert render(view) =~ "Resume Auto Capture"
  end
end
