defmodule HadrianWeb.DailyScheduleController do
  use HadrianWeb, :controller

  alias Hadrian.Owners
  alias Hadrian.Owners.DailySchedule

  def index(conn, _params) do
    daily_schedules = Owners.list_daily_schedules()
    render(conn, "index.html", daily_schedules: daily_schedules)
  end

  def new(conn, _params) do
    changeset = Owners.change_daily_schedule(%DailySchedule{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"daily_schedule" => daily_schedule_params}) do
    case Owners.create_daily_schedule(daily_schedule_params) do
      {:ok, daily_schedule} ->
        conn
        |> put_flash(:info, "Daily schedule created successfully.")
        |> redirect(to: daily_schedule_path(conn, :show, daily_schedule))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    daily_schedule = Owners.get_daily_schedule!(id)
    render(conn, "show.html", daily_schedule: daily_schedule)
  end

  def edit(conn, %{"id" => id}) do
    daily_schedule = Owners.get_daily_schedule!(id)
    changeset = Owners.change_daily_schedule(daily_schedule)
    render(conn, "edit.html", daily_schedule: daily_schedule, changeset: changeset)
  end

  def update(conn, %{"id" => id, "daily_schedule" => daily_schedule_params}) do
    daily_schedule = Owners.get_daily_schedule!(id)

    case Owners.update_daily_schedule(daily_schedule, daily_schedule_params) do
      {:ok, daily_schedule} ->
        conn
        |> put_flash(:info, "Daily schedule updated successfully.")
        |> redirect(to: daily_schedule_path(conn, :show, daily_schedule))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", daily_schedule: daily_schedule, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    daily_schedule = Owners.get_daily_schedule!(id)
    {:ok, _daily_schedule} = Owners.delete_daily_schedule(daily_schedule)

    conn
    |> put_flash(:info, "Daily schedule deleted successfully.")
    |> redirect(to: daily_schedule_path(conn, :index))
  end
end
