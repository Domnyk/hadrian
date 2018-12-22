defmodule PaymentTest do
  use Hadrian.DataCase

  alias Hadrian.Payments.Payment
  alias Ecto.Changeset

  @invalid_attrs %{payer_email: nil, sport_object_name: nil, amount_to_pay: nil, complexes_owner_email: nil,
                   return_url: nil, cancel_url: nil}

  describe "changeset/2" do
    test "returns invalid changeset when data is missing" do
      assert %Ecto.Changeset{valid?: false} = Payment.changeset(%Payment{}, @invalid_attrs)
    end

    test "returns invalid changeset when payer_email does not belong to any user" do
      attrs = build(:payment_attrs, %{"payer_email" => "no@user.com"})

      payer_email_error = {:payer_email, {"no user with such email", []}}
      assert %Changeset{valid?: false, errors: errors} = Payment.changeset(%Payment{}, attrs)
      assert List.keyfind(errors, :payer_email, 0) == payer_email_error
    end

    test "returns invalid changeset when complexes_owner_email does not belong to any complexes owner" do
      attrs = build(:payment_attrs, %{"complexes_owner_email" => "no@owner.com"})

      complexes_owner_email_error = {:complexes_owner_email, {"no complexes owner with such email", []}}
      assert %Changeset{valid?: false, errors: errors} = Payment.changeset(%Payment{}, attrs)
      assert List.keyfind(errors, :complexes_owner_email, 0) == complexes_owner_email_error
    end

    test "returns invalid changeset when there's no sport object with given name" do
      attrs = build(:payment_attrs, %{"sport_object_name" => "non existing name"})

      sport_object_name_error = {:sport_object_name, {"no sport object with such name", []}}
      assert %Changeset{valid?: false, errors: errors} = Payment.changeset(%Payment{}, attrs)
      assert List.keyfind(errors, :sport_object_name, 0) == sport_object_name_error
    end
  end
end