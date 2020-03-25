defmodule WebAuthn.Repo do
  use Ecto.Repo,
    otp_app: :web_authn,
    adapter: Ecto.Adapters.Postgres
end
