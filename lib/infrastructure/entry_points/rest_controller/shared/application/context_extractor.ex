defmodule Infrastructure.EntryPoints.RestController.Shared.Application.ContextExtractor do

  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do

    context = Domain.Model.Shared.CQRS.Model.ContextData.from_connection(conn)
    conn = assign(conn, :context, context)
    Domain.Model.Shared.CQRS.Model.ContextData.put(context)
    conn
  end

end
