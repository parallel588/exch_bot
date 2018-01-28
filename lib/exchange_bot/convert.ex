defmodule ExchangeBot.Convert do
  @moduledoc false
  @msg_patter ~r/([\d\.]*)\s*(\w+)\s*(in|to)\s*([\w\,\s]+)\z/i

  alias ExchangeBot.Fixer
  alias Tesla.Multipart
  alias ExchangeBot.Convert.Reply

  def start(params), do: Task.start(__MODULE__, :run, [params])

  def run(%{"token" => token, "response_url" => url, "body" => msg} = _param) do
    with res <- Regex.run(@msg_patter, msg), false <- is_nil(res) do
      [_, str_amount, source, _, target] = res
      {amount, _} = Float.parse(str_amount)
      rates = Fixer.get_rates(source, target)

      Enum.each(rates, fn({currency, rate}) ->
        build_msg = "#{amount} #{source} -> #{rate * amount} #{currency} (rate: #{rate})"
        Reply.send_msg(url, token, build_msg)
      end)

    end
  end

  def run(_params), do: :ok

  defmodule Reply do
    @moduledoc false
    def send_msg(url, token, msg) do
      mp = Multipart.new
      |> Multipart.add_content_type_param("charset=utf-8")
      |> Multipart.add_field("token", token)
      |> Multipart.add_field("body", msg)
      Tesla.post(url, mp, headers: %{"Content-Type" => "application/json"})
    end
  end
end
