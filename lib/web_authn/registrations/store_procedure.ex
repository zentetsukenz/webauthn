defmodule WebAuthn.Registrations.StoreProcedure do
  alias WebAuthn.Registrations.Registration
  alias WebAuthn.Registrations.RegistrationChallenge
  alias Ecto.Multi

  def create_registration(%{email: _, name: _} = params) do
    registration_create_params = Map.merge(params, %{status: "pending"})

    Multi.new()
    |> Multi.insert(
      :registration,
      %Registration{}
      |> Registration.changeset(registration_create_params)
    )
    |> Multi.merge(fn %{registration: registration} ->
      create_challenge(registration)
    end)
  end

  def renew_challenge(registration) do
    Multi.new()
    |> Multi.update_all(
      :deactivate_challenges,
      Ecto.assoc(registration, :challenges),
      set: [status: "inactive"]
    )
    |> Multi.merge(fn _ ->
      create_challenge(registration)
    end)
  end

  defp create_challenge(registration) do
    attrs = %{
      relying_party_name: "Wiwatta Mongkhonchit",
      relying_party_id: "localhost",
      username: registration.email,
      display_name: registration.name,
      timeout: 60000,
      attestation: "direct",
      user_verification: "required",
      status: "active"
    }

    Multi.new()
    |> Multi.insert(
      :challenge,
      registration
      |> Ecto.build_assoc(:challenges)
      |> RegistrationChallenge.changeset(attrs)
    )
  end
end
