defmodule Hadrian.SessionTest do
  use HadrianWeb.IntegrationCase
  
  describe "current_user/1 when user is signed in" do
    test "returns his data" do
    end
  end

  describe "current_user/1 when user is not signed in" do
    test "does something but I do not know what..." do
      assert false
    end
  end

  describe "login/2 when using InApp option" do
    test "when authentication succeds returns {:ok, %User{}}" do
      assert false
    end

    test "when authentication fails returns {:error}" do
      assert false
    end
  end

  describe "login/2 when using Facebook option" do
    test "when user didn't exist earlier creates user and returns {:ok, %User{}}" do
      assert false
    end

    test "when user existed earlier returns {:ok, %User{}}" do
        assert false
    end
  end

  describe "logged_in?/1 when user is signed in" do
    test "returns true" do
      assert false
    end
  end

  describe "logged_in?/1 when user is not signed in" do
    test "returns false" do
      assert false
    end
  end
end