-- Created on 2017-01-31
-- Added location_code varchar(10) 2017-01-31...For Gil. In addition to waloc_id
-- Changed to orientation_type_description in location_orientation_type_lut
-- Changed name of 'capture_event' table to 'fish_capture' table
-- Added survey_intent and count_type_lut tables 2017-05-03
-- Added cwt_result_type_lut, 2017-05-16
-- Added cwt_result_type_id to individual_fish, 2017-05-16
-- Added cwt_tag_code to individual_fish, 2017-05-16
-- Moved origin_lut down to fish_encounter, 2017-05-16
-- Edited some field names. Added spatial tables for
--   location_coordinates, stream and lake geometry
--   Changed stream_lut to waterbody_lut. 2018-03-14
-- Changed from geom_id to gid. 2018-05-07.
-- Changed lake geometry to multipolygonz to match NHD layer. 2018-05-22
-- Dropped longitude and latitude columns. Should use view. 2018-06-08
-- Dropped total_age and fresh_water_age. Set age_code to age_code_id. 2018-06-13
-- Added age_code lut 2018-06-13
-- Changed names of survey_start_location_id and survey_end_location_id
--   to upper_end_point_id and lower_end_point_id. We have RMs, but usually not direction. 2018-06-13
-- Added fish_biologist_district table .... floating table. No foreign keys.
--   Need for filtering views based on biologist districts.  2018-06-14
-- Amended fish_biologist_district to include district description column. 2018-06-25.
-- Dropped most not null constraints on survey_comment table. 2018-06-21
-- Dropped not null constraint on waterbody_measurement table. 2018-06-22
-- Added hydrologic_unit table to allow defining tribs and biologist areas. 2018-07-31
-- Added media_location_id table to enable storage of photo, video, audio files. 2018-08-29
--     Also added new media_type_lut to allow specifying types of media, and also
--     media location_type value in location_type_lut. Added table comments. 2018-08-29
-- Changed all character varying fields to text. 2019-07-10.
-- Added survey_direction_lut and survey_direction_id to survey_comment. 2019-07-10
-- Changed order of columns in survey_comment. 2019-07-10
-- Changed name of survey_visibility_type_lut to visibility_type_lut. 2019-07-10
-- Changed name of point_location to location. 2019-07-10
-- Added stream_section to hold IMW RP segments...primarily historical data. 2019-07-10
-- Changed name of wildlife_encounter to other_observation. 2019-07-10
-- Changed name of wildlife_type_lut to observation_type_lut. 2019-07-10
-- Added redd_dewatered_type to individual redd. Add new redd_dewatered_type_lut. 2019-07-10
-- Added stock_lut linked to waterbody_lut. Last minute requirement by Brodie. 2019-10-15
-- Added index on survey_datetime.
-- Added comment_text to media_location. 2020-06-06
-- Changed fish_barrier table to fish_passage_feature at Gil's request. 2020-06-17

-- Notes:
-- 1. No need for grant all statement
-- 2. LLID has been deprecated for Lakes. Do not use...do not set to required,
--    but require LLID if Lake geometry is not entered. Require Lake Geometry
--    if LLID is NULL.
-- 3. Only load waterbody data as survey data are entered. This can avoid loading
--    orphan streams...and requires that streams are checked for proper LLIDs.
--    Only load data as stream LLIDs are verified, and LLID geometry is loaded.
-- 4. Tried to change stream table geom to multilinestringm 2018-05-01
--    Did not work. Should be possible, but docs recommend against M dimension
--    unless really needed.

-- ToDo:
-- 1. For Columbia basin fecundity data consider adding new fecundity sampling table as needed.
--    Data for TWS is currently handled by individual_fish fields.
-- 2. For population definition, mng_methods_basin, etc., add spatial layers as needed.

-- Current date 2021-05-26

-- Create tables ------------------------------------------------------

CREATE TABLE adipose_clip_status_lut (
    adipose_clip_status_id uuid DEFAULT gen_random_uuid() NOT NULL,
    adipose_clip_status_code text NOT NULL,
    adipose_clip_status_description text NOT NULL,
    obsolete_flag boolean NOT NULL,
    obsolete_datetime timestamp(6) with time zone
);

CREATE TABLE age_code_lut (
    age_code_id uuid DEFAULT gen_random_uuid() NOT NULL,
    european_age_code text NOT NULL,
    gilbert_rich_age_code text,
    fresh_water_annuli integer,
    maiden_salt_water_annuli integer,
    total_salt_water_annuli integer,
    age_at_spawning integer,
    prior_spawn_event_count integer,
    obsolete_flag boolean NOT NULL,
    obsolete_datetime timestamp(6) with time zone
);

CREATE TABLE area_surveyed_lut (
    area_surveyed_id uuid DEFAULT gen_random_uuid() NOT NULL,
    area_surveyed text NOT NULL,
    obsolete_flag boolean NOT NULL,
    obsolete_datetime timestamp(6) with time zone
);

CREATE TABLE coordinate_capture_method_lut (
    coordinate_capture_method_id uuid DEFAULT gen_random_uuid() NOT NULL,
    capture_method_description text NOT NULL,
    obsolete_flag boolean NOT NULL,
    obsolete_datetime timestamp(6) with time zone
);

CREATE TABLE count_type_lut (
    count_type_id uuid DEFAULT gen_random_uuid() NOT NULL,
    count_type_code text NOT NULL,
    count_type_description text NOT NULL,
    obsolete_flag boolean NOT NULL,
    obsolete_datetime timestamp(6) with time zone
);

CREATE TABLE cwt_detection_method_lut (
    cwt_detection_method_id uuid DEFAULT gen_random_uuid() NOT NULL,
    detection_method_description text NOT NULL,
    obsolete_flag boolean NOT NULL,
    obsolete_datetime timestamp(6) with time zone
);

CREATE TABLE cwt_detection_status_lut (
    cwt_detection_status_id uuid DEFAULT gen_random_uuid() NOT NULL,
    detection_status_description text NOT NULL,
    obsolete_flag boolean NOT NULL,
    obsolete_datetime timestamp(6) with time zone
);

CREATE TABLE cwt_result_type_lut (
    cwt_result_type_id uuid DEFAULT gen_random_uuid() NOT NULL,
    cwt_result_type_code text NOT NULL,
    cwt_result_type_short_description text NOT NULL,
    cwt_result_type_description text NOT NULL,
    obsolete_flag boolean NOT NULL,
    obsolete_datetime timestamp(6) with time zone
);

CREATE TABLE data_review_status_lut (
    data_review_status_id uuid DEFAULT gen_random_uuid() NOT NULL,
    data_review_status_description text NOT NULL,
    obsolete_flag boolean NOT NULL,
    obsolete_datetime timestamp(6) with time zone
);

CREATE TABLE data_source_lut (
    data_source_id uuid DEFAULT gen_random_uuid() NOT NULL,
    data_source_name text NOT NULL,
    data_source_code text NOT NULL,
    obsolete_flag boolean NOT NULL,
    obsolete_datetime timestamp(6) with time zone
);

CREATE TABLE data_source_unit_lut (
    data_source_unit_id uuid DEFAULT gen_random_uuid() NOT NULL,
    data_source_unit_name text NOT NULL,
    obsolete_flag boolean NOT NULL,
    obsolete_datetime timestamp(6) with time zone
);

CREATE TABLE disposition_lut (
    disposition_id uuid DEFAULT gen_random_uuid() NOT NULL,
    disposition_code text NOT NULL,
    fish_books_code text,
    disposition_description text NOT NULL,
    obsolete_flag boolean NOT NULL,
    obsolete_datetime timestamp(6) with time zone
);

CREATE TABLE disposition_type_lut (
    disposition_type_id uuid DEFAULT gen_random_uuid() NOT NULL,
    disposition_type_code text NOT NULL,
    disposition_type_description text NOT NULL,
    obsolete_flag boolean NOT NULL,
    obsolete_datetime timestamp(6) with time zone
);

CREATE TABLE fish_abundance_condition_lut (
    fish_abundance_condition_id uuid DEFAULT gen_random_uuid() NOT NULL,
    fish_abundance_condition text NOT NULL,
    obsolete_flag boolean NOT NULL,
    obsolete_datetime timestamp(6) with time zone
);

CREATE TABLE fish_behavior_type_lut (
    fish_behavior_type_id uuid DEFAULT gen_random_uuid() NOT NULL,
    behavior_short_description text NOT NULL,
    behavior_description text NOT NULL,
    obsolete_flag boolean NOT NULL,
    obsolete_datetime timestamp(6) with time zone
);

CREATE TABLE fish_biologist_district (
    fish_biologist_district_id uuid DEFAULT gen_random_uuid() NOT NULL,
    fish_biologist_district_code integer NOT NULL,
    district_description text NOT NULL,
    wdfw_region_code integer NOT NULL,
    gid serial unique,
    geom geometry(polygon, 2927) NOT NULL,
    created_datetime timestamp(6) with time zone DEFAULT now() NOT NULL,
    created_by text NOT NULL,
    modified_datetime timestamp(6) with time zone,
    modified_by text
);

CREATE TABLE fish_capture (
    fish_capture_id uuid DEFAULT gen_random_uuid() NOT NULL,
    survey_id uuid NOT NULL,
    gear_performance_type_id uuid NOT NULL,
    fish_start_datetime timestamp(6) with time zone,
    fish_end_datetime timestamp(6) with time zone,
    created_datetime timestamp(6) with time zone DEFAULT now() NOT NULL,
    created_by text NOT NULL,
    modified_datetime timestamp(6) with time zone,
    modified_by text
);

CREATE TABLE fish_capture_event (
    fish_capture_event_id uuid DEFAULT gen_random_uuid() NOT NULL,
    fish_encounter_id uuid NOT NULL,
    fish_capture_status_id uuid NOT NULL,
    disposition_type_id uuid NOT NULL,
    disposition_id uuid NOT NULL,
    disposition_location_id uuid,
    created_datetime timestamp(6) with time zone DEFAULT now() NOT NULL,
    created_by text NOT NULL,
    modified_datetime timestamp(6) with time zone,
    modified_by text
);

CREATE TABLE fish_capture_status_lut (
    fish_capture_status_id uuid DEFAULT gen_random_uuid() NOT NULL,
    fish_capture_status_code text NOT NULL,
    fish_capture_status_description text NOT NULL,
    obsolete_flag boolean NOT NULL,
    obsolete_datetime timestamp(6) with time zone
);

CREATE TABLE fish_condition_type_lut (
    fish_condition_type_id uuid DEFAULT gen_random_uuid() NOT NULL,
    fish_condition_short_description text NOT NULL,
    fish_condition_description text NOT NULL,
    obsolete_flag boolean NOT NULL,
    obsolete_datetime timestamp(6) with time zone
);

