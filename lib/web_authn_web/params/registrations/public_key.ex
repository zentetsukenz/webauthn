defmodule WebAuthnWeb.RegistrationParams.PublicKey do
  use WebAuthnWeb.ParamSchema
  import Ecto.Changeset

  embedded_schema do
    field(:challenge, :string)

    embeds_one :credential, Credential, primary_key: false do
      field(:id, :string)
      field(:raw_id, :string)
      field(:type, :string)
      field(:attestation_object, :string)
      field(:client_data, :string)
      field(:registration_client_extensions, :string)
    end
  end

  def changeset(public_key, params \\ %{}) do
    public_key
    |> cast(params, [:challenge])
    |> validate_required([:challenge])
    |> cast_embed(:credential, with: &credential_changeset/2)
  end

  defp credential_changeset(credential, params) do
    credential
    |> cast(params, [
      :id,
      :raw_id,
      :type,
      :attestation_object,
      :client_data,
      :registration_client_extensions
    ])
    |> validate_required([
      :id,
      :raw_id,
      :type,
      :attestation_object,
      :client_data,
      :registration_client_extensions
    ])
  end
end
