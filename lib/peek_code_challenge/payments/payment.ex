defmodule PeekCodeChallenge.Payments.Payment do
  use Ecto.Schema
  import Ecto.Changeset

  alias PeekCodeChallenge.Orders.Order

  schema "payments" do
    belongs_to :order, Order
    field :amount, Money.Ecto.Map.Type
    field :processor_refid, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(payment, attrs) do
    payment
    |> cast(attrs, [:amount, :order_id, :processor_refid])
    |> validate_required([:amount, :order_id])
  end
end
