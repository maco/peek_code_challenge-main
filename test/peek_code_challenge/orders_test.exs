defmodule PeekCodeChallenge.OrdersTest do
  use PeekCodeChallenge.DataCase

  alias PeekCodeChallenge.Orders

  describe "customers" do
    alias PeekCodeChallenge.Orders.Customer

    import PeekCodeChallenge.OrdersFixtures

    @invalid_attrs %{name: nil, email: "not an email"}

    test "list_customers/0 returns all customers" do
      customer = customer_fixture()
      assert Orders.list_customers() == [customer]
    end

    test "get_customer!/1 returns the customer with given id" do
      customer = customer_fixture()
      assert Orders.get_customer!(customer.id) == customer
    end

    test "create_customer/1 with valid data creates a customer" do
      valid_attrs = %{name: "some name", email: "some@gmail.com"}

      assert {:ok, %Customer{} = customer} = Orders.create_customer(valid_attrs)
      assert customer.name == "some name"
      assert customer.email == "some@gmail.com"
    end

    test "create_customer/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Orders.create_customer(@invalid_attrs)
    end

    test "update_customer/2 with valid data updates the customer" do
      customer = customer_fixture()
      update_attrs = %{name: "some updated name", email: "some-updated@email.com"}

      assert {:ok, %Customer{} = customer} = Orders.update_customer(customer, update_attrs)
      assert customer.name == "some updated name"
      assert customer.email == "some-updated@email.com"
    end

    test "update_customer/2 with invalid data returns error changeset" do
      customer = customer_fixture()
      assert {:error, %Ecto.Changeset{}} = Orders.update_customer(customer, @invalid_attrs)
      assert customer == Orders.get_customer!(customer.id)
    end

    test "delete_customer/1 deletes the customer" do
      customer = customer_fixture()
      assert {:ok, %Customer{}} = Orders.delete_customer(customer)
      assert_raise Ecto.NoResultsError, fn -> Orders.get_customer!(customer.id) end
    end
  end

  describe "orders" do
    alias PeekCodeChallenge.Orders.Order

    import PeekCodeChallenge.OrdersFixtures

    @invalid_attrs %{amount: nil, customer_id: nil}

    test "list_orders/0 returns all orders" do
      order = order_fixture()
      assert Orders.list_orders() == [order]
    end

    test "get_order!/1 returns the order with given id" do
      order = order_fixture()
      assert Orders.get_order!(order.id) == order
    end

    test "get_order/1 returns the order with given id" do
      order = order_fixture()
      assert Orders.get_order(order.id) == {:ok, order}
    end

    test "get_order/1 returns not_found error when the order does not exist" do
      assert Orders.get_order(1) == {:error, :not_found}
    end

    test "create_order/1 with valid data creates a order" do
      customer = customer_fixture()
      valid_attrs = %{amount: ~M[15.00]USD, customer_id: customer.id}

      assert {:ok, %Order{} = order} = Orders.create_order(valid_attrs)
      assert order.amount == ~M[15.00]USD
      assert order.customer_id == customer.id
    end

    test "create_order/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Orders.create_order(@invalid_attrs)
    end

    test "update_order/2 with valid data updates the order" do
      order = order_fixture()
      update_attrs = %{amount: ~M[20.00]USD}

      assert {:ok, %Order{} = order} = Orders.update_order(order, update_attrs)
      assert order.amount == ~M[20.00]USD
    end

    test "update_order/2 with invalid data returns error changeset" do
      order = order_fixture()
      assert {:error, %Ecto.Changeset{}} = Orders.update_order(order, @invalid_attrs)
      assert order == Orders.get_order!(order.id)
    end

    test "delete_order/1 deletes the order" do
      order = order_fixture()
      assert {:ok, %Order{}} = Orders.delete_order(order)
      assert_raise Ecto.NoResultsError, fn -> Orders.get_order!(order.id) end
    end

    test "get_orders_for_customer/1 returns all order for the given customer email" do
      customer1 = customer_fixture(%{email: "some@gmail.com"})
      customer2 = customer_fixture(%{email: "other@gmail.com"})

      order1 = order_fixture(%{customer_id: customer1.id})
      order2 = order_fixture(%{customer_id: customer1.id})

      order3 = order_fixture(%{customer_id: customer2.id})

      assert Orders.get_orders_for_customer(customer1.email) == [order1, order2]
      assert Orders.get_orders_for_customer(customer2.email) == [order3]
    end
  end
end
