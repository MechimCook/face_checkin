defmodule FaceCheckin.Profiles do
  @moduledoc "The Profiles context."

  import Ecto.Query, warn: false
  alias FaceCheckin.Repo
  alias FaceCheckin.Profile

  def list_profiles, do: Repo.all(Profile)

  def get_profile!(id), do: Repo.get!(Profile, id)

  def create_profile(attrs \\ %{}) do
    %Profile{}
    |> Profile.changeset(attrs)
    |> Repo.insert()
  end

  def update_profile(%Profile{} = profile, attrs) do
    profile
    |> Profile.changeset(attrs)
    |> Repo.update()
  end

  def delete_profile(%Profile{} = profile), do: Repo.delete(profile)

  def change_profile(%Profile{} = profile, attrs \\ %{}) do
    Profile.changeset(profile, attrs)
  end
end
