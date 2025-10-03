defmodule Domain.Model.Authentication.SignInDTOTest do
  use ExUnit.Case

  alias Domain.Model.Authentication.SignInDTO
  alias Domain.Model.Shared.Common.Validate.SessionId
  alias Domain.Model.Shared.CQRS.Model.ContextData

  setup do
    :ok
  end

  test "new/3 returns ok tuple with valid data" do
    email_str = "user@example.com"
    session_id = %SessionId{value: "session123"}
    context_data = %ContextData{message_id: "msgid", x_request_id: "xreqid"}

    assert {:ok, %SignInDTO{email: _, session_id: ^session_id, context_data: ^context_data}} =
             SignInDTO.new(email_str, session_id, context_data)
  end

  test "set_sign_in/4 updates sign_in struct" do
    email_str = "user@example.com"
    session_id = %SessionId{value: "session123"}
    context_data = %ContextData{message_id: "msgid", x_request_id: "xreqid"}

    {:ok, sign_in} = SignInDTO.new(email_str, session_id, context_data)
    new_session_id = %SessionId{value: "session456"}
    new_email_str = "newuser@example.com"

    assert {:ok, %SignInDTO{email: _, session_id: ^new_session_id}} =
             SignInDTO.set_sign_in(sign_in, new_email_str, new_session_id, context_data)
  end
end
