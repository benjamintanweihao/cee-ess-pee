defmodule VendingMachine.GenServer.VMS do
  @moduledoc """
  A simple vending machine which serves as many chocs as required.
  """
  use GenServer

  defmodule State do
    defstruct dispensed: []
  end

  def start_link do
    GenServer.start_link(__MODULE__, :ok)
  end

  def coin(pid) do
    GenServer.call(pid, :coin)
  end

  def init(:ok) do
    {:ok, %State{}}
  end

  def handle_call(:coin, _from, state) do
    new_dispensed = [:choc | state.dispensed]
    {:reply, :choc, %{state | dispensed: new_dispensed}}
  end

end
