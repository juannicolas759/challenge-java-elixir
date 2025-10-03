defmodule Domain.UseCases.Authentication.Signin.SigninUseCase do
  @moduledoc """
  Caso de uso: iniciar sesión (SignIn).
  - Verifica si el usuario existe por email.
  - Valida password (texto plano).
  - Genera un session_id (UUID) y persiste la sesión en memoria.
  - Retorna un SignInDTO con el session_id.
  """
  alias Domain.Model.Authentication.SignInDTO
  alias Domain.Model.Shared.Common.Validate.{Email, SessionId}
  alias Domain.Model.Shared.CQRS.Model.ContextData
  alias Infrastructure.Adapters.InMemory.{SignInGateway, SignUpGateway}
  alias Domain.Model.Shared.Common.Exception.BusinessCode

  @spec execute(String.t(), String.t(), ContextData.t(), map(), map()) ::
          {:ok, SignInDTO.t(), map()} | {:error, atom()}
  def execute(email_str, password_str, %ContextData{} = context_data, user_state, session_state) do
  with {:ok, email} <- Email.new(email_str, context_data),
       user when not is_nil(user) <- SignUpGateway.get(context_data, user_state, email.value),
       true <- user.password.value == password_str,
       {:ok, session_id} <- SessionId.new(),
       {:ok, dto} <- SignInDTO.new(email_str, session_id, context_data),
       new_session_state <- SignInGateway.save(session_state, email.value, session_id) do
    {:ok, dto, new_session_state}
  else
    nil ->
      {:error, BusinessCode.status_code(:not_found),
       %{
         code: BusinessCode.business_code_message(:ER404_00),
         message: BusinessCode.code_message(:ER404_00),
         detail: %{
           business_code: BusinessCode.business_code(:ER404_00),
           category: BusinessCode.category(:BEX_ECS)
         },
         correlation: %{
           message_id: context_data.message_id,
           x_request_id: context_data.x_request_id
         }
       }}
    false ->
      {:error, BusinessCode.status_code(:unauthorized),
       %{
         code: BusinessCode.business_code_message(:ER401_00),
         message: BusinessCode.code_message(:ER401_00),
         detail: %{
           business_code: BusinessCode.business_code(:ER401_00),
           category: BusinessCode.category(:BEX_ECS)
         },
         correlation: %{
           message_id: context_data.message_id,
           x_request_id: context_data.x_request_id
         }
       }}
    {:error, status, error_map} ->
      {:error, status, error_map}
  end
end
end
