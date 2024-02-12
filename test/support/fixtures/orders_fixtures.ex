defmodule PeekCodeChallenge.OrdersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `PeekCodeChallenge.Orders` context.
  """

  import Money.Sigil

  @doc """
  Generate a customer.
  """
  def customer_fixture(attrs \\ %{}) do
    {:ok, customer} =
      attrs
      |> Enum.into(%{
        email: "some@email.com",
        name: "some name"
      })
      |> PeekCodeChallenge.Orders.create_customer()

    customer
  end

  @doc """
  Generate a order.
  """
  def order_fixture(attrs \\ %{}) do
    customer_id =
      Map.get_lazy(attrs, :customer_id, fn ->
        customer_attrs = Map.get(attrs, :customer, %{})
        customer_fixture(customer_attrs).id
      end)

    {:ok, order} =
      attrs
      |> Enum.into(%{
        amount: ~M[10.00]USD,
        customer_id: customer_id
      })
      |> PeekCodeChallenge.Orders.create_order()

    order
  end
end