CREATE TABLE fish_encounter (
    fish_encounter_id uuid DEFAULT gen_random_uuid() NOT NULL,
    survey_event_id uuid NOT NULL,
    fish_location_id uuid,
    fish_status_id uuid NOT NULL,
    sex_id uuid NOT NULL,
    maturity_id uuid NOT NULL,
    origin_id uuid NOT NULL,
    cwt_detection_status_id uuid NOT NULL,
    adipose_clip_status_id uuid NOT NULL,
    fish_behavior_type_id uuid NOT NULL,
    mortality_type_id uuid NOT NULL,
    fish_encounter_datetime timestamp(6) with time zone,
    fish_count integer NOT NULL,
    previously_counted_indicator boolean NOT NULL,
    created_datetime timestamp(6) with time zone DEFAULT now() NOT NULL,
    created_by text NOT NULL,
    modified_datetime timestamp(6) with time zone,
    modified_by text
);

CREATE TABLE fish_length_measurement (
    fish_length_measurement_id uuid DEFAULT gen_random_uuid() NOT NULL,
    individual_fish_id uuid NOT NULL,
    fish_length_measurement_type_id uuid NOT NULL,
    length_measurement_centimeter numeric(6,2) NOT NULL,
    created_datetime timestamp(6) with time zone DEFAULT now() NOT NULL,
    created_by text NOT NULL,
    modified_datetime timestamp(6) with time zone,
    modified_by text
);

CREATE TABLE fish_length_measurement_type_lut (
    fish_length_measurement_type_id uuid DEFAULT gen_random_uuid() NOT NULL,
    length_type_code text NOT NULL,
    length_type_description text NOT NULL,
    obsolete_flag boolean NOT NULL,
    obsolete_datetime timestamp(6) with time zone
);

CREATE TABLE fish_mark (
    fish_mark_id uuid DEFAULT gen_random_uuid() NOT NULL,
    fish_encounter_id uuid NOT NULL,
    mark_type_id uuid NOT NULL,
    mark_status_id uuid NOT NULL,
    mark_orientation_id uuid NOT NULL,
    mark_placement_id uuid NOT NULL,
    mark_size_id uuid NOT NULL,
    mark_color_id uuid NOT NULL,
    mark_shape_id uuid NOT NULL,
    tag_number text,
    created_datetime timestamp(6) with time zone DEFAULT now() NOT NULL,
    created_by text NOT NULL,
    modified_datetime timestamp(6) with time zone,
    modified_by text
);

CREATE TABLE fish_passage_feature (
    fish_passage_feature_id uuid DEFAULT gen_random_uuid() NOT NULL,
    survey_id uuid NOT NULL,
    feature_location_id uuid NOT NULL,
    passage_feature_type_id uuid NOT NULL,
    feature_observed_datetime timestamp(6) with time zone,
    feature_height_meter numeric(4,2),
    feature_height_type_id uuid NOT NULL,
    plunge_pool_depth_meter numeric(4,2),
    plunge_pool_depth_type_id uuid NOT NULL,
    comment_text text,
    created_datetime timestamp(6) with time zone DEFAULT now() NOT NULL,
    created_by text NOT NULL,
    modified_datetime timestamp(6) with time zone,
    modified_by text
);

CREATE TABLE fish_presence_type_lut (
    fish_presence_type_id uuid DEFAULT gen_random_uuid() NOT NULL,
    fish_presence_type_description text NOT NULL,
    obsolete_flag boolean NOT NULL,
    obsolete_datetime timestamp(6) with time zone
);

CREATE TABLE fish_species_presence (
    fish_species_presence_id uuid DEFAULT gen_random_uuid() NOT NULL,
    survey_id uuid NOT NULL,
    species_id uuid NOT NULL,
    fish_presence_type_id uuid NOT NULL,
    comment_text text,
    created_datetime timestamp(6) with time zone DEFAULT now() NOT NULL,
    created_by text NOT NULL,
    modified_datetime timestamp(6) with time zone,
    modified_by text
);

CREATE TABLE fish_status_lut (
    fish_status_id uuid DEFAULT gen_random_uuid() NOT NULL,
    fish_status_description text NOT NULL,
    obsolete_flag boolean NOT NULL,
    obsolete_datetime timestamp(6) with time zone
);

CREATE TABLE fish_trauma_type_lut (
    fish_trauma_type_id uuid DEFAULT gen_random_uuid() NOT NULL,
    trauma_type_short_description text NOT NULL,
    trauma_type_description text NOT NULL,
    obsolete_flag boolean NOT NULL,
    obsolete_datetime timestamp(6) with time zone
);

CREATE TABLE gear_performance_type_lut (
    gear_performance_type_id uuid DEFAULT gen_random_uuid() NOT NULL,
    performance_short_description text NOT NULL,
    performance_description text NOT NULL,
    obsolete_flag boolean NOT NULL,
    obsolete_datetime timestamp(6) with time zone
);

CREATE TABLE gill_condition_type_lut (
    gill_condition_type_id uuid DEFAULT gen_random_uuid() NOT NULL,
    gill_condition_type_description text NOT NULL,
    obsolete_flag boolean NOT NULL,
    obsolete_datetime timestamp(6) with time zone
);

CREATE TABLE hydrologic_unit (
    hydrologic_unit_id uuid DEFAULT gen_random_uuid() NOT NULL,
    hydrologic_unit_code text NOT NULL,
    hydrologic_unit_name text,
    marine_terminus text,
    reach_description text,
    tributary_one text,
    tributary_two text,
    tributary_three text,
    tributary_four text,
    tributary_five text,
    gid serial unique,
    geom geometry(multipolygon, 2927) NOT NULL,
    created_datetime timestamp(6) with time zone DEFAULT now() NOT NULL,
    created_by text NOT NULL,
    modified_datetime timestamp(6) with time zone,
    modified_by text
);

CREATE TABLE incomplete_survey_type_lut (
    incomplete_survey_type_id uuid DEFAULT gen_random_uuid() NOT NULL,
    incomplete_survey_description text NOT NULL,
    obsolete_flag boolean NOT NULL,
    obsolete_datetime timestamp(6) with time zone
);

CREATE TABLE individual_fish (
    individual_fish_id uuid DEFAULT gen_random_uuid() NOT NULL,
    fish_encounter_id uuid NOT NULL,
    fish_condition_type_id uuid NOT NULL,
    fish_trauma_type_id uuid NOT NULL,
    gill_condition_type_id uuid NOT NULL,
    spawn_condition_type_id uuid NOT NULL,
    cwt_result_type_id uuid NOT NULL,
    age_code_id uuid,
    percent_eggs_retained integer,
    eggs_retained_gram numeric(4,1),
    eggs_retained_number integer,
    fish_sample_number text,
    scale_sample_card_number text,
    scale_sample_position_number text,
    cwt_snout_sample_number text,
    cwt_tag_code text,
    genetic_sample_number text,
    otolith_sample_number text,
    comment_text text,
    created_datetime timestamp(6) with time zone DEFAULT now() NOT NULL,
    created_by text NOT NULL,
    modified_datetime timestamp(6) with time zone,
    modified_by text
);

CREATE TABLE individual_redd (
    individual_redd_id uuid DEFAULT gen_random_uuid() NOT NULL,
    redd_encounter_id uuid NOT NULL,
    redd_shape_id uuid NOT NULL,
    redd_dewatered_type_id uuid,
    percent_redd_visible integer,
    redd_length_measure_meter numeric(4,2),
    redd_width_measure_meter numeric(4,2),
    redd_depth_measure_meter numeric(3,2),
    tailspill_height_measure_meter numeric(3,2),
    percent_redd_superimposed integer,
    percent_redd_degraded integer,
    superimposed_redd_name text,
    comment_text text,
    created_datetime timestamp(6) with time zone DEFAULT now() NOT NULL,
    created_by text NOT NULL,
    modified_datetime timestamp(6) with time zone,
    modified_by text
);

CREATE TABLE lake (
    lake_id uuid DEFAULT gen_random_uuid() NOT NULL,
    waterbody_id uuid NOT NULL,
    gid serial unique,
    geom geometry(multipolygonz, 2927) NOT NULL,
    created_datetime timestamp(6) with time zone DEFAULT now() NOT NULL,
    created_by text NOT NULL,
    modified_datetime timestamp(6) with time zone,
    modified_by text
);

CREATE TABLE location (
    location_id uuid DEFAULT gen_random_uuid() NOT NULL,
    waterbody_id uuid NOT NULL,
    wria_id uuid NOT NULL,
    location_type_id uuid NOT NULL,
    stream_channel_type_id uuid NOT NULL,
    location_orientation_type_id uuid NOT NULL,
    river_mile_measure numeric(6,2),
    location_code text,
    location_name text,
    location_description text,
    waloc_id integer,
    created_datetime timestamp(6) with time zone DEFAULT now() NOT NULL,
    created_by text NOT NULL,
    modified_datetime timestamp(6) with time zone,
    modified_by text
);

CREATE TABLE location_coordinates (
    location_coordinates_id uuid DEFAULT gen_random_uuid() NOT NULL,
    location_id uuid NOT NULL,
    horizontal_accuracy numeric(8,2),
    comment_text text,
    gid serial unique,
    geom geometry(point, 2927) NOT NULL,
    created_datetime timestamp(6) with time zone DEFAULT now() NOT NULL,
    created_by text NOT NULL,
    modified_datetime timestamp(6) with time zone,
    modified_by text
);

CREATE TABLE location_error_correction_type_lut (
    location_error_correction_type_id uuid DEFAULT gen_random_uuid() NOT NULL,
    correction_type_short_description text NOT NULL,
    correction_type_description text NOT NULL,
    obsolete_flag boolean NOT NULL,
    obsolete_datetime timestamp(6) with time zone
);

CREATE TABLE location_error_type_lut (
    location_error_type_id uuid DEFAULT gen_random_uuid() NOT NULL,
    location_error_type_code text NOT NULL,
    location_error_type_description text NOT NULL,
    obsolete_flag boolean NOT NULL,
    obsolete_datetime timestamp(6) with time zone
);

CREATE TABLE location_orientation_type_lut (
    location_orientation_type_id uuid DEFAULT gen_random_uuid() NOT NULL,
    orientation_type_description text NOT NULL,
    obsolete_flag boolean NOT NULL,
    obsolete_datetime timestamp(6) with time zone
);

CREATE TABLE location_source (
    location_source_id uuid DEFAULT gen_random_uuid() NOT NULL,
    location_coordinates_id uuid NOT NULL,
    coordinate_capture_method_id uuid NOT NULL,
    location_error_type_id uuid NOT NULL,
    location_error_correction_type_id uuid NOT NULL,
    source_longitude numeric(14,9),
    source_latitude numeric(12,9),
    elevation_meter numeric(6,1),
    location_correction_layer_name text,
    waypoint_name text,
    waypoint_datetime timestamp(6) with time zone,
    comment_text text,
    created_datetime timestamp(6) with time zone DEFAULT now() NOT NULL,
    created_by text NOT NULL,
    modified_datetime timestamp(6) with time zone,
    modified_by text
);

CREATE TABLE location_type_lut (
    location_type_id uuid DEFAULT gen_random_uuid() NOT NULL,
    location_type_description text NOT NULL,
    obsolete_flag boolean NOT NULL,
    obsolete_datetime timestamp(6) with time zone
);

