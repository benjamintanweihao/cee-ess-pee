defmodule VendingMachineTest do
  use ExUnit.Case
  alias VendingMachine, as: VM

  describe "1.1.1 Prefix" do
    test "A VM which consumes on coin before breaking" do
      vm = spawn(VM.Prefix, :x1, [])
      cust = self()

      assert Process.alive?(vm)
      send(vm, {:coin, cust})
      assert_receive :stop
      refute Process.alive?(vm)
    end

    test "A VM that successfully serves two customers before breaking" do
      vm = spawn(VM.Prefix, :x2, [])
      cust = self()

      assert Process.alive?(vm)

      0..1 |> Enum.each(fn _ ->
        send(vm, {:coin, cust})
        assert_receive :ok
        send(vm, {:choc, cust})
        assert_receive :ok
      end)

      refute Process.alive?(vm)
    end
  end

  describe "1.1.2 Recursion" do
    test "A VM which serves as many chocs as required" do
      vm = spawn(VM.Recursion, :vms, [])
      cust = self()

      assert Process.alive?(vm)

      0..6 |> Enum.each(fn _ ->
        send(vm, {:coin, cust})
        assert_receive :ok
        send(vm, {:choc, cust})
        assert_receive :ok
      end)

      assert Process.alive?(vm)
    end

    test "A VM that gives change for 5p repeatedly" do
      vm = spawn(VM.Recursion, :ch5a, [])
      cust = self()

      assert Process.alive?(vm)

      send(vm, {:in5p, cust})
      assert_receive :ok

      send(vm, {:out2p, cust})
      assert_receive :ok

      send(vm, {:out1p, cust})
      assert_receive :ok

      send(vm, {:out2p, cust})
      assert_receive :ok

      # Complete one round + 1 more event
      send(vm, {:in5p, cust})
      assert_receive :ok
    end

    test "A VM that gives change for 5p slightly differently from ch5a" do
      vm = spawn(VM.Recursion, :ch5b, [])
      cust = self()

      assert Process.alive?(vm)

      send(vm, {:in5p, cust})
      assert_receive :ok

      send(vm, {:out1p, cust})
      assert_receive :ok

      send(vm, {:out1p, cust})
      assert_receive :ok

      send(vm, {:out1p, cust})
      assert_receive :ok

      send(vm, {:out2p, cust})
      assert_receive :ok

      # Complete one round + 1 more event
      send(vm, {:in5p, cust})
      assert_receive :ok
    end
  end

  describe "1.1.3 Choice" do
    test "A VM which offers a choice of two combinations of change for 5p." do
      vm = spawn(VM.Choice, :ch5c, [])
      cust = self()

      assert Process.alive?(vm)

      # handle out1p

      send(vm, {:in5p, cust})
      assert_receive :ok

      send(vm, {:out1p, cust})
      assert_receive :ok

      send(vm, {:out1p, cust})
      assert_receive :ok

      send(vm, {:out1p, cust})
      assert_receive :ok

      send(vm, {:out2p, cust})
      assert_receive :ok

      # handle out2p

      send(vm, {:in5p, cust})
      assert_receive :ok

      send(vm, {:out2p, cust})
      assert_receive :ok

      send(vm, {:out1p, cust})
      assert_receive :ok

      send(vm, {:out2p, cust})
      assert_receive :ok

      assert Process.alive?(vm)
    end

    test "A VM that serves either chocolate or toffee on each transaction" do
      vm = spawn(VM.Choice, :vmct, [])
      cust = self()

      assert Process.alive?(vm)

      send(vm, {:coin, cust})
      assert_receive :ok

      send(vm, {:choc, cust})
      assert_receive :ok

      send(vm, {:coin, cust})
      assert_receive :ok

      send(vm, {:toffee, cust})
      assert_receive :ok

      send(vm, {:coin, cust})
      assert_receive :ok

      send(vm, {:toffee, cust})
      assert_receive :ok

      send(vm, {:coin, cust})
      assert_receive :ok

      send(vm, {:choc, cust})
      assert_receive :ok

      assert Process.alive?(vm)
    end

    test "A VM that offers a choice of coins and a choice of goods and change" do
      vm = spawn(VM.Choice, :vmc, [])
      cust = self()

      assert Process.alive?(vm)

      # in2p -> large -> vmc

      send(vm, {:in2p, cust})
      assert_receive :ok

      send(vm, {:large, cust})
      assert_receive :ok

      # in2p -> small -> out1p -> vmc

      send(vm, {:in2p, cust})
      assert_receive :ok

      send(vm, {:small, cust})
      assert_receive :ok

      send(vm, {:out1p, cust})
      assert_receive :ok

      # in1p -> small -> vmc

      send(vm, {:in1p, cust})
      assert_receive :ok

      send(vm, {:small, cust})
      assert_receive :ok

      # in1p -> in1p -> large -> vmc

      send(vm, {:in1p, cust})
      assert_receive :ok

      send(vm, {:in1p, cust})
      assert_receive :ok

      send(vm, {:large, cust})
      assert_receive :ok

      # in1p -> in1p -> in1p -> stop

      send(vm, {:in1p, cust})
      assert_receive :ok

      send(vm, {:in1p, cust})
      assert_receive :ok

      send(vm, {:in1p, cust})
      assert_receive :stop

      refute Process.alive?(vm)
    end

  end

end
