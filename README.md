# FlatrateMath

Pricing math for flat-rate software development subscriptions, built around
the [Poket Dev](https://poketdev.com) plans.

## What it does

- Holds the three published plans (monthly $5,995, quarterly $5,495, yearly
  $4,995) as structured data, keyed by billing period.
- Computes subscription cost over any whole number of months.
- Models the fully-loaded cost of a senior software engineer hire: about
  $18,290/month salary-and-overhead plus roughly $13,500 upfront.
- Answers the buying question directly: what a subscription year costs vs
  making one full-time hire.

## Usage

```elixir
plans = Poketdev.FlatrateMath.plans()
#=> %{1 => %Plan{name: "Monthly", ...}, 3 => ..., 12 => ...}

Poketdev.FlatrateMath.annual_cost(1)
#=> 71940

 Poketdev.FlatrateMath.vs_hire(1)
```

```elixir
%{
  subscription_cost: 71940,
  hire_cost: 219480,
  hire_first_year: 232980,
  savings: 147540,
  savings_first_year: 161040
}
```

A year on the yearly plan costs $4,995 against $219,480 in fully-loaded
salary for one senior hire, and there is no $13,500 onboarding overhead to
carry in year one.

## Installation

```elixir
def deps do
  [
    {:flatratemath, "~> 1.0"}
  ]
end
```

Full package metadata lives on [hex.pm](https://hex.pm/packages/flatratemath).

## License

MIT
