defmodule WebAuthnWeb.RegistrationController do
  use WebAuthnWeb, :controller

  alias WebAuthn.Registrations
  alias WebAuthnWeb.RegistrationParams

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def challenge(conn, params) do
    with {:ok, valid_params} <- RegistrationParams.challenge(params) |> IO.inspect(),
         {:ok, registration} <- Registrations.initiate(valid_params) do
      conn
      |> put_status(:ok)
      |> render("challenge.json", registration: registration)
    end
  end

  def public_key(conn, params) do
  end
end
