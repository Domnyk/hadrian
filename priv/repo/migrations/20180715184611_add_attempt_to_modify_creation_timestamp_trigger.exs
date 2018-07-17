defmodule Hadrian.Repo.Migrations.AddAttemptToModifyCreationTimestampTrigger do
  use Ecto.Migration

  def up do
    execute "
      CREATE FUNCTION attempt_to_modify_creation_timestamp()
      RETURNS trigger
      LANGUAGE plpgsql
      AS $$
      BEGIN
<<<<<<< HEAD
        IF (NEW.created_at <> OLD.created_at) THEN
=======
        IF (NEW.inserted_at <> OLD.inserted_at) THEN
>>>>>>> c4f1ba2dd11aa769312d904ce8a2fd4a403f56a6
          RAISE EXCEPTION 'Modifying creation timestamp is illegal';
        END IF;
  
        RETURN NEW;
      END;
      $$;
    "

    execute "
      CREATE TRIGGER attempt_to_modify_creation_timestamp_trg
      BEFORE UPDATE
      ON events
      FOR EACH ROW
      EXECUTE PROCEDURE attempt_to_modify_creation_timestamp();
    "
  end

  def down do
    execute "
      DROP TRIGGER attempt_to_modify_creation_timestamp_trg
      ON events;
    "

    execute "DROP FUNCTION attempt_to_modify_creation_timestamp();"
  end
end
