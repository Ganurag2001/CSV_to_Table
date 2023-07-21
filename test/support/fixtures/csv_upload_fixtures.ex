defmodule CsvTable.CsvUploadFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `CsvTable.CsvUpload` context.
  """

  @doc """
  Generate a upload.
  """
  def upload_fixture(attrs \\ %{}) do
    {:ok, upload} =
      attrs
      |> Enum.into(%{
        age: "some age",
        email: "some email",
        name: "some name"
      })
      |> CsvTable.CsvUpload.create_upload()

    upload
  end
end
