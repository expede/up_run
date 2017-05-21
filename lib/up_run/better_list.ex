defmodule UpRun.BetterList do
  @type t :: Empty.t() | Cons.t()

  defmodule Empty do
    @type t :: %Empty{}
    defstruct []

    def new(), do: %Empty{}
  end

  defmodule Cons do
    @behaviour Access

    @type t :: %Cons{
      value: any(),
      link: MyList.t()
    }
    defstruct value: nil, link: %Empty{}

    @spec new(any()) :: t()
    def new(value), do: UpRun.BetterList.Empty.new() |> cons(value)

    @spec cons(t(), any()) :: t()
    def cons(list, value \\ nil) do
      %Cons{
        value: value,
        link: list
      }
    end

    def fetch(%Cons{value: value}, 0), do: {:ok, value}
    def fetch(%Cons{value: value, link: link}, index), do: fetch(link, index - 1)
    def fetch(_, _), do: :error

    def get(list, index, default) do
      case fetch(list, index) do
        {:ok, value} -> value
        :error       -> default
      end
    end

    def get_and_update(list, index, fun) do
      get_and_update(list, [], index, fun)
    end

    @spec get_and_update(t(), [t()], non_neg_integer(), fun()) :: {any(), t()}
    def get_and_update(%Cons{value: value, link: link}, acc_list, 0, fun) do
      case fun.(value) do
        :pop ->
          pop(link, 0, acc_list)

        {old_value, new_value} ->
          new_node = %Cons{value: new_value, link: link}
          new_list = Enum.reduce(acc_list, new_node, &cons(&2, &1))
          {value, new_list}
      end
    end

    def get_and_update(%Cons{value: value, link: link}, acc_list, index, fun) do
      get_and_update(link, [value | acc_list], index - 1, fun)
    end

    def pop(list, index), do: pop(list, index, [])

    def pop(%{value: value, link: link}, acc_list, 0) do
      new_list = Enum.reduce(acc_list, link, &cons(&2, &1))
      {value, new_list}
    end

    def pop(%{value: value, link: link}, acc_list, index) do
      pop(link, index - 1, [value | acc_list])
    end
  end

  def append(%Empty{}, bs), do: bs
  def append(%Cons{value: value, link: link}, bs) do
    link
    |> append(bs)
    |> cons(value)

    # Equivalent:
    #   new_inner = MyList.append(link, bs)
    #   MyList.cons(new_inner, value)
  end

  @spec count(t()) :: non_neg_integer()
  def count(%Empty{}), do: 0
  def count(%{link: link}), do: 1 + count(link)

  @spec new() :: Empty.t()
  def new(), do: Empty.new()

  @spec new(any()) :: Cons.t()
  def new(value), do: Cons.new(value)

  @spec cons(t(), any()) :: t()
  def cons(list, value \\ nil), do: Cons.cons(list, value)
end
