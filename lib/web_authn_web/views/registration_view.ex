defmodule WebAuthnWeb.RegistrationView do
  use WebAuthnWeb, :view

  def render("base.json", %{registration: r}) do
    %{object: "registration", status: r.status, uid: r.uid}
  end

  def render("init.json", %{registration: r}) do
    r
    |> render_one(WebAuthnWeb.RegistrationView, "base.json")
    |> Map.merge(render_one(r, WebAuthnWeb.RegistrationView, "registration.json"))
    |> Map.merge(render_one(r, WebAuthnWeb.RegistrationView, "instruction.json"))
  end

  def render("registration.json", %{registration: r}) do
    %{email: r.email, name: r.name}
  end

  def render("instruction.json", %{registration: r}) do
    %{instruction: r.instruction}
    |> Map.merge(render_instruction(r))
  end

  defp render_instruction(%{instruction: :credential, credential: c}) do
    %{
      credential: %{
        uid: c.uid,
        challenge: c.challenge,
        rp: %{
          id: c.rp_id,
          name: c.rp_name
        },
        user: %{
          id: c.user_uid,
          name: c.username,
          display_name: c.display_name
        },
        public_key_credential_params: [
          %{
            alg: -7,
            type: "public-key"
          }
        ],
        timeout: c.timeout,
        attestation: c.attestation,
        user_verification: c.user_verification
      }
    }
  end

  def render("credential.json", %{registration: r}) do
    r
    |> render_one(WebAuthnWeb.RegistrationView, "base.json")
  end

  def render("temp.json", _assigns) do
    %{test: true}
  end
end
