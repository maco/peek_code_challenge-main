defmodule PeekCodeChallenge.Repo.Migrations.CreatePayments do
  use Ecto.Migration

  def change do
    create table(:payments) do
      add :amount, :map
      add :order_id, references(:orders, on_delete: :nothing)
      add :processor_refid, :string

      timestamps(type: :utc_datetime)
    end

    create index(:payments, [:order_id])
  end
end
