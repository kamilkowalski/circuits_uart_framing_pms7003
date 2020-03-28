defmodule CircuitsUARTFramingPMS7003.MixProject do
  use Mix.Project

  def project do
    [
      app: :circuits_uart_framing_pms7003,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:circuits_uart, "~> 1.4"},
      {:ex_doc, "~> 0.21", only: :dev, runtime: false}
    ]
  end
end
