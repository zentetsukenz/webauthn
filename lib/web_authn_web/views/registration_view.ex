defmodule WebAuthnWeb.RegistrationView do
  use WebAuthnWeb, :view

  alias WebAuthnWeb.Router.Helpers, as: Routes
  alias WebAuthnWeb.Endpoint

  def render("base.json", %{registration: r}) do
    %{object: "registration", status: r.status, uid: r.uid}
  end

  def render("challenge.json", %{registration: r}) do
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

  defp render_instruction(%{instruction: :public_key, public_key: p}) do
    %{
      public_key: %{
        location: Routes.registration_url(Endpoint, :public_key),
        challenge: p.challenge
      }
    }
  end
end
