defmodule WebAuthn.Registrations.Registration do
  use Ecto.Schema
  use WebAuthn.Changeset

  alias WebAuthn.Registrations.RegistrationChallenge

  @uid_prefix "rgst"
  @statuses ["pending", "complete"]

  schema "registrations" do
    field :uid, :string
    field :email, :string
    field :name, :string
    field :status, :string

    has_many :challenges, RegistrationChallenge

    timestamps()
  end

  def changeset(registration, params \\ %{}) do
    registration
    |> cast(params, [:email, :name, :status])
    |> generate_uid(@uid_prefix)
    |> validate_required([:uid, :email, :name, :status])
    |> validate_inclusion(:status, @statuses)
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email)
  end
end
