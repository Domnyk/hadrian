defmodule Hadrian.Repo.Migrations.AddEventsOverlap do
  use Ecto.Migration

  def up do
    execute "
      CREATE FUNCTION events_overlap()
        RETURNS trigger
      LANGUAGE plpgsql
      AS $$
      DECLARE
          existing_start_time TIME;
          existing_end_time TIME;

          BEGIN
            SELECT events.start_time, events.end_time INTO existing_start_time, existing_end_time FROM events;

            IF ((NEW.start_time, NEW.end_time) OVERLAPS (existing_start_time, existing_end_time )) THEN
              RAISE EXCEPTION 'This event would overlap with existing one. Existing event takes place during: % and %',
                           existing_start_time, existing_end_time;
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
