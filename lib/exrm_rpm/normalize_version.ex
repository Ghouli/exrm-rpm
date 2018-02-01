defmodule ReleaseManager.Plugin.Rpm.NormalizeVersion do
  def normalize_version(version) when is_binary(version) do
    version 
    |> String.split("+")
    |> hd
    |> String.split([".", "-"]) 
    |> normalize_version 
    |> Enum.join(".")
  end
  def normalize_version(v = [_maj, _min, _patch]) do
    v
  end
  def normalize_version(v = [maj, _min, _patch, _pre]) when is_binary(maj) do
    normalize_version(v |> Enum.map(fn(segment) -> Regex.replace(~r/[^0-9]+/, segment, "") |> String.to_integer end))
  end
  def normalize_version([maj, 0, 0, pre]) when maj > 0 do
    [maj - 1, 99, 99, 99, pre]
  end
  def normalize_version([maj, min, 0, pre]) when min > 0 do
    [maj, min - 1, 99, 99, pre]
  end
  def normalize_version([maj, min, patch, pre]) when patch > 0 do
    [maj, min, patch - 1, 99, pre]
  end
end