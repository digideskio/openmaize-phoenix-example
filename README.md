# Openmaize-phoenix

The latest version of Openmaize depends on Elixir 1.2.

Example of using Openmaize authentication library in a Phoenix web
application.


## Getting started with the Openmaize-Phoenix-Example `welcome` Application

These are the step-by-step instructions to how to run this example for the first time:

   1. Adapt the configuration files in `config/` and the file `lib/welcome/mailer.ex` to reflect your local enviroiment, 
      hints: 
        - set the correct PostgreSQL host, username and password in `config/dev.exs` and `config/test.exs`)(*)
        - customize url and the `from` mail address in `lib/welcome/mailer.ex`, and take note of (or modify) the `test_file_path` path 
          (that's where you can read the mail sent to the user when testing)
        - add the mailgun configuration to `config/config.exs` (**)

   2. (Optional step) Add/modify some sample users in `priv/repo/seeds.exs`
      (At least one user with role `admin` is needed to be able to try all the application functionalities)
  
   3. Run `mix do deps.get, compile`
      (If you get the error `** (Mix) Registry checksum mismatch against lock (openmaize x.x.x)` 
      please remove the file `mix.lock` and try again);

   4. Run `npm install`

   5. Run `mix ecto.create`

   6. Run `mix ecto.migrate`

   7. Run `mix run priv/repo/seeds.exs`

   8. Run `mix phoenix.server`

   9. Open the url `http://localhost:4000` on your preferred browser

  10. Referring to the `priv/repo/seeds.exs` file, try to login with different identities. 
      *(Note: for users registered with an `admin` role, a Verification Code is required to complete the login)* (***)


(*) I.e. you can either:
     - change the database username from `dev` to `postgres`
     - add a new role `dev` to your PostgreSQL this way:
       - launch `psql` from your command line
       - type `\du` to display the current users
       - type `CREATE ROLE dev WITH LOGIN CREATEDB SUPERUSER;`

(**) Go to `http://mailgun.com`, open a demo account and obtain your domain and key, then add and customize these three lines to `config/config.exs`:
     # Configures MailGun
       config :welcome, mailgun_domain: "https://api.mailgun.net/v3/sandbox<your_mailgun_domain_code>.mailgun.org",
       mailgun_key: "key-<your_mailgun_key_code>"

(***) Before to try the admin login, open a new terminal session, then launch the Interactive Elixir 
      typing `iex -S mix` on the command line,
      then type `Welcome.Repo.get(Welcome.User, <id>).otp_secret |> Comeonin.Otp.gen_totp` but **without** executing the command by pressing the return key.
      *(substitute `<id>` with the actual record id of the admin user, that is 1 for the `Tom` user in the default seed file)*
      then:
        - navigate to `http://localhost:4000/login`, 
        - enter username and password for the preferred admin user (i.e. `tom`, `mangoes`) and press the submit button
        - you will see the `Verification code` request
        - got to the `iex` session and press enter to the previously typed command line to generate the tOTP token
        - you will get a six digits number
        - submit the token into the "Verification code" login form before the token expires.

Happy testing!





Following there is the content of the Openmaize README.md file (you can safely ignore to read this to be able to run the example):


## Getting started with Openmaize authentication library

The following instructions show the most straightforward of getting started
with Openmaize.

1. Add openmaize to your `mix.exs` dependencies

  ```elixir
  defp deps do
    [{:openmaize, "~> 1.0.0-beta"}]
  end
  ```

2. List `:openmaize` as an application dependency

  ```elixir
  def application do
    [applications: [:logger, :openmaize]]
  end
  ```

3. Run `mix do deps.get, compile`

4. Run `mix openmaize.gen.ectodb`

5. Run `mix openmaize.gen.phoenixauth`

You then need to configure Openmaize. For more information, see the documentation
for the Openmaize.Config module.

## Migrating from Devise

Follow the above instructions for generating database and authorization
modules, and then add the following lines to the config file:

    config :openmaize,
      hash_name: :encrypted_password

Some of the functions in the Authorize module depend on a `role` being
set for each user. If you are not using roles, you will need to edit
these functions before use.

### Optional password strength checker

This example uses a password strength checker which is an optional dependency of
Openmaize. If you don't want to use this, just remove the line `{:not_qwerty123, "~> 1.0"}`
from the deps in the mix.exs file.

### License

MIT.
