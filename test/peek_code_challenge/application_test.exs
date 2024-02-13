defmodule PeekCodeChallenge.ApplicationTest do
  use PeekCodeChallenge.DataCase

  describe "clear_expired_tokens/1 does so" do
    :ets.insert(:idempotency_tokens, {"1", System.os_time() - 100_000})
    :ets.insert(:idempotency_tokens, {"2", System.os_time() - 10_000})
    :ets.insert(:idempotency_tokens, {"3", System.os_time()})

    yesterday = :ets.lookup(:idempotency_tokens, "1")
    earlier = :ets.lookup(:idempotency_tokens, "2")
    recently = :ets.lookup(:idempotency_tokens, "3")

    assert 1 == length(yesterday)
    assert 1 == length(earlier)
    assert 1 == length(recently)

    PeekCodeChallenge.clear_expired_tokens(:idempotency_tokens)
    yesterday = :ets.lookup(:idempotency_tokens, "1")
    earlier = :ets.lookup(:idempotency_tokens, "2")
    recently = :ets.lookup(:idempotency_tokens, "3")

    assert 0 == length(yesterday)
    assert 1 == length(earlier)
    assert 1 == length(recently)
  end
end
