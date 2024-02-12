defmodule PeekCodeChallenge.Orders.Order do
  use Ecto.Schema
  import Ecto.Changeset

  alias PeekCodeChallenge.Orders.Customer

  schema "orders" do
    belongs_to :customer, Customer
    field :amount, Money.Ecto.Map.Type

    timestamps(type: :utc_datetime_usec)
  end

  @doc false
  def changeset(order, attrs) do
    order
    |> cast(attrs, [:amount, :customer_id])
    |> validate_required([:amount, :customer_id])
  end
end
