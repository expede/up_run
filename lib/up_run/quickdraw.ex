defmodule UpRun.Quickdraw do
  @moduledoc ~S"""
  Game instructions:

  1. `iex --sname your_name --cookie monster -S mix`
  2. `alias UpRun.Quickdraw, as: QD`
  3. `{:ok, me} = QD.spawn(:john_wayne)`
  4. `target = {:clint_eastwood, "machine_address"}`
  4. Someone (possibly a third person) `QD.pace([me, target])`
  5. `QD.fire(me, target)`
  """

  use GenServer

  # ========== #
  # Client API #
  # ========== #

  def spawn(name \\ :player) do
    {:ok, pid} = GenServer.start_link(__MODULE__, :ok)
    Process.register(pid, name)

    me = {name, Node.self()}
    GenServer.call(pid, {:name, me})

    {:ok, me}
  end

  @doc "Timer for draw"
  def pace(player_pids) do
    Task.start(fn ->
      5_000..20_000 |> Enum.random() |> Process.sleep()
      Enum.each(player_pids, &GenServer.cast(&1, :draw))
    end)
  end

  def fire(shooter_pid, target_pid) do
    if GenServer.call(shooter_pid, :alive?) do
      GenServer.cast(target_pid, {:bullet, shooter_pid})
    else
      IO.puts "Not time to shoot yet!"
    end
  end

  def scoreboard(pid), do: GenServer.call(pid, :get_score)

  # ========== #
  # Server API #
  # ========== #

  # Setup
  # -----

  def init(:ok), do: {:ok, %{alive: false, score: %{}}}

  def handle_info(_unkown, status), do: {:noreply, status}

  # Sync
  # ----

  def handle_call(:alive?,       _from, status), do: {:reply, status.alive, status}
  def handle_call(:get_score,    _from, status), do: {:reply, status.score, status}
  def handle_call({:name, name}, _from, status), do: {:reply, name, Map.put(status, :name, name)}

  # Async
  # -----

  def handle_cast(:draw, status) do
    IO.puts "🔫 DRAW!"
    {:noreply, %{status | alive: true}}
  end

  def handle_cast({:won, {opponent_pid, opponent_room}}, %{score: score} = status) do
    opponent_name  = "#{opponent_pid}/#{opponent_room}"
    opponent_score = Map.get(score, opponent_name, 0)
    new_score      = Map.put(score, opponent_name, opponent_score + 1)

    IO.puts "🎉 Nice shot!"
    {:noreply, %{status | score: new_score}}
  end

  def handle_cast({:bullet, _}, %{alive: false} = status), do: {:noreply, status}

  def handle_cast({:bullet, {opponent_pid, opponent_room} = opponent}, %{score: score} = status) do
    opponent_name  = "#{opponent_pid}/#{opponent_room}"
    opponent_score = Map.get(score, opponent_name, 0)
    new_score      = Map.put(score, opponent_name, opponent_score - 1)

    IO.puts "☠️ Got hit by #{opponent_pid}"
    GenServer.cast(opponent, {:won, status.name})

    {:noreply, %{status | score: new_score, alive: false}}
  end
end
