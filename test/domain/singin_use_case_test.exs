defmodule Domain.UseCases.Authentication.Signin.SigninUseCaseTest do
  use ExUnit.Case

  alias Domain.UseCases.Authentication.Signin.SigninUseCase
  alias Domain.UseCase.Authentication.SignUp
  alias Domain.Model.Shared.CQRS.Model.ContextData
  alias Infrastructure.Adapters.InMemory.{SignUpGateway, SignInGateway}

  setup do
    context = %ContextData{message_id: "mid", x_request_id: "xid"}
    user_state = SignUpGateway.new()
    session_state = SignInGateway.new()
    {:ok, context: context, user_state: user_state, session_state: session_state}
  end

  test "signin ok", %{context: context, user_state: user_state, session_state: session_state} do
    {:ok, _dto, user_state} = SignUp.execute(user_state, "user@test.com", "password123", "Test", context)
    {:ok, dto, _new_session_state} = SigninUseCase.execute("user@test.com", "password123", context, user_state, session_state)
    assert dto.session_id.value
  end

  test "user not found (404)", %{context: context, user_state: user_state, session_state: session_state} do
    {:error, 404, error_map} = SigninUseCase.execute("nouser@test.com", "password123", context, user_state, session_state)
    assert error_map.code == "ER404_00"
  end

  test "credentials invalid (401)", %{context: context, user_state: user_state, session_state: session_state} do
    {:ok, _dto, user_state} = SignUp.execute(user_state, "user2@test.com", "password123", "Test", context)
    {:error, 401, error_map} = SigninUseCase.execute("user2@test.com", "wrongpass", context, user_state, session_state)
    assert error_map.code == "ER401_00"
  end
end
