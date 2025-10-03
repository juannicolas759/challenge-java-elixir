defmodule ChallengeElixir.ApplicationTest do
  use ExUnit.Case
  doctest ChallengeElixir.Application
  alias ChallengeElixir.Config.{ConfigHolder, AppConfig}

  test "test childrens" do
    assert ChallengeElixir.Application.env_children(:test, %AppConfig{}) == []
  end

  setup do
    if :ets.info(:challenge_elixir_config) == :undefined do
      :ets.new(:challenge_elixir_config, [:public, :named_table, read_concurrency: true])
    end

    :ets.delete_all_objects(:challenge_elixir_config)
    :ok
  end

  test "conf/0 returns the current config when it exists" do
    config = %AppConfig{env: :test, enable_server: true, http_port: 8083}

    :ets.insert(:challenge_elixir_config, {:config, config})

    assert ConfigHolder.conf() == config
  end

  test "get!/1 raises an error when the key does not exist" do
    :ets.delete_all_objects(:challenge_elixir_config)

    assert_raise RuntimeError, "Config with key :nonexistent_key not found", fn ->
      ConfigHolder.get!(:nonexistent_key)
    end
  end
end
