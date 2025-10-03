defmodule Domain.Model.Authentication.SignUpDTO do
  @moduledoc """
  DTO para manejar datos de registro (SignUp).
  Integra Value Objects: Email y Password.
  """

  alias Domain.Model.Shared.Common.Validate.Email
  alias Domain.Model.Shared.Common.Validate.Password
  alias Domain.Model.Shared.CQRS.Model.ContextData

  defstruct [:email, :password, :name, :context_data]

  @type t :: %__MODULE__{
          email: Email.t(),
          password: Password.t(),
          name: String.t(),
          context_data: ContextData.t()
        }

  @spec new(String.t(), String.t(), String.t(), ContextData.t()) ::
          {:ok, t} | {:error, atom}
  def new(email_str, password_str, name, %ContextData{} = context_data) do
    with {:ok, email} <- Email.new(email_str, context_data),
         {:ok, pass} <- Password.new(password_str, context_data),
         :ok <- Password.validate(pass,context_data) do
      {:ok,
       %__MODULE__{
         email: email,
         password: pass,
         name: name,
         context_data: context_data
       }}
    else
      {:error, reason} -> {:error, reason}
    end
  end

  @spec set_sign_in(t(), String.t(), String.t(), String.t(), ContextData.t()) ::
          {:ok, t} | {:error, atom}
  def set_sign_in(%__MODULE__{} = sign_in, email_str, password_str, name, %ContextData{} = context_data) do
    with {:ok, email} <- Email.new(email_str,context_data),
         {:ok, pass} <- Password.new(password_str, context_data),
         :ok <- Password.validate(pass, context_data) do
      {:ok,
       %__MODULE__{
         sign_in
         | email: email,
           password: pass,
           name: name
       }}
    else
      {:error, reason} -> {:error, reason}
    end
  end
end
