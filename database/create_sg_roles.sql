
-- Useful links:
-- https://postgis.net/workshops/postgis-intro/security.html

-- SET UP ROLES NEEDED FOR EDITING --------------------------------------------------------------------------------------

-- 1. Create postgis_reader role....don't need a postgis_writer role
CREATE ROLE postgis_reader INHERIT;
GRANT USAGE ON SCHEMA public TO postgis_reader;
GRANT SELECT ON geometry_columns TO postgis_reader;
GRANT SELECT ON geography_columns TO postgis_reader;
GRANT SELECT ON spatial_ref_sys TO postgis_reader;
GRANT EXECUTE ON ALL FUNCTIONS in SCHEMA "public" TO postgis_reader;

-- 2. Create sg_writer_app role...note separate schema below
CREATE ROLE sg_writer_app INHERIT;
GRANT USAGE ON SCHEMA spawning_ground TO sg_writer_app;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA spawning_ground TO sg_writer_app;
GRANT ALL ON ALL SEQUENCES IN SCHEMA spawning_ground TO sg_writer_app;
GRANT postgis_reader TO sg_writer_app;

-- 3. To avoid having to preface st functions in public schema with public.st_xxx
ALTER USER sg_writer_app SET search_path = spawning_ground, public;

-- 4. Assign sg_writer_app to users
GRANT sg_writer_app TO username_one;
GRANT sg_writer_app TO username_two;

-- SET UP ROLES NEEDED FOR READONLY --------------------------------------------------------------------------------------

-- 1. Use postgis_reader role from above

-- 2. Create sg_readonly role...note separate schema below
CREATE ROLE sg_readonly INHERIT;
GRANT USAGE ON SCHEMA spawning_ground TO sg_readonly;
GRANT SELECT ON ALL TABLES IN SCHEMA spawning_ground TO sg_readonly;
GRANT SELECT ON ALL SEQUENCES IN SCHEMA spawning_ground TO sg_readonly;
GRANT postgis_reader TO sg_readonly;

-- 3. To avoid having to preface st functions in public schema with public.st_xxx
ALTER USER sg_readonly SET search_path = spawning_ground, public;

-- 4. Assign sg_readonly to users
GRANT sg_readonly TO username_three;

--Testing ---------------------------------------------------------------------

-- Worked when logged in as username_three prior to postgis_reader inherit...no geometry tables
select distinct wr.wria_code || ' ' || wr.wria_description as wria_name
from spawning_ground.wria_lut as wr
where wr.wria_code in ('22', '23')
order by wria_name

-- Now works when logged in as username_three after postgis_reader inherit...did not work prior
-- Explicit postgis_reader permissions needed for selects on geometry tables
select distinct wb.waterbody_id, wb.waterbody_name as stream_name,
             wb.waterbody_name, wb.latitude_longitude_id as llid,
             wb.stream_catalog_code as cat_code, wr.wria_id, st.stream_id,
             wr.wria_code || ' ' || wr.wria_description as wria_name, st.geom as geometry
             from spawning_ground.waterbody_lut as wb
             inner join spawning_ground.stream as st on wb.waterbody_id = st.waterbody_id
             inner join spawning_ground.wria_lut as wr on st_intersects(st.geom, wr.geom)
             where wr.wria_code = '22'
             order by wb.waterbody_name


