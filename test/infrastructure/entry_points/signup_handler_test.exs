defmodule Infrastructure.EntryPoints.RestController.Authentication.Signup.Application.SignupHandlerTest do
  use ExUnit.Case, async: true
  use Plug.Test

  alias Infrastructure.EntryPoints.RestController.Authentication.Signup.Application.SignupHandler

  @opts SignupHandler.init([])

  test "signup ok" do
    conn =
      :post
      |> conn("/", ~s({"email":"test@unit.com","password":"password123","name":"Unit"}))
      |> put_req_header("content-type", "application/json")

    conn = SignupHandler.call(conn, @opts)
    assert conn.status == 201
  end

  test "email invalid" do
    conn =
      :post
      |> conn("/", ~s({"email":"invalid","password":"password123","name":"Unit"}))
      |> put_req_header("content-type", "application/json")

    conn = SignupHandler.call(conn, @opts)
    assert conn.status == 400
    assert %{"code" => "ER400_02"} = Jason.decode!(conn.resp_body)
  end

  test "password weak" do
    conn =
      :post
      |> conn("/", ~s({"email":"pw@unit.com","password":"123","name":"Unit"}))
      |> put_req_header("content-type", "application/json")

    conn = SignupHandler.call(conn, @opts)
    assert conn.status == 400
    assert %{"code" => "ER400_01"} = Jason.decode!(conn.resp_body)
  end

  test "without param" do
    conn =
      :post
      |> conn("/", ~s({"email":"test@unit.com","password":"password123"}))
      |> put_req_header("content-type", "application/json")

    conn = SignupHandler.call(conn, @opts)
    assert conn.status == 400
    assert %{"code" => "MALFORMED_REQUEST"} = Jason.decode!(conn.resp_body)
  end
end
