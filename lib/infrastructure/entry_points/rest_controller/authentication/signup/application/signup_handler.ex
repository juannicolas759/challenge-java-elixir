defmodule Infrastructure.EntryPoints.RestController.Authentication.Signup.Application.SignupHandler do
  import Plug.Conn
  alias Domain.UseCase.Authentication.SignUp
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
    name = params["name"]

    message_id = Plug.Conn.get_req_header(conn, "message-id") |> List.first() || UUID.uuid4()
    x_request_id = Plug.Conn.get_req_header(conn, "x-request-id") |> List.first() || message_id

    {:ok, context} = ContextData.new(message_id, x_request_id)


    state = Infrastructure.DrivenAdapters.InMemory.Signup.Application.SignUpStateAgent.get_state()

    case SignUp.execute(state, email, password, name, context) do
      {:ok, _dto, new_state} ->
        Infrastructure.DrivenAdapters.InMemory.Signup.Application.SignUpStateAgent.update_state(
          new_state
        )

        conn
        |> put_resp_content_type("application/json")
        |> send_resp(201, "")

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

  match _ do
    send_resp(conn, 404, "Not Found")
  end

end
