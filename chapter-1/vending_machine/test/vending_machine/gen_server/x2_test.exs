defmodule VendingMachine.GenServer.X2Test do
  use ExUnit.Case
  alias VendingMachine.GenServer.X2

  test "vending machine crashes serving two customers" do
    Process.flag(:trap_exit, true)

    {:ok, pid} = X2.start_link

    assert :choc = X2.coin(pid)
    assert :choc = X2.coin(pid)
    assert catch_exit(X2.coin(pid))
  end

end

