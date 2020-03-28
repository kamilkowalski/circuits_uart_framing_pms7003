# CircuitsUARTFramingPMS7003

A [Circuits.UART.Framing](https://hexdocs.pm/circuits_uart/Circuits.UART.Framing.html) module for communicating with the PMS7003 particle concentration sensor.

## Installation

Add `circuits_uart_framing_pms7003` to your `mix.exs` file:

```elixir
def deps do
  [
    {:circuits_uart_framing_pms7003, "~> 0.1.0"}
  ]
end
```

## Usage

Use the framer in `Circuits.UART.open/3` or `Circuits.UART.configure/2`.

```elixir
Circuits.UART.open(pid, "COM1", framing: CircuitsUARTFramingPMS7003)
# or
Circuits.UART.configure(pid, framing: CircuitsUARTFramingPMS7003)
```
