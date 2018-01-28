defmodule ExchangeBot.ConvertTest do
  @response_url "https://example.com/responses/5c7eb24b"
  @token "111"

  use ExUnit.Case
  import Mock
  alias ExchangeBot.Convert

  setup do
    Tesla.Mock.mock fn
      %{method: :post, url: @response_url} ->
        %Tesla.Env{ status: 200,  body: ""}
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

  test "run" do
    with_mock ExchangeBot.Convert.Reply, [send_msg: fn(_,_,_) -> :ok end] do
      attrs = %{
        "token" => @token, "response_url" => @response_url,
        "body" => "10.5 USD in EUR"}
      ExchangeBot.Convert.run(attrs)
      assert called ExchangeBot.Convert.Reply.send_msg(
        @response_url, @token, "10.5 USD -> 8.71731 EUR (rate: 0.83022)"
      )
    end
  end

  test "reply" do
    assert %Tesla.Env{} = env = Convert.Reply.send_msg(@response_url, @token, "msg")
    assert env.status == 200
    assert env.body == ""
  end
end
