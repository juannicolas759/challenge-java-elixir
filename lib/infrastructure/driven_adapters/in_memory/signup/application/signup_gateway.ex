defmodule Infrastructure.Adapters.InMemory.SignUpGateway do
  @moduledoc """
  In-memory repository for SignUp users using email as key.
  """

  alias Domain.Model.Authentication.SignUpDTO
  alias Domain.Model.Shared.CQRS.Model.ContextData

  @type state :: %{String.t() => SignUpDTO.t()}

  def new(), do: %{}

  @spec save(ContextData.t(),state(), SignUpDTO.t()) :: {:ok, state()} | {:error, :email_already_exists}
  def save(%ContextData{}= _context ,state, %SignUpDTO{email: email} = user) do
    if Map.has_key?(state, email.value) do
      {:error, :email_already_exists}
    else
      {:ok, Map.put(state, email.value, user)}
    end
  end

  @spec get(ContextData.t(),state(), String.t()) :: SignUpDTO.t() | nil
  def get(%ContextData{}= _context, state, email), do: Map.get(state, email)

  @spec exists?(ContextData.t(),state(), String.t()) :: boolean()
  def exists?(%ContextData{}= _context, state, email), do: Map.has_key?(state, email)

end
