defmodule Welcome.User do
  use Welcome.Web, :model

  alias Welcome.OpenmaizeEcto

  # IMPORTANT
  # only add `confirmed_at` to your schema if you are using email confirmation
  schema "users" do
    field :email, :string
    field :username, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    field :remember, :boolean
    field :role, :string
    field :confirmed_at, Ecto.DateTime
    field :confirmation_token, :string
    field :confirmation_sent_at, Ecto.DateTime
    field :reset_token, :string
    field :reset_sent_at, Ecto.DateTime
    field :bio, :string
    field :otp_required, :boolean
    field :otp_secret, :string

    timestamps()
  end

  @doc """
  Creates a changeset based on the `model` and `params`.
  """
  def changeset(model, params \\ %{}) do
    model
    |> cast(params, ~w(email role), ~w(username bio))
    |> validate_length(:username, min: 1, max: 100)
    |> unique_constraint(:email)
  end

  def auth_changeset(model, params, key) do
    model
    |> changeset(params)
    |> OpenmaizeEcto.add_password_hash(params)
    |> OpenmaizeEcto.add_confirm_token(key)
  end

  def reset_changeset(model, params, key) do
    model
    |> cast(params, ~w(email), [])
    |> OpenmaizeEcto.add_reset_token(key)
  end
end
