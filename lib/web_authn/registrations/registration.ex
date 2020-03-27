defmodule WebAuthn.Registrations.Registration do
  use Ecto.Schema
  import Ecto.Changeset

  alias WebAuthn.Registrations.RegistrationChallenge

  schema "registrations" do
    field :email, :string
    field :name, :string
    field :status, :string

    has_many :challenges, RegistrationChallenge

    timestamps()
  end

  def changeset(registration, params \\ %{}) do
    registration
    |> cast(params, [:email, :name, :status])
    |> validate_required([:email, :name, :status])
    |> validate_inclusion(:status, ["pending", "complete"])
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email)
  end
end
