defmodule Welcome.User do
  use Welcome.Web, :model

  alias Welcome.OpenmaizeEcto

  schema "users" do
    field :username, :string
    field :email, :string
    field :password, :string, virtual: true
    field :password_hash, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:username, :email])
    |> validate_required([:username, :email])
    |> unique_constraint(:username)
  end

  def auth_changeset(struct, params) do
    struct
    |> changeset(params)
    |> OpenmaizeEcto.add_password_hash(params)
  end
end
