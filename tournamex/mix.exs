defmodule Tournamex.MixProject do
  use Mix.Project

  def project do
    [
      app: :tournamex,
      version: "0.1.1",
      elixir: "~> 1.9",
      description: "Simple package for managing tournament.",
      start_permanent: Mix.env() == :prod,
      package: package(),
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    []
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, "~> 0.22.0", only: :dev, runtime: false}
    ]
  end

  defp package do
    [
      maintainers: ["Papillon6814"],
      licenses: ["MIT"],
      links: %{"Github" => "https://github.com/Papillon6814/tournamex"}
    ]
  end
end
