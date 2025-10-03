defmodule Domain.Model.Shared.Common.Validate.Password do
  @moduledoc """
  Value Object para Password.
  - Puede construirse con cualquier string.
  - La validación de reglas de negocio (>= 8 caracteres) se hace
    explícitamente con `validate/1`.
  """

  alias Domain.Model.Shared.Common.Exception.BusinessCode
  alias Domain.Model.Shared.CQRS.Model.ContextData
  defstruct [:value]

  @type t :: %__MODULE__{
          value: String.t()
        }

  @spec new(t(), ContextData.t()) :: :ok | {:error, integer(), map()}
  def new(value, %ContextData{} = context_data) when is_binary(value) do
    if !is_nil(value) do
      {:ok, %__MODULE__{value: value}}
    else
      {:error, BusinessCode.status_code(:bad_request),
       %{
         code: BusinessCode.business_code_message(:ER400_01),
         message: BusinessCode.code_message(:ER400_01),
         detail: %{
           business_code: BusinessCode.business_code(:ER400_01),
           category: BusinessCode.category(:BEX_ECS)
         },
         correlation: %{
           message_id: context_data.message_id,
           x_request_id: context_data.x_request_id
         }
       }}
    end
  end

  @spec validate(t(), ContextData.t()) :: :ok | {:error, integer(), map()}
  def validate(%__MODULE__{value: password}, %ContextData{} = context_data) do
    if String.length(password) >= 8 do
      :ok
    else
      {:error, BusinessCode.status_code(:bad_request),
       %{
         code: BusinessCode.business_code_message(:ER400_01),
         message: BusinessCode.code_message(:ER400_01),
         detail: %{
           business_code: BusinessCode.business_code(:ER400_01),
           category: BusinessCode.category(:BEX_ECS)
         },
         correlation: %{
           message_id: context_data.message_id,
           x_request_id: context_data.x_request_id
         }
       }}
    end
  end
end
