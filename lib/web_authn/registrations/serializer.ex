defmodule WebAuthn.Registrations.Serializer do
  alias WebAuthn.Registrations.{
    Registration,
    Object
  }

  def serialize({:ok, %Registration{} = registration}) do
    o =
      %Object{}
      |> serialize_registration(registration)
      |> serialize_instruction(registration)

    {:ok, o}
  end

  def serialize({:error, %Ecto.Changeset{} = changeset}) do
    {:error, changeset}
  end

  defp serialize_registration(%Object{} = o, %Registration{} = r) do
    %{o | uid: to_string(r.id), status: r.status, email: r.email, name: r.name}
  end

  defp serialize_instruction(%Object{} = o, %Registration{status: "pending"} = r) do
    %{o | instruction: :public_key}
    |> serialize_public_key(r)
  end

  defp serialize_instruction(%Object{} = o, %Registration{status: "complete"}) do
    %{o | instruction: nil}
  end

  defp serialize_public_key(%Object{} = o, %Registration{} = r) do
    c =
      r.challenges
      |> Enum.find(fn c -> c.status == "active" end)

    %{o | public_key: %{challenge: c.challenge}}
  end
end
