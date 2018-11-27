defmodule Hadrian.Repo.Migrations.AddEventDoesNotFulfillTimeMarginTrigger do
  use Ecto.Migration

  def up do
#    execute "
#      CREATE FUNCTION event_does_not_fulfill_time_margin()
#      RETURNS trigger
#      LANGUAGE plpgsql
#      AS $$
#      DECLARE
#        booking_margin INTERVAL;
#        schedule_day DATE;
#        proposed_end_of_booking_phase DATE;
#        required_end_of_booking_phase DATE;
#      BEGIN
#        SELECT sport_objects.booking_margin, d_s.schedule_day INTO booking_margin, schedule_day from sport_objects
#        JOIN sport_arenas s_a ON sport_objects.id = s_a.sport_object_id
#        JOIN daily_schedules d_s ON s_a.id = d_s.sport_arena_id
#        WHERE NEW.daily_schedule_id = d_s.id;
#
#        proposed_end_of_booking_phase = now() + NEW.duration_of_joining_phase + NEW.duration_of_paying_phase;
#        required_end_of_booking_phase = schedule_day - booking_margin;
#
#        IF (proposed_end_of_booking_phase > required_end_of_booking_phase) THEN
#          RAISE EXCEPTION 'Booking phase has to be shorter. It has to end on % but right now ends on %',
#          required_end_of_booking_phase, proposed_end_of_booking_phase;
#        END IF;
#
#        RETURN NEW;
#      END;
#      $$;
#    "
    execute "
     CREATE FUNCTION event_does_not_fulfill_time_margin()
       RETURNS trigger
       LANGUAGE plpgsql
       AS $$
       DECLARE
         booking_margin INTERVAL;
         schedule_day DATE;
         required_end_of_paying_phase DATE;
       BEGIN
         SELECT sport_objects.booking_margin, d_s.schedule_day INTO booking_margin, schedule_day from sport_objects
         JOIN sport_arenas s_a ON sport_objects.id = s_a.sport_object_id
         JOIN daily_schedules d_s ON s_a.id = d_s.sport_arena_id
         WHERE NEW.daily_schedule_id = d_s.id;

         required_end_of_paying_phase = schedule_day - booking_margin;
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
