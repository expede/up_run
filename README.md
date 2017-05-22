# Up & Running with Elixir & Phoenix

![](https://github.com/robot-overlord/up_run/blob/master/priv/logo.png?raw=true)

## Installation

```shell
> mix deps.get
```

## How to play the Quickdraw demo

```elixir
# You need to use your own address. 10.1.10.42 probably won't work for you.
# You can use `ipconfig getifaddr en0` to find your local address
#                     vvvvvvvvvv
> iex --name shootout@10.1.10.42 --cookie monster -S mix
# Erlang/OTP 19 [erts-8.3] [source] [64-bit] [smp:4:4] [async-threads:10] [hipe] [kernel-poll:false] [dtrace]
# Interactive Elixir (1.4.4) - press Ctrl+C to exit (type h() ENTER for help)

iex(shootout@10.1.10.42)1> use UpRun.Quickdraw, player: :dolores
# 11:10:02.107 [info]  Your player address is: {:dolores, :"shootout@10.1.10.42"}
# :ok

iex(shootout@10.1.10.42)2> me = {:dolores, :shootout@10.1.10.42}
# 11:40:23.405 [info]  Your player address is: {:dolores, :"shootout@10.1.10.42"}

iex(shootout@10.1.10.42)3> target = {:ford, :"shootout@10.1.10.13"}
# {:ford, :"shootout@10.1.10.13"}

# *** Wait for sherif to print `🔫 DRAW!` ***

iex(shootout2@10.1.10.42)4> me |> fire(target)
# :ok
# 🎉 Nice shot! (Or maybe you get hit instead)

iex(shootout2@10.1.10.42)5> alive? me
# true (or maybe false)

iex(shootout2@10.1.10.42)6> scoreboard me
# %{...}
```
