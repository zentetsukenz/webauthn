defmodule WebAuthnWeb.RegistrationParams do
  alias WebAuthnWeb.RegistrationParams.CredentialOptions
  alias WebAuthnWeb.RegistrationParams.PublicKey
  alias Ecto.Changeset

  def credential_options(params) do
    with %Changeset{valid?: true} = c <- CredentialOptions.changeset(%CredentialOptions{}, params) do
      {:ok, c.changes}
    else
      %Changeset{valid?: false} = c -> {:error, c.errors}
    end
  end

  def public_key(params) do
    with %Changeset{valid?: true} = p <- PublicKey.changeset(%PublicKey{}, params),
         %Changeset{valid?: true} = c <- p.changes.credential do
      valid_params = Map.merge(p.changes, %{credential: c.changes})
      {:ok, valid_params}
    else
      %Changeset{valid?: false} = c -> {:error, c.errors}
    end
  end
end