CREATE TABLE mark_color_lut (
    mark_color_id uuid DEFAULT gen_random_uuid() NOT NULL,
    mark_color_code text NOT NULL,
    mark_color_name text NOT NULL,
    obsolete_flag boolean NOT NULL,
    obsolete_datetime timestamp(6) with time zone
);

CREATE TABLE mark_orientation_lut (
    mark_orientation_id uuid DEFAULT gen_random_uuid() NOT NULL,
    mark_orientation_code text NOT NULL,
    mark_orientation_description text NOT NULL,
    obsolete_flag boolean NOT NULL,
    obsolete_datetime timestamp(6) with time zone
);

CREATE TABLE mark_placement_lut (
    mark_placement_id uuid DEFAULT gen_random_uuid() NOT NULL,
    mark_placement_code text NOT NULL,
    mark_placement_description text NOT NULL,
    obsolete_flag boolean NOT NULL,
    obsolete_datetime timestamp(6) with time zone
);

CREATE TABLE mark_shape_lut (
    mark_shape_id uuid DEFAULT gen_random_uuid() NOT NULL,
    mark_shape_code text NOT NULL,
    mark_shape_description text NOT NULL,
    obsolete_flag boolean NOT NULL,
    obsolete_datetime timestamp(6) with time zone
);

CREATE TABLE mark_size_lut (
    mark_size_id uuid DEFAULT gen_random_uuid() NOT NULL,
    mark_size_code text NOT NULL,
    mark_size_description text NOT NULL,
    obsolete_flag boolean NOT NULL,
    obsolete_datetime timestamp(6) with time zone
);

CREATE TABLE mark_status_lut (
    mark_status_id uuid DEFAULT gen_random_uuid() NOT NULL,
    mark_status_description text NOT NULL,
    obsolete_flag boolean NOT NULL,
    obsolete_datetime timestamp(6) with time zone
);

CREATE TABLE mark_type_category_lut (
    mark_type_category_id uuid DEFAULT gen_random_uuid() NOT NULL,
    mark_type_category_name text NOT NULL,
    obsolete_flag boolean NOT NULL,
    obsolete_datetime timestamp(6) with time zone
);

CREATE TABLE mark_type_lut (
    mark_type_id uuid DEFAULT gen_random_uuid() NOT NULL,
    mark_type_category_id uuid NOT NULL,
    mark_type_code text NOT NULL,
    mark_type_description text NOT NULL,
    obsolete_flag boolean NOT NULL,
    obsolete_datetime timestamp(6) with time zone
);

CREATE TABLE maturity_lut (
    maturity_id uuid DEFAULT gen_random_uuid() NOT NULL,
    maturity_short_description text NOT NULL,
    maturity_description text NOT NULL,
    obsolete_flag boolean NOT NULL,
    obsolete_datetime timestamp(6) with time zone
);

CREATE TABLE media_location (
    media_location_id uuid DEFAULT gen_random_uuid() NOT NULL,
    location_id uuid NOT NULL,
    media_type_id uuid NOT NULL,
    media_url text NOT NULL,
    comment_text text,
    created_datetime timestamp(6) with time zone DEFAULT now() NOT NULL,
    created_by text NOT NULL,
    modified_datetime timestamp(6) with time zone,
    modified_by text
);

CREATE TABLE media_type_lut (
    media_type_id uuid DEFAULT gen_random_uuid() NOT NULL,
    media_type_code text NOT NULL,
    media_type_description text NOT NULL,
    obsolete_flag boolean NOT NULL,
    obsolete_datetime timestamp(6) with time zone
);

CREATE TABLE mobile_device (
    mobile_device_id uuid DEFAULT gen_random_uuid() NOT NULL,
    mobile_device_type_id uuid NOT NULL,
    mobile_equipment_identifier text NOT NULL,
    mobile_device_name text NOT NULL,
    mobile_device_description text NOT NULL,
    active_indicator boolean NOT NULL,
    inactive_datetime timestamp(6) with time zone,
    created_datetime timestamp(6) with time zone DEFAULT now() NOT NULL,
    created_by text NOT NULL,
    modified_datetime timestamp(6) with time zone,
    modified_by text
);

CREATE TABLE mobile_device_type_lut (
    mobile_device_type_id uuid DEFAULT gen_random_uuid() NOT NULL,
    mobile_device_type_description text NOT NULL,
    obsolete_flag boolean NOT NULL,
    obsolete_datetime timestamp(6) with time zone
);

CREATE TABLE mobile_survey_form (
    mobile_survey_form_id uuid DEFAULT gen_random_uuid() NOT NULL,
    survey_id uuid NOT NULL,
    parent_form_survey_id integer NOT NULL,
    parent_form_survey_guid uuid NOT NULL,
    parent_form_name text NOT NULL,
    parent_form_id text NOT NULL,
    created_datetime timestamp(6) with time zone DEFAULT now() NOT NULL,
    created_by text NOT NULL,
    modified_datetime timestamp(6) with time zone,
    modified_by text
);

CREATE TABLE mortality_type_lut (
    mortality_type_id uuid DEFAULT gen_random_uuid() NOT NULL,
    mortality_type_short_description text NOT NULL,
    mortality_type_description text NOT NULL,
    obsolete_flag boolean NOT NULL,
    obsolete_datetime timestamp(6) with time zone
);

CREATE TABLE observation_type_lut (
    observation_type_id uuid DEFAULT gen_random_uuid() NOT NULL,
    observation_type_name text NOT NULL,
    observation_type_description text NOT NULL,
    obsolete_flag boolean NOT NULL,
    obsolete_datetime timestamp(6) with time zone
);

CREATE TABLE origin_lut (
    origin_id uuid DEFAULT gen_random_uuid() NOT NULL,
    origin_description text NOT NULL,
    obsolete_flag boolean NOT NULL,
    obsolete_datetime timestamp(6) with time zone
);

CREATE TABLE other_observation (
    other_observation_id uuid DEFAULT gen_random_uuid() NOT NULL,
    survey_id uuid NOT NULL,
    observation_location_id uuid,
    observation_type_id uuid NOT NULL,
    observation_datetime timestamp(6) with time zone,
    observation_count integer,
    comment_text text,
    created_datetime timestamp(6) with time zone DEFAULT now() NOT NULL,
    created_by text NOT NULL,
    modified_datetime timestamp(6) with time zone,
    modified_by text
);

CREATE TABLE passage_feature_type_lut (
    passage_feature_type_id uuid DEFAULT gen_random_uuid() NOT NULL,
    feature_type_description text NOT NULL,
    obsolete_flag boolean NOT NULL,
    obsolete_datetime timestamp(6) with time zone
);

CREATE TABLE passage_measurement_type_lut (
    passage_measurement_type_id uuid DEFAULT gen_random_uuid() NOT NULL,
    measurement_type_description text NOT NULL,
    obsolete_flag boolean NOT NULL,
    obsolete_datetime timestamp(6) with time zone
);

CREATE TABLE redd_confidence (
    redd_confidence_id uuid DEFAULT gen_random_uuid() NOT NULL,
    redd_encounter_id uuid NOT NULL,
    redd_confidence_type_id uuid NOT NULL,
    redd_confidence_review_status_id uuid NOT NULL,
    comment_text text,
    created_datetime timestamp(6) with time zone DEFAULT now() NOT NULL,
    created_by text NOT NULL,
    modified_datetime timestamp(6) with time zone,
    modified_by text
);

CREATE TABLE redd_confidence_review_status_lut (
    redd_confidence_review_status_id uuid DEFAULT gen_random_uuid() NOT NULL,
    review_status_description text NOT NULL,
    obsolete_flag boolean NOT NULL,
    obsolete_datetime timestamp(6) with time zone
);

CREATE TABLE redd_confidence_type_lut (
    redd_confidence_type_id uuid DEFAULT gen_random_uuid() NOT NULL,
    confidence_type_short_description text NOT NULL,
    confidence_type_description text NOT NULL,
    obsolete_flag boolean NOT NULL,
    obsolete_datetime timestamp(6) with time zone
);

CREATE TABLE redd_dewatered_type_lut (
    redd_dewatered_type_id uuid DEFAULT gen_random_uuid() NOT NULL,
    dewatered_type_description text NOT NULL,
    obsolete_flag boolean NOT NULL,
    obsolete_datetime timestamp(6) with time zone
);

CREATE TABLE redd_encounter (
    redd_encounter_id uuid DEFAULT gen_random_uuid() NOT NULL,
    survey_event_id uuid NOT NULL,
    redd_location_id uuid,
    redd_status_id uuid NOT NULL,
    redd_encounter_datetime timestamp(6) with time zone,
    redd_count integer NOT NULL,
    comment_text text,
    created_datetime timestamp(6) with time zone DEFAULT now() NOT NULL,
    created_by text NOT NULL,
    modified_datetime timestamp(6) with time zone,
    modified_by text
);

CREATE TABLE redd_shape_lut (
    redd_shape_id uuid DEFAULT gen_random_uuid() NOT NULL,
    redd_shape_description text NOT NULL,
    obsolete_flag boolean NOT NULL,
    obsolete_datetime timestamp(6) with time zone
);

CREATE TABLE redd_status_lut (
    redd_status_id uuid DEFAULT gen_random_uuid() NOT NULL,
    redd_status_code text NOT NULL,
    redd_status_short_description text NOT NULL,
    redd_status_description text NOT NULL,
    obsolete_flag boolean NOT NULL,
    obsolete_datetime timestamp(6) with time zone
);

CREATE TABLE redd_substrate (
    redd_substrate_id uuid DEFAULT gen_random_uuid() NOT NULL,
    redd_encounter_id uuid NOT NULL,
    substrate_level_id uuid NOT NULL,
    substrate_type_id uuid NOT NULL,
    substrate_percent integer NOT NULL,
    created_datetime timestamp(6) with time zone DEFAULT now() NOT NULL,
    created_by text NOT NULL,
    modified_datetime timestamp(6) with time zone,
    modified_by text
);

CREATE TABLE redd_superimposition (
    redd_superimposition_id uuid DEFAULT gen_random_uuid() NOT NULL,
    individual_redd_id uuid NOT NULL,
    intersecting_redd_id uuid,
    intersecting_species_id uuid,
    superimposition_type_id uuid NOT NULL,
    percent_superimposed integer,
    created_datetime timestamp(6) with time zone DEFAULT now() NOT NULL,
    created_by text NOT NULL,
    modified_datetime timestamp(6) with time zone,
    modified_by text
);

CREATE TABLE run_lut (
    run_id uuid DEFAULT gen_random_uuid() NOT NULL,
    run_short_description text NOT NULL,
    run_description text NOT NULL,
    obsolete_flag boolean NOT NULL,
    obsolete_datetime timestamp(6) with time zone
);

CREATE TABLE sex_lut (
    sex_id uuid DEFAULT gen_random_uuid() NOT NULL,
    sex_description text NOT NULL,
    obsolete_flag boolean NOT NULL,
    obsolete_datetime timestamp(6) with time zone
);

