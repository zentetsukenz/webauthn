defmodule WebAuthnWeb.Router do
  use WebAuthnWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  scope "/", WebAuthnWeb do
    pipe_through :browser

    get "/", RegistrationController, :new
  end
end
