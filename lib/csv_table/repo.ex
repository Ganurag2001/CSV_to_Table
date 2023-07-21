defmodule CsvTable.Repo do
  use Ecto.Repo,
    otp_app: :csv_table,
    adapter: Ecto.Adapters.Postgres
end
