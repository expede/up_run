defmodule UpRun.Commands do
  @callback ask() :: {:ok, any()} | {:error, String.t()}
  @callback tell() :: :ok | {:error, String.t()}
end
