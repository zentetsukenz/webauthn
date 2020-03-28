defmodule WebAuthn.Repo.Migrations.CreateRegistrationChallenges do
  use Ecto.Migration

  def change do
    create table(:registration_challenges) do
      add :uid, :string
      add :challenge, :string
      add :relying_party_name, :string
      add :relying_party_id, :string
      add :user_uid, :string
      add :username, :string
      add :display_name, :string
      add :timeout, :integer
      add :attestation, :string
      add :user_verification, :string
      add :status, :string
      add :registration_id, references(:registrations)

      timestamps()
    end
  end
end
