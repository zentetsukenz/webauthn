defmodule WebAuthnWeb.AuthenticationController do
  use WebAuthnWeb, :controller

  def new(conn, _params) do
    render(conn, "new.html")
  end
end
