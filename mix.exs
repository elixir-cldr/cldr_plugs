defmodule Cldr.Plug.MixProject do
  use Mix.Project

  @version "1.3.1"

  def project do
    [
      app: :ex_cldr_plugs,
      version: @version,
      elixir: "~> 1.11",
      compilers: Mix.compilers(),
      elixirc_paths: elixirc_paths(Mix.env()),
      name: "Cldr Plug",
      description: description(),
      source_url: "https://github.com/elixir-cldr/cldr_plugs",
      docs: docs(),
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      elixirc_paths: elixirc_paths(Mix.env()),
      deps: deps(),
      package: package(),
      dialyzer: [
        ignore_warnings: ".dialyzer_ignore_warnings",
        plt_add_apps: ~w(gettext)a
      ]
    ]
  end

  defp description do
    """
    Plugs suporting CLDR and setting the locale from requests and request headers.
    """
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp package do
    [
      maintainers: ["Kip Cole"],
      licenses: ["Apache-2.0"],
      links: links(),
      files: [
        "lib",
        "config",
        "mix.exs",
        "README*",
        "CHANGELOG*",
        "LICENSE*"
      ]
    ]
  end

  def docs do
    [
      source_ref: "v#{@version}",
      main: "readme",
      extras: ["README.md", "CHANGELOG.md", "LICENSE.md"],
      logo: "logo.png",
      skip_undefined_reference_warnings_on: ["changelog", "CHANGELOG.md"],
      formatters: ["html"]
    ]
  end

  def links do
    %{
      "GitHub" => "https://github.com/elixir-cldr/cldr_plugs",
      "Readme" => "https://github.com/elixir-cldr/cldr_plugs/blob/v#{@version}/README.md",
      "Changelog" => "https://github.com/elixir-cldr/cldr_plugs/blob/v#{@version}/CHANGELOG.md"
    }
  end

  defp deps do
    [
      {:ex_cldr, "~> 2.37"},
      {:ex_doc, "~> 0.18", only: [:dev, :test, :release], runtime: false},
      {:gettext, "~> 0.19", optional: true},
      {:jason, "~> 1.0", optional: true},
      {:plug, "~> 1.9"},
      {:dialyxir, "~> 1.0", only: [:dev], runtime: false}
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "mix", "src", "test"]
  defp elixirc_paths(:dev), do: ["lib", "mix", "src", "bench"]
  defp elixirc_paths(_), do: ["lib", "src"]
end
