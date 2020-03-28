defmodule CircuitsUARTFramingPMS7003.Measurement do
  @moduledoc """
  Structure representing measurements read from the sensor.

  The fields of this structure represent the concentration of particles
  of a given size in μg/m3 (micrograms per quadric meter of air), specifically:

  * `pm1` - particles less than 1μm in diameter
  * `pm25` - particles less than 2.5μm in diameter
  * `pm10` - particles less than 10μm in diameter
  """

  @type t :: %__MODULE__{
          pm1: integer(),
          pm25: integer(),
          pm10: integer()
        }

  @enforce_keys [:pm1, :pm25, :pm10]
  defstruct pm1: nil, pm25: nil, pm10: nil
end
