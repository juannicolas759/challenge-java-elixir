defmodule Domain.Model.Shared.Common.Validate.SessionId do
  @moduledoc """
  Value Object para SessionId.
  - Encapsula un UUID.
  - Garantiza que siempre sea un valor válido.
  """

  defstruct [:value]

  @type t :: %__MODULE__{
          value: String.t()
        }

  @doc """
  Crea un nuevo SessionId con un UUID v4 generado automáticamente.
  """
  @spec new() :: {:ok, t}
  def new do
    {:ok, %__MODULE__{value: UUID.uuid4()}}
  end

  @doc """
  Crea un SessionId a partir de un string existente.
  Retorna {:ok, session_id} si es válido, {:error, :invalid_uuid} si no.
  """
  @spec from_string(String.t()) :: {:ok, t} | {:error, atom}
  def from_string(uuid_str) when is_binary(uuid_str) do
    case UUID.info(uuid_str) do
      {:ok, _info} -> {:ok, %__MODULE__{value: uuid_str}}
      _ -> {:error, :invalid_uuid}
    end
  end
end
