defmodule ExchangeBot.CurrencyExchangePlugTest do
  use ExUnit.Case
  use Plug.Test
  import Mock

  alias ExchangeBot.CurrencyExchangePlug

  @opts CurrencyExchangePlug.init([])

  test "return 404 if bad route" do
    conn =
      conn(:get, "/", "")
      |> CurrencyExchangePlug.call(@opts)

    assert conn.resp_body == "not_found"
    assert conn.state == :sent
    assert conn.status == 404
  end

  test "return 202 if correct route" do
    with_mock ExchangeBot.Convert, [start: fn(_) -> :ok end] do
      conn =
        conn(:post, "/", "")
        |> CurrencyExchangePlug.call(@opts)
      assert called ExchangeBot.Convert.start(%{})
      assert conn.resp_body == ""
      assert conn.state == :sent
      assert conn.status == 202
    end
  end
end
