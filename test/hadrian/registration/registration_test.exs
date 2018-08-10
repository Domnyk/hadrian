defmodule Hadrian.RegistrationTest do
  use Hadrian.DataCase

  alias Hadrian.Registration

  describe "register_user/1" do
    alias Hadrian.Accounts.User

    test "returns :error when source argument is invalid" do
      assert :error = Registration.register_user(%{}, :invalid)
    end

    test "returns {:ok, user} tuple when registering using in app option" do
      user_attrs = build(:user_attrs)

      assert {:ok, %User{} = user} = Registration.register_user(user_attrs, :in_app)
    end

    test "returns {:ok, user} tuple when registering using facebook option" do
      user_attrs = build(:user_attrs)
      |> Map.update("password", nil, fn val -> nil end)

      user_attrs |> inspect |> IO.puts

      assert {:ok, %User{} = user} = Registration.register_user(user_attrs, :facebook)
    end
  end
end