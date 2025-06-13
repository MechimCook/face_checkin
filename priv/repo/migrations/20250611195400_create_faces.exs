defmodule FaceCheckin.Repo.Migrations.CreateProfilesFacesTables do
  use Ecto.Migration

  def change do
    create table(:profiles) do
      add :name, :string, null: false
      add :profile_pic, :binary
      add :checked_in, :boolean
      timestamps()
    end

    create table(:faces) do
      add :encoded_face, :text, null: false
      timestamps()
    end

    create table(:profiles_faces) do
      add :profile_id, references(:profiles, on_delete: :delete_all), null: false
      add :face_pic, :binary
      add :face_id, references(:faces, on_delete: :delete_all), null: false
      timestamps()
    end

    create index(:profiles_faces, [:profile_id])
    create index(:profiles_faces, [:face_id])
  end
end
