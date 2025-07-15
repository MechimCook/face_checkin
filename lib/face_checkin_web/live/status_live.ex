defmodule FaceCheckinWeb.StatusLive do
  use Phoenix.LiveView
  alias FaceCheckin.Profiles

  def mount(_params, _session, socket) do
    profiles = Profiles.list_profiles()

    {:ok,
     socket
     |> allow_upload(:avatar, accept: ~w(.jpg .jpeg .png), max_entries: 1)
     |> assign(
       profiles: profiles,
       show_modal: false,
       recog_modal: nil,
       modal_profile_id: nil,
       detected_face_img: nil,
       pause_auto_capture: false,
       show_add_to_profile_modal: false,
       show_add_new_profile_modal: false,
       recog_modal_timer: 5,
       recog_modal_rejected: false,
       add_encoding: nil
     )}
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

    {:noreply,
     socket
     |> assign(profiles: Profiles.list_profiles(), show_modal: false, modal_profile_id: nil)}
  end

  def handle_event("validate", _params, socket), do: {:noreply, socket}

  def handle_event("auto_capture", %{"image" => data_url}, socket) do
    <<_::binary-size(23), base64::binary>> = data_url
    {:ok, image_binary} = Base.decode64(base64)

    tmp_path = Path.join(System.tmp_dir!(), "capture-#{System.unique_integer()}.jpg")
    File.write!(tmp_path, image_binary)

    faces = FaceCheckin.FacialRecognition.detect_and_crop_faces(tmp_path)

    case faces do
      [] ->
        {:noreply, socket}

      _ ->
        {captured_encoding, match} = FaceCheckin.FacialRecognition.find_best_match(faces)

        recog_modal =
          case match do
            profile_id when is_integer(profile_id) ->
              profile = FaceCheckin.Profiles.get_profile!(profile_id)

              %{
                mode: :match,
                profile: profile,
                encoding: captured_encoding,
                image: Base.encode64(List.first(faces))
              }

            :no_match ->
              %{
                mode: :unknown,
                encoding: captured_encoding,
                image: Base.encode64(List.first(faces))
              }
          end

        {:noreply,
         socket
         |> assign(
           recog_modal: recog_modal,
           detected_face_img: recog_modal.image,
           pause_auto_capture: true,
           recog_modal_timer: 5,
           recog_modal_rejected: false
         )}
    end
  end

  def handle_event("close_recog_modal", _params, socket) do
    {:noreply, assign(socket, recog_modal: nil, pause_auto_capture: false, recog_modal_timer: 5)}
  end

  def handle_event("toggle_auto_capture_pause", _params, socket) do
    pause = !(socket.assigns[:pause_auto_capture] || false)
    {:noreply, assign(socket, pause_auto_capture: pause)}
  end

  def handle_event("decrement_recog_modal_timer", _params, socket) do
    if socket.assigns[:show_add_to_profile_modal] or socket.assigns[:show_add_new_profile_modal] do
      {:noreply, socket}
    else
      timer = max(socket.assigns.recog_modal_timer - 1, 0)

      cond do
        timer > 0 ->
          {:noreply, assign(socket, recog_modal_timer: timer)}

        socket.assigns.recog_modal &&
          socket.assigns.recog_modal.mode == :match &&
            !socket.assigns.recog_modal_rejected ->
          profile_id = socket.assigns.recog_modal.profile.id
          profile = FaceCheckin.Profiles.get_profile!(profile_id)

          {:ok, _profile} =
            FaceCheckin.Profiles.update_profile(profile, %{checked_in: !profile.checked_in})

          {:noreply,
           socket
           |> assign(
             recog_modal: nil,
             pause_auto_capture: false,
             recog_modal_timer: 5,
             profiles: FaceCheckin.Profiles.list_profiles(),
             recog_modal_rejected: false
           )}

        true ->
          {:noreply, assign(socket, recog_modal_timer: timer)}
      end
    end
  end

  def handle_event("add_to_profile", %{"encoding" => encoding}, socket) do
    {:noreply, assign(socket, show_add_to_profile_modal: true, add_encoding: encoding)}
  end

  def handle_event("add_to_profile", params, socket) do
    IO.inspect(params, label: "Unexpected add_to_profile params")
    {:noreply, socket}
  end

  def handle_event(
        "confirm_add_to_profile",
        %{"profile_id" => profile_id, "encoding" => encoding},
        socket
      ) do
    attrs = %{profile_id: profile_id, encoded_face: encoding}

    case FaceCheckin.Faces.create_face(attrs) do
      {:ok, _face} ->
        profile = FaceCheckin.Profiles.get_profile!(profile_id)

        {:ok, _profile} =
          FaceCheckin.Profiles.update_profile(profile, %{checked_in: !profile.checked_in})

        {:noreply,
         socket
         |> assign(
           show_add_to_profile_modal: false,
           add_encoding: nil,
           profiles: FaceCheckin.Profiles.list_profiles()
         )}

      {:error, _changeset} ->
        {:noreply, assign(socket, show_add_to_profile_modal: false)}
    end
  end

  def handle_event("close_add_to_profile_modal", _params, socket) do
    {:noreply,
     assign(socket,
       show_add_to_profile_modal: false,
       add_encoding: nil,
       pause_auto_capture: false
     )}
  end

  def handle_event("add_new_profile", %{"encoding" => encoding}, socket) do
    {:noreply, assign(socket, show_add_new_profile_modal: true, add_encoding: encoding)}
  end

  def handle_event("close_add_new_profile_modal", _params, socket) do
    {:noreply, assign(socket, show_add_new_profile_modal: false, add_encoding: nil)}
  end

  def handle_event("confirm_add_new_profile", %{"name" => name, "encoding" => encoding}, socket) do
    case FaceCheckin.Profiles.create_profile(%{name: name, checked_in: false}) do
      {:ok, profile} ->
        FaceCheckin.Faces.create_face(%{
          profile_id: profile.id,
          encoded_face: encoding
        })

        {:noreply,
         socket
         |> assign(
           show_add_new_profile_modal: false,
           add_encoding: nil,
           profiles: FaceCheckin.Profiles.list_profiles()
         )}

      {:error, _changeset} ->
        {:noreply, assign(socket, show_add_new_profile_modal: false)}
    end
  end

  def handle_event("not_this_profile", %{"encoding" => encoding}, socket) do
    {:noreply,
     socket
     |> assign(
       recog_modal: nil,
       show_add_to_profile_modal: true,
       add_encoding: encoding,
       pause_auto_capture: true
     )}
  end
end
