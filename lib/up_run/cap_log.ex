defmodule UpRun.CapLog do
  @moduledoc "Captain Log system built with GenEvent"

  use GenEvent

  @doc "Starts a new Captain's Log"
  def new(), do: GenEvent.start_link([])

  @doc "Attach a new handler module starting with a blank list"
  def attach_handler(pid, handler_module) do
    GenEvent.add_handler pid, handler_module, []
  end
end
