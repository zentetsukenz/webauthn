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

  def verify(%{challenge: challenge, credential: credential}) do
    %{
      client_data: client_data
    } = credential

    IO.inspect(client_data)

    with {:ok, decoded_client_data} <- decode_client_data(client_data) do
      IO.inspect(decoded_client_data)
      {:ok, nil}
    end
  end

  defp decode_client_data(client_data) do
    Base.decode64(client_data)
  end
end
