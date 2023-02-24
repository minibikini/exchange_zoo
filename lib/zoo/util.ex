defmodule Zoo.Util do
  def underscore_keys(data) when is_map(data) do
    data
    |> Enum.map(fn {k, v} ->
      case v do
        v when is_map(v) ->
          {Macro.underscore(k), underscore_keys(v)}

        v when is_list(v) ->
          {Macro.underscore(k), Enum.map(v, &underscore_keys/1)}

        _ ->
          {Macro.underscore(k), v}
      end
    end)
    |> Enum.into(%{})
  end

  def update_values(attrs, keys, update_fn) do
    Enum.reduce(keys, attrs, fn key, acc ->
      {_, attrs} = Map.get_and_update(acc, key, fn v -> {v, update_fn.(v)} end)
      attrs
    end)
  end
end
