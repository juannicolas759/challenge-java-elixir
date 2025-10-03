defmodule Domain.UseCase.Authentication.SignUp do
  @moduledoc """
  Use case for user SignUp.
  """

  alias Domain.Model.Shared.Common.Validate.{Email, Password}
  alias Domain.Model.Shared.CQRS.Model.ContextData
  alias Domain.Model.Authentication.SignUpDTO
  alias Infrastructure.Adapters.InMemory.SignUpGateway
  alias Domain.Model.Shared.Common.Exception.BusinessCode

  @type state :: SignUpGateway.state()

  @spec execute(state(), String.t(), String.t(), String.t(), ContextData.t()) ::
          {:ok, SignUpDTO.t(), state()} | {:error, atom()}
  def execute(state, email_str, password_str, name_str, %ContextData{} = context_data) do
    with {:ok, email} <- Email.new(email_str, context_data),
         {:ok, password} <- Password.new(password_str, context_data),
         false <- SignUpGateway.exists?(context_data, state, email.value),
         :ok <- Password.validate(password, context_data),
         {:ok, dto} <- SignUpDTO.new(email_str, password_str, name_str, context_data),
         {:ok, new_state} <- SignUpGateway.save(context_data, state, dto) do
      {:ok, dto, new_state}
    else
      true ->
        {:error, BusinessCode.status_code(:conflict),
         %{
           code: BusinessCode.business_code_message(:ER409_00),
           message: BusinessCode.code_message(:ER409_00),
           detail: %{
             business_code: BusinessCode.business_code(:ER409_00),
             category: BusinessCode.category(:BEX_ECS)
           },
           correlation: %{
             message_id: context_data.message_id,
             x_request_id: context_data.x_request_id
           }
         }}

      {:error, status, error_map} ->
        {:error, status, error_map}

      {:error, reason} when is_atom(reason) ->
        {:error, BusinessCode.status_code(:internal_server_error),
         %{
           code: BusinessCode.business_code_message(:ER500_00),
           message: "Error inesperado",
           detail: %{reason: to_string(reason)},
           correlation: %{
             message_id: context_data.message_id,
             x_request_id: context_data.x_request_id
           }
         }}
    end
  end
end
