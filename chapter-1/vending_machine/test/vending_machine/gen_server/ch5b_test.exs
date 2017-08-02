defmodule GenServer.Ch5bTest do
  use ExUnit.Case

  alias GenServer.Ch5b, as: VM

  test "A VM that gives change for 5p slightly differently from ch5a" do
    {:ok, vm} = VM.start_link()

    assert Process.alive?(vm)

    :ok = vm |> VM.in5p()

    assert_receive :out1p
    assert_receive :out1p
    assert_receive :out1p
    assert_receive :out2p

    :ok = vm |> VM.in5p()

    assert_receive :out1p
    assert_receive :out1p
    assert_receive :out1p
    assert_receive :out2p
  end

end
