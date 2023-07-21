defmodule CsvTable.CsvUpload.Upload do
  use Ecto.Schema
  import Ecto.Changeset

  schema "uploads" do
    field :age, :string
    field :email, :string
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(upload, attrs) do
    upload
    |> cast(attrs, [:name, :age, :email])
    |> validate_required([:name, :age, :email])
  end
end
