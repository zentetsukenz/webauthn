defmodule WebAuthn.Changeset do
  defmacro __using__(_) do
    quote do
      import Ecto.Changeset

      def generate_uid(changeset, prefix)
      def generate_uid(%{changes: %{uid: uid}} = c, _) when not is_nil(uid), do: c

      def generate_uid(changeset, prefix) do
        changeset |> put_change(:uid, prefix <> "_" <> ExULID.ULID.generate())
      end
    end
  end
end
