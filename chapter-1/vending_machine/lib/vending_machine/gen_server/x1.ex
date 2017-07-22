defmodule VendingMachine.GenServer.X1 do
  @moduledoc """
  A simple vending machine which consumes one coin before breaking.
  """

  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, :ok)
  end

  def coin(pid) do
    GenServer.call(pid, :coin)
  end

  def init(:ok) do
    {:ok, %{state: :started}}
  end

  def handle_call(:coin, _from, state) do
    {:stop, :broken, :broken}
   end

end
