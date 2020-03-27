defmodule WebAuthn.Registrations.RegistrationChallenge do
  use Ecto.Schema
  import Ecto.Changeset

  alias WebAuthn.Registrations.Registration

  schema "registration_challenges" do
    field :challenge, :string
    field :status, :string

    belongs_to(:registration, Registration)

    timestamps()
  end

  def changeset(challenge, params \\ %{}) do
    challenge
    |> cast(params, [:challenge, :registration_id, :status])
    |> validate_required([:challenge, :registration_id, :status])
    |> validate_inclusion(:status, ["active", "inactive"])
    |> validate_length(:challenge, min: 16, count: :bytes)
  end
end
