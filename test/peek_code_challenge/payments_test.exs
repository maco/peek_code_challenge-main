defmodule PeekCodeChallenge.PaymentsTest do
  use PeekCodeChallenge.DataCase

  alias PeekCodeChallenge.Payments

  describe "payments" do
    alias PeekCodeChallenge.Payments.Payment

    import PeekCodeChallenge.OrdersFixtures
    import PeekCodeChallenge.PaymentsFixtures

    test "list_payments_for_order/1 returns all payments for a given order" do
      order1 = order_fixture(%{amount: ~M[30.00]USD})
      order2 = order_fixture()

      payment1 = payment_fixture(order1.id, ~M[20.00]USD)
      payment2 = payment_fixture(order1.id, ~M[10.00]USD)
      payment3 = payment_fixture(order2.id)

      assert Payments.list_payments_for_order(order1.id) == [payment1, payment2]
      assert Payments.list_payments_for_order(order2.id) == [payment3]
    end

    test "apply_payment_to_order/3 applies a payment to an order" do
      order = order_fixture()

      assert {:ok, payment} =
               Payments.apply_payment_to_order(order.id, order.amount, UUID.uuid4())

      assert payment.amount == order.amount
      assert payment.order_id == order.id

      # TODO: Check if the payment was created in the processor somehow???
      assert is_binary(payment.processor_refid)
    end

    test "apply_payment_to_order/3 does not apply a payment to a non-existing order" do
      assert {:error, :not_found} = Payments.apply_payment_to_order(1, ~M[10.00]USD, UUID.uuid4())
    end

    test "apply_payment_to_order/3 does not apply a payment if the balance is already paid" do
      order = order_fixture()
      payment_fixture(order.id, order.amount)

      assert {:error, :fully_paid} =
               Payments.apply_payment_to_order(1, ~M[10.00]USD, UUID.uuid4())
    end

    test "apply_payment_to_order/3 does not reapply payment if client doesn't send new token" do
      order = order_fixture(%{amount: ~M[50.00]USD})
      token = UUID.uuid4()
      Payments.apply_payment_to_order(order.id, ~M[10.00]USD, token)
      Payments.apply_payment_to_order(order.id, ~M[10.00]USD, token)
      assert 1 == length(Payments.list_payments_for_order(order.id))
    end

    test "apply_payment_to_order/3 can be called multiple times (with new tokens)" do
      order = order_fixture(%{amount: ~M[50.00]USD})
      Payments.apply_payment_to_order(order.id, ~M[10.00]USD, UUID.uuid4())
      Payments.apply_payment_to_order(order.id, ~M[10.00]USD, UUID.uuid4())
      Payments.apply_payment_to_order(order.id, ~M[30.00]USD, UUID.uuid4())
      assert 3 == length(Payments.list_payments_for_order(order.id))
    end

    test "create_order_and_pay/1 creates an order an applies a payment for it" do
      customer = customer_fixture()

      assert {:ok, order} =
               Payments.create_order_and_pay(%{amount: ~M[55.95]USD, customer_id: customer.id})

      assert order.amount == ~M[55.95]USD

      assert [payment] = Payments.list_payments_for_order(order.id)

      assert payment.amount == order.amount
    end

    test "create_order_and_pay/1 fails if the attrs are invalid" do
      assert {:error, %Ecto.Changeset{}} = Payments.create_order_and_pay(%{amount: nil})
    end

    test "get_payment!/1 returns the payment with given id" do
      order = order_fixture()
      payment = payment_fixture(order.id)
      assert Payments.get_payment!(payment.id) == payment
    end

    test "delete_payment/1 deletes the payment" do
      order = order_fixture()
      payment = payment_fixture(order.id)
      assert {:ok, %Payment{}} = Payments.delete_payment(payment)
      assert_raise Ecto.NoResultsError, fn -> Payments.get_payment!(payment.id) end
    end
  end
end
