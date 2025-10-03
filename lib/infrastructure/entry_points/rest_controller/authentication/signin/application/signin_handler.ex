defmodule Infrastructure.EntryPoints.RestController.Authentication.Signin.Application.SigninHandler do
  import Plug.Conn
  alias Domain.UseCases.Authentication.Signin.SigninUseCase
  alias Domain.Model.Shared.CQRS.Model.ContextData
  alias Domain.Model.Shared.Common.Exception.BusinessCode
  use Plug.Router

  plug(Plug.Parsers,
    parsers: [:urlencoded, :json],
    pass: ["*/*"],
    json_decoder: Jason
  )

  plug(:match)
  plug(:dispatch)

  post "/" do
    params = conn.body_params

    email = params["email"]
    password = params["password"]

    message_id = Plug.Conn.get_req_header(conn, "message-id") |> List.first() || UUID.uuid4()
    x_request_id = Plug.Conn.get_req_header(conn, "x-request-id") |> List.first() || message_id

    {:ok, context} = ContextData.new(message_id, x_request_id)

    if is_nil(email) or is_nil(password) do
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
                message_id: context.message_id,
                x_request_id: context.x_request_id
              }
            })
          )
    else


      user_state =
        Infrastructure.DrivenAdapters.InMemory.Signup.Application.SignUpStateAgent.get_state()

      session_state =
        Infrastructure.DrivenAdapters.InMemory.Signin.Application.SignInStateAgent.get_state()

      case SigninUseCase.execute(email, password, context, user_state, session_state) do
        {:ok, dto, _new_session_state} ->
          conn
          |> put_resp_content_type("application/json")
          |> send_resp(
            200,
            Jason.encode!(%{
              session_id: dto.session_id.value
            })
          )

        {:error, status, reason} ->
          conn
          |> put_resp_content_type("application/json")
          |> send_resp(status, Jason.encode!(%{error: reason}))

        _ ->
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
                message_id: context.message_id,
                x_request_id: context.x_request_id
              }
            })
          )
      end
    end
  end

  match _ do
    send_resp(conn, 404, "Not Found")
  end
end
