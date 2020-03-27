defmodule WebAuthn.Repo.Migrations.CreateRegistrationChallenges do
  use Ecto.Migration

  def change do
    create table(:registration_challenges) do
      add :challenge, :string
      add :status, :string
      add :registration_id, references(:registrations)

      timestamps()
    end
  end
end
