defmodule ExrmRpm.Mixfile do
  use Mix.Project

  def project do
    [app: :exrm_rpm,
     version: "0.3.4",
     elixir: "~> 1.4",
     description: description(),
     package: package(),
     deps: deps()]
  end

  def application do
    [applications: []]
  end

  defp description do
    """
    Adds simple Red Hat Package Manager (RPM) generation to the exrm package manager.
    The generated RPM file includes the Elixir release and an init.d script to 
    manage the project's service.
    """
  end

  defp deps do
     [{:exrm, github: "ghouli/exrm"}]
  end

  defp package do
    [ files: ["lib", "priv", "mix.exs", "README.md", "LICENSE"],
      contributors: ["Stephen Pallen"],
      maintainers: ["Stephen Pallen"],
      licenses: ["MIT"],
      links: %{github: "https://github.com/smpallen99/exrm-rpm"}
    ]
  end
end
