defmodule PeekCodeChallenge do
  @moduledoc """
  PeekCodeChallenge keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  @doc """
  Delete idempotency tokens out of ETS if more than 24 hours old
  """
  def clear_expired_tokens(table_name) do
    yesterday = System.os_time() - 86400

    # :ets.select_delete(table_name, :ets.fun2ms(fn {_token, timestamp} when timestamp < yesterday -> true end))
    :ets.select_delete(table_name, [{{:_, :"$1"}, [{:<, :"$1", yesterday}], [true]}])
    # ets.select(table_name, [])
    # |> Enum.each(fn token -> :ets.delete(table_name, token) end)
  end
end
