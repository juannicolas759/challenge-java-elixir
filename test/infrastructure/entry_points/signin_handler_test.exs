defmodule Infrastructure.EntryPoints.RestController.Authentication.Signin.Application.SigninHandlerTest do
  use ExUnit.Case, async: true
  use Plug.Test

  alias Infrastructure.EntryPoints.RestController.Authentication.Signin.Application.SigninHandler
  alias Infrastructure.EntryPoints.RestController.Authentication.Signup.Application.SignupHandler

  @signin_opts SigninHandler.init([])
  @signup_opts SignupHandler.init([])

  setup do
    conn =
      :post
      |> conn("/",
        ~s({"email":"user@unit.com","password":"password123","name":"Unit"})
      )
      |> put_req_header("content-type", "application/json")

    SignupHandler.call(conn, @signup_opts)
    :ok
  end

  test "signin ok" do
    conn =
      :post
      |> conn("/", ~s({"email":"user@unit.com","password":"password123"}))
      |> put_req_header("content-type", "application/json")

    conn = SigninHandler.call(conn, @signin_opts)
    assert conn.status == 200
    assert %{"session_id" => _} = Jason.decode!(conn.resp_body)
  end

  test "user not found" do
    conn =
      :post
      |> conn("/", ~s({"email":"nouser@unit.com","password":"password123"}))
      |> put_req_header("content-type", "application/json")

    conn = SigninHandler.call(conn, @signin_opts)
    assert conn.status == 404
    assert %{"code" => "ER404_00"} = Jason.decode!(conn.resp_body)
  end

  test "invalid credentials" do
    conn =
      :post
      |> conn("/", ~s({"email":"user@unit.com","password":"wrongpass"}))
      |> put_req_header("content-type", "application/json")

    conn = SigninHandler.call(conn, @signin_opts)
    assert conn.status == 401
    assert %{"code" => "ER401_00"} = Jason.decode!(conn.resp_body)
  end

  test "missing param" do
    conn =
      :post
      |> conn("/", ~s({"email":"user@unit.com"}))
      |> put_req_header("content-type", "application/json")

    conn = SigninHandler.call(conn, @signin_opts)
    assert conn.status == 400
    assert %{"code" => "MALFORMED_REQUEST"} = Jason.decode!(conn.resp_body)
  end
end
