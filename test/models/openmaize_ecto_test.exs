defmodule Welcome.OpenmaizeEctoTest do
  use ExUnit.Case
  use Plug.Test

  alias Welcome.{OpenmaizeEcto, Repo, User}

  test "easy password results in an error being added to the changeset" do
    user = %{email: "bill@mail.com", username: "bill", password: "123456",
             phone: "081655555", confirmed_at: Ecto.DateTime.utc}
    {:error, changeset} = %User{}
                          |> User.auth_changeset(user)
                          |> Repo.insert
    errors = changeset.errors[:password] |> elem(0)
    assert errors =~ "password is too short"
  end

  test "check time" do
    assert OpenmaizeEcto.check_time(Ecto.DateTime.utc, 60)
    refute OpenmaizeEcto.check_time(Ecto.DateTime.utc, -60)
    refute OpenmaizeEcto.check_time(nil, 60)
  end

end