CREATE TABLE spawn_condition_type_lut (
    spawn_condition_type_id uuid DEFAULT gen_random_uuid() NOT NULL,
    spawn_condition_short_description text NOT NULL,
    spawn_condition_description text NOT NULL,
    obsolete_flag boolean NOT NULL,
    obsolete_datetime timestamp(6) with time zone
);

CREATE TABLE species_lut (
    species_id uuid DEFAULT gen_random_uuid() NOT NULL,
    species_code text NOT NULL,
    common_name text NOT NULL,
    genus text,
    species text,
    sub_species text,
    obsolete_flag boolean NOT NULL,
    obsolete_datetime timestamp(6) with time zone
);

CREATE TABLE stock_lut (
    stock_id uuid DEFAULT gen_random_uuid() NOT NULL,
    waterbody_id uuid NOT NULL,
    species_id uuid NOT NULL,
    run_id uuid NOT NULL,
    sasi_stock_number text,
    stock_name text,
    status_code text,
    esa_code text,
    obsolete_flag boolean NOT NULL,
    obsolete_datetime timestamp(6) with time zone
);

CREATE TABLE stream_channel_type_lut (
    stream_channel_type_id uuid DEFAULT gen_random_uuid() NOT NULL,
    channel_type_description text NOT NULL,
    obsolete_flag boolean NOT NULL,
    obsolete_datetime timestamp(6) with time zone
);

CREATE TABLE stream_condition_lut (
    stream_condition_id uuid DEFAULT gen_random_uuid() NOT NULL,
    stream_condition text NOT NULL,
    obsolete_flag boolean NOT NULL,
    obsolete_datetime timestamp(6) with time zone
);

CREATE TABLE stream_flow_type_lut (
    stream_flow_type_id uuid DEFAULT gen_random_uuid() NOT NULL,
    flow_type_short_description text NOT NULL,
    flow_type_description text NOT NULL,
    obsolete_flag boolean NOT NULL,
    obsolete_datetime timestamp(6) with time zone
);

CREATE TABLE stream (
    stream_id uuid DEFAULT gen_random_uuid() NOT NULL,
    waterbody_id uuid NOT NULL,
    gid serial unique,
    geom geometry(multilinestring, 2927) NOT NULL,
    created_datetime timestamp(6) with time zone DEFAULT now() NOT NULL,
    created_by text NOT NULL,
    modified_datetime timestamp(6) with time zone,
    modified_by text
);

CREATE TABLE stream_section (
    stream_section_id uuid DEFAULT gen_random_uuid() NOT NULL,
    location_id uuid NOT NULL,
    gid serial unique,
    geom geometry(multilinestring, 2927) NOT NULL,
    created_datetime timestamp(6) with time zone DEFAULT now() NOT NULL,
    created_by text NOT NULL,
    modified_datetime timestamp(6) with time zone,
    modified_by text
);

CREATE TABLE substrate_level_lut (
    substrate_level_id uuid DEFAULT gen_random_uuid() NOT NULL,
    substrate_level_short_description text NOT NULL,
    substrate_level_description text NOT NULL,
    obsolete_flag boolean NOT NULL,
    obsolete_datetime timestamp(6) with time zone
);

CREATE TABLE substrate_type_lut (
    substrate_type_id uuid DEFAULT gen_random_uuid() NOT NULL,
    substrate_type_description text NOT NULL,
    obsolete_flag boolean NOT NULL,
    obsolete_datetime timestamp(6) with time zone
);

CREATE TABLE superimposition_type_lut (
    superimposition_type_id uuid DEFAULT gen_random_uuid() NOT NULL,
    superimposition_type_code text NOT NULL,
    superimposition_type_name text NOT NULL,
    superimposition_description text NOT NULL,
    obsolete_flag boolean not null,
    obsolete_datetime timestamp(6) with time zone
);

CREATE TABLE survey (
    survey_id uuid DEFAULT gen_random_uuid() NOT NULL,
    survey_datetime timestamp(6) with time zone NOT NULL,
    data_source_id uuid NOT NULL,
    data_source_unit_id uuid NOT NULL,
    survey_method_id uuid NOT NULL,
    data_review_status_id uuid NOT NULL,
    upper_end_point_id uuid NOT NULL,
    lower_end_point_id uuid NOT NULL,
    survey_completion_status_id uuid,
    incomplete_survey_type_id uuid NOT NULL,
    survey_start_datetime timestamp(6) with time zone,
    survey_end_datetime timestamp(6) with time zone,
    observer_last_name text,
    data_submitter_last_name text,
    created_datetime timestamp(6) with time zone DEFAULT now() NOT NULL,
    created_by text NOT NULL,
    modified_datetime timestamp(6) with time zone,
    modified_by text
);

CREATE TABLE survey_comment (
    survey_comment_id uuid DEFAULT gen_random_uuid() NOT NULL,
    survey_id uuid NOT NULL,
    area_surveyed_id uuid,
    fish_abundance_condition_id uuid,
    stream_condition_id uuid,
    stream_flow_type_id uuid,
    survey_count_condition_id uuid,
    survey_direction_id uuid,
    survey_timing_id uuid,
    visibility_condition_id uuid,
    visibility_type_id uuid,
    weather_type_id uuid,
    comment_text text,
    created_datetime timestamp(6) with time zone DEFAULT now() NOT NULL,
    created_by text NOT NULL,
    modified_datetime timestamp(6) with time zone,
    modified_by text
);

CREATE TABLE survey_completion_status_lut (
    survey_completion_status_id uuid DEFAULT gen_random_uuid() NOT NULL,
    completion_status_description text NOT NULL,
    obsolete_flag boolean NOT NULL,
    obsolete_datetime timestamp(6) with time zone
);

CREATE TABLE survey_count_condition_lut (
    survey_count_condition_id uuid DEFAULT gen_random_uuid() NOT NULL,
    survey_count_condition text NOT NULL,
    obsolete_flag boolean NOT NULL,
    obsolete_datetime timestamp(6) with time zone
);

CREATE TABLE survey_design_type_lut (
    survey_design_type_id uuid DEFAULT gen_random_uuid() NOT NULL,
    survey_design_type_code text NOT NULL,
    survey_design_type_description text NOT NULL,
    obsolete_flag boolean NOT NULL,
    obsolete_datetime timestamp(6) with time zone
);

CREATE TABLE survey_direction_lut (
    survey_direction_id uuid DEFAULT gen_random_uuid() NOT NULL,
    survey_direction_description text NOT NULL,
    obsolete_flag boolean NOT NULL,
    obsolete_datetime timestamp(6) with time zone
);

CREATE TABLE survey_event (
    survey_event_id uuid DEFAULT gen_random_uuid() NOT NULL,
    survey_id uuid NOT NULL,
    species_id uuid NOT NULL,
    survey_design_type_id uuid NOT NULL,
    cwt_detection_method_id uuid NOT NULL,
    run_id uuid NOT NULL,
    run_year integer NOT NULL,
    estimated_percent_fish_seen integer,
    comment_text text,
    created_datetime timestamp(6) with time zone DEFAULT now() NOT NULL,
    created_by text NOT NULL,
    modified_datetime timestamp(6) with time zone,
    modified_by text
);

CREATE TABLE survey_intent (
    survey_intent_id uuid DEFAULT gen_random_uuid() NOT NULL,
    survey_id uuid NOT NULL,
    species_id uuid NOT NULL,
    count_type_id uuid NOT NULL,
    created_datetime timestamp(6) with time zone DEFAULT now() NOT NULL,
    created_by text NOT NULL,
    modified_datetime timestamp(6) with time zone,
    modified_by text
);

CREATE TABLE survey_method_lut (
    survey_method_id uuid DEFAULT gen_random_uuid() NOT NULL,
    survey_method_code text NOT NULL,
    survey_method_description text NOT NULL,
    obsolete_flag boolean NOT NULL,
    obsolete_datetime timestamp(6) with time zone
);

CREATE TABLE survey_mobile_device (
    survey_mobile_device_id uuid DEFAULT gen_random_uuid() NOT NULL,
    survey_id uuid NOT NULL,
    mobile_device_id uuid NOT NULL
);

CREATE TABLE survey_timing_lut (
    survey_timing_id uuid DEFAULT gen_random_uuid() NOT NULL,
    survey_timing text NOT NULL,
    obsolete_flag boolean NOT NULL,
    obsolete_datetime timestamp(6) with time zone
);

CREATE TABLE visibility_condition_lut (
    visibility_condition_id uuid DEFAULT gen_random_uuid() NOT NULL,
    visibility_condition text NOT NULL,
    obsolete_flag boolean NOT NULL,
    obsolete_datetime timestamp(6) with time zone
);

CREATE TABLE visibility_type_lut (
    visibility_type_id uuid DEFAULT gen_random_uuid() NOT NULL,
    visibility_type_short_description text NOT NULL,
    visibility_type_description text NOT NULL,
    obsolete_flag boolean NOT NULL,
    obsolete_datetime timestamp(6) with time zone
);

CREATE TABLE waterbody_lut (
    waterbody_id uuid DEFAULT gen_random_uuid() NOT NULL,
    waterbody_name text NOT NULL,
    waterbody_display_name text,
    latitude_longitude_id character varying(13),
    stream_catalog_code text,
    tributary_to_name text,
    obsolete_flag boolean NOT NULL DEFAULT false,
    obsolete_datetime timestamp(6) with time zone
);

CREATE TABLE waterbody_measurement (
    waterbody_measurement_id uuid DEFAULT gen_random_uuid() NOT NULL,
    survey_id uuid NOT NULL,
    water_clarity_type_id uuid,
    water_clarity_meter numeric(4,2),
    stream_flow_measurement_cfs integer,
    start_water_temperature_datetime timestamp(6) with time zone,
    start_water_temperature_celsius numeric(4,1),
    end_water_temperature_datetime timestamp(6) with time zone,
    end_water_temperature_celsius numeric(4,1),
    waterbody_ph numeric(2,1),
    created_datetime timestamp(6) with time zone DEFAULT now() NOT NULL,
    created_by text NOT NULL,
    modified_datetime timestamp(6) with time zone,
    modified_by text
);

CREATE TABLE water_clarity_type_lut (
    water_clarity_type_id uuid DEFAULT gen_random_uuid() NOT NULL,
    clarity_type_short_description text NOT NULL,
    clarity_type_description text NOT NULL,
    obsolete_flag boolean NOT NULL,
    obsolete_datetime timestamp(6) with time zone
);

CREATE TABLE weather_type_lut (
    weather_type_id uuid DEFAULT gen_random_uuid() NOT NULL,
    weather_type_description text NOT NULL,
    obsolete_flag boolean NOT NULL,
    obsolete_datetime timestamp(6) with time zone
);

CREATE TABLE wria_lut (
    wria_id uuid DEFAULT gen_random_uuid() NOT NULL,
    wria_code character varying(2) NOT NULL,
    wria_description text NOT NULL,
    gid serial unique,
    geom geometry(polygon, 2927) NOT NULL,
    obsolete_flag boolean NOT NULL,
    obsolete_datetime timestamp(6) with time zone
);

-- Set primary keys ------------------------------------------------------

ALTER TABLE ONLY adipose_clip_status_lut
    ADD CONSTRAINT pk_adipose_clip_status_lut PRIMARY KEY (adipose_clip_status_id);

ALTER TABLE ONLY age_code_lut
    ADD CONSTRAINT pk_age_code_lut PRIMARY KEY (age_code_id);

ALTER TABLE ONLY area_surveyed_lut
    ADD CONSTRAINT pk_area_surveyed_lut PRIMARY KEY (area_surveyed_id);

ALTER TABLE ONLY coordinate_capture_method_lut
    ADD CONSTRAINT pk_coordinate_capture_method_lut PRIMARY KEY (coordinate_capture_method_id);

ALTER TABLE ONLY count_type_lut
    ADD CONSTRAINT pk_count_type_lut PRIMARY KEY (count_type_id);

ALTER TABLE ONLY cwt_detection_method_lut
    ADD CONSTRAINT pk_cwt_detection_method_lut PRIMARY KEY (cwt_detection_method_id);

ALTER TABLE ONLY cwt_detection_status_lut
    ADD CONSTRAINT pk_cwt_detection_status_lut PRIMARY KEY (cwt_detection_status_id);

ALTER TABLE ONLY cwt_result_type_lut
    ADD CONSTRAINT pk_cwt_result_type_lut PRIMARY KEY (cwt_result_type_id);

ALTER TABLE ONLY data_review_status_lut
    ADD CONSTRAINT pk_data_review_status_lut PRIMARY KEY (data_review_status_id);

ALTER TABLE ONLY data_source_lut
    ADD CONSTRAINT pk_data_source_lut PRIMARY KEY (data_source_id);

ALTER TABLE ONLY data_source_unit_lut
    ADD CONSTRAINT pk_data_source_unit_lut PRIMARY KEY (data_source_unit_id);

ALTER TABLE ONLY disposition_lut
    ADD CONSTRAINT pk_disposition_lut PRIMARY KEY (disposition_id);

ALTER TABLE ONLY disposition_type_lut
    ADD CONSTRAINT pk_disposition_type_lut PRIMARY KEY (disposition_type_id);

ALTER TABLE ONLY fish_abundance_condition_lut
    ADD CONSTRAINT pk_fish_abundance_condition_lut PRIMARY KEY (fish_abundance_condition_id);

ALTER TABLE ONLY fish_biologist_district
    ADD CONSTRAINT pk_fish_biologist_district_id PRIMARY KEY (fish_biologist_district_id);

ALTER TABLE ONLY fish_capture
    ADD CONSTRAINT pk_fish_capture PRIMARY KEY (fish_capture_id);

ALTER TABLE ONLY fish_behavior_type_lut
    ADD CONSTRAINT pk_fish_behavior_type_lut PRIMARY KEY (fish_behavior_type_id);

ALTER TABLE ONLY fish_capture_event
    ADD CONSTRAINT pk_fish_capture_event PRIMARY KEY (fish_capture_event_id);

ALTER TABLE ONLY fish_capture_status_lut
    ADD CONSTRAINT pk_fish_capture_status_lut PRIMARY KEY (fish_capture_status_id);

ALTER TABLE ONLY fish_condition_type_lut
    ADD CONSTRAINT pk_fish_condition_type_lut PRIMARY KEY (fish_condition_type_id);

ALTER TABLE ONLY fish_encounter
    ADD CONSTRAINT pk_fish_encounter PRIMARY KEY (fish_encounter_id);

ALTER TABLE ONLY fish_length_measurement
    ADD CONSTRAINT pk_fish_length_measurement PRIMARY KEY (fish_length_measurement_id);

ALTER TABLE ONLY fish_length_measurement_type_lut
    ADD CONSTRAINT pk_fish_length_measurement_type_lut PRIMARY KEY (fish_length_measurement_type_id);

ALTER TABLE ONLY fish_mark
    ADD CONSTRAINT pk_fish_mark PRIMARY KEY (fish_mark_id);

ALTER TABLE ONLY fish_passage_feature
    ADD CONSTRAINT pk_fish_passage_feature PRIMARY KEY (fish_passage_feature_id);

ALTER TABLE ONLY fish_presence_type_lut
    ADD CONSTRAINT pk_fish_presence_type_lut PRIMARY KEY (fish_presence_type_id);

ALTER TABLE ONLY fish_species_presence
    ADD CONSTRAINT pk_fish_species_presence PRIMARY KEY (fish_species_presence_id);

ALTER TABLE ONLY fish_status_lut
    ADD CONSTRAINT pk_fish_status_lut PRIMARY KEY (fish_status_id);

ALTER TABLE ONLY fish_trauma_type_lut
    ADD CONSTRAINT pk_fish_trauma_type_lut PRIMARY KEY (fish_trauma_type_id);

ALTER TABLE ONLY gear_performance_type_lut
    ADD CONSTRAINT pk_gear_performance_type_lut PRIMARY KEY (gear_performance_type_id);

ALTER TABLE ONLY gill_condition_type_lut
    ADD CONSTRAINT pk_gill_condition_type_lut PRIMARY KEY (gill_condition_type_id);

ALTER TABLE ONLY hydrologic_unit
    ADD CONSTRAINT pk_hydrologic_unit PRIMARY KEY (hydrologic_unit_id);

ALTER TABLE ONLY incomplete_survey_type_lut
    ADD CONSTRAINT pk_incomplete_survey_type_lut PRIMARY KEY (incomplete_survey_type_id);

ALTER TABLE ONLY individual_fish
    ADD CONSTRAINT pk_individual_fish PRIMARY KEY (individual_fish_id);

ALTER TABLE ONLY individual_redd
    ADD CONSTRAINT pk_individual_redd PRIMARY KEY (individual_redd_id);

ALTER TABLE ONLY lake
    ADD CONSTRAINT pk_lake PRIMARY KEY (lake_id);

ALTER TABLE ONLY location
    ADD CONSTRAINT pk_location PRIMARY KEY (location_id);

ALTER TABLE ONLY location_coordinates
    ADD CONSTRAINT pk_location_coordinates PRIMARY KEY (location_coordinates_id);

ALTER TABLE ONLY location_error_correction_type_lut
    ADD CONSTRAINT pk_location_error_correction_type_lut PRIMARY KEY (location_error_correction_type_id);

ALTER TABLE ONLY location_error_type_lut
    ADD CONSTRAINT pk_location_error_type_lut PRIMARY KEY (location_error_type_id);

ALTER TABLE ONLY location_orientation_type_lut
    ADD CONSTRAINT pk_location_orientation_type_lut PRIMARY KEY (location_orientation_type_id);

ALTER TABLE ONLY location_source
    ADD CONSTRAINT pk_location_source PRIMARY KEY (location_source_id);

ALTER TABLE ONLY location_type_lut
    ADD CONSTRAINT pk_location_type_lut PRIMARY KEY (location_type_id);

ALTER TABLE ONLY mark_color_lut
    ADD CONSTRAINT pk_mark_color_lut PRIMARY KEY (mark_color_id);

ALTER TABLE ONLY mark_orientation_lut
    ADD CONSTRAINT pk_mark_orientation_lut PRIMARY KEY (mark_orientation_id);

ALTER TABLE ONLY mark_placement_lut
    ADD CONSTRAINT pk_mark_placement_lut PRIMARY KEY (mark_placement_id);

ALTER TABLE ONLY mark_shape_lut
    ADD CONSTRAINT pk_mark_shape_lut PRIMARY KEY (mark_shape_id);

ALTER TABLE ONLY mark_size_lut
    ADD CONSTRAINT pk_mark_size_lut PRIMARY KEY (mark_size_id);

ALTER TABLE ONLY mark_status_lut
    ADD CONSTRAINT pk_mark_status_lut PRIMARY KEY (mark_status_id);

ALTER TABLE ONLY mark_type_category_lut
    ADD CONSTRAINT pk_mark_type_category_lut PRIMARY KEY (mark_type_category_id);

ALTER TABLE ONLY mark_type_lut
    ADD CONSTRAINT pk_mark_type_lut PRIMARY KEY (mark_type_id);

ALTER TABLE ONLY maturity_lut
    ADD CONSTRAINT pk_maturity_lut PRIMARY KEY (maturity_id);

ALTER TABLE ONLY media_location
    ADD CONSTRAINT pk_media_location PRIMARY KEY (media_location_id);

ALTER TABLE ONLY media_type_lut
    ADD CONSTRAINT pk_media_type_lut PRIMARY KEY (media_type_id);

ALTER TABLE ONLY mobile_device
    ADD CONSTRAINT pk_mobile_device PRIMARY KEY (mobile_device_id);

ALTER TABLE ONLY mobile_device_type_lut
    ADD CONSTRAINT pk_mobile_device_type_lut PRIMARY KEY (mobile_device_type_id);

ALTER TABLE ONLY mobile_survey_form
    ADD CONSTRAINT pk_mobile_survey_form PRIMARY KEY (mobile_survey_form_id);

ALTER TABLE ONLY mortality_type_lut
    ADD CONSTRAINT pk_mortality_type_lut PRIMARY KEY (mortality_type_id);

ALTER TABLE ONLY origin_lut
    ADD CONSTRAINT pk_origin_lut PRIMARY KEY (origin_id);

ALTER TABLE ONLY passage_feature_type_lut
    ADD CONSTRAINT pk_passage_feature_type_lut PRIMARY KEY (passage_feature_type_id);

ALTER TABLE ONLY passage_measurement_type_lut
    ADD CONSTRAINT pk_passage_measurement_type_lut PRIMARY KEY (passage_measurement_type_id);

ALTER TABLE ONLY redd_confidence
    ADD CONSTRAINT pk_redd_confidence PRIMARY KEY (redd_confidence_id);

ALTER TABLE ONLY redd_confidence_review_status_lut
    ADD CONSTRAINT pk_redd_confidence_review_status_lut PRIMARY KEY (redd_confidence_review_status_id);

ALTER TABLE ONLY redd_confidence_type_lut
    ADD CONSTRAINT pk_redd_confidence_type_lut PRIMARY KEY (redd_confidence_type_id);

ALTER TABLE ONLY redd_dewatered_type_lut
    ADD CONSTRAINT pk_redd_dewatered_type_lut PRIMARY KEY (redd_dewatered_type_id);

ALTER TABLE ONLY redd_encounter
    ADD CONSTRAINT pk_redd_encounter PRIMARY KEY (redd_encounter_id);

ALTER TABLE ONLY redd_shape_lut
    ADD CONSTRAINT pk_redd_shape_lut PRIMARY KEY (redd_shape_id);

ALTER TABLE ONLY redd_status_lut
    ADD CONSTRAINT pk_redd_status_lut PRIMARY KEY (redd_status_id);

ALTER TABLE ONLY redd_substrate
    ADD CONSTRAINT pk_redd_substrate PRIMARY KEY (redd_substrate_id);

ALTER TABLE ONLY redd_superimposition
    ADD CONSTRAINT pk_redd_superimposition PRIMARY KEY (redd_superimposition_id);

ALTER TABLE ONLY run_lut
    ADD CONSTRAINT pk_run_lut PRIMARY KEY (run_id);

