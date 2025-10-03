defmodule Infrastructure.Adapters.InMemory.SignInGateway do
  @moduledoc """
  In-memory repository for SignIn sessions using email as key.
  """

  alias Domain.Model.Shared.Common.Validate.SessionId

  @type state :: %{String.t() => SessionId.t()}

  @doc """
  Inicializa el estado vacío.
  """
  def new(), do: %{}

  @doc """
  Guarda la sesión en el mapa usando el email como llave.
  """
  @spec save(state(), String.t(), SessionId.t()) :: state()
  def save(state, email, %SessionId{} = session_id) do
    Map.put(state, email, session_id)
  end

  @doc """
  Busca la sesión por email.
  """
  @spec get(state(), String.t()) :: SessionId.t() | nil
  def get(state, email) do
    Map.get(state, email)
  end


end
