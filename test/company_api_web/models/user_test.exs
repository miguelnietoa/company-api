defmodule CompanyApiWeb.UserTest do
  use CompanyApi.DataCase, async: true

  @valid_attributes %{name: "John", subname: "Doe", email: "doe@gmail.com", job: "engineer"}

  test "user with valid attributes" do
    user = CompanyApiWeb.User.reg_changeset(%User{}, @valid_attributes)
    assert user.valid?
  end
end
