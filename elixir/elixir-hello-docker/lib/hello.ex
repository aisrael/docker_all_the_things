defmodule Hello do
  @moduledoc """
  Documentation for Hello.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Hello.hello
      :world

  """
  def hello([]) do
    :world
  end

  def hello([who|_]) do
    who
  end

  def main(args) do
    IO.puts "Hello, #{Hello.hello(args)}!"
  end
end
