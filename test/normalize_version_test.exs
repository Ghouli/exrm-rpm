defmodule NormalizeVersionTest do
  use ExUnit.Case
  alias ReleaseManager.Config
  alias ReleaseManager.Plugin.Rpm
  
  import ReleaseManager.Plugin.Rpm.NormalizeVersion

  test "normalize_version acts correctly" do
    versions = %{
        "1.2.3" => "1.2.3",
        "1.0.0-alpha1" => "0.99.99.99.1",
        "1.1.0-alpha1" => "1.0.99.99.1",
        "1.1.1-alpha1" => "1.1.0.99.1",
        "1.2.3+60" => "1.2.3",
        "1.2.3-alpha1+60" => "1.2.2.99.1"
      }

    for {version, expected} <- versions do
      assert normalize_version(version) == expected
    end
  end

  test "build_number acts correctly" do
    versions = %{
      "1.2.3" => "0",
      "1.0.0-alpha1" => "0",
      "1.2.3+60" => "60",
      "1.2.3-alpha1+60" => "60"
    }

    for {version, expected} <- versions do
      assert build_number(version) == expected
    end
  end
end