defmodule CircuitsUARTFramingPMS7003 do
  @moduledoc """
  Framing module for the PMS7003 particle concentration sensor.

  Reads the PM1, PM2.5 and PM10 concentration under atmospheric environment.
  Returns messages of type `CircuitsUARTFramingPMS7003.Measurement.t()`.

  In order to use the framing module, pass it as an option to `Circuits.UART.open/3`
  or `Circuits.UART.configure/2`:

  ```
  Circuits.UART.open(pid, "COM1", framing: CircuitsUARTFramingPMS7003)
  # or
  Circuits.UART.configure(pid, framing: CircuitsUARTFramingPMS7003)
  ```
  """

  alias CircuitsUARTFramingPMS7003.Measurement

  @behaviour Circuits.UART.Framing

  @impl true
  def init(_args) do
    {:ok, <<>>}
  end

  @impl true
  def add_framing(data, state) when is_binary(data) do
    # We allow the app to send any arbitrary data through
    # TODO: Implement protocol for changing mode
    {:ok, data, state}
  end

  @impl true
  def remove_framing(new_data, state) do
    process_data(state <> new_data, [])
  end

  @impl true
  def frame_timeout(_state) do
    {:ok, [], <<>>}
  end

  @impl true
  def flush(_direction, _state) do
    <<>>
  end

  defp process_data(<<0x42, 0x4D, body::binary-size(30), rest::binary>>, messages) do
    message = parse_body(body)
    process_data(rest, messages ++ [message])
  end

  defp process_data(state = <<0x42, 0x4D, _rest::binary>>, messages) do
    {:in_frame, messages, state}
  end

  defp process_data(<<>>, messages) do
    {:ok, messages, <<>>}
  end

  defp process_data(<<_head::binary-size(1), tail::binary>>, messages) do
    process_data(tail, messages)
  end

  defp parse_body(body) do
    <<_padding::binary-size(8), readings::binary-size(6), _tail::binary>> = body
    <<pm1::binary-size(2), pm25::binary-size(2), pm10::binary-size(2)>> = readings

    %Measurement{
      pm1: :binary.decode_unsigned(pm1),
      pm25: :binary.decode_unsigned(pm25),
      pm10: :binary.decode_unsigned(pm10)
    }
  end
end
