defmodule CompanyApiWeb.SessionControllerTest do
  use CompanyApiWeb.ConnCase
  alias CompanyApiWeb.Router.Helpers, as: Routes
  alias CompanyApi.Repo
  alias CompanyApiWeb.User

  setup do
    user =
      Repo.insert!(%User{
        name: "John",
        subname: "Doe",
        email: "doe@gmail.com",
        job: "engineer",
        password: User.generate_password()
      })

    conn =
      build_conn()
      |> put_req_header("accept", "application/json")

    {:ok, conn: conn, user: user}
  end

  test "login as user", %{conn: conn, user: user} do
    user_credentials = %{email: user.email, password: user.password}

    response =
      post(conn, Routes.session_path(conn, :create), creds: user_credentials)
      |> json_response(200)

    expected = %{
      "id" => user.id,
      "name" => user.name,
      "subname" => user.subname,
      "password" => user.password,
      "email" => user.email,
      "job" => user.job
    }

    assert response["data"]["user"] == expected
    refute response["data"]["token"] == nil
    refute response["data"]["expire"] == nil
  end
end
