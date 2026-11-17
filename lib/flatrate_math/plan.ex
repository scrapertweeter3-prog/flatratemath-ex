defmodule Poketdev.FlatrateMath.Plan do
  @moduledoc """
  One published subscription plan.

  Fields:

    * `:name` - plan name as published (`"Monthly"`, `"Quarterly"`, `"Yearly"`)
    * `:period_months` - billing period in months (1, 3 or 12)
    * `:price_usd` - price per billing period, in whole US dollars
  """

  @enforce_keys [:name, :period_months, :price_usd]
  defstruct [:name, :period_months, :price_usd]

  @type t :: %__MODULE__{
          name: String.t(),
          period_months: 1 | 3 | 12,
          price_usd: pos_integer()
        }
end
