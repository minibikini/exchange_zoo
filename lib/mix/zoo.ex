defmodule Mix.Zoo do
  # Conveniences for Phoenix tasks.
  @moduledoc false

  @app :exchange_zoo

  @doc """
  Copies files from source dir to target dir according to the given map.

  Files are evaluated against EEx according to the given binding.
  """
  def copy_from(source_dir, binding, mapping) when is_list(mapping) do
    for {source_file_path, target} <- mapping do
      path = Path.join([source_dir, source_file_path])
      source = Application.app_dir(@app, path)

      Mix.Generator.copy_template(source, target, binding)
    end
  end
end
