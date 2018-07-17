defmodule Hadrian.Repo.Migrations.AddSetUpdateTimestampToProperValueTrigger do
  use Ecto.Migration

  def up do
    execute "
      CREATE FUNCTION set_update_timestamp_to_proper_value()
      RETURNS trigger
      LANGUAGE plpgsql
      AS $$
      BEGIN
        NEW.updated_at = CURRENT_TIMESTAMP;
  
        RETURN NEW;
      END;
      $$;
    "

    execute "
      CREATE TRIGGER set_update_timestamp_to_proper_value
      BEFORE UPDATE
      ON events
      FOR EACH ROW
    EXECUTE PROCEDURE set_update_timestamp_to_proper_value();
    "
  end

  def down do
    execute "
      DROP TRIGGER set_update_timestamp_to_proper_value
      ON events;
    " 

    execute "
      DROP FUNCTION set_update_timestamp_to_proper_value();
    "
  end

end