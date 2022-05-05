defmodule CompanyApiWeb.User do
  use CompanyApiWeb, :model

  @pass_length 10

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

  def generate_password do
    :crypto.strong_rand_bytes(@pass_length)
    |> Base.encode64
    |> binary_part(0, @pass_length)
  end
end
