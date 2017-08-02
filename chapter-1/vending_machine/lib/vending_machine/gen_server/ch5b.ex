defmodule GenServer.Ch5b do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, :ok)
  end

  def in5p(pid) do
    GenServer.call(pid, :in5p)
  end

  def init(:ok) do
    {:ok, %{}}
  end

  def handle_call(:in5p, {pid, _}, state) do
    send(pid, :out1p)
    send(pid, :out1p)
    send(pid, :out1p)
    send(pid, :out2p)

    {:reply, :ok, state}
  end

end
