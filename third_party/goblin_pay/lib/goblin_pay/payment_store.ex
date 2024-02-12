defmodule GoblinPay.PaymentStore do
  @moduledoc """
  This stores payments that were applied.

  In theory, this should be in a database, but for the purposes of this challenge, we'll
  just use an agent to hold the state instead.
  """

  use Agent

  def start_link(_opts) do
    Agent.start_link(fn -> %{payments: %{}} end, name: __MODULE__)
  end

  def capture_payment(attrs) do
    transaction_id = Map.get(attrs, :transaction_id, Ecto.UUID.generate())

    case Agent.get(__MODULE__, &Map.fetch(&1, transaction_id)) do
      :error ->
        payment_ref = Ecto.UUID.generate()
        Agent.update(__MODULE__, &Map.put(&1, transaction_id, payment_ref))
        payment_ref

      existing_payment_ref ->
        existing_payment_ref
    end
  end
end
