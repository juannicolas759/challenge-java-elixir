defmodule Domain.Model.Authentication.SignUpDTOTest do
  use ExUnit.Case

  alias Domain.Model.Authentication.SignUpDTO
  alias Domain.Model.Shared.CQRS.Model.ContextData


  setup do
    context_data = %ContextData{message_id: "msgid", x_request_id: "xreqid"}
    {:ok, context_data: context_data}
  end

  test "new/4 returns ok tuple with valid data", %{context_data: context_data} do
    email_str = "user@example.com"
    password_str = "StrongPassword123"
    name = "Test User"

    assert {:ok, %SignUpDTO{email: _, password: _, name: ^name, context_data: ^context_data}} =
             SignUpDTO.new(email_str, password_str, name, context_data)
  end

  test "new/4 returns error tuple with invalid email", %{context_data: context_data} do
    email_str = "invalid-email"
    password_str = "StrongPassword123"
    name = "Test User"

    assert {:error, 400, error_map} = SignUpDTO.new(email_str, password_str, name, context_data)
  end

  test "set_sign_up/5 updates sign_up struct", %{context_data: context_data} do
    email_str = "user@example.com"
    password_str = "StrongPassword123"
    name = "Test User"

    {:ok, sign_up} = SignUpDTO.new(email_str, password_str, name, context_data)
    new_email_str = "newuser@example.com"
    new_password_str = "NewStrongPassword456"
    new_name = "New Name"

    assert {:ok, %SignUpDTO{email: _, password: _, name: ^new_name}} =
             SignUpDTO.set_sign_up(
               sign_up,
               new_email_str,
               new_password_str,
               new_name,
               context_data
             )
  end
end
