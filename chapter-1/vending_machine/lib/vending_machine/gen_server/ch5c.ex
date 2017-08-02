defmodule GenServer.Ch5c do
  use GenServer

  def start_link(change \\ []) do
    GenServer.start_link(__MODULE__, change)
  end

  def in5p(pid) do
    GenServer.call(pid, :in5p)
  end

  def init(change) do
    {:ok, change}
  end

  def handle_call(:in5p, _from, []) do
    {:stop, :no_more_change, []}
  end

end
