defmodule FaceCheckinWeb.FaceHTML do
  use FaceCheckinWeb, :html

  embed_templates "face_html/*"

  @doc """
  Renders a face form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def face_form(assigns)
end
