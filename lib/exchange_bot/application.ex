defmodule ExchangeBot.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Starts a worker by calling: ExchangeBot.Worker.start_link(arg)
      # {ExchangeBot.Worker, arg},
      {
        Plug.Adapters.Cowboy2, scheme: :http,
        plug: ExchangeBot.CurrencyExchangePlug,
        options: [port: Application.get_env(:exchange_bot, :port)]
      }
    ]
    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ExchangeBot.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
