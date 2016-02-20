defmodule Welcome.PageController do
  use Welcome.Web, :controller

  import Openmaize.Confirm
  alias Openmaize.{LoginTools, Signup}
  alias Welcome.{Mailer, User}

  # in the following two plug functions, `key_expires_after` is set to
  # 10 minutes simply for testing purposes
  plug :confirm_email, [key_expires_after: 10,
    mail_function: &Mailer.receipt_confirm/1] when action in [:confirm]
  plug :reset_password, [key_expires_after: 10,
    mail_function: &Mailer.receipt_confirm/1] when action in [:reset_password]

  #plug Openmaize.Login, [unique_id: :email] when action in [:login_user]
  plug Openmaize.Login, [unique_id: &LoginTools.email_username/1] when action in [:login_user]
  plug Openmaize.Logout when action in [:logout]

  def index(conn, _params) do
    render conn, "index.html"
  end

  def login(conn, _params) do
    render conn, "login.html"
  end

  def askreset(conn, _params) do
    render conn, "askreset_form.html"
  end

  def askreset_password(conn, %{"user" => %{"email" => email} = user_params}) do
    {key, link} = Signup.gen_token_link(email)
    changeset = User.reset_changeset(Repo.get_by(User, email: email), user_params, key)

    case Repo.update(changeset) do
      {:ok, _user} ->
        Mailer.ask_reset(email, link)
        conn
        |> put_flash(:info, "Check your inbox for instructions on how to reset your password.")
        |> redirect(to: page_path(conn, :index))
      {:error, changeset} ->
        render(conn, "index.html", changeset: changeset)
    end
  end

  def reset(conn, %{"email" => email, "key" => key}) do
    render conn, "reset_form.html", email: email, key: key
  end
end
