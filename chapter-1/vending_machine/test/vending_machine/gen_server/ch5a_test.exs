defmodule GenServer.Ch5aTest do
  use ExUnit.Case

  alias GenServer.Ch5a, as: VM

  test "A VM that gives change for 5p repeatedly" do
    {:ok, vm} = VM.start_link()

    assert Process.alive?(vm)

    vm |> VM.in5p()

    assert_receive :out2p
    assert_receive :out2p
    assert_receive :out1p

    :ok = vm |> VM.in5p()

    assert_receive :out2p
    assert_receive :out2p
    assert_receive :out1p
  end

end
