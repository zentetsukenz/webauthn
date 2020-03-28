defmodule WebAuthnWeb.RegistrationController do
  use WebAuthnWeb, :controller

  alias WebAuthn.Registrations
  alias WebAuthnWeb.RegistrationParams

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"step" => "init"} = params) do
    with {:ok, valid_params} <- RegistrationParams.credential_options(params),
         {:ok, registration} <- Registrations.initiate(valid_params) do
      conn
      |> put_status(:ok)
      |> render("init.json", registration: registration)
    end
  end

  def create(conn, %{"step" => "credential"} = params) do
    with {:ok, valid_params} <- RegistrationParams.public_key(params),
         {:ok, _registration} <- Registrations.verify(valid_params) do
      conn
      |> put_status(:ok)
      |> render("temp.json")
    end
  end
end
