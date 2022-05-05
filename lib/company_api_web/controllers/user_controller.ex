defmodule CompanyApiWeb.UserController do
  use CompanyApiWeb, :controller
  alias CompanyApiWeb.User
  alias CompanyApi.Repo

  def create(conn, %{"user" => user_data}) do
    params = Map.put(user_data, "password", User.generate_password())

    case Repo.insert(User.changeset(%User{}, params)) do
      {:ok, user} ->
        conn
        |> put_status(:created)
        |> render("create.json", user: user)

      {:error, user} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render("error.json", user: user)
    end
  end
end
