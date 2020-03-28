defmodule CircuitsUARTFramingPMS7003.MixProject do
  use Mix.Project

  def project do
    [
      app: :circuits_uart_framing_pms7003,
      version: "0.1.0",
      elixir: "~> 1.9",
      source_url: "https://github.com/kamilkowalski/circuits_uart_framing_pms7003",
      deps: deps(),
      description: description(),
      package: package()
    ]
  end

  defp deps do
    [
      {:circuits_uart, "~> 1.4"},
      {:ex_doc, "~> 0.21", only: :dev, runtime: false}
    ]
  end

  defp description do
    """
    Framing module for PMS7003 implementing Circuits.UART.Framing behaviour.
    """
  end

  defp package do
    [
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/kamilkowalski/circuits_uart_framing_pms7003"}
    ]
  end
end
