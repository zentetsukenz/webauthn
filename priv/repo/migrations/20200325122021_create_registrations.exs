defmodule WebAuthn.Repo.Migrations.CreateRegistrations do
  use Ecto.Migration

  def change do
    create table(:registrations) do
      add :email, :string
      add :name, :string
      add :status, :string

      timestamps()
    end
  end
end
