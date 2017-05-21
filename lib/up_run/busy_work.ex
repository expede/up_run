defmodule UpRun.BusyWork do

  def run do
    Enum.each(0..99, fn n ->
      spawn(fn ->
        IO.puts "New process #{n}"

        Enum.each(0..999, fn m ->
          spawn(fn ->
            name = "⚙ #{(n * 100) + m}"
            IO.puts "🌟 Start  #{name}"

            time =
              [10, 500, 1000, 2000, 5000]
              |> Enum.random()
              |> :rand.uniform()

            Process.sleep(time)

            IO.puts "🏁 Finish #{name} in 🕒 #{time}ms"
          end)
        end)
      end)
    end)
  end
end
