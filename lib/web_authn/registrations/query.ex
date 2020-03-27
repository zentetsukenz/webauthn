defmodule WebAuthn.Registrations.Query do
  import Ecto.Query

  alias WebAuthn.Registrations.Registration

  def registration_by(%{email: email}) do
    from r in Registration,
      join: c in assoc(r, :challenges),
      where: r.email == ^email and c.status == "active",
      preload: [:challenges]
  end
end
