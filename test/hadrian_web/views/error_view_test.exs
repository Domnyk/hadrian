defmodule HadrianWeb.ErrorViewTest do
  use HadrianWeb.ConnCase, async: true

  alias HadrianWeb.Api.ErrorView
  
  test "renders 404.html" do
    assert ErrorView.template_not_found("404", []) == %{status: :error, reason: "Not Found"}
  end

  test "renders 500.html" do
    assert ErrorView.template_not_found("500", []) == %{status: :error, reason: "Internal Server Error"}
  end

  describe "parse_errors" do
    alias Hadrian.Accounts.User

    test "when invalid changeset returns map with fields which did not pass validation" do
      user_params = %{"email" => "this email has wrong format"}
      expected_map = %{email: ["has invalid format"], password: ["can't be blank"]}
      changeset = User.changeset(%User{}, user_params)

      assert expected_map == ErrorView.parse_errors(changeset)
    end

    test "when valid changset returns empty map" do
      user_params = %{"email" => "proper@email.com", "password" => "Very good password"}
      expected_map = %{}
      changeset = User.changeset(%User{}, user_params)

      assert expected_map == ErrorView.parse_errors(changeset)
    end
  end
end
