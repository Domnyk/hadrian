defmodule HadrianWeb.ErrorViewTest do
  use HadrianWeb.ConnCase, async: true

  alias HadrianWeb.ErrorView

  # Bring render/3 and render_to_string/3 for testing custom views
  import Phoenix.View
  
  test "renders 404.html" do
    assert render_to_string(ErrorView, "404.html", []) ==
           "Not Found"
  end

  test "renders 500.html" do
    assert render_to_string(ErrorView, "500.html", []) ==
           "Internal Server Error"
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
