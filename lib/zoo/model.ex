defmodule ExchangeZoo.Model do
  defmacro __using__(_opts) do
    quote location: :keep do
      use Ecto.Schema
      import Ecto.Changeset
      import ExchangeZoo.Util

      def from!(data) do
        data = underscore_keys(data)

        __MODULE__
        |> struct()
        |> changeset(data)
        |> apply_action!(:insert)
      end
    end
  end
end
