defmodule Hadrian.RegistrationTest.InAppTest do
  use Hadrian.DataCase
  
  alias Hadrian.Accounts.User
  alias Hadrian.Registration.InApp
  
  describe "register/1" do
    test "returns {:ok, %User{}} tuple with hashed password" do
      user_attrs = build(:user_attrs)

      assert {ok, %User{} = user} = InApp.register(user_attrs)
      assert user.password_hash
    end
  end
end