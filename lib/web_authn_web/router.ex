defmodule WebAuthnWeb.Router do
  use WebAuthnWeb, :router

  pipeline :auth_browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", WebAuthnWeb do
    pipe_through :auth_browser

    get "/page", PageController, :index
  end

  scope "/", WebAuthnWeb do
    pipe_through :browser

    get "/", RegistrationController, :new
  end

  scope "/register", WebAuthnWeb do
    pipe_through :api

    post "/", RegistrationController, :create
  end
end
