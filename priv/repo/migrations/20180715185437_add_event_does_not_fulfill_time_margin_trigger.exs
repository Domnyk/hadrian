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
        schedule_day DATE;
        proposed_end_of_booking_phase DATE;
        required_end_of_booking_phase DATE;
      BEGIN
        SELECT sport_objects.booking_margin, d_s.schedule_day INTO booking_margin, schedule_day from sport_objects
        JOIN sport_arenas s_aa ON sport_objects.id = s_a.sport_object_id
        JOIN daily_schedules d_s ON s_a.id = d_s.sport_arena_id
        JOIN time_blocks t_b ON d_s.id = t_b.daily_schedule_id
        WHERE NEW.time_block_id = t_b.id;
    
        proposed_end_of_booking_phase = now() + NEW.duration_of_joining_phase + NEW.duration_of_paying_phase;
        required_end_of_booking_phase = schedule_day - booking_margin;
    
        IF (proposed_end_of_booking_phase > required_end_of_booking_phase) THEN
          RAISE EXCEPTION 'Booking phase has to be shorter. It has to end on % but right now ends on %',
          required_end_of_booking_phase, proposed_end_of_booking_phase;
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
