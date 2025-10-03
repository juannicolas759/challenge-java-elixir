defmodule Infrastructure.EntryPoints.RestController.Authentication.Signup.Domain.SignUpDTO do
  @moduledoc """
  DTO para manejar datos de registro (SignUp).
  """

  alias Domain.Model.Shared.CQRS.Model.ContextData
  alias Domain.Model.Shared.Common.Exception.BusinessCode

  defstruct [:email, :password, :name, :context_data]

  @type t :: %__MODULE__{
          email: String.t(),
          password: String.t(),
          name: String.t(),
          context_data: ContextData.t()
        }

  @spec new(String.t(), String.t(), String.t(), ContextData.t()) ::
          {:ok, t} | {:error, atom}
  def new(email, pass, name, %ContextData{} = context_data) do
    if is_nil(email) or is_nil(pass) or is_nil(name) do
      {:error, BusinessCode.status_code(:bad_request),
       %{
         code: BusinessCode.business_code_message(:ER400_00),
         message: BusinessCode.code_message(:ER400_00),
         detail: %{
           business_code: BusinessCode.business_code(:ER400_00),
           category: BusinessCode.category(:BEX_ECS)
         },
         correlation: %{
           message_id: context_data.message_id,
           x_request_id: context_data.x_request_id
         }
       }}
    else
      {:ok,
       %__MODULE__{
         email: email,
         password: pass,
         name: name,
         context_data: context_data
       }}
    end
  end
end
