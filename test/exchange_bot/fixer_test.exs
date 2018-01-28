defmodule ExchangeBot.FixerTest do
  use ExUnit.Case

  setup do
    Tesla.Mock.mock fn
      %{method: :get, url: "https://api.fixer.io/latest"} ->
        %Tesla.Env{
          status: 200,
          body: %{
            "base" => "USD", "date" => "2018-01-05",
            "rates" => %{"EUR" => 0.83022}
          }
        }
    end

    :ok
  end

  test "get rates" do
    res = ExchangeBot.Fixer.get_rates("USD", "EUR")
    assert res == %{"EUR" => 0.83022}
  end
end
