defmodule FaceCheckinWeb.StatusLive do
  use Phoenix.LiveView
  alias FaceCheckin.Profiles

  def mount(_params, _session, socket) do
    profiles = Profiles.list_profiles()
    socket =
      socket
      |> allow_upload(:avatar, accept: ~w(.jpg .jpeg .png), max_entries: 1)
      |> assign(:profiles, profiles)
      |> assign(:show_modal, false)
      |> assign(:modal_profile_id, nil)
      |> assign(:detected_face_img, nil)
    {:ok, socket}
  end

  def handle_event("toggle_checked_in", %{"id" => id}, socket) do
    profile = Profiles.get_profile!(id)
    {:ok, _} = Profiles.update_profile(profile, %{checked_in: !profile.checked_in})
    {:noreply, assign(socket, profiles: Profiles.list_profiles())}
  end

  def handle_event("open_modal", %{"id" => id}, socket) do
    {:noreply, assign(socket, show_modal: true, modal_profile_id: id)}
  end

  def handle_event("close_modal", _params, socket) do
    {:noreply, assign(socket, show_modal: false, modal_profile_id: nil, detected_face_img: nil)}
  end

  def handle_event("save_pic", %{"id" => id}, socket) do
    consume_uploaded_entries(socket, :avatar, fn %{path: path}, _entry ->
      {:ok, image_binary} = File.read(path)
      profile = Profiles.get_profile!(id)
      Profiles.update_profile(profile, %{profile_pic: image_binary})
      :ok
    end)

    socket =
      socket
      |> assign(:profiles, Profiles.list_profiles())
      |> assign(:show_modal, false)
      |> assign(:modal_profile_id, nil)

    {:noreply, socket}
  end

  def handle_event("validate", _params, socket) do
    {:noreply, socket}
  end

  def handle_event("auto_capture", %{"image" => data_url}, socket) do
    <<_::binary-size(23), base64::binary>> = data_url
    {:ok, image_binary} = Base.decode64(base64)

    tmp_path = Path.join(System.tmp_dir!(), "capture-#{System.unique_integer()}.jpg")
    File.write!(tmp_path, image_binary)

    faces = FaceCheckin.FacialRecognition.detect_and_crop_faces(tmp_path)

    face_img =
      case faces do
        [first | _] -> Base.encode64(first)
        _ -> nil
      end

    show_modal = face_img != nil

    socket =
      socket
      |> assign(:show_modal, show_modal)
      |> assign(:detected_face_img, face_img)
      |> assign(:modal_profile_id, nil)

    {:noreply, socket}
  end
end
