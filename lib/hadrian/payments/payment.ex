defmodule Hadrian.Payments.Payment do
  import Ecto.Changeset
  alias Hadrian.Repo
  alias Hadrian.Payments.Payment
  alias Hadrian.Accounts
  alias Hadrian.Accounts.User
  alias Hadrian.Accounts.ComplexesOwner
  alias Hadrian.Owners.SportObject

  defstruct [:payer_email, :sport_object_name, :amount_to_pay, :complexes_owner_email, :return_url, :cancel_url]

  def changeset(payment = %Payment{}, attrs) do
    {payment, types()}
    |> cast(attrs, [:payer_email, :sport_object_name, :amount_to_pay, :complexes_owner_email, :return_url, :cancel_url])
    |> validate_required([:payer_email, :sport_object_name, :amount_to_pay, :complexes_owner_email, :return_url,
                          :cancel_url])
    |> validate_change(:payer_email, &validate_payer_exists/2)
    |> validate_change(:sport_object_name, &validate_sport_object_exists/2)
    |> validate_change(:complexes_owner_email, &validate_complexes_owner_email_exists/2)
    |> validate_number(:amount_to_pay, greater_than: 0)
    |> validate_url(:return_url)
    |> validate_url(:cancel_url)
  end

  defp types do
    %{payer_email: :string, sport_object_name: :string, amount_to_pay: :float, complexes_owner_email: :string,
      return_url: :string, cancel_url: :string}
  end

  defp validate_payer_exists(:payer_email, value) do
    case Accounts.get_user_by_email(value) do
      {:ok, %User{}} -> []
      {:no_such_user, _} -> [payer_email: "no user with such email"]
    end
  end

  defp validate_sport_object_exists(:sport_object_name, value) do
    case Repo.get_by(SportObject, name: value) do
      %SportObject{} -> []
      nil -> [sport_object_name: "no sport object with such name"]
    end
  end

  defp validate_complexes_owner_email_exists(:complexes_owner_email, value) do
    case Repo.get_by(ComplexesOwner, email: value) do
      %ComplexesOwner{} -> []
      nil -> [complexes_owner_email: "no complexes owner with such email"]
    end
  end

  defp validate_url(changeset, field, opts \\ []) do
    validate_change changeset, field, fn _, value ->
      case URI.parse(value) do
        %URI{scheme: nil} -> "is missing a scheme (e.g. https)"
        %URI{host: nil} -> "is missing a host"
        %URI{host: host} ->
          case :inet.gethostbyname(Kernel.to_charlist host) do
            {:ok, _} -> nil
            {:error, _} -> "invalid host"
          end
      end
      |> case do
           error when is_binary(error) -> [{field, Keyword.get(opts, :message, error)}]
           _ -> []
         end
    end
  end

  def to_map(payment = %Payment{}) do
    payer_info = %{email: payment.payer_email}
    payer = %{payment_method: :paypal, payer_info: payer_info}
    application_context = %{brand_name: payment.sport_object_name, locale: :PL, user_action: :commit}
    amount = %{currency: :PLN, total: payment.amount_to_pay}
    payee = %{email: payment.complexes_owner_email}
    transactions = [%{amount: amount, payee: payee}]
    redirect_urls = %{return_url: payment.return_url, cancel_url: payment.cancel_url}

    %{intent: :sale, payer: payer, application_context: application_context, transactions: transactions,
      redirect_urls: redirect_urls}
  end
end
