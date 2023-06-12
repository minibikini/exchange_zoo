defmodule ExchangeZoo.Model do
  defmacro __using__(_opts) do
    quote location: :keep do
      use Ecto.Schema
      import Ecto.Changeset
      import ExchangeZoo.Model

      def from!(data) do
        __MODULE__
        |> struct()
        |> changeset(data)
        |> apply_action!(:insert)
      end

      def enum_fields() do
        Enum.filter(__MODULE__.__schema__(:fields), fn field ->
          case __MODULE__.__schema__(:type, field) do
            {:parameterized, Ecto.Enum, _} -> true
            _ -> false
          end
        end)
      end
    end
  end

  def map_keys(attrs, fields) do
    Enum.into(attrs, %{}, fn {k, v} -> {fields[k], v} end)
  end

  def underscore_keys(data) when is_map(data) do
    data
    |> Enum.map(fn {k, v} -> {Macro.underscore(k), underscore_keys(v)} end)
    |> Enum.into(%{})
  end

  def underscore_keys(data) when is_list(data),
    do: Enum.map(data, &underscore_keys/1)

  def underscore_keys(data), do: data

  def update_values(attrs, keys, update_fn) do
    Enum.reduce(keys, attrs, fn key, acc ->
      {_, attrs} = Map.get_and_update(acc, key, fn v -> {v, update_fn.(v)} end)
      attrs
    end)
  end

  def prepare_enums(attrs, keys, prep_fun \\ fn v -> Macro.underscore(v) end) do
    update_values(attrs, keys, fn
      v when is_list(v) -> Enum.map(v, prep_fun)
      v when is_binary(v) -> prep_fun.(v)
      v -> v
    end)
  end
end
