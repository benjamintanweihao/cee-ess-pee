defmodule VendingMachine.GenServer.X1Test do
  use ExUnit.Case
  alias VendingMachine.GenServer.X1

  test "vending machine crashes when after adding coin" do
    Process.flag(:trap_exit, true)

    {:ok, pid} = X1.start_link

    assert catch_exit(X1.coin(pid))
  end

end

