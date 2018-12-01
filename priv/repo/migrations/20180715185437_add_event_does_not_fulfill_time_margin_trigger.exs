defmodule Hadrian.Repo.Migrations.AddEventDoesNotFulfillTimeMarginTrigger do
  use Ecto.Migration

  def up do
    execute "
     CREATE FUNCTION event_does_not_fulfill_time_margin()
       RETURNS trigger
       LANGUAGE plpgsql
       AS $$
       DECLARE
         booking_margin INTERVAL;
         required_end_of_paying_phase DATE;
       BEGIN
         SELECT sport_objects.booking_margin INTO booking_margin FROM sport_objects
         JOIN sport_arenas s_a ON sport_objects.id = s_a.sport_object_id
         WHERE NEW.sport_arena_id = s_a.id;

         required_end_of_paying_phase = NEW.event_day - booking_margin;
         IF (NEW.end_of_paying_phase > required_end_of_paying_phase) THEN
           RAISE EXCEPTION 'Joining phase or paying phase has to be shorter. Event must be fully booked on % but now is on %',
           required_end_of_paying_phase, NEW.end_of_paying_phase;
         END IF;

         RETURN NEW;
       END;
     $$;
    "

    execute "
      CREATE TRIGGER event_does_not_fulfill_time_margin
      BEFORE INSERT
      ON events
      FOR EACH ROW
      EXECUTE PROCEDURE event_does_not_fulfill_time_margin();
    "
  end

  def down do
    execute "
      DROP TRIGGER event_does_not_fulfill_time_margin
      ON events;
    "

    execute "
      DROP FUNCTION event_does_not_fulfill_time_margin()
    "
  end
end
