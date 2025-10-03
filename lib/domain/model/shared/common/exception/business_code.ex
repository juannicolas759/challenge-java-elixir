defmodule Domain.Model.Shared.Common.Exception.BusinessCode do

  @business_code %{
    ER400_00: "ER400_00",
    ER401_00: "ER401_00",
    ER404_00: "ER404_00",
    ER409_00: "ER409_00",
    ER500_00: "ER500_00",
    ER400_01: "ER400_01",
    ER400_02: "ER400_02"
  }

  @business_code_message %{
    ER400_00: "MALFORMED_REQUEST",
    ER401_00: "INVALID_CREDENTIALS",
    ER404_00: "USER_NOT_FOUND",
    ER409_00: "EMAIL_ALREADY_EXISTS",
    ER500_00: "UNEXPECTED_ERROR",
    ER400_01: "WEAK_PASSWORD",
    ER400_02: "INVALID_EMAIL_FORMAT"
  }

  @status_code %{
    bad_request: 400,
    not_found: 404,
    conflict: 409,
    internal_server_error: 500,
    unauthorized: 401
  }

  @category %{
    BEX_ECS: "BEX_ECS"
  }

  @code_message %{
    ER400_00: "Solicitud invalida",
    ER401_00: "No autorizado",
    ER404_00: "Recurso no encontrado",
    ER409_00: "Email ya registrado",
    ER500_00: "Error interno del servidor",
    ER400_01: "Contraseña debil",
    ER400_02: "Formato de Email invalido"
  }

  @internal_message %{
    ER400_00: "Parametros invalidos en la solicitud",
    ER401_00: "Autenticacion ausente o invalida",
    ER404_00: "No se encontro el recurso solicitado",
    ER409_00: "Email ya registrado",
    ER500_00: "Falla no inesperada mapeada",
    ER400_01: "Contraseña no cumple con los paramteros",
    ER400_02: "Formato de Email invalido"
  }

  def business_code(key), do: @business_code[key]
  def business_code_message(key), do: @business_code_message[key]
  def code_message(key), do: @code_message[key]
  def category(key), do: @category[key]
  def status_code(key), do: @status_code[key]
end
