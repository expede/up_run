defmodule UpRun.ScanDB do
  use GenServer

  # ========== #
  # Client API #
  # ========== #

  def new, do: GenServer.start_link(__MODULE__, :ok)

  def push(pid, key, value), do: GenServer.cast(pid, {:set, key, value})

  def get(pid, key), do: GenServer.call(pid, {:get, key})
  def dump(pid), do: GenServer.call(pid, {:get_all})

  # ========== #
  # Server API #
  # ========== #

  def init(:ok), do: {:ok, %{}}

  def handle_call({:get_all}, _from, store) do
    {:reply, store, store}
  end

  def handle_call({:get, key}, _from, store) do
    {:reply, Map.get(store, key), store}
  end

  def handle_cast({:set, key, value}, store) do
    scan =
      case Map.get(store, key) do
        nil  -> [value]
        list -> [value | list]
      end

    {:noreply, Map.put(store, key, scan)}
  end

  def handle_info(_unkown, store) do
    {:noreply, store}
  end
end
