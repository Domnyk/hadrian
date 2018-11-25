defmodule Hadrian.Authentication.AuthenticationTest do
  use Hadrian.DataCase

  alias Hadrian.Accounts
  alias Hadrian.Authentication

  describe "verify_password/2" do
    test "returns :no_match if password hash doesn't match provided password" do
      user_attrs = build(:user_attrs, %{"password" => "Very secret password"})
      {:ok, %Accounts.User{} = user} = Accounts.create_user(user_attrs)

      assert :no_match == Authentication.verify_password("Wrong password",  user.password_hash)
    end

    test "returns :match if password hash matches provided password" do
      password = "Very secret password"
      user_attrs = build(:user_attrs, %{"password" => password})
      {:ok, %Accounts.User{} = user} = Accounts.create_user(user_attrs)

      assert :match == Authentication.verify_password(password,  user.password_hash)
    end
  end
end
