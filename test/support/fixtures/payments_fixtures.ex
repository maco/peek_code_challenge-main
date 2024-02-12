defmodule PeekCodeChallenge.PaymentsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `PeekCodeChallenge.Payments` context.
  """

  import Money.Sigil

  @doc """
  Generate a payment.
  """
  def payment_fixture(order_id, amount \\ ~M[10.00]USD) do
    {:ok, payment} = PeekCodeChallenge.Payments.apply_payment_to_order(order_id, amount)

    payment
  end
end
