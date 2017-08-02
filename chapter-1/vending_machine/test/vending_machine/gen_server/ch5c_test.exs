defmodule GenServer.Ch5cTest do
  use ExUnit.Case

  alias GenServer.Ch5c, as: VM

  test "it returns change for 5p in 1p, 1p, 1p, 2p" do
    {:ok, vm} = VM.start_link([1, 2, 1, 1])

    :ok = vm |> VM.in5p

    assert_receive :out1p
    assert_receive :out1p
    assert_receive :out1p
    assert_receive :out2p
  end

end