ALTER TABLE ONLY sex_lut
    ADD CONSTRAINT pk_sex_lut PRIMARY KEY (sex_id);

ALTER TABLE ONLY spawn_condition_type_lut
    ADD CONSTRAINT pk_spawn_condition_type_lut PRIMARY KEY (spawn_condition_type_id);

ALTER TABLE ONLY species_lut
    ADD CONSTRAINT pk_species_lut PRIMARY KEY (species_id);

ALTER TABLE ONLY stock_lut
    ADD CONSTRAINT pk_stock_lut PRIMARY KEY (stock_id);

ALTER TABLE ONLY stream_channel_type_lut
    ADD CONSTRAINT pk_stream_channel_type_lut PRIMARY KEY (stream_channel_type_id);

ALTER TABLE ONLY stream_condition_lut
    ADD CONSTRAINT pk_stream_condition_lut PRIMARY KEY (stream_condition_id);

ALTER TABLE ONLY stream_flow_type_lut
    ADD CONSTRAINT pk_stream_flow_type_lut PRIMARY KEY (stream_flow_type_id);

ALTER TABLE ONLY stream
    ADD CONSTRAINT pk_stream PRIMARY KEY (stream_id);

ALTER TABLE ONLY stream_section
    ADD CONSTRAINT pk_stream_section PRIMARY KEY (stream_section_id);

ALTER TABLE ONLY substrate_level_lut
    ADD CONSTRAINT pk_substrate_level_lut PRIMARY KEY (substrate_level_id);

ALTER TABLE ONLY substrate_type_lut
    ADD CONSTRAINT pk_substrate_type_lut PRIMARY KEY (substrate_type_id);

ALTER TABLE ONLY superimposition_type_lut
    ADD CONSTRAINT pk_superimposition_type_lut PRIMARY KEY (superimposition_type_id);

ALTER TABLE ONLY survey
    ADD CONSTRAINT pk_survey PRIMARY KEY (survey_id);

ALTER TABLE ONLY survey_comment
    ADD CONSTRAINT pk_survey_comment PRIMARY KEY (survey_comment_id);

ALTER TABLE ONLY survey_completion_status_lut
    ADD CONSTRAINT pk_survey_completion_status_lut PRIMARY KEY (survey_completion_status_id);

ALTER TABLE ONLY survey_count_condition_lut
    ADD CONSTRAINT pk_survey_count_condition_lut PRIMARY KEY (survey_count_condition_id);

ALTER TABLE ONLY survey_design_type_lut
    ADD CONSTRAINT pk_survey_design_type_lut PRIMARY KEY (survey_design_type_id);

ALTER TABLE ONLY survey_direction_lut
    ADD CONSTRAINT pk_survey_direction_lut PRIMARY KEY (survey_direction_id);

ALTER TABLE ONLY survey_event
    ADD CONSTRAINT pk_survey_event PRIMARY KEY (survey_event_id);

ALTER TABLE ONLY survey_intent
    ADD CONSTRAINT pk_survey_intent PRIMARY KEY (survey_intent_id);

ALTER TABLE ONLY survey_method_lut
    ADD CONSTRAINT pk_survey_method_lut PRIMARY KEY (survey_method_id);

ALTER TABLE ONLY survey_mobile_device
    ADD CONSTRAINT pk_survey_mobile_device PRIMARY KEY (survey_mobile_device_id);

ALTER TABLE ONLY survey_timing_lut
    ADD CONSTRAINT pk_survey_timing_lut PRIMARY KEY (survey_timing_id);

ALTER TABLE ONLY visibility_type_lut
    ADD CONSTRAINT pk_visibility_type_lut PRIMARY KEY (visibility_type_id);

ALTER TABLE ONLY visibility_condition_lut
    ADD CONSTRAINT pk_visibility_condition_lut PRIMARY KEY (visibility_condition_id);

ALTER TABLE ONLY waterbody_lut
    ADD CONSTRAINT pk_waterbody_lut PRIMARY KEY (waterbody_id);

ALTER TABLE ONLY waterbody_measurement
    ADD CONSTRAINT pk_waterbody_measurement PRIMARY KEY (waterbody_measurement_id);

ALTER TABLE ONLY water_clarity_type_lut
    ADD CONSTRAINT pk_water_clarity_type_lut PRIMARY KEY (water_clarity_type_id);

ALTER TABLE ONLY weather_type_lut
    ADD CONSTRAINT pk_weather_type_lut PRIMARY KEY (weather_type_id);

ALTER TABLE ONLY other_observation
    ADD CONSTRAINT pk_other_observation PRIMARY KEY (other_observation_id);

ALTER TABLE ONLY observation_type_lut
    ADD CONSTRAINT pk_observation_type_lut PRIMARY KEY (observation_type_id);

ALTER TABLE ONLY wria_lut
    ADD CONSTRAINT pk_wria_lut PRIMARY KEY (wria_id);

-- Set foreign keys ------------------------------------------------------

ALTER TABLE ONLY fish_passage_feature
    ADD CONSTRAINT fk_survey__fish_passage_feature FOREIGN KEY (survey_id) REFERENCES survey(survey_id);

ALTER TABLE ONLY fish_passage_feature
    ADD CONSTRAINT fk_location__fish_passage_feature FOREIGN KEY (feature_location_id) REFERENCES location(location_id);

ALTER TABLE ONLY fish_passage_feature
    ADD CONSTRAINT fk_passage_measurement_type_lut__height_type_id FOREIGN KEY (feature_height_type_id) REFERENCES passage_measurement_type_lut(passage_measurement_type_id);

ALTER TABLE ONLY fish_passage_feature
    ADD CONSTRAINT fk_passage_measurement_type_lut__depth_type_id FOREIGN KEY (plunge_pool_depth_type_id) REFERENCES passage_measurement_type_lut(passage_measurement_type_id);

ALTER TABLE ONLY fish_passage_feature
    ADD CONSTRAINT fk_passage_feature_type_lut__fish_passage_feature FOREIGN KEY (passage_feature_type_id) REFERENCES passage_feature_type_lut(passage_feature_type_id);

-------------------------
ALTER TABLE ONLY fish_capture
    ADD CONSTRAINT fk_survey__fish_capture FOREIGN KEY (survey_id) REFERENCES survey(survey_id);

ALTER TABLE ONLY fish_capture
    ADD CONSTRAINT fk_gear_performance_type_lut__fish_capture FOREIGN KEY (gear_performance_type_id) REFERENCES gear_performance_type_lut(gear_performance_type_id);

-------------------------
ALTER TABLE ONLY fish_capture_event
    ADD CONSTRAINT fk_fish_encounter__fish_capture_event FOREIGN KEY (fish_encounter_id) REFERENCES fish_encounter(fish_encounter_id);

ALTER TABLE ONLY fish_capture_event
    ADD CONSTRAINT fk_fish_capture_status_lut__fish_capture_event FOREIGN KEY (fish_capture_status_id) REFERENCES fish_capture_status_lut(fish_capture_status_id);

ALTER TABLE ONLY fish_capture_event
    ADD CONSTRAINT fk_disposition_type_lut__fish_capture_event FOREIGN KEY (disposition_type_id) REFERENCES disposition_type_lut(disposition_type_id);

ALTER TABLE ONLY fish_capture_event
    ADD CONSTRAINT fk_disposition_lut__fish_capture_event FOREIGN KEY (disposition_id) REFERENCES disposition_lut(disposition_id);

ALTER TABLE ONLY fish_capture_event
    ADD CONSTRAINT fk_location__fish_capture_event FOREIGN KEY (disposition_location_id) REFERENCES location(location_id);

-------------------------
ALTER TABLE ONLY fish_encounter
    ADD CONSTRAINT fk_survey_event__fish_encounter FOREIGN KEY (survey_event_id) REFERENCES survey_event(survey_event_id);

ALTER TABLE ONLY fish_encounter
    ADD CONSTRAINT fk_location__fish_encounter FOREIGN KEY (fish_location_id) REFERENCES location(location_id);

ALTER TABLE ONLY fish_encounter
    ADD CONSTRAINT fk_fish_status_lut__fish_encounter FOREIGN KEY (fish_status_id) REFERENCES fish_status_lut(fish_status_id);

ALTER TABLE ONLY fish_encounter
    ADD CONSTRAINT fk_sex_lut__fish_encounter FOREIGN KEY (sex_id) REFERENCES sex_lut(sex_id);

ALTER TABLE ONLY fish_encounter
    ADD CONSTRAINT fk_maturity_lut__fish_encounter FOREIGN KEY (maturity_id) REFERENCES maturity_lut(maturity_id);

ALTER TABLE ONLY fish_encounter
    ADD CONSTRAINT fk_origin_lut__fish_encounter FOREIGN KEY (origin_id) REFERENCES origin_lut(origin_id);

ALTER TABLE ONLY fish_encounter
    ADD CONSTRAINT fk_cwt_detection_status_lut__fish_encounter FOREIGN KEY (cwt_detection_status_id) REFERENCES cwt_detection_status_lut(cwt_detection_status_id);

ALTER TABLE ONLY fish_encounter
    ADD CONSTRAINT fk_adipose_clip_status_lut__fish_encounter FOREIGN KEY (adipose_clip_status_id) REFERENCES adipose_clip_status_lut(adipose_clip_status_id);

ALTER TABLE ONLY fish_encounter
    ADD CONSTRAINT fk_fish_behavior_type_lut__fish_encounter FOREIGN KEY (fish_behavior_type_id) REFERENCES fish_behavior_type_lut(fish_behavior_type_id);

ALTER TABLE ONLY fish_encounter
    ADD CONSTRAINT fk_mortality_type_lut__fish_encounter FOREIGN KEY (mortality_type_id) REFERENCES mortality_type_lut(mortality_type_id);

-------------------------
ALTER TABLE ONLY fish_length_measurement
    ADD CONSTRAINT fk_individual_fish__fish_length_measurement FOREIGN KEY (individual_fish_id) REFERENCES individual_fish(individual_fish_id);

ALTER TABLE ONLY fish_length_measurement
    ADD CONSTRAINT fk_fish_length_measurement_type_lut__fish_length_measurement FOREIGN KEY (fish_length_measurement_type_id) REFERENCES fish_length_measurement_type_lut(fish_length_measurement_type_id);

-------------------------
ALTER TABLE ONLY fish_mark
    ADD CONSTRAINT fk_fish_encounter__fish_mark FOREIGN KEY (fish_encounter_id) REFERENCES fish_encounter(fish_encounter_id);

ALTER TABLE ONLY fish_mark
    ADD CONSTRAINT fk_mark_type_lut__fish_mark FOREIGN KEY (mark_type_id) REFERENCES mark_type_lut(mark_type_id);

ALTER TABLE ONLY fish_mark
    ADD CONSTRAINT fk_mark_status_lut__fish_mark FOREIGN KEY (mark_status_id) REFERENCES mark_status_lut(mark_status_id);

ALTER TABLE ONLY fish_mark
    ADD CONSTRAINT fk_mark_orientation_lut__fish_mark FOREIGN KEY (mark_orientation_id) REFERENCES mark_orientation_lut(mark_orientation_id);

