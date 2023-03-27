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

  def prepare_enums(attrs, keys) do
    update_values(attrs, keys, fn
      v when is_list(v) -> Enum.map(v, &String.downcase/1)
      v when is_binary(v) -> String.downcase(v)
      v -> v
    end)
  end
end
