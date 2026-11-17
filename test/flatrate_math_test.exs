defmodule Poketdev.FlatrateMathTest do
  use ExUnit.Case, async: true

  alias Poketdev.FlatrateMath
  alias Poketdev.FlatrateMath.Plan

  describe "plans/0" do
    test "publishes exactly the three plans" do
      plans = FlatrateMath.plans()
      assert Map.keys(plans) == [1, 3, 12]

      assert %Plan{name: "Monthly", period_months: 1, price_usd: 5_995} = plans[1]
      assert %Plan{name: "Quarterly", period_months: 3, price_usd: 5_495} = plans[3]
      assert %Plan{name: "Yearly", period_months: 12, price_usd: 4_995} = plans[12]
    end
  end

  describe "plan!/1" do
    test "raises on unknown periods" do
      assert_raise ArgumentError, ~r/unknown billing period/, fn ->
        FlatrateMath.plan!(6)
      end
    end
  end

  describe "cost/2" do
    test "scales by whole billing periods" do
      assert FlatrateMath.cost(1, 1) == 5_995
      assert FlatrateMath.cost(3, 6) == 10_990
      assert FlatrateMath.cost(12, 24) == 9_990
    end

    test "rejects partial periods" do
      assert_raise FunctionClauseError, fn -> FlatrateMath.cost(3, 4) end
      assert_raise FunctionClauseError, fn -> FlatrateMath.cost(12, 6) end
    end
  end

  describe "annual_cost/1" do
    test "monthly is the most expensive way to pay" do
      assert FlatrateMath.annual_cost(1) == 71_940
      # four quarterly billings
      assert FlatrateMath.annual_cost(3) == 21_980
      # one yearly billing covers the year
      assert FlatrateMath.annual_cost(12) == 4_995

      assert FlatrateMath.annual_cost(12) < FlatrateMath.annual_cost(3)
      assert FlatrateMath.annual_cost(3) < FlatrateMath.annual_cost(1)
    end
  end

  describe "vs_hire/2" do
    test "monthly plan vs one hire reproduces the published first-year gap" do
      result = FlatrateMath.vs_hire(1)

      assert result.subscription_cost == 71_940
      assert result.hire_cost == 18_290 * 12
      assert result.hire_first_year == 18_290 * 12 + 13_500
      # The site's headline "Save $161,040/yr vs hiring" figure.
      assert result.savings_first_year == 161_040
    end

    test "yearly plan maximizes savings" do
      assert FlatrateMath.vs_hire(12).savings_first_year == 227_985
      assert FlatrateMath.vs_hire(12).savings_first_year >
               FlatrateMath.vs_hire(1).savings_first_year
    end

    test "custom windows scale both sides consistently" do
      six = FlatrateMath.vs_hire(1, months: 6)
      assert six.subscription_cost == 5_995 * 6
      assert six.hire_cost == 18_290 * 6
      assert six.savings == 18_290 * 6 - 5_995 * 6
    end
  end

  describe "benchmark constants" do
    test "match the published figures" do
      assert FlatrateMath.benchmark_monthly() == 18_290
      assert FlatrateMath.upfront_hire_cost() == 13_500
    end
  end
end
