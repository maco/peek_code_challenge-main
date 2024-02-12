defmodule PeekCodeChallenge.Payments do
  @moduledoc """
  The Payments context.
  """

  import Ecto.Query, warn: false
  alias PeekCodeChallenge.Repo

  alias PeekCodeChallenge.Orders
  alias PeekCodeChallenge.Payments.Payment

  @doc """
  Gets a single payment.

  Raises `Ecto.NoResultsError` if the Payment does not exist.

  ## Examples

      iex> get_payment!(123)
      %Payment{}

      iex> get_payment!(456)
      ** (Ecto.NoResultsError)

  """
  def get_payment!(id), do: Repo.get!(Payment, id)

  @doc """
  List all the payments applied to a given order.

  ## Examples

      iex> list_payments_for_order(123)
      [%Payment{}, %Payment{}]
  """
  def list_payments_for_order(order_id) do
    Payment
    |> where([p], p.order_id == ^order_id)
    |> Repo.all()
  end

  @doc """
  Creates a payment and applies it to an order.

  Returns an error if something goes wrong.

  ## Examples

      iex> apply_payment_to_order(123, Money.new("10.00", :USD))
      {:ok, %Payment{}}
  """
  def apply_payment_to_order(order_id, amount) do
    case Orders.get_order(order_id) do
      {:ok, order} ->
        zero = Money.zero(order.amount.currency)

        amount_applied =
          list_payments_for_order(order_id)
          |> Enum.map(& &1.amount)
          |> Enum.reduce(zero, &Money.add!/2)

        if amount_applied >= order.amount do
          {:error, :fully_paid}
        else
          payment =
            %Payment{}
            |> Payment.changeset(%{amount: amount, order_id: order.id})
            |> Repo.insert!()

          case GoblinPay.capture_payment(payment) do
            {:ok, refid} ->
              payment =
                payment
                |> Payment.changeset(%{processor_refid: refid})
                |> Repo.update!()

              {:ok, payment}

            {:error, :network_error} ->
              {:error, :network_error}
          end
        end

      {:error, :not_found} ->
        {:error, :not_found}
    end
  end

  @doc """
  Creates an order and pays for it fully.

  ## Examples

      iex> create_order_and_pay(order_attrs)
      {:ok, %Order{}}
  """
  def create_order_and_pay(order_attrs) do
    case Orders.create_order(order_attrs) do
      {:ok, order} ->
        apply_payment_to_order(order.id, order.amount)

        {:ok, order}

      {:error, changeset} ->
        {:error, changeset}
    end
  end

  @doc """
  Deletes a payment.

  ## Examples

      iex> delete_payment(payment)
      {:ok, %Payment{}}

      iex> delete_payment(payment)
      {:error, %Ecto.Changeset{}}

  """
  def delete_payment(%Payment{} = payment) do
    Repo.delete(payment)
  end
end
