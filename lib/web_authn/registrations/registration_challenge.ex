defmodule WebAuthn.Registrations.RegistrationChallenge do
  use Ecto.Schema
  use WebAuthn.Changeset

  alias WebAuthn.Registrations.Registration

  @uid_prefix "chlg"
  @statuses ["active", "inactive"]
  @attestations ["none", "indirect", "direct"]
  @user_verifications ["required", "preferred", "discouraged"]

  schema "registration_challenges" do
    field :uid, :string
    field :challenge, :string
    field :relying_party_name, :string
    field :relying_party_id, :string
    field :user_uid, :string
    field :username, :string
    field :display_name, :string
    field :timeout, :integer
    field :attestation, :string
    field :user_verification, :string
    field :status, :string

    belongs_to(:registration, Registration)

    timestamps()
  end

  def changeset(challenge, params \\ %{}) do
    challenge
    |> cast(params, [
      :relying_party_name,
      :relying_party_id,
      :username,
      :display_name,
      :timeout,
      :attestation,
      :user_verification,
      :status,
      :registration_id
    ])
    |> generate_uid(@uid_prefix)
    |> generate_challenge()
    |> generate_user_uid()
    |> validate_required([
      :uid,
      :challenge,
      :relying_party_name,
      :relying_party_id,
      :user_uid,
      :username,
      :display_name,
      :timeout,
      :attestation,
      :user_verification,
      :status,
      :registration_id
    ])
    |> validate_inclusion(:status, @statuses)
    |> validate_inclusion(:attestation, @attestations)
    |> validate_inclusion(:user_verification, @user_verifications)
    |> validate_length(:challenge, min: 16, count: :bytes)
  end

  defp generate_challenge(changeset)
  defp generate_challenge(%{changes: %{challenge: c}}) when not is_nil(c), do: c

  defp generate_challenge(changeset) do
    changeset
    |> put_change(:challenge, random_bytes())
  end

  defp generate_user_uid(changeset)
  defp generate_user_uid(%{changes: %{user_uid: u}}) when not is_nil(u), do: u

  defp generate_user_uid(changeset) do
    changeset
    |> put_change(:user_uid, random_bytes())
  end

  defp random_bytes(len \\ 32) do
    Base.encode64(:crypto.strong_rand_bytes(len))
  end
end
