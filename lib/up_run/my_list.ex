defmodule UpRun.MyList do
  alias __MODULE__

  @type t :: %MyList{
    value: any(),
    link: t() | nil
  }

  defstruct value: nil, link: nil

  @spec new() :: t()
  def new(), do: %MyList{}

  @spec new(nil | any()) :: t()
  def new(nil), do: %MyList{}
  def new(value), do: %MyList{value: value}

  @spec cons(t(), any()) :: t()
  def cons(link, value \\ nil) do
    %MyList{
      value: value,
      link: link
    }
  end
end
