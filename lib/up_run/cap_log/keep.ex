defmodule UpRun.CapLog.Keep do
  use GenEvent

  @doc "Start a new permanent list"
  def init(_), do: {:ok, []}

  @doc """
  Synchronous calls. Only listens for `:get` to print out the existing list
  in reverse order (ie: reading order)
  """
  def handle_call(:get, logs), do: {:ok, Enum.reverse(logs), logs}
  def handle_call(_, logs), do: {:ok, logs, logs}

  @doc """
  Asynchronous calls. Listens for:

  - `:log` -> log a generic message (`"WIN"`)
  - `{:log, message}` -> adds a new log to the list
  """
  def handle_event(:log, logs), do: {:ok, ["WIN" | logs]}
  def handle_event({:log, msg}, logs), do: {:ok, [msg | logs]}
  def handle_event(_, logs), do: {:ok, logs}
end
