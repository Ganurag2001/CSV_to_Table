defmodule CsvTable.Repo.Migrations.CreateUploads do
  use Ecto.Migration

  def change do
    create table(:uploads) do
      add :name, :string
      add :age, :string
      add :email, :string

      timestamps()
    end
  end
end
