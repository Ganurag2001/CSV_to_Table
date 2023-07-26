defmodule CsvTable.Importer do
  def preview(rows) do
    rows
    |> Enum.take(length(rows))
    |> transform_keys()
  end

  def import(rows) do
    rows
    |> transform_keys()
  end

  # "First Name" => "first_name"
  defp transform_keys(rows) do
    rows
    |> Enum.map(fn row ->
      Enum.reduce(row, %{}, fn {key, val}, map ->
        Map.put(map, underscore_key(key), val)
      end)
    end)
  end

  defp underscore_key(key) do
    key
    |> String.replace(" ", "")
    |> Phoenix.Naming.underscore()
  end
end
