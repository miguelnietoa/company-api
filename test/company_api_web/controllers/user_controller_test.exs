defmodule CompanyApiWeb.UserControllerTest do
  use CompanyApiWeb.ConnCase
  alias CompanyApiWeb.User

  @valid_data %{name: "Jim", subname: "Doe", email: "doe@gmail.com", job: "CEO"}
  @user %{name: "John", subname: "Doe", email: "doe@gmail.com", job: "engineer"}
  @user_jane %{name: "Jane", subname: "Doe", email: "jane@gmail.com", job: "architect"}

  setup do
    user =
      %User{}
      |> User.changeset(@user)
      |> Repo.insert!()

    conn =
      build_conn()
      |> put_req_header("accept", "application/json")

    %{conn: conn, user: user}
  end

  describe "tries to create and render" do
    test "user with valid data", %{conn: conn} do
      response =
        post(conn, user_path(conn, :create), user: @valid_data)
        |> json_response(201)

      assert Repo.get_by(User, name: "Jim")
      assert_delivered_email(Email.create_mail(response["password"], response["email"]))
    end

    test "user with invalid data", %{conn: conn} do
      response =
        post(conn, user_path(conn, :create), user: %{})
        |> json_response(422)

      assert response["errors"] != %{}
    end
  end
end
