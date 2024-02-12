defmodule PeekCodeChallenge.Repo do
  use Ecto.Repo,
    otp_app: :peek_code_challenge,
    adapter: Ecto.Adapters.SQLite3

  def fetch(queryable, id) do
    case get(queryable, id) do
      nil -> {:error, :not_found}
      result -> {:ok, result}
    end
  end
end
