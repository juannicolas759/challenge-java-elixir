defmodule Domain.Model.Shared.Common.Validate.Email do
  @moduledoc """
  Value Object para representar un Email válido.
  """

  alias Domain.Model.Shared.Common.Exception.BusinessCode
  alias Domain.Model.Shared.CQRS.Model.ContextData

  defstruct [:value]

  @type t :: %__MODULE__{value: String.t()}


  @regex ~r/^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/


  @spec new(String.t(), ContextData.t()) :: {:ok, t} | {:error, atom}
  def new(email, %ContextData{} = context_data) when is_binary(email) do
    email = String.trim(email) |> String.downcase()

    cond do
      email == "" ->
        {{:error, BusinessCode.status_code(:bad_request), %{
          code: BusinessCode.business_code_message(:ER400_02),
          message: BusinessCode.code_message(:ER400_02),
          detail: %{business_code: BusinessCode.business_code(:ER400_02), category: BusinessCode.category(:BEX_ECS) },
          correlation: %{message_id: context_data.message_id, x_request_id: context_data.x_request_id}
        }}}

      not Regex.match?(@regex, email) ->
        {:error, BusinessCode.status_code(:bad_request), %{
          code: BusinessCode.business_code_message(:ER400_02),
          message: BusinessCode.code_message(:ER400_02),
          detail: %{business_code: BusinessCode.business_code(:ER400_02), category: BusinessCode.category(:BEX_ECS) },
          correlation: %{message_id: context_data.message_id, x_request_id: context_data.x_request_id}
        }}

      true ->
        {:ok, %__MODULE__{value: email}}
    end
  end
end
