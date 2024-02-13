defmodule PeekCodeChallenge.Repo.Migrations.AddOrderStatus do
  use Ecto.Migration

  def change do
    alter table("orders") do
      add :status, :text
    end
  end
end
