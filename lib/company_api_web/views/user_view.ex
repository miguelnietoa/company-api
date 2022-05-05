defmodule CompanyApiWeb.UserView do
  use CompanyApiWeb, :view

  def render("create.json", %{user: user}) do
    render_one(user, CompanyApiWeb.UserView, "user.json")
  end

  def render("error.json", %{user: user}) do
    %{errors: translate_errors(user)}
  end

  def render("user.json", %{user: user}) do
    %{
      id: user.id,
      name: user.name,
      subname: user.subname,
      password: user.password,
      email: user.email,
      job: user.job
    }
  end

  defp translate_errors(user) do
    Ecto.Changeset.traverse_errors(user, &translate_error/1)
  end
end
