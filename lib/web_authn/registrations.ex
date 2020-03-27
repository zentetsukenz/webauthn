defmodule WebAuthn.Registrations do
  alias WebAuthn.Registrations.{
    Query,
    StoreProcedure,
    Serializer
  }

  alias WebAuthn.Repo

  def initiate(%{email: email, name: _} = params) do
    Query.registration_by(%{email: email})
    |> Repo.one()
    |> do_initiate(params)
    |> Serializer.serialize()
  end

  defp do_initiate(nil, params) do
    creation = StoreProcedure.create_registration(params)

    with {:ok, %{registration: r}} <- Repo.transaction(creation),
         registration = Repo.one!(Query.registration_by(%{email: r.email})) do
      {:ok, registration}
    else
      {:error, _step, error, _changes} ->
        {:error, error}
    end
  end

  defp do_initiate(r, _) do
    renewal = StoreProcedure.renew_challenge(r)

    with {:ok, _} <- Repo.transaction(renewal),
         registration <- Repo.one!(Query.registration_by(%{email: r.email})) do
      {:ok, registration}
    else
      {:error, _step, error, _changes} ->
        {:error, error}
    end
  end
end
