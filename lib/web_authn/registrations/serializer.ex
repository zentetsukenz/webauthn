defmodule WebAuthn.Registrations.Serializer do
  alias WebAuthn.Registrations.{
    Registration,
    Object
  }

  def serialize({:ok, %Registration{} = registration}) do
    o =
      %Object{}
      |> serialize_registration(registration)
      |> serialize_instruction(registration)

    {:ok, o}
  end

  def serialize({:error, %Ecto.Changeset{} = changeset}) do
    {:error, changeset}
  end

  defp serialize_registration(%Object{} = o, %Registration{} = r) do
    %{o | uid: to_string(r.uid), status: r.status, email: r.email, name: r.name}
  end

  defp serialize_instruction(%Object{} = o, %Registration{status: "pending"} = r) do
    %{o | instruction: :credential}
    |> serialize_credential_instruction(r)
  end

  defp serialize_instruction(%Object{} = o, %Registration{status: "complete"}) do
    %{o | instruction: nil}
  end

  defp serialize_credential_instruction(%Object{} = o, %Registration{} = r) do
    c = r.challenges |> Enum.find(fn c -> c.status == "active" end)

    %{
      o
      | credential: %{
          uid: c.uid,
          challenge: c.challenge,
          rp_name: c.relying_party_name,
          rp_id: c.relying_party_id,
          user_uid: c.user_uid,
          username: c.username,
          display_name: c.display_name,
          timeout: c.timeout,
          attestation: c.attestation,
          user_verification: c.user_verification
        }
    }
  end
end
