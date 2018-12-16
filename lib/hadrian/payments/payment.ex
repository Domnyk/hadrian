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
  alias Poison, as: Json

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

  def create(payment = %Payment{}, token) when is_binary(token) do
    Logger.info("Attempt to create payment")

    url = Application.get_env(:hadrian, :api_url) <> @create_payment_endpoint
    body = create_body(payment)
    perform_create_request(url, body, token)
  end

  def create(payment, token) do
    msg = ~s(Wrong type of arguments. \n token: #{inspect(token)} \n payment: #{inspect(payment)})
    raise ArgumentError, message: msg
  end

  defp perform_create_request(url, body, token) do
    headers = create_headers(token)

    with {:ok, response = %HTTP.Response{}} <- HTTP.post(url, body, headers),
         {:ok, %HTTP.Response{}} <- parse_status_code(response),
         %{"approval_url" => approval_url, "execute" => execute_url} <- parse_body(response.body) do
      Logger.debug ~s(Received resposnse: \n #{inspect(response)})
      %{token: token, urls: %{approval: approval_url, execute: execute_url}}
    else
      {:unauthorized, %HTTP.Response{}} -> handle_unauthorized(url, body)
      {:unkown_status_code, resp = %HTTP.Response{}} -> raise "Unknown status code in response: #{inspect(resp)}"
    end
  end

  defp parse_status_code(response = %HTTP.Response{status_code: status_code}) do
    case status_code do
      201 -> {:ok, response}
      401 -> {:unauthorized, response}
      _   -> {:unkown_status_code, response}
    end
  end

  defp parse_body(body) when is_binary(body) do
    Json.decode!(body)
    |> Map.get("links")
    |> Enum.filter(fn %{"rel" => rel} -> rel == "execute" or rel == "approval_url" end)
    |> Enum.reduce(%{}, fn %{"rel" => r, "href" => h}, acc -> Map.put(acc, r, h) end)
  end

  defp parse_body(body) do
    msg = "Argument is not string. body: #{inspect(body)}"
    raise ArgumentError, message: msg
  end

  defp handle_unauthorized(url, body) do
    Logger.warn("Token expired")
    token = Payments.fetch_token()
    perform_create_request(url, body, token)
  end

  defp create_body(payment = %Payment{}) do


    payment
    |> to_map()
    |>  Json.encode!()
  end

  defp create_headers(token) when is_binary(token) do
    ["Content-Type": "Application/json", "Authorization": "Bearer #{token}"]
  end

  defp create_headers(token) do
    msg = ~s(Token is not string. \n Token: #{inspect(token)})
    Logger.error(msg)
  end
end
