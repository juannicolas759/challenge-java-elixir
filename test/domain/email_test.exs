defmodule Domain.Model.Shared.Common.Validate.EmailTest do
  use ExUnit.Case

  alias Domain.Model.Shared.Common.Validate.Email
  alias Domain.Model.Shared.CQRS.Model.ContextData

  setup do
    context = %ContextData{message_id: "mid", x_request_id: "xid"}
    {:ok, context: context}
  end

  test "email ok", %{context: context} do
    assert {:ok, %Email{value: "valid@test.com"}} = Email.new("valid@test.com", context)
  end

  test "email invalid", %{context: context} do
    assert {:error, 400, error_map} = Email.new("invalid", context)
    assert error_map.code == "ER400_02"
  end

  test "email empty", %{context: context} do
    assert {{:error, 400, error_map}} = Email.new("", context)
    assert error_map.code == "ER400_02"
  end
end