ALTER TABLE ONLY fish_mark
    ADD CONSTRAINT fk_mark_placement_lut__fish_mark FOREIGN KEY (mark_placement_id) REFERENCES mark_placement_lut(mark_placement_id);

ALTER TABLE ONLY fish_mark
    ADD CONSTRAINT fk_mark_size_lut__fish_mark FOREIGN KEY (mark_size_id) REFERENCES mark_size_lut(mark_size_id);

ALTER TABLE ONLY fish_mark
    ADD CONSTRAINT fk_mark_color_lut__fish_mark FOREIGN KEY (mark_color_id) REFERENCES mark_color_lut(mark_color_id);

ALTER TABLE ONLY fish_mark
    ADD CONSTRAINT fk_mark_shape_lut__fish_mark FOREIGN KEY (mark_shape_id) REFERENCES mark_shape_lut(mark_shape_id);

-------------------------
ALTER TABLE ONLY fish_species_presence
    ADD CONSTRAINT fk_survey__fish_species_presence FOREIGN KEY (survey_id) REFERENCES survey(survey_id);

ALTER TABLE ONLY fish_species_presence
    ADD CONSTRAINT fk_species_lut__fish_species_presence FOREIGN KEY (species_id) REFERENCES species_lut(species_id);

ALTER TABLE ONLY fish_species_presence
    ADD CONSTRAINT fk_fish_presence_type_lut__fish_species_presence FOREIGN KEY (fish_presence_type_id) REFERENCES fish_presence_type_lut(fish_presence_type_id);

    -------------------------
ALTER TABLE ONLY individual_fish
    ADD CONSTRAINT fk_fish_encounter__individual_fish FOREIGN KEY (fish_encounter_id) REFERENCES fish_encounter(fish_encounter_id);

ALTER TABLE ONLY individual_fish
    ADD CONSTRAINT fk_fish_condition_type_lut__individual_fish FOREIGN KEY (fish_condition_type_id) REFERENCES fish_condition_type_lut(fish_condition_type_id);

ALTER TABLE ONLY individual_fish
    ADD CONSTRAINT fk_fish_trauma_type_lut__individual_fish FOREIGN KEY (fish_trauma_type_id) REFERENCES fish_trauma_type_lut(fish_trauma_type_id);

ALTER TABLE ONLY individual_fish
    ADD CONSTRAINT fk_gill_condition_type_lut__individual_fish FOREIGN KEY (gill_condition_type_id) REFERENCES gill_condition_type_lut(gill_condition_type_id);

ALTER TABLE ONLY individual_fish
    ADD CONSTRAINT fk_spawn_condition_type_lut__individual_fish FOREIGN KEY (spawn_condition_type_id) REFERENCES spawn_condition_type_lut(spawn_condition_type_id);

ALTER TABLE ONLY individual_fish
    ADD CONSTRAINT fk_cwt_result_type_lut__individual_fish FOREIGN KEY (cwt_result_type_id) REFERENCES cwt_result_type_lut(cwt_result_type_id);

ALTER TABLE ONLY individual_fish
    ADD CONSTRAINT fk_age_code_lut__individual_fish FOREIGN KEY (age_code_id) REFERENCES age_code_lut(age_code_id);

-------------------------
ALTER TABLE ONLY individual_redd
    ADD CONSTRAINT fk_redd_encounter__individual_redd FOREIGN KEY (redd_encounter_id) REFERENCES redd_encounter(redd_encounter_id);

ALTER TABLE ONLY individual_redd
    ADD CONSTRAINT fk_redd_shape_lut__individual_redd FOREIGN KEY (redd_shape_id) REFERENCES redd_shape_lut(redd_shape_id);

ALTER TABLE ONLY individual_redd
    ADD CONSTRAINT fk_redd_dewatered_type_lut__individual_redd FOREIGN KEY (redd_dewatered_type_id) REFERENCES redd_dewatered_type_lut(redd_dewatered_type_id);

-------------------------
ALTER TABLE ONLY lake
    ADD CONSTRAINT fk_waterbody_lut__lake FOREIGN KEY (waterbody_id) REFERENCES waterbody_lut(waterbody_id);

-------------------------
ALTER TABLE ONLY location_coordinates
    ADD CONSTRAINT fk_location__location_coordinates FOREIGN KEY (location_id) REFERENCES location(location_id);

-------------------------
ALTER TABLE ONLY location_source
    ADD CONSTRAINT fk_location_coordinates__location_source FOREIGN KEY (location_coordinates_id) REFERENCES location_coordinates(location_coordinates_id);

ALTER TABLE ONLY location_source
    ADD CONSTRAINT fk_coordinate_capture_method_lut__location_source FOREIGN KEY (coordinate_capture_method_id) REFERENCES coordinate_capture_method_lut(coordinate_capture_method_id);

ALTER TABLE ONLY location_source
    ADD CONSTRAINT fk_location_error_type_lut__location_source FOREIGN KEY (location_error_type_id) REFERENCES location_error_type_lut(location_error_type_id);

ALTER TABLE ONLY location_source
    ADD CONSTRAINT fk_location_error_correction_type_lut__location_source FOREIGN KEY (location_error_correction_type_id) REFERENCES location_error_correction_type_lut(location_error_correction_type_id);

------------------------
ALTER TABLE ONLY mark_type_lut
    ADD CONSTRAINT fk_mark_type_category_lut__mark_type_lut FOREIGN KEY (mark_type_category_id) REFERENCES mark_type_category_lut(mark_type_category_id);

------------------------
ALTER TABLE ONLY media_location
    ADD CONSTRAINT fk_location__media_location FOREIGN KEY (location_id) REFERENCES location(location_id);

ALTER TABLE ONLY media_location
    ADD CONSTRAINT fk_media_type_lut__media_location FOREIGN KEY (media_type_id) REFERENCES media_type_lut(media_type_id);

-------------------------
ALTER TABLE ONLY mobile_device
    ADD CONSTRAINT fk_mobile_device_type_lut__mobile_device FOREIGN KEY (mobile_device_type_id) REFERENCES mobile_device_type_lut(mobile_device_type_id);

-------------------------
ALTER TABLE ONLY mobile_survey_form
    ADD CONSTRAINT fk_survey__mobile_survey_form FOREIGN KEY (survey_id) REFERENCES survey(survey_id);

-------------------------
ALTER TABLE ONLY location
    ADD CONSTRAINT fk_waterbody_lut__location FOREIGN KEY (waterbody_id) REFERENCES waterbody_lut(waterbody_id);

ALTER TABLE ONLY location
    ADD CONSTRAINT fk_wria_lut__location FOREIGN KEY (wria_id) REFERENCES wria_lut(wria_id);

ALTER TABLE ONLY location
    ADD CONSTRAINT fk_location_type_lut__location FOREIGN KEY (location_type_id) REFERENCES location_type_lut(location_type_id);

ALTER TABLE ONLY location
    ADD CONSTRAINT fk_stream_channel_type_lut__location FOREIGN KEY (stream_channel_type_id) REFERENCES stream_channel_type_lut(stream_channel_type_id);

ALTER TABLE ONLY location
    ADD CONSTRAINT fk_location_orientation_type_lut__location FOREIGN KEY (location_orientation_type_id) REFERENCES location_orientation_type_lut(location_orientation_type_id);

-------------------------
ALTER TABLE ONLY other_observation
    ADD CONSTRAINT fk_survey__other_observation FOREIGN KEY (survey_id) REFERENCES survey(survey_id);

ALTER TABLE ONLY other_observation
    ADD CONSTRAINT fk_location__other_observation FOREIGN KEY (observation_location_id) REFERENCES location(location_id);

ALTER TABLE ONLY other_observation
    ADD CONSTRAINT fk_observation_type_lut__other_observation FOREIGN KEY (observation_type_id) REFERENCES observation_type_lut(observation_type_id);

-------------------------
ALTER TABLE ONLY redd_confidence
    ADD CONSTRAINT fk_redd_encounter__redd_confidence FOREIGN KEY (redd_encounter_id) REFERENCES redd_encounter(redd_encounter_id);

ALTER TABLE ONLY redd_confidence
    ADD CONSTRAINT fk_redd_confidence_type_lut__redd_confidence FOREIGN KEY (redd_confidence_type_id) REFERENCES redd_confidence_type_lut(redd_confidence_type_id);

ALTER TABLE ONLY redd_confidence
    ADD CONSTRAINT fk_redd_confidence_review_status_lut__redd_confidence FOREIGN KEY (redd_confidence_review_status_id) REFERENCES redd_confidence_review_status_lut(redd_confidence_review_status_id);

-------------------------
ALTER TABLE ONLY redd_encounter
    ADD CONSTRAINT fk_survey_event__redd_encounter FOREIGN KEY (survey_event_id) REFERENCES survey_event(survey_event_id);

ALTER TABLE ONLY redd_encounter
    ADD CONSTRAINT fk_location__redd_encounter FOREIGN KEY (redd_location_id) REFERENCES location(location_id);

ALTER TABLE ONLY redd_encounter
    ADD CONSTRAINT fk_redd_status_lut__redd_encounter FOREIGN KEY (redd_status_id) REFERENCES redd_status_lut(redd_status_id);

-------------------------
ALTER TABLE ONLY redd_substrate
    ADD CONSTRAINT fk_redd_encounter__redd_substrate FOREIGN KEY (redd_encounter_id) REFERENCES redd_encounter(redd_encounter_id);

ALTER TABLE ONLY redd_substrate
    ADD CONSTRAINT fk_substrate_level_lut__redd_substrate FOREIGN KEY (substrate_level_id) REFERENCES substrate_level_lut(substrate_level_id);

ALTER TABLE ONLY redd_substrate
    ADD CONSTRAINT fk_substrate_type_lut__redd_substrate FOREIGN KEY (substrate_type_id) REFERENCES substrate_type_lut(substrate_type_id);

-------------------------
ALTER TABLE ONLY redd_superimposition
    ADD CONSTRAINT fk_individual_redd__redd_superimposition FOREIGN KEY (individual_redd_id) REFERENCES individual_redd(individual_redd_id);

ALTER TABLE ONLY redd_superimposition
    ADD CONSTRAINT fk_intersecting_redd__redd_superimposition FOREIGN KEY (intersecting_redd_id) REFERENCES individual_redd(individual_redd_id);

ALTER TABLE ONLY redd_superimposition
    ADD CONSTRAINT fk_intersecting_species__redd_superimposition FOREIGN KEY (intersecting_species_id) REFERENCES species_lut(species_id);

ALTER TABLE ONLY redd_superimposition
    ADD CONSTRAINT fk_superimposition_type__redd_superimposition FOREIGN KEY (superimposition_type_id) REFERENCES superimposition_type_lut(superimposition_type_id);

-------------------------
ALTER TABLE ONLY stock_lut
    ADD CONSTRAINT fk_waterbody_lut__stock_lut FOREIGN KEY (waterbody_id) REFERENCES waterbody_lut(waterbody_id);

ALTER TABLE ONLY stock_lut
    ADD CONSTRAINT fk_species_lut__stock_lut FOREIGN KEY (species_id) REFERENCES species_lut(species_id);

