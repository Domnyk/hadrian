defmodule Hadrian.Repo.Migrations.AddEventsOverlap do
  use Ecto.Migration

  def up do
    execute "
      CREATE FUNCTION events_overlap()
        RETURNS TRIGGER
      LANGUAGE plpgsql
      AS $$
      DECLARE
        overlaping_event_start_time TIME;
        overlaping_event_end_time TIME;
      BEGIN
        SELECT events.start_time, events.end_time INTO overlaping_event_start_time, overlaping_event_end_time FROM events
        WHERE
          event_day = NEW.event_day AND
          (
            (NEW.end_time > events.start_time AND NEW.end_time < events.end_time) OR
            (NEW.start_time > events.start_time AND NEW.start_time < events.end_time)
          );

        IF (overlaping_event_start_time IS NOT NULL OR overlaping_event_end_time IS NOT NULL) THEN
          RAISE EXCEPTION 'This event would overlap with existing one. Existing event takes place during: % and %',
                       overlaping_event_start_time, overlaping_event_end_time;
        END IF;

        RETURN NEW;
      END
      $$;
    "

    execute "
      CREATE TRIGGER events_overlap
      BEFORE INSERT
      ON events
      FOR EACH ROW
      EXECUTE PROCEDURE events_overlap();
    "
  end

  def down do
    execute "
      DROP TRIGGER events_overlap ON events;
    "

    execute "
      DROP FUNCTION events_overlap();
    "
  end
end
