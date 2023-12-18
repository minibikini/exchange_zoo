defmodule Mix.Zoo do
  # Conveniences for Phoenix tasks.
  @moduledoc false

  @app :exchange_zoo

  @doc """
  Evals EEx files from source dir.

  Files are evaluated against EEx according to the given binding.
  """
  def eval_from(source_file_path, binding) do
    source = Application.app_dir(@app, source_file_path)

    content =
      (File.exists?(source) && File.read!(source)) ||
        raise "could not find #{source_file_path} in any of the sources"

    EEx.eval_string(content, binding)
  end

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

  @doc """
  Evals EEx in source file and injects before final end in target file.

  Files are evaluated against EEx according to the given binding.
  """
  def inject_from(source_file, target_file, binding) do
    content_to_inject = eval_from(source_file, assigns: binding)
    inject_eex_before_final_end(content_to_inject, target_file)
  end

  defp inject_eex_before_final_end(content_to_inject, file_path) do
    file = File.read!(file_path)

    if String.contains?(file, content_to_inject) do
      :ok
    else
      Mix.shell().info([:green, "* injecting ", :reset, Path.relative_to_cwd(file_path)])

      file
      |> String.trim_trailing()
      |> String.trim_trailing("end")
      |> Kernel.<>(content_to_inject)
      |> Kernel.<>("end\n")
      |> write_file(file_path)
    end
  end

  defp write_file(content, file), do: File.write!(file, content)
end
