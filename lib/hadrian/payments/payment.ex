defmodule Hadrian.Payments.Payment do
  require Logger
  import Ecto.Changeset
  alias Hadrian.Repo
  alias Hadrian.Payments
  alias Hadrian.Payments.Payment
  alias Hadrian.Accounts
  alias Hadrian.Accounts.User
  alias Hadrian.Accounts.ComplexesOwner
  alias Hadrian.Owners.SportObject
  alias HTTPoison, as: HTTP

  @create_payment_endpoint "/v1/payments/payment"

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

  def create(token, payment = %Payment{}) when is_binary(token) do
    Logger.info("Attempt to create payment")

    url = Application.get_env(:hadrian, :api_url) <> @create_payment_endpoint
    body = create_body(payment)
    headers = create_headers(token)
    perform_create_request(url, body, headers)
  end

  def create(token, payment) do
    msg = ~s(Token is not string. \n Token: #{inspect(token)}. Payment: #{inspect(payment)})
    Logger.error(msg)
  end

  defp perform_create_request(url, body, headers) do
    with {:ok, response = %HTTP.Response{}} <- HTTP.post(url, body, headers),
         {:ok, %HTTP.Response{}} <- parse_status_code(response) do
      Logger.info("Received response: \n #{inspect(response)}")
      response
    else
      {:unauthorized, %HTTP.Response{}} ->
        Logger.warn("Token expired")
        headers = Payments.fetch_token() |> create_headers()
        perform_create_request(url, body, headers)
    end
  end

  def create_body(payment = %Payment{}) do
    alias Poison, as: Json

    # TODO: replace encode!/1 with encode/1
    payment
    |> to_map()
    |>  Json.encode!()
  end

  defp parse_status_code(response = %HTTP.Response{status_code: status_code}) do
    case status_code do
      200 -> {:ok, response}
      401 -> {:unauthorized, response}
      _   -> {:error, response}
    end
  end

  defp create_headers(token) when is_binary(token) do
    ["Content-Type": "Application/json", "Authorization": "Bearer #{token}"]
  end

  defp create_headers(token) do
    msg = ~s(Token is not string. \n Token: #{inspect(token)})
    Logger.error(msg)
  end
end
