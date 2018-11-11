defmodule Hadrian.Repo.Migrations.AddOnDayOff do
  use Ecto.Migration

  def up do
    execute "
      CREATE FUNCTION event_on_day_off()
      RETURNS trigger
      LANGUAGE plpgsql
      AS $$
      DECLARE
        is_day_off_ BOOLEAN;
      BEGIN
        SELECT is_day_off INTO is_day_off_ FROM daily_schedules
          WHERE id = NEW.daily_schedule_id;

        IF (is_day_off_) THEN
          RAISE EXCEPTION 'Can not add event on day off';
        END IF;

        RETURN NEW;
      END;
      $$;
    "

    execute "
      CREATE TRIGGER event_on_day_off
      BEFORE INSERT
      ON events
      FOR EACH ROW
      EXECUTE PROCEDURE event_on_day_off();
    "
  end

  def down do
    execute "
      DROP TRIGGER event_on_day_off
      ON events;
    "

    execute "
      DROP FUNCTION event_on_day_off();
    "
  end
end
