defmodule CsvTable.CsvUploadTest do
  use CsvTable.DataCase

  alias CsvTable.CsvUpload

  describe "uploads" do
    alias CsvTable.CsvUpload.Upload

    import CsvTable.CsvUploadFixtures

    @invalid_attrs %{age: nil, email: nil, name: nil}

    test "list_uploads/0 returns all uploads" do
      upload = upload_fixture()
      assert CsvUpload.list_uploads() == [upload]
    end

    test "get_upload!/1 returns the upload with given id" do
      upload = upload_fixture()
      assert CsvUpload.get_upload!(upload.id) == upload
    end

    test "create_upload/1 with valid data creates a upload" do
      valid_attrs = %{age: "some age", email: "some email", name: "some name"}

      assert {:ok, %Upload{} = upload} = CsvUpload.create_upload(valid_attrs)
      assert upload.age == "some age"
      assert upload.email == "some email"
      assert upload.name == "some name"
    end

    test "create_upload/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = CsvUpload.create_upload(@invalid_attrs)
    end

    test "update_upload/2 with valid data updates the upload" do
      upload = upload_fixture()
      update_attrs = %{age: "some updated age", email: "some updated email", name: "some updated name"}

      assert {:ok, %Upload{} = upload} = CsvUpload.update_upload(upload, update_attrs)
      assert upload.age == "some updated age"
      assert upload.email == "some updated email"
      assert upload.name == "some updated name"
    end

    test "update_upload/2 with invalid data returns error changeset" do
      upload = upload_fixture()
      assert {:error, %Ecto.Changeset{}} = CsvUpload.update_upload(upload, @invalid_attrs)
      assert upload == CsvUpload.get_upload!(upload.id)
    end

    test "delete_upload/1 deletes the upload" do
      upload = upload_fixture()
      assert {:ok, %Upload{}} = CsvUpload.delete_upload(upload)
      assert_raise Ecto.NoResultsError, fn -> CsvUpload.get_upload!(upload.id) end
    end

    test "change_upload/1 returns a upload changeset" do
      upload = upload_fixture()
      assert %Ecto.Changeset{} = CsvUpload.change_upload(upload)
    end
  end
end
