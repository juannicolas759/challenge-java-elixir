defmodule ChallengeElixir.Infrastructure.EntryPoints.RestController.RouterController do
  @compile if Mix.env() == :test, do: :export_all
  @moduledoc """
  Access point to the rest exposed services
  """
  # alias ChallengeElixir.Utils.DataTypeUtils
  require Logger
  use Plug.Router
  # suse Plug.Conn
  use Timex
  use Plug.ErrorHandler

  alias Domain.Model.Shared.Common.Exception.BusinessCode
  alias Infrastructure.EntryPoints.RestController.Authentication.Signup.Domain.SignUpDTO
  alias Infrastructure.EntryPoints.RestController.Authentication.Signin.Domain.SignInDTO

  plug(CORSPlug,
    methods: ["GET", "POST", "PUT", "DELETE"],
    origin: [~r/.*/],
    headers: ["Content-Type", "Accept", "User-Agent"]
  )

  plug(Plug.Logger, log: :debug)
  plug(:match)
  plug(Plug.Parsers, parsers: [:urlencoded, :json], json_decoder: Poison)
  plug(Plug.Telemetry, event_prefix: [:challenge_elixir, :plug])
  plug(:dispatch)

  forward("/signup",
    to: Infrastructure.EntryPoints.RestController.Authentication.Signup.Application.SignupHandler,
    schema: SignUpDTO
  )

  forward("/signin",
    to: Infrastructure.EntryPoints.RestController.Authentication.Signin.Application.SigninHandler,
    schema: SignInDTO
  )


  defp handle_errors(conn, %{kind: _kind, reason: _reason, stack: _stack}) do
    message_id = List.first(Plug.Conn.get_req_header(conn, "message-id"))
    x_request_id = List.first(Plug.Conn.get_req_header(conn, "x-request-id"))

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(
      BusinessCode.status_code(:bad_request),
      Jason.encode!(%{
        code: BusinessCode.business_code_message(:ER400_00),
        message: BusinessCode.code_message(:ER400_00),
        detail: %{
          business_code: BusinessCode.business_code(:ER400_00),
          category: BusinessCode.category(:BEX_ECS)
        },
        correlation: %{
          message_id: message_id,
          x_request_id: x_request_id
        }
      })
    )
  end

  match _ do
    send_resp(
      conn,
      404,
      {:error,
       %{
         code: BusinessCode.business_code(:ER500_00),
         message: BusinessCode.code_message(:ER500_00),
         detail: BusinessCode.business_code_message(:ER500_00),
         category: BusinessCode.category(:BEX_ECS)
       }}
    )
  end
end
