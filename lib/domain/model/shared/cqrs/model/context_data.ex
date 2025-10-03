defmodule Domain.Model.Shared.CQRS.Model.ContextData do
  @moduledoc """
  ContextData module for storing request-scoped metadata according to Clean Architecture and DDD.
  Both `message_id` and `x_request_id` must be UUID v4 strings.
  """

  @enforce_keys [:message_id, :x_request_id]
  defstruct [:message_id, :x_request_id]

  @type t :: %__MODULE__{
          message_id: String.t(),
          x_request_id: String.t()
        }

  @doc """
  Creates a new ContextData struct.
  Both IDs must be valid UUIDs.
  """
  @spec new(String.t(), String.t()) :: {:ok, t} | {:error, atom}
  def new(message_id, x_request_id) do
    with {:ok, _} <- UUID.info(message_id),
         {:ok, _} <- UUID.info(x_request_id) do
      {:ok,
       %__MODULE__{
         message_id: message_id,
         x_request_id: x_request_id
       }}
    else
      _ -> {:error, :invalid_uuid}
    end
  end

  def from_connection(conn) do
    _message_id = extract_header(conn, "message-id")
    _x_request_id = extract_header(conn, "x-request-id") || extract_header(conn, "message-id")
  end

  def new(opts\\ []) do
    %__MODULE__{
      message_id: opts[:message_id] || UUID.uuid4(),
      x_request_id: opts[:x_request_id] || UUID.uuid4()
    }
  end

  def get do
    Process.get(:context_data)
  end

  def put(%__MODULE__{} = context_data) do
    Process.put(:context_data, context_data)
  end

  defp extract_header(conn, header) do
    case Plug.Conn.get_req_header(conn, header) do
      [value | _] -> value
      [] -> nil
    end
  end


end
