defmodule WebAuthn.Registrations.StoreProcedure do
  alias WebAuthn.Registrations.Registration
  alias Ecto.Multi

  def create_registration(%{email: _, name: _} = params) do
    registration_create_params = Map.merge(params, %{status: "pending"})

    Multi.new()
    |> Multi.insert(
      :registration,
      %Registration{}
      |> Registration.changeset(registration_create_params)
    )
    |> Multi.merge(fn %{registration: r} ->
      create_challenge(r)
    end)
  end

  def renew_challenge(registration) do
    Multi.new()
    |> Multi.update_all(
      :deactivate_old_challenges,
      Ecto.assoc(registration, :challenges),
      set: [status: "inactive"]
    )
    |> Multi.merge(fn _ ->
      create_challenge(registration)
    end)
  end

  def create_challenge(registration) do
    Multi.insert(
      Multi.new(),
      :challenge,
      Ecto.build_assoc(registration, :challenges, %{
        status: "active",
        challenge: generate_challenge()
      })
    )
  end

  defp generate_challenge do
    :crypto.strong_rand_bytes(16)
    |> Base.encode64()
  end
end
