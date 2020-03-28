defmodule WebAuthn.Registrations.Object do
  @type t :: %__MODULE__{
          uid: String.t(),
          status: status(),
          email: String.t(),
          name: String.t(),
          instruction: instruction(),
          credential: credential()
        }

  @type status :: :pending | :complete
  @type instruction :: :credential
  @type credential :: %{
          uid: String.t(),
          challenge: String.t(),
          rp_name: String.t(),
          rp_id: String.t(),
          user_uid: String.t(),
          username: String.t(),
          display_name: String.t(),
          timeout: integer(),
          attestation: attestation(),
          user_verification: user_verification()
        }

  @type attestation :: :direct | :indirect | :none
  @type user_verification :: :required | :preferred | :discouraged

  defstruct(
    uid: nil,
    status: nil,
    email: nil,
    name: nil,
    instruction: nil,
    credential: nil
  )
end
