defmodule WebAuthn.Registrations.Object do
  @type t :: %__MODULE__{
          uid: String.t(),
          status: status(),
          email: String.t(),
          name: String.t(),
          instruction: instruction(),
          public_key: public_key()
        }

  @type status :: :pending | :complete
  @type instruction :: :public_key
  @type public_key :: %{
          challenge: String.t()
        }

  defstruct(
    uid: nil,
    status: nil,
    email: nil,
    name: nil,
    instruction: nil,
    public_key: nil
  )
end
