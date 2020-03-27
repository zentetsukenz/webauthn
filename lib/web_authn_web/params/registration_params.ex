defmodule WebAuthnWeb.RegistrationParams do
  alias WebAuthnWeb.RegistrationParams.Challenge
  alias Ecto.Changeset

  def challenge(params) do
    with %Changeset{valid?: true} = c <- Challenge.changeset(%Challenge{}, params) do
      {:ok, c.changes}
    else
      %Changeset{valid?: false} = c -> {:error, c.errors}
    end
  end
end
