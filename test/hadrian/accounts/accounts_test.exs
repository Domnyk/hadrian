defmodule Hadrian.AccountsTest do
  use Hadrian.DataCase

  alias Hadrian.Accounts

  describe "users" do
    alias Hadrian.Accounts.User

    @update_attrs %{fb_id: "0123456789", display_name: "New Display Name"}
    @invalid_attrs %{fb_id: nil, display_name: nil}

    test "list_users/0 returns all users" do
      num_of_users = 3
      users_list = insert_list(num_of_users, :user)

      users_list_from_db = Accounts.list_users()
      assert length(users_list_from_db) == num_of_users
      for i <- 0..num_of_users - 1 do
        user = Enum.at(users_list, i)
        user_from_db = Enum.at(users_list_from_db, i)

        assert_that_users_are_equal(user, user_from_db)
      end     
    end

    test "get_user!/1 returns the user with given id" do
      user = insert(:user)

      user_from_db = Accounts.get_user!(user.id)

      assert_that_users_are_equal(user, user_from_db)
    end

    test "get_user_by_fb_id/1 returns the user with given facebook id" do
      user = insert(:user)

      {:ok, %User{} = user_from_db} = Accounts.get_user_by_fb_id(user.fb_id)

      assert_that_users_are_equal(user, user_from_db)
    end

    test "get_user_by_fb_id/1 returns {:no_such_user, fb_id} when user does not exist" do
      fb_id = "0123456789"

      {:no_such_user, fb_id: ^fb_id} = Accounts.get_user_by_fb_id(fb_id)
    end

    test "create_user/1 with valid data creates a user" do
      attrs = string_params_for(:user)

      assert {:ok, %User{} = user} = Accounts.create_user(attrs)
      assert user.fb_id == attrs["fb_id"]
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = insert(:user)

      assert {:ok, user} = Accounts.update_user(user, @update_attrs)
      assert %User{} = user
      assert user.fb_id == @update_attrs.fb_id
    end

    test "update_user/2 with invalid data returns error changeset" do
      original_user = insert(:user)

      user_to_update = Accounts.get_user!(original_user.id)

      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user_to_update, @invalid_attrs)
      assert original_user.id == user_to_update.id
      assert original_user.fb_id == user_to_update.fb_id
    end

    test "delete_user/1 deletes the user" do
      user = insert(:user)

      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = insert(:user)
      
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end

    # defp insert_with_hashed_password(:user) do
    #   user = build(:user)
    #   password_hash = Comeonin.Bcrypt.hashpwsalt(user.password)
    #   
    #   insert(:user, %{password_hash: password_hash})
    # end

    defp assert_that_users_are_equal(%User{} = user_1, %User{} = user_2) do
      assert user_1.id == user_2.id
      assert user_1.fb_id == user_2.fb_id
    end
  end

  describe "complexes owners" do
    alias Hadrian.Accounts.ComplexesOwner

    @update_attrs %{email: "new@domain.com", password: "123456789aA_"}
    @invalid_attrs %{email: nil, password: nil}

    test "list_complexes_owners/0 returns all complexes owners" do
      num_of_complexes_owners = 3
      insert_list(num_of_complexes_owners, :complexes_owner)

      complexes_owners_list = Accounts.list_complexes_owners()
      assert length(complexes_owners_list) == num_of_complexes_owners
      for i <- 0..num_of_complexes_owners - 1 do
        complexes_owner = Enum.at(complexes_owners_list, i)
        complexes_owner_from_db = Enum.at(complexes_owners_list, i)

        assert_that_complexes_owners_are_equal(complexes_owner, complexes_owner_from_db)
      end
    end

    test "get_complexes_owner!/1 returns the complexes owner with given id" do
      complexes_owner = insert(:complexes_owner)

      complexes_owner_from_db = Accounts.get_complexes_owner!(complexes_owner.id)

      assert_that_complexes_owners_are_equal(complexes_owner, complexes_owner_from_db)
    end

    test "get_complexes_owner_by_email/1 returns the user with given email" do
      complexes_owner = insert(:complexes_owner)

      {:ok, %ComplexesOwner{} = complexes_owner_from_db} = Accounts.get_complexes_owner_by_email(complexes_owner.email)

      assert_that_complexes_owners_are_equal(complexes_owner, complexes_owner_from_db)
    end

    test "get_complexes_owner_by_email/1 returns {:no_such_complexes_owner, email} when complexes owner does not exist" do
      email = "bob@test.com"

      {:no_such_complexes_owner, email: ^email} = Accounts.get_complexes_owner_by_email(email)
    end

    test "create_complexes_owner/1 with valid data creates a complexes owner" do
      attrs = string_params_for(:complexes_owner)

      assert {:ok, %ComplexesOwner{} = complexes_owner} = Accounts.create_complexes_owner(attrs)
      assert complexes_owner.email == attrs["email"]
    end

    test "create_complexes_owner/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_complexes_owner(@invalid_attrs)
    end

    test "create_complexes_owner/1 with invalid password length returns error changeset" do
      less_than_8_characters = "123456"
      invalid_attrs = %{email: "test@test.com", password: less_than_8_characters}
      assert {:error, %Ecto.Changeset{}} = Accounts.create_complexes_owner(invalid_attrs)
    end

    test "create_complexes_owner/1 with invalid password format returns error changeset" do
      no_letter_no_special_character = "12345678"
      invalid_attrs = %{email: "test@test.com", password: no_letter_no_special_character}
      assert {:error, %Ecto.Changeset{}} = Accounts.create_complexes_owner(invalid_attrs)
    end

    test "update_complexes_owner/2 with valid data updates the complexes owner" do
      attrs = string_params_for(:complexes_owner)
      {:ok, %ComplexesOwner{} = complexes_owner} = Accounts.create_complexes_owner(attrs)

      assert {:ok, %ComplexesOwner{} = complexes_owner} = Accounts.update_complexes_owner(complexes_owner, @update_attrs)
      assert %ComplexesOwner{} = complexes_owner
      assert complexes_owner.email == @update_attrs.email
    end

    test "update_complexes_owner/2 with invalid data returns error changeset" do
      original_complexes_owner = insert(:complexes_owner)

      complexes_owner = Accounts.get_complexes_owner!(original_complexes_owner.id)

      assert {:error, %Ecto.Changeset{}} = Accounts.update_complexes_owner(complexes_owner, @invalid_attrs)
      assert original_complexes_owner.id == complexes_owner.id
      assert original_complexes_owner.email == complexes_owner.email
    end

    test "delete_complexes_owner/1 deletes the complexes_owner" do
      complexes_owner = insert(:complexes_owner)

      assert {:ok, %ComplexesOwner{}} = Accounts.delete_complexes_owner(complexes_owner)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_complexes_owner!(complexes_owner.id) end
    end

    test "change_complexes_owner/1 returns a complexes owner changeset" do
      attrs = string_params_for(:complexes_owner)
      {:ok, %ComplexesOwner{} = complexes_owner} = Accounts.create_complexes_owner(attrs)
      assert %Ecto.Changeset{} = Accounts.change_complexes_owner(complexes_owner)
    end

    defp assert_that_complexes_owners_are_equal(%ComplexesOwner{} = a, %ComplexesOwner{} = b) do
      assert a.id == b.id
      assert a.email == b.email
    end
  end
end
