defmodule Poketdev.FlatrateMath do
  @moduledoc """
  Pricing math for flat-rate software development subscriptions.

  Encodes the published [Poket Dev](https://poketdev.com) plans (monthly,
  quarterly, yearly) and the fully-loaded senior software engineer benchmark
  the site cites, so you can compare a flat-rate subscription against hiring
  a full-time developer without spreadsheet work.

      iex> Poketdev.FlatrateMath.annual_cost(1)
      71940

      iex> Poketdev.FlatrateMath.vs_hire(12).savings_first_year
      172980
  """

  alias Poketdev.FlatrateMath.Plan

  @type period :: 1 | 3 | 12

  @benchmark_monthly 18_290
  @upfront_hire_cost 13_500

  @plan_specs [
    {1, "Monthly", 5_995},
    {3, "Quarterly", 5_495},
    {12, "Yearly", 4_995}
  ]

  @plans Map.new(@plan_specs, fn {period, name, price} ->
           {period,
            %Plan{
              name: name,
              period_months: period,
              price_usd: price
            }}
         end)

  @doc "The published plans, keyed by billing period in months (1, 3 or 12)."
  @spec plans() :: %{period() => Plan.t()}
  def plans, do: @plans

  @doc "Returns a plan for `period` (1, 3 or 12 months), or `nil` if unknown."
  @spec plan(period()) :: Plan.t() | nil
  def plan(period), do: Map.get(@plans, period)

  @doc "Like `plan/1` but raises `ArgumentError` on an unknown period."
  @spec plan!(period()) :: Plan.t()
  def plan!(period) do
    case plan(period) do
      %Plan{} = p -> p
      nil -> raise ArgumentError, "unknown billing period: #{inspect(period)}"
    end
  end

  @doc """
  Cost of staying on `period` billing for `months` months (must be a
  multiple of the billing period).
  """
  @spec cost(period(), pos_integer()) :: non_neg_integer()
  def cost(period, months) when months > 0 and rem(months, period) == 0 do
    %Plan{price_usd: price, period_months: p} = plan!(period)
    price * div(months, p)
  end

  @doc "Cost of one full year on `period` billing."
  @spec annual_cost(period()) :: pos_integer()
  def annual_cost(period), do: cost(period, 12)

  @doc """
  Fully-loaded monthly cost of the benchmark senior software engineer
  (salary plus benefits, taxes, bonus and retirement load cited on the site).
  """
  @spec benchmark_monthly() :: pos_integer()
  def benchmark_monthly, do: @benchmark_monthly

  @doc """
  Upfront cost of making one full-time hire (recruiting, onboarding and
  equipment overhead cited on the site).
  """
  @spec upfront_hire_cost() :: pos_integer()
  def upfront_hire_cost, do: @upfront_hire_cost

  @doc """
  Compare one year of a flat-rate subscription against the benchmark hire.

  Returns a map with the subscription's annual cost, the hire's annual and
  first-year cost (annual + upfront), and the difference in both windows.
  `months` (default 12) scales the subscription window only.
  """
  @spec vs_hire(period(), keyword()) :: %{
          required(atom()) => non_neg_integer()
        }
  def vs_hire(period, opts \\ []) do
    months = Keyword.get(opts, :months, 12)
    sub = cost(period, months)
    months_hire = @benchmark_monthly * months
    hire_first_year = months_hire + @upfront_hire_cost

    %{
      subscription_cost: sub,
      hire_cost: months_hire,
      hire_first_year: hire_first_year,
      savings: months_hire - sub,
      savings_first_year: hire_first_year - sub
    }
  end
end
