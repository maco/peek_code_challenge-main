defmodule GoblinPay do
  @moduledoc """
  Documentation for `GoblinPay`.
  """

  alias GoblinPay.PaymentStore

  # This function represents an HTTP call to a third party payment system, which
  # will occassionally fail due to a network outage. The application code should account
  # for this.
  def capture_payment(attrs) do
    # Fail about 25% of the time
    [:success, :success, :success, :failure]
    |> Enum.random()
    |> case do
      :success -> {:ok, PaymentStore.capture_payment(attrs)}
      :failure -> {:error, :network_error}
    end
  end
end
