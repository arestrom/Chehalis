-- Code to create editable stream view
-- AS 2018-05-30

--DROP VIEW public.stream_info;

-- Create the view. Make sure any columns referenced are in the view.
CREATE OR REPLACE VIEW public.stream_info AS
 SELECT
    s.gid,
    w.waterbody_id,
    s.stream_id,
    w.waterbody_name,
    w.waterbody_display_name,
    w.latitude_longitude_id,
    w.stream_catalog_code,
    w.tributary_to_name,
    w.obsolete_flag,
    w.obsolete_datetime,
    s.created_datetime,
    s.created_by,
    s.modified_datetime,
    s.modified_by,
    s.geom
   FROM waterbody_lut w
     JOIN stream s ON w.waterbody_id = s.waterbody_id
 ORDER BY s.gid;

ALTER TABLE public.stream_info
    OWNER TO stromas;


-- DROP FUNCTION public.stream_info_change() CASCADE;

CREATE FUNCTION public.stream_info_change()
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
		    next_gid = 1 + (select max(gid) from stream);

        -- insert operation
        INSERT INTO  waterbody_lut
        VALUES(water_id, NEW.waterbody_name, NEW.waterbody_display_name,
			         NEW.latitude_longitude_id, NEW.stream_catalog_code, NEW.tributary_to_name,
			         NEW.obsolete_flag, now());
        INSERT INTO  stream
        VALUES(gen_random_uuid(), water_id, next_gid, NEW.geom, now(), current_user, NULL, NULL);
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
		     latitude_longitude_id=NEW.latitude_longitude_id,
		     stream_catalog_code=NEW.stream_catalog_code,
		     tributary_to_name=NEW.tributary_to_name,
		     obsolete_flag=NEW.obsolete_flag, obsolete_datetime=obs_date
	     WHERE waterbody_id=OLD.waterbody_id;
       UPDATE stream
       SET
         stream_id=NEW.stream_id, waterbody_id=NEW.waterbody_id, gid=NEW.gid,
         geom=NEW.geom, modified_datetime=now(), modified_by=current_user
       WHERE stream_id=OLD.stream_id;
       RETURN NEW;

    ELSIF TG_OP = 'DELETE' THEN
       DELETE FROM stream WHERE stream_id=OLD.stream_id;
       DELETE FROM waterbody_lut WHERE waterbody_id=OLD.waterbody_id;
       RETURN NULL;
    END IF;
    RETURN NEW;
  END;
$BODY$;

ALTER FUNCTION public.stream_info_change()
    OWNER TO stromas;

-- Create the trigger
CREATE TRIGGER stream_info_trig
    INSTEAD OF INSERT OR DELETE OR UPDATE
    ON public.stream_info
    FOR EACH ROW
    EXECUTE PROCEDURE public.stream_info_change();










