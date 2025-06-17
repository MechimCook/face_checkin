defmodule FaceCheckin.ProfilesTest do
  use FaceCheckin.DataCase

  alias FaceCheckin.Profiles
  alias FaceCheckin.Profile

  @valid_attrs %{name: "Alice", profile_pic: <<1, 2, 3>>, checked_in: true}
  @update_attrs %{name: "Bob", profile_pic: <<4, 5, 6>>, checked_in: false}
  @invalid_attrs %{name: nil, profile_pic: nil, checked_in: nil}

  test "list_profiles/0 returns all profiles" do
    {:ok, profile} = Profiles.create_profile(@valid_attrs)
    assert Profiles.list_profiles() == [profile]
  end

  test "get_profile!/1 returns the profile with given id" do
    {:ok, profile} = Profiles.create_profile(@valid_attrs)
    assert Profiles.get_profile!(profile.id) == profile
  end

  test "create_profile/1 with valid data creates a profile" do
    assert {:ok, %Profile{} = profile} = Profiles.create_profile(@valid_attrs)
    assert profile.name == "Alice"
    assert profile.profile_pic == <<1, 2, 3>>
    assert profile.checked_in == true
  end

  test "create_profile/1 with invalid data returns error changeset" do
    assert {:error, %Ecto.Changeset{}} = Profiles.create_profile(@invalid_attrs)
  end

  test "update_profile/2 with valid data updates the profile" do
    {:ok, profile} = Profiles.create_profile(@valid_attrs)
    assert {:ok, %Profile{} = profile} = Profiles.update_profile(profile, @update_attrs)
    assert profile.name == "Bob"
    assert profile.profile_pic == <<4, 5, 6>>
    assert profile.checked_in == false
  end

  test "update_profile/2 with invalid data returns error changeset" do
    {:ok, profile} = Profiles.create_profile(@valid_attrs)
    assert {:error, %Ecto.Changeset{}} = Profiles.update_profile(profile, @invalid_attrs)
    assert profile == Profiles.get_profile!(profile.id)
  end

  test "delete_profile/1 deletes the profile" do
    {:ok, profile} = Profiles.create_profile(@valid_attrs)
    assert {:ok, %Profile{}} = Profiles.delete_profile(profile)
    assert_raise Ecto.NoResultsError, fn -> Profiles.get_profile!(profile.id) end
  end

  test "change_profile/1 returns a profile changeset" do
    {:ok, profile} = Profiles.create_profile(@valid_attrs)
    assert %Ecto.Changeset{} = Profiles.change_profile(profile)
  end
end
