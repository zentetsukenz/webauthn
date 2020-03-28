defmodule WebAuthnWeb.RegistrationParams.CredentialOptions do
  use WebAuthnWeb.ParamSchema
  import Ecto.Changeset

  embedded_schema do
    field(:email, :string)
    field(:name, :string)
  end

  def changeset(challenge, params \\ %{}) do
    challenge
    |> cast(params, [:email, :name])
    |> validate_required([:email, :name])
    |> validate_format(:email, ~r/@/)
  end
end
