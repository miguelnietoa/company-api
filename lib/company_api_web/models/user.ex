defmodule CompanyApiWeb.User do
  use CompanyApiWeb, :model

  schema "users" do
    field :name, :string
    field :subname, :string
    field :email, :string
    field :password, :string
    field :job, :string
  end

  def changeset(changeset, params \\ %{}) do
    changeset
    |> cast(params, [:name, :subname, :email, :password, :job])
    |> validate_required([:name, :subname, :email, :job])
    |> validate_format(:email, ~r/\S+@\S+\.\S+/)
  end
end
