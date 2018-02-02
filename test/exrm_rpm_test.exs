defmodule ExrmRpmTest do
  use ExUnit.Case
  alias ReleaseManager.Config
  alias ReleaseManager.Utils
  alias ReleaseManager.Plugin.Rpm

  @test_project_path  Path.expand("test_project", __DIR__)
  @rpm_file           "/rel/test_project/releases/0.1.0/test_project-0.1.0-0.x86_64.rpm"

  defmacrop with_app(body) do
    quote do
      cwd = File.cwd!
      File.cd! @test_project_path
      unquote(body)
      File.cd! cwd
    end
  end

  setup do
    File.rm_rf Path.join([File.cwd!, "_build", "rpm"])
    config = %Config{name: "test", version: "0.0.1"}
    {:ok, config: Map.merge(config, %{rpm: true, build_arch: "x86_64"})}
  end

  def create_rpm_build(config) do
    build_arch = Rpm.get_config_item config, :build_arch, "x86_64"
    Rpm.rpm_file_name(config.name, config.version, build_arch)
  end

  test "rpm_file_name with build" do
    rpm_file = Rpm.rpm_file_name("test", "0.0.1+47", "x86_64")
    assert rpm_file == "test-0.0.1-47.x86_64.rpm"
  end

  test "rpm_file_name without build" do
    rpm_file = Rpm.rpm_file_name("test", "0.0.1", "x86_64")
    assert rpm_file == "test-0.0.1-0.x86_64.rpm"
  end

  test "creates the spec work directories", meta do
    Rpm.after_release(meta[:config])
  end

  test "can create a release and package it to rpm" do
    with_app do
        # Build and package release
        assert :ok = Utils.mix("do deps.get, compile", Mix.env, :quiet)
        assert :ok = Utils.mix("release --rpm --verbosity=verbose", Mix.env, :verbose)
        assert File.exists?(Path.join(@test_project_path, @rpm_file))
    end
  end
end
