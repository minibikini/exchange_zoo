defmodule Mix.Zoo.Model do
  defstruct name: nil, types: nil

  def valid?(name) do
    name =~ ~r/^[A-Z]\w*(\.[A-Z]\w*)*$/
  end

  def new(model_name, cli_attrs) do
    attrs = extract_attr_flags(cli_attrs)

    %__MODULE__{
      name: model_name,
      types: types(attrs)
    }
  end

  defp types(attrs) do
    Enum.into(attrs, %{}, fn {key, val} -> {key, val} end)
  end

  def format_fields_for_schema(schema) do
    Enum.map_join(schema.types, "\n", fn {k, v} ->
      "    field #{inspect(k)}, #{inspect(v)}"
    end)
  end

  def extract_attr_flags(cli_attrs) do
    Enum.map(cli_attrs, fn attr ->
      [attr_name, type] = String.split(attr, ":")
      {String.to_atom(attr_name), type}
    end)
  end
end
