defmodule Hadrian.RegistrationTest.FacebookTest do
    use Hadrian.DataCase
    
    alias Hadrian.Accounts.User
    alias Hadrian.Registration.Facebook
    
    describe "register/1" do
      test "returns {:ok, %User{}} tuple with hashed password and display name" do
        user_attrs = build(:user_attrs)
  
        assert {:ok, %User{} = user} = Facebook.register(user_attrs)
        assert user.password == "Facebook"
      end
    end
  end