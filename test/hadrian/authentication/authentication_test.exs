defmodule Hadrian.Authentication.AuthenticationTest do
  use Hadrian.DataCase

  alias Hadrian.Accounts
  alias Hadrian.Authentication

  describe "verify_password/2" do
    test "returns :no_match if password hash doesn't match provided password" do
      complexes_owner_attrs = build(:complexes_owner_attrs, %{"password" => "Very secret password"})
      {:ok, %Accounts.ComplexesOwner{} = complexes_owner} = Accounts.create_complexes_owner(complexes_owner_attrs)

      assert :no_match == Authentication.verify_password("Wrong password",  complexes_owner.password_hash)
    end

    test "returns :match if password hash matches provided password" do
      password = "Very secret password"
      complexes_owner_attrs = build(:complexes_owner_attrs, %{"password" => password})
      {:ok, %Accounts.ComplexesOwner{} = complexes_owner} = Accounts.create_complexes_owner(complexes_owner_attrs)

      assert :match == Authentication.verify_password(password,  complexes_owner.password_hash)
    end
  end
end
