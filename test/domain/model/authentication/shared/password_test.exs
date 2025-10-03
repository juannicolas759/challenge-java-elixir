defmodule Domain.Model.Shared.Common.Validate.PasswordTest do
  use ExUnit.Case

  alias Domain.Model.Shared.Common.Validate.Password
  alias Domain.Model.Shared.CQRS.Model.ContextData

  setup do
    context = %ContextData{message_id: "mid", x_request_id: "xid"}
    {:ok, context: context}
  end

  test "password ok", %{context: context} do
    assert {:ok, %Password{value: "password123"}} = Password.new("password123", context)
    assert :ok = Password.validate(%Password{value: "password123"}, context)
  end

  test "password weak", %{context: context} do
    assert {:ok, %Password{value: "123"}} = Password.new("123", context)
    assert {:error, 400, error_map} = Password.validate(%Password{value: "123"}, context)
    assert error_map.code == "WEAK_PASSWORD"
  end
end
