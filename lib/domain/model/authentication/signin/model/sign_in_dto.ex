defmodule Domain.Model.Authentication.SignInDTO do
  @moduledoc """
  DTO para manejar datos de inicio de sesión (SignIn).
  Integra Value Objects: Email y SessionId.
  """

  alias Domain.Model.Shared.Common.Validate.Email
  alias Domain.Model.Shared.CQRS.Model.ContextData
  alias Domain.Model.Shared.Common.Validate.SessionId

  defstruct [:email, :session_id, :context_data]

  @type t :: %__MODULE__{
          email: Email.t(),
          session_id: SessionId.t(),
          context_data: ContextData.t()
        }

  @spec new(String.t(), SessionId.t(), ContextData.t()) ::
          {:ok, t} | {:error, atom}
  def new(email_str, %SessionId{} = session_id, %ContextData{} = context_data) do
    with {:ok, email} <- Email.new(email_str, context_data) do
      {:ok,
       %__MODULE__{
         email: email,
         session_id: session_id,
         context_data: context_data
       }}
    end
  end

  @spec set_sign_in(t(), String.t(), SessionId.t(), ContextData.t()) ::
          {:ok, t} | {:error, atom}
  def set_sign_in(%__MODULE__{} = sign_in, email_str, %SessionId{} = session_id, %ContextData{} = context_data) do
    with {:ok, email} <- Email.new(email_str, context_data) do
      {:ok,
       %__MODULE__{
         sign_in
         | email: email,
           session_id: session_id
       }}
    end
  end
end
