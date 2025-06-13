import Ecto.Query
alias FaceCheckin.Repo
alias FaceCheckin.Profile

# Only add if not already present
unless Repo.exists?(from p in Profile, where: p.name == "Starter User") do
  %Profile{
    name: "Starter User",
    checked_in: true,
    profile_pic: nil # or provide binary data for a real image
  }
  |> Repo.insert!()
end
