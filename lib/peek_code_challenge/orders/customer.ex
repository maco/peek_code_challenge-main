defmodule PeekCodeChallenge.Orders.Customer do
  use Ecto.Schema
  import Ecto.Changeset

  schema "customers" do
    field :name, :string
    field :email, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(customer, attrs) do
    customer
    |> cast(attrs, [:name, :email])
    |> validate_required([:name, :email])
    |> validate_email()
  end

  defp validate_email(changeset) do
    validate_format(changeset, :email, ~r/.+@.+/)
  end
end
