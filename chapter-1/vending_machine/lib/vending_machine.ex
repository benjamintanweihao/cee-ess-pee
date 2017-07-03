defmodule VendingMachine do

  defmodule Prefix do
    @moduledoc """
    1.1.1 Prefix
    """

    @doc """
    A simple vending machine which consumes one coin before breaking.
    """
    def x1 do
      receive do
        {:coin, cust} ->
          send(cust, :stop)
          exit(:stop)
      end
    end

    @doc """
    A simple vending machine that successfully serves two customers before
    breaking.
    """
    def x2 do
      receive do
        {:coin, cust} ->
          send(cust, :ok)
          receive do
            {:choc, cust} ->
              send(cust, :ok)
              receive do
                {:coin, cust} ->
                  send(cust, :ok)
                  receive do
                    {:choc, cust} ->
                      send(cust, :ok)
                      exit(:stop)
                  end
              end
          end
      end
    end
  end

  defmodule Recursion do
    @moduledoc """
    1.1.2 Recursion
    """

    @doc """
    A simple vending machine which serves as many chocs as required.
    """
    def vms do
      receive do
        {:coin, cust} ->
          send(cust, :ok)
          receive do
            {:choc, cust} ->
              send(cust, :ok)
              vms()
          end
      end
    end

    @doc """
    A machine that gives change for 5p repeatedly.
    """
    def ch5a do
      receive do
        {:in5p, cust} ->
          send(cust, :ok)
          receive do
            {:out2p, cust} ->
              send(cust, :ok)
              receive do
                {:out1p, cust} ->
                  send(cust, :ok)
                  receive do
                    {:out2p, cust} ->
                      send(cust, :ok)
                      ch5a()
                  end
              end
          end
      end
    end

    @doc """
    A machine that gives change for 5p slightly differently from ch5a.
    """
    def ch5b do
      receive do
        {:in5p, cust} ->
          send(cust, :ok)
          receive do
            {:out1p, cust} ->
              send(cust, :ok)
              receive do
                {:out1p, cust} ->
                  send(cust, :ok)
                  receive do
                    {:out1p, cust} ->
                      send(cust, :ok)
                      receive do
                        {:out2p, cust} ->
                          send(cust, :ok)
                          ch5b()
                      end
                  end
              end
          end
      end
    end


  end

  defmodule Choice do
    @moduledoc """
    1.1.3 Choice
    """

    @doc """
    A machine which offers a choice of two combinations of change for 5p.
    """
    def ch5c do
      receive do
        {:in5p, cust} ->
          send(cust, :ok)
          receive do
            {:out1p, cust} ->
                send(cust, :ok)
                receive do
                  {:out1p, cust} ->
                    send(cust, :ok)
                    receive do
                      {:out1p, cust} ->
                        send(cust, :ok)
                        receive do
                          {:out2p, cust} ->
                            send(cust, :ok)
                            ch5c()
                        end
                    end
                end

            {:out2p, cust} ->
              send(cust, :ok)
              receive do
                {:out1p, cust} ->
                  send(cust, :ok)
                  receive do
                    {:out2p, cust} ->
                      send(cust, :ok)
                      ch5c()
                  end
              end
          end
      end
    end

    @doc """
    A machine that serves either chocolate or toffee on each transaction.
    """
    def vmct do
      receive do
        {:coin, cust} ->
          send(cust, :ok)

          receive do
            {:choc, cust} ->
              send(cust, :ok)
              vmct()

            {:toffee, cust} ->
              send(cust, :ok)
              vmct()
          end
      end
    end

    @doc """
    A more complicated vending machine, which offers a choice of coins and a
    choice of goods and change.
    """
    def vmc do
      receive do
        {:in2p, cust} ->
          send(cust, :ok)
          receive do
            {:large, cust} ->
              send(cust, :ok)
              vmc()

            {:small, cust} ->
              send(cust, :ok)
              receive do
                {:out1p, cust} ->
                  send(cust, :ok)
                  vmc()
              end
          end

        {:in1p, cust} ->
          send(cust, :ok)
          receive do
            {:small, cust} ->
              send(cust, :ok)
              vmc()

            {:in1p, cust} ->
              send(cust, :ok)
              receive do
                {:large, cust} ->
                  send(cust, :ok)
                  vmc()

                {:in1p, cust} ->
                  send(cust, :stop)
                  exit(:stop)
              end
          end
      end
    end

  end

end
