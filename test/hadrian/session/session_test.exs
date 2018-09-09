defmodule Hadrian.SessionTest do
  use Hadrian.DataCase

  alias Hadrian.Session
  alias Hadrian.Accounts.User

  describe "login/1" do
    test "when argument map does not have 'auth_method' key returns :error" do
      params = %{"password" => "Very weak password"}

      assert {:error, reason} = Session.login(params) 
    end

    test "when value under key 'auth_method' contains unkown method returns :error" do
      params = %{"password" => "Very weak password", "auth_method" => "twitter"}

      assert {:error, reason} = Session.login(params)
    end
  end

  describe "login/1 when using inside app authorization" do
    setup [:use_in_app_auth]

    test "returns {:ok, %User{}} tuple when user exists", %{params: params} do
      user = insert(:user)
      params = Map.put(params, "user", %{"email" => user.email, "password" => user.password})
      
      assert {:ok, %User{}} = Session.login(params)
    end

    test "returns {:error, params} when user does not exist", %{params: params} do
      params = Map.put(params, "user", %{"email" => "user@domain.com", "password" => "Some funny password"})
      
      assert {:error, params} = Session.login(params)
    end
  end

  defp use_in_app_auth(context) do
    context
    |> Map.put(:params, %{"auth_method" => "in_app"})
  end

  describe "login/1 when using facebook authorization" do
    setup [:use_fb_auth]

    test "returns {:ok, %User{}} tuple when user exists and access token is valid", %{params: params} do
      access_token = "CAAEe4ALTtoMBAPfhNONNBJcfFsT3C9C1ky3tZAXxF9k4HBybM7o3V8bGofuXOtz6TgIEGObmDSKwUGr0LYZChBTMU2QtP" <>
        "5995mkteEMsqyKHuVr9rUbEFvHT7kz7Rjkw3rxeUfxNKRdZBQ3ym4YZB4FFKuAbhzrxe2ltYhxEQKEXepJ2q7oITJ2w2j7A7vBiZB9JNC4k" <>
        "fRwZDZD"
      user = insert(:user)
      params = Map.put(params, "user", %{"email" => user.email, "access_token" => access_token})
      
      assert {:ok, %User{}} = Session.login(params)
    end

    test "returns {:error, params} when user does not exist", %{params: params} do
      access_token = "CAAEe4ALTtoMBAPfhNONNBJcfFsT3C9C1ky3tZAXxF9k4HBybM7o3V8bGofuXOtz6TgIEGObmDSKwUGr0LYZChBTMU2QtP" <>
        "5995mkteEMsqyKHuVr9rUbEFvHT7kz7Rjkw3rxeUfxNKRdZBQ3ym4YZB4FFKuAbhzrxe2ltYhxEQKEXepJ2q7oITJ2w2j7A7vBiZB9JNC4k" <>
        "fRwZDZD"
      params = Map.put(params, "user", %{"email" => "donot@exists.com", "access_token" => access_token})

      assert {:error, params} = Session.login(params)
    end
    
    test "returns {:error, params} when access token is invalid", %{params: params} do
      user = insert(:user)
      params = Map.put(params, "user", %{"email" => user.email, "access_token" => ""})

      assert {:error, params} = Session.login(params)
    end
  end

  defp use_fb_auth(context) do
    context
    |> Map.put(:params, %{"auth_method" => "facebook"})
  end
end