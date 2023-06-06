defmodule Mix.Zoo.Exchange do
  @moduledoc false

  defstruct name: nil, handle: nil

  def valid?(name) do
    name =~ ~r/^[A-Z]\w*(\.[A-Z]\w*)*$/
  end

  def new(module_name, opts) do
    handle = Keyword.get(opts, :handle, Macro.underscore(module_name))

    %__MODULE__{
      name: module_name,
      handle: handle
    }
  end
end