ALTER TABLE ONLY stock_lut
    ADD CONSTRAINT fk_run_lut__stock_lut FOREIGN KEY (run_id) REFERENCES run_lut(run_id);

-------------------------
ALTER TABLE ONLY stream
    ADD CONSTRAINT fk_waterbody_lut__stream FOREIGN KEY (waterbody_id) REFERENCES waterbody_lut(waterbody_id);

-------------------------
ALTER TABLE ONLY stream_section
    ADD CONSTRAINT fk_location__stream_section FOREIGN KEY (location_id) REFERENCES location(location_id);

-------------------------
ALTER TABLE ONLY survey
    ADD CONSTRAINT fk_data_source_lut__survey FOREIGN KEY (data_source_id) REFERENCES data_source_lut(data_source_id);

ALTER TABLE ONLY survey
    ADD CONSTRAINT fk_data_source_unit_lut__survey FOREIGN KEY (data_source_unit_id) REFERENCES data_source_unit_lut(data_source_unit_id);

ALTER TABLE ONLY survey
    ADD CONSTRAINT fk_survey_method_lut__survey FOREIGN KEY (survey_method_id) REFERENCES survey_method_lut(survey_method_id);

ALTER TABLE ONLY survey
    ADD CONSTRAINT fk_data_review_status_lut__survey FOREIGN KEY (data_review_status_id) REFERENCES data_review_status_lut(data_review_status_id);

ALTER TABLE ONLY survey
    ADD CONSTRAINT fk_location__survey__upper_end_point FOREIGN KEY (upper_end_point_id) REFERENCES location(location_id);

ALTER TABLE ONLY survey
    ADD CONSTRAINT fk_location__survey__lower_end_point FOREIGN KEY (lower_end_point_id) REFERENCES location(location_id);

ALTER TABLE ONLY survey
    ADD CONSTRAINT fk_survey_completion_status_lut__survey FOREIGN KEY (survey_completion_status_id) REFERENCES survey_completion_status_lut(survey_completion_status_id);

ALTER TABLE ONLY survey
    ADD CONSTRAINT fk_incomplete_survey_type_lut__survey FOREIGN KEY (incomplete_survey_type_id) REFERENCES incomplete_survey_type_lut(incomplete_survey_type_id);

-------------------------
ALTER TABLE ONLY survey_comment
    ADD CONSTRAINT fk_survey__survey_comment FOREIGN KEY (survey_id) REFERENCES survey(survey_id);

ALTER TABLE ONLY survey_comment
    ADD CONSTRAINT fk_area_surveyed_lut__survey_comment FOREIGN KEY (area_surveyed_id) REFERENCES area_surveyed_lut(area_surveyed_id);

ALTER TABLE ONLY survey_comment
    ADD CONSTRAINT fk_fish_abundance_condition_lut__survey_comment FOREIGN KEY (fish_abundance_condition_id) REFERENCES fish_abundance_condition_lut(fish_abundance_condition_id);

ALTER TABLE ONLY survey_comment
    ADD CONSTRAINT fk_survey_count_condition_lut__survey_comment FOREIGN KEY (survey_count_condition_id) REFERENCES survey_count_condition_lut(survey_count_condition_id);

ALTER TABLE ONLY survey_comment
    ADD CONSTRAINT fk_survey_direction_lut__survey_comment FOREIGN KEY (survey_direction_id) REFERENCES survey_direction_lut(survey_direction_id);

ALTER TABLE ONLY survey_comment
    ADD CONSTRAINT fk_survey_timing_lut__survey_comment FOREIGN KEY (survey_timing_id) REFERENCES survey_timing_lut(survey_timing_id);

ALTER TABLE ONLY survey_comment
    ADD CONSTRAINT fk_stream_condition_lut__survey_comment FOREIGN KEY (stream_condition_id) REFERENCES stream_condition_lut(stream_condition_id);

ALTER TABLE ONLY survey_comment
    ADD CONSTRAINT fk_weather_type_lut__survey_comment FOREIGN KEY (weather_type_id) REFERENCES weather_type_lut(weather_type_id);

ALTER TABLE ONLY survey_comment
    ADD CONSTRAINT fk_visibility_condition_lut__survey_comment FOREIGN KEY (visibility_condition_id) REFERENCES visibility_condition_lut(visibility_condition_id);

ALTER TABLE ONLY survey_comment
    ADD CONSTRAINT fk_stream_flow_type_lut__survey_comment FOREIGN KEY (stream_flow_type_id) REFERENCES stream_flow_type_lut(stream_flow_type_id);

ALTER TABLE ONLY survey_comment
    ADD CONSTRAINT fk_visibility_type_lut__survey_comment FOREIGN KEY (visibility_type_id) REFERENCES visibility_type_lut(visibility_type_id);

-------------------------
ALTER TABLE ONLY survey_event
    ADD CONSTRAINT fk_survey__survey_event FOREIGN KEY (survey_id) REFERENCES survey(survey_id);

ALTER TABLE ONLY survey_event
    ADD CONSTRAINT fk_species_lut__survey_event FOREIGN KEY (species_id) REFERENCES species_lut(species_id);

ALTER TABLE ONLY survey_event
    ADD CONSTRAINT fk_survey_design_type_lut__survey_event FOREIGN KEY (survey_design_type_id) REFERENCES survey_design_type_lut(survey_design_type_id);

ALTER TABLE ONLY survey_event
    ADD CONSTRAINT fk_cwt_detection_method_lut__survey_event FOREIGN KEY (cwt_detection_method_id) REFERENCES cwt_detection_method_lut(cwt_detection_method_id);

ALTER TABLE ONLY survey_event
    ADD CONSTRAINT fk_run_lut__survey_event FOREIGN KEY (run_id) REFERENCES run_lut(run_id);

-------------------------
ALTER TABLE ONLY survey_intent
    ADD CONSTRAINT fk_survey__survey_intent FOREIGN KEY (survey_id) REFERENCES survey(survey_id);

ALTER TABLE ONLY survey_intent
    ADD CONSTRAINT fk_species_lut__survey_intent FOREIGN KEY (species_id) REFERENCES species_lut(species_id);

ALTER TABLE ONLY survey_intent
    ADD CONSTRAINT fk_count_type_lut__survey_intent FOREIGN KEY (count_type_id) REFERENCES count_type_lut(count_type_id);

-------------------------
ALTER TABLE ONLY survey_mobile_device
    ADD CONSTRAINT fk_survey__survey_mobile_device FOREIGN KEY (survey_id) REFERENCES survey(survey_id);

ALTER TABLE ONLY survey_mobile_device
    ADD CONSTRAINT fk_mobile_device__survey_mobile_device FOREIGN KEY (mobile_device_id) REFERENCES mobile_device(mobile_device_id);

-------------------------
ALTER TABLE ONLY waterbody_measurement
    ADD CONSTRAINT fk_survey__waterbody_measurement FOREIGN KEY (survey_id) REFERENCES survey(survey_id);

ALTER TABLE ONLY waterbody_measurement
    ADD CONSTRAINT fk_water_clarity_type_lut__waterbody_measurement FOREIGN KEY (water_clarity_type_id) REFERENCES water_clarity_type_lut(water_clarity_type_id);

-- Add normal indexes --------------------------------------------------------------------------------------------------

-- location
CREATE INDEX location_waterbody_idx ON location (waterbody_id);
CREATE INDEX location_wria_idx ON location (wria_id);

-- survey
CREATE INDEX survey_upper_end_point_idx ON survey (upper_end_point_id);
CREATE INDEX survey_lower_end_point_idx ON survey (lower_end_point_id);
CREATE INDEX survey_survey_datetime_idx ON survey ( date(timezone('UTC', survey_datetime)) );

-- survey_comment
CREATE INDEX survey_comment_survey_idx ON survey_comment (survey_id);

-- survey_intent
CREATE INDEX survey_intent_survey_idx ON survey_intent (survey_id);

-- waterbody_measurement
CREATE INDEX waterbody_measurement_survey_idx ON waterbody_measurement (survey_id);

-- mobile_survey_form
CREATE INDEX mobile_survey_form_survey_idx ON mobile_survey_form (survey_id);

-- fish_passage_feature
CREATE INDEX fish_passage_feature_survey_idx ON fish_passage_feature (survey_id);
CREATE INDEX fish_passage_feature_location_idx ON fish_passage_feature (feature_location_id);

-- other_observation
CREATE INDEX other_observation_survey_idx ON other_observation (survey_id);
CREATE INDEX other_observation_location_idx ON other_observation (observation_location_id);

-- survey_event
CREATE INDEX survey_event_survey_idx ON survey_event (survey_id);

-- fish_encounter
CREATE INDEX fish_encounter_survey_event_idx ON fish_encounter (survey_event_id);
CREATE INDEX fish_encounter_location_idx ON fish_encounter (fish_location_id);

-- fish_capture_event
CREATE INDEX fish_capture_event_fish_encounter_idx ON fish_capture_event (fish_encounter_id);
CREATE INDEX fish_capture_event_location_idx ON fish_capture_event (disposition_location_id);

-- fish_mark
CREATE INDEX fish_mark_fish_encounter_idx ON fish_mark (fish_encounter_id);

-- individual_fish
CREATE INDEX individual_fish_fish_encounter_idx ON individual_fish (fish_encounter_id);

-- fish_length_measurement
CREATE INDEX fish_length_measurement_individual_fish_idx ON fish_length_measurement (individual_fish_id);

-- redd_encounter
CREATE INDEX redd_encounter_survey_event_idx ON redd_encounter (survey_event_id);
CREATE INDEX redd_encounter_location_idx ON redd_encounter (redd_location_id);

-- individual_redd
CREATE INDEX individual_redd_redd_encounter_idx ON individual_redd (redd_encounter_id);

-- redd_superimposition
CREATE INDEX redd_superimposition_individual_redd_idx ON redd_superimposition (individual_redd_id);
CREATE INDEX redd_superimposition_intersecting_redd_idx ON redd_superimposition (intersecting_redd_id);
CREATE INDEX redd_superimposition_intersecting_species_idx ON redd_superimposition (intersecting_species_id);
CREATE INDEX redd_superimposition_superimposition_type_idx ON redd_superimposition (superimpositon_type_id);

-- Add geometry indexes

CREATE INDEX fish_biologist_district_gix ON fish_biologist_district USING GIST (geom);
CREATE INDEX hydrologic_unit_gix ON hydrologic_unit USING GIST (geom);
CREATE INDEX lake_gix ON lake USING GIST (geom);
CREATE INDEX location_coordinates_gix ON location_coordinates USING GIST (geom);
CREATE INDEX stream_gix ON stream USING GIST (geom);
CREATE INDEX stream_section_gix ON stream_section USING GIST (geom);
CREATE INDEX wria_gix ON wria_lut USING GIST (geom);

-- Cluster on gix, only run periodically after much data has been loaded ---

-- CLUSTER lake_geometry_gix ON lake_geometry;

-- CLUSTER location_coordinates_gix ON location_coordinates;

-- CLUSTER stream_geometry_gix ON stream_geometry;


