defmodule FaceCheckinWeb.CameraFeedComponent do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~H"""
    <div id="camera-feed-container"
         phx-hook="CameraInit"
         data-pause-auto-capture={@pause_auto_capture}>
      <video id="camera-feed" autoplay playsinline style="display:none; width: 320px; height: 240px;"></video>
      <canvas id="camera-canvas" width="320" height="240" style="display:none;"></canvas>
    </div>
    """
  end
end
