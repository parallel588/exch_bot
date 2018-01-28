defmodule ExchangeBot.Fixer do
  @moduledoc false

  use Tesla
  plug Tesla.Middleware.BaseUrl, "https://api.fixer.io"
  plug Tesla.Middleware.Headers, %{'content-type' => 'application/json'}
  plug Tesla.Middleware.DecodeJson

  def get_rates(base, currences) do
    get("/latest",
      query: [
        base: :string.uppercase(base),
        symbols: :string.uppercase(currences)
      ]
    ).body["rates"]
  end
end
