defmodule ChallengeElixir.Application do
  @moduledoc """
  ChallengeElixir application
  """

  alias ChallengeElixir.Infrastructure.EntryPoints.RestController.RouterController
  alias ChallengeElixir.Config.{AppConfig, ConfigHolder}

  use Application
  require Logger

  def start(_type, [env]) do
    config = AppConfig.load_config()

    children = with_plug_server(config) ++ all_env_children(config) ++ env_children(env, config)

    opts = [strategy: :one_for_one, name: ChallengeElixir.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp with_plug_server(%AppConfig{enable_server: true, http_port: port}) do
    Logger.debug("Configure Http server in port #{inspect(port)}. ")
    [{Plug.Cowboy, scheme: :http, plug: RouterController, options: [port: port]}]
  end

  defp with_plug_server(%AppConfig{enable_server: false}), do: []

  def all_env_children(%AppConfig{} = config) do
    [
      {ConfigHolder, config},
      Infrastructure.DrivenAdapters.InMemory.Signup.Application.SignUpStateAgent,
      Infrastructure.DrivenAdapters.InMemory.Signin.Application.SignInStateAgent
    ]
  end

  def env_children(:test, %AppConfig{}) do
    []
  end

  def env_children(_other_env, _config) do
    []
  end
end
