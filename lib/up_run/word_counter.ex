defmodule UpRun.WordCounter do

  @text_file_path "./priv/WarAndPeace.txt"

  @ignore [""] ++ ~W(
    the or to a and or his her their in this that will was of
    with is be him her had have he she it i me you at not on as
    but said for all any from if no an so been are now then esle
    all from were by they who which one what my yours your
  )

  def concurrent(agent_name \\ :tally) do
    {:ok, agent} = Agent.start_link(fn -> %{} end)
    Process.register(agent, agent_name)

    Task.async(fn ->
      @text_file_path
      |> File.stream!()
      |> Stream.chunk(500)
      |> Task.async_stream(fn chunks ->
        chunks
        |> Enum.flat_map(&String.split(&1, " "))
        |> Enum.each(fn word ->
          cleaned_word =
            word
            |> String.trim()
            |> String.replace(~r/[.,!?;”\-\(\)\/]/, "")
            |> String.downcase()

          unless Enum.member?(@ignore, cleaned_word) do
            Agent.update(agent, fn words ->
              Map.update(words, cleaned_word, 1, &(&1 + 1))
            end)
          end
        end)
      end)
      |> Stream.run()
    end)
  end

  def sync() do
    @text_file_path
    |> File.read!()
    |> String.split("\n")
    |> Enum.flat_map(&String.split(&1, " "))
    |> Enum.reduce(%{}, fn(word, acc) ->
      cleaned_word = word |> String.trim() |> String.downcase()
      Map.update(acc, cleaned_word, 1, &(&1 + 1))
    end)
  end
end
