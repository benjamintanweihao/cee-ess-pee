defmodule VendingMachine.GenServer.VMSTest do
  use ExUnit.Case
  alias VendingMachine.GenServer.VMS

  test "vending machine serves as many chocs as required" do
    {:ok, pid} = VMS.start_link

    1..5 |> Enum.each(fn _ ->
      assert :choc = VMS.coin(pid)
    end)

  end

end

