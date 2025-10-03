defmodule Domain.UseCase.Authentication.SignUpTest do
  use ExUnit.Case

  alias Domain.UseCase.Authentication.SignUp
  alias Domain.Model.Shared.CQRS.Model.ContextData
  alias Infrastructure.Adapters.InMemory.SignUpGateway

  setup do
    context = %ContextData{message_id: "mid", x_request_id: "xid"}
    state = SignUpGateway.new()
    {:ok, context: context, state: state}
  end

  test "signup ok", %{context: context, state: state} do
    {:ok, dto, new_state} = SignUp.execute(state, "test@test.com", "password123", "Test", context)
    assert dto.email.value == "test@test.com"
    assert new_state["test@test.com"]
  end

  test "email exist (409)", %{context: context, state: state} do
    {:ok, _dto, state1} = SignUp.execute(state, "dup@test.com", "password123", "Test", context)
    {:error, 409, error_map} = SignUp.execute(state1, "dup@test.com", "password123", "Test", context)
    assert error_map.code == "ER409_00"
  end

  test "email invalid (400)", %{context: context, state: state} do
    {:error, 400, error_map} = SignUp.execute(state, "invalid-email", "password123", "Test", context)
    assert error_map.code == "ER400_02"
  end

  test "password weak (400)", %{context: context, state: state} do
    {:error, 400, error_map} = SignUp.execute(state, "pw@test.com", "123", "Test", context)
    assert error_map.code == "ER400_01"
  end
end
