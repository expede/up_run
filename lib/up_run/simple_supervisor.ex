defmodule UpRun.SimpleSupervisor do
  use Supervisor

  def start_link, do: Supervisor.start_link(__MODULE__, [])

  def init(_) do
    children = [
      worker(UpRun.SimpleServer, [])
    ]

    supervise(children, strategy: :one_for_one)
  end
end
