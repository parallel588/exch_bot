defmodule ExchangeBot.CurrencyExchangePlug do
  @moduledoc false

  use Plug.Router
  alias ExchangeBot.Convert

  plug :match
  plug Plug.Parsers,
    parsers: [:urlencoded, :json],
    pass:  ["text/*"],
    json_decoder: Poison
  plug :dispatch

  post "/" do
    Convert.start(conn.body_params)
    send_resp(conn, 202, "")
  end

  match _ do
    send_resp(conn, 404, "not_found")
  end

end
