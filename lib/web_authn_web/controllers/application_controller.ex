defmodule WebAuthnWeb.ApplicationController do
  use WebAuthnWeb, :controller

  def new(conn, _) do
    render(conn, "new.html")
  end
end
