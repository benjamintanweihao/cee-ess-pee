defmodule VendingMachine.GenServer.X2 do
  @moduledoc """
  A simple vending machine that successfully serves two customers before
  breaking.
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

  def handle_call(:coin, _from, %{dispensed: dispensed}) when length(dispensed) == 2 do
    {:stop, :broken, :broken}
  end

  def handle_call(:coin, _from, state) do
    new_dispensed = [:choc | state.dispensed]
    {:reply, :choc, %{state | dispensed: new_dispensed}}
   end

end
