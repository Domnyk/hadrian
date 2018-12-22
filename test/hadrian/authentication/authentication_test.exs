defmodule Hadrian.Authentication.AuthenticationTest do
  use Hadrian.DataCase

  alias Hadrian.Accounts
  alias Hadrian.Authentication

  describe "verify_password/2" do
    test "returns :no_match if password hash doesn't match provided password" do
      attrs = string_params_for(:complexes_owner)
      {:ok, %Accounts.ComplexesOwner{} = complexes_owner} = Accounts.create_complexes_owner(attrs)

      assert :no_match == Authentication.verify_password("Wrong password",  complexes_owner.password_hash)
    end

    test "returns :match if password hash matches provided password" do
      attrs = string_params_for(:complexes_owner)
      {:ok, %Accounts.ComplexesOwner{} = complexes_owner} = Accounts.create_complexes_owner(attrs)

      assert :match == Authentication.verify_password(attrs["password"],  complexes_owner.password_hash)
    end
  end
end
