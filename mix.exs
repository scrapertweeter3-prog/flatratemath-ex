defmodule FlatrateMath.MixProject do
  use Mix.Project

  @version "1.0.0"
  @source_url "https://github.com/scrapertweeter3-prog/flatratemath-ex"
  @homepage_url "https://poketdev.com"

  def project do
    [
      app: :flatratemath,
      version: @version,
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      name: "FlatrateMath",
      description: description(),
      source_url: @source_url,
      homepage_url: @homepage_url
    ]
  end

  def application do
    [extra_applications: []]
  end

  defp deps do
    [
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end

  defp description do
    "Pricing math for flat-rate software development subscriptions: published " <>
      "Poket Dev plan costs, a fully-loaded senior engineer hire benchmark, " <>
      "and first-year savings comparisons."
  end

  defp package do
    [
      name: :flatratemath,
      files: ["lib", "mix.exs", "README.md", "LICENSE"],
      maintainers: ["James Verlander"],
      licenses: ["MIT"],
      links: %{
        "Website" => @homepage_url,
        "GitHub" => @source_url
      }
    ]
  end
end
