-- Code to create editable lake view....This works
-- AS 2018-05-30

--DROP VIEW public.lake_info;

-- Create the view. Make sure any columns referenced are in the view.
CREATE OR REPLACE VIEW public.lake_info AS
 SELECT
    lk.gid,
    w.waterbody_id,
    lk.lake_id,
    w.waterbody_name,
    w.waterbody_display_name,
    w.obsolete_flag,
    w.obsolete_datetime,
    lk.created_datetime,
    lk.created_by,
    lk.modified_datetime,
    lk.modified_by,
    lk.geom
   FROM waterbody_lut AS w
     INNER JOIN lake AS lk ON w.waterbody_id = lk.waterbody_id
 ORDER BY lk.gid;

ALTER TABLE public.d15_lake
    OWNER TO stromas;

-- FUNCTION: public.lake_info_change()

-- DROP FUNCTION public.lake_info_change() CASCADE;

CREATE FUNCTION public.lake_info_change()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$

    DECLARE
        water_id   uuid;
	      next_gid   integer;
	      obs_date   timestamptz;

    BEGIN
      IF TG_OP = 'INSERT' THEN

		-- set default values
	    water_id = gen_random_uuid();
		  next_gid = 1 + (select max(gid) from lake);

		-- insert operation
        INSERT INTO  waterbody_lut
        VALUES (water_id, NEW.waterbody_name, NEW.waterbody_display_name,
                NULL, NULL, NULL, NEW.obsolete_flag, NEW.obsolete_datetime);
        INSERT INTO  lake
        VALUES(gen_random_uuid(), water_id, next_gid, NEW.geom, now(), current_user);
        RETURN NEW;

    ELSIF TG_OP = 'UPDATE' THEN

       -- calculate obs_date
       IF (NEW.obsolete_flag = true) THEN
	        obs_date = now();
	     ELSEIF (NEW.obsolete_flag = false) THEN
	        obs_date = NULL;
	     END IF;

       UPDATE waterbody_lut
       SET
         waterbody_id=NEW.waterbody_id, waterbody_name=NEW.waterbody_name,
	       waterbody_display_name=NEW.waterbody_display_name,
		     latitude_longitude_id=NULL, stream_catalog_code=NULL,
		     tributary_to_name=NULL, obsolete_flag=NEW.obsolete_flag,
		     obsolete_datetime=obs_date
	    WHERE waterbody_id=OLD.waterbody_id;
      UPDATE lake
       SET
         lake_id=NEW.lake_id, waterbody_id=NEW.waterbody_id, gid=NEW.gid,
         geom=NEW.geom, modified_datetime=now(), modified_by=current_user
       WHERE lake_id=OLD.lake_id;
       RETURN NEW;

    ELSIF TG_OP = 'DELETE' THEN
       DELETE FROM lake WHERE lake_id=OLD.lake_id;
       DELETE FROM waterbody_lut WHERE waterbody_id=OLD.waterbody_id;
       RETURN NULL;
    END IF;
    RETURN NEW;
  END;

$BODY$;

ALTER FUNCTION public.lake_info_change()
    OWNER TO stromas;


-- Create the trigger
CREATE TRIGGER lake_info_trig
    INSTEAD OF INSERT OR DELETE OR UPDATE
    ON public.lake_info
    FOR EACH ROW
    EXECUTE PROCEDURE public.lake_info_change();





