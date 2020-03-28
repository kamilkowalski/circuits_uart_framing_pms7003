defmodule CircuitsUARTFramingPMS7003Test do
  alias CircuitsUARTFramingPMS7003, as: Framer
  alias CircuitsUARTFramingPMS7003.Measurement

  use ExUnit.Case

  @payload_header <<0x42, 0x4D>>

  describe "init/1" do
    test "initializing an empty state" do
      assert Framer.init(foo: :bar) == {:ok, <<>>}
    end
  end

  describe "add_framing/2" do
    test "sending binary data" do
      data = <<1, 2, 3>>
      state = <<4, 5, 6>>
      assert Framer.add_framing(data, state) == {:ok, data, state}
    end

    test "raising on non-binary data being sent" do
      data = 123
      state = <<4, 5, 6>>

      assert_raise(FunctionClauseError, fn ->
        Framer.add_framing(data, state)
      end)
    end
  end

  describe "remove_framing/2" do
    test "parsing measurement received as data" do
      payload = generate_payload(5, 7, 3)

      assert Framer.remove_framing(payload, <<>>) ==
               {:ok, [%Measurement{pm1: 5, pm25: 7, pm10: 3}]}
    end

    test "parsing measurement received partially as data and partially in the buffer" do
      <<buffer::binary-size(16), payload::binary-size(16)>> = generate_payload(3, 7, 1)

      assert Framer.remove_framing(payload, buffer) ==
               {:ok, [%Measurement{pm1: 3, pm25: 7, pm10: 1}]}
    end

    test "rewinding to data frame" do
      payload = generate_payload(7, 4, 19)

      assert Framer.remove_framing(<<1, 2, 3>> <> payload, <<>>) ==
               {:ok, [%Measurement{pm1: 7, pm25: 4, pm10: 19}]}
    end

    test "keeping the tail after extracting measurement" do
      payload = generate_payload(9, 11, 8)

      assert Framer.remove_framing(@payload_header, payload) ==
               {:in_frame, [%Measurement{pm1: 9, pm25: 11, pm10: 8}], @payload_header}
    end

    test "extracting multiple measurement" do
      payload_1 = generate_payload(8, 5, 9)
      payload_2 = generate_payload(9, 11, 7)

      assert Framer.remove_framing(payload_2, payload_1) ==
               {:ok,
                [
                  %Measurement{pm1: 8, pm25: 5, pm10: 9},
                  %Measurement{pm1: 9, pm25: 11, pm10: 7}
                ]}
    end
  end

  describe "frame_timeout/1" do
    test "dropping state and returning no messages" do
      assert Framer.frame_timeout(@payload_header) == {:ok, [], <<>>}
    end
  end

  describe "flush/2" do
    test "dropping state" do
      assert Framer.flush(:both, @payload_header) == <<>>
    end
  end

  defp generate_payload(pm1, pm25, pm10) do
    measurements =
      [pm1, pm25, pm10]
      |> Enum.map(fn measurement ->
        # converts integers to 2-byte binaries
        binary_integer = :binary.encode_unsigned(measurement)

        case byte_size(binary_integer) do
          2 -> binary_integer
          1 -> <<0::8>> <> binary_integer
        end
      end)
      |> Enum.join()

    @payload_header <>
      :crypto.strong_rand_bytes(8) <>
      measurements <>
      :crypto.strong_rand_bytes(16)
  end
end
