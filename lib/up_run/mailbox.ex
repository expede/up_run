defmodule UpRun.Mailbox do
  def start_link, do: Task.start_link(fn -> loop() end)

  def loop() do
    receive do
      {:msg, message} ->
        IO.puts "Got: #{message}"
        loop()

      bad ->
        IO.puts "Eh? I don't understand #{inspect bad}"
        loop()
    end
  end
end
