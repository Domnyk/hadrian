defmodule Hadrian.SessionTest do
  use HadrianWeb.ConnCase

  describe "current_user/1" do
    test "when user is logged returns his data" do
      assert false
    end

    test "when user is not logged does something but I do not know what..." do
      assert false
    end
  end

  describe "login/2" do
    describe "when using InApp option" do
      test "returs {:ok, %User{}} when authentication succeds" do
        assert false
      end

      test "retursn {:error} when authentication fails" do
        assert false
      end
    end

    describe "when using Facebook option" do
      test "creats user if it didn't exist earlier and retursn {:ok, %User{}}" do
        assert false
      end

      test "returns {:ok, %User{}} if user existed earlier" do
        assert false
      end
    end
  end

  describe "logged_in?/1" do
    test "returns true when user is signed in" do
      assert false
    end

    test "returns false when user is not signed in" do
      assert false
    end
  end
end