defmodule FaceCheckinWeb.StatusHTML do
  @moduledoc """
  This module contains status rendered by StatusController.

  See the `status_html` directory for all templates available.
  """
  use FaceCheckinWeb, :html

  embed_templates "status_html/*"
end
