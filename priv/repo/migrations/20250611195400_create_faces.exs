defmodule FaceCheckin.Repo.Migrations.CreateFaces do
  use Ecto.Migration

  def change do
    create table(:faces) do
      add :name, :string
      add :face_encoding, :text
      add :checked_in, :boolean, default: false, null: false

      timestamps(type: :utc_datetime)
    end
  end
end
