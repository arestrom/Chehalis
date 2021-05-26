
-- Create comments to tables and columns
-- Created 2017-03-06
-- For survey_design_type...only display obsolete = FALSE???
-- Add similar code for all other categories???
-- Updated to match 2017-05-16 changes to create script
-- Uploaded to github 2017-05-16
-- Edited for spatial version 2018-05-01
-- Added hydrologic_unit 2018-07-31

-- survey
COMMENT ON TABLE public.survey IS 'Top level header information for surveys';
COMMENT ON COLUMN survey.survey_id IS 'Universally unique primary key';
COMMENT ON COLUMN survey.survey_datetime IS 'Date of survey';
COMMENT ON COLUMN survey.data_source_id IS 'Organization that conducted the survey';
COMMENT ON COLUMN survey.data_source_unit_id IS 'Unit within data source organization';
COMMENT ON COLUMN survey.survey_method_id IS 'Method used to conduct survey (foot, raft, etc.)';
COMMENT ON COLUMN survey.data_review_status_id IS 'Status of data review (final, preliminary, etc.)';
COMMENT ON COLUMN survey.upper_end_point_id IS 'Link to location table, describes upper end point of survey';
COMMENT ON COLUMN survey.lower_end_point_id IS 'Link to location table, describes lower end point of survey';
COMMENT ON COLUMN survey.survey_completion_status_id IS 'Was survey completed (partial, completed, etc.)';
COMMENT ON COLUMN survey.incomplete_survey_type_id IS 'Reason that survey was not completed';
COMMENT ON COLUMN survey.survey_start_datetime IS 'Time of day when survey started';
COMMENT ON COLUMN survey.survey_end_datetime IS 'Time of day when survey ended';
COMMENT ON COLUMN survey.observer_last_name IS 'Last name of person(s) conducting the survey';
COMMENT ON COLUMN survey.data_submitter_last_name IS 'Last name of person who submitted the data.';

-- data_source_lut
COMMENT ON TABLE public.data_source_lut IS 'Organization that conducted the survey';
COMMENT ON COLUMN data_source_lut.data_source_id IS 'Universally unique primary key';
COMMENT ON COLUMN data_source_lut.data_source_name IS 'Name of organization';
COMMENT ON COLUMN data_source_lut.data_source_code IS 'Organization code';

-- data_source_unit_lut
COMMENT ON TABLE public.data_source_unit_lut IS 'Unit within organization that conducted the survey';
COMMENT ON COLUMN data_source_unit_lut.data_source_unit_id IS 'Universally unique primary key';
COMMENT ON COLUMN data_source_unit_lut.data_source_unit_name IS 'Name of organization unit';

-- survey_method_lut
COMMENT ON TABLE public.survey_method_lut IS 'Physical method used to conduct the survey';
COMMENT ON COLUMN survey_method_lut.survey_method_id IS 'Universally unique primary key';
COMMENT ON COLUMN survey_method_lut.survey_method_code IS 'Method code';
COMMENT ON COLUMN survey_method_lut.survey_method_code IS 'Description of method';

-- data_review_status_lut
COMMENT ON TABLE public.data_review_status_lut IS 'Status of data review process';
COMMENT ON COLUMN data_review_status_lut.data_review_status_id IS 'Universally unique primary key';
COMMENT ON COLUMN data_review_status_lut.data_review_status_description IS 'Description of review categories';

-- survey_completion_status_lut
COMMENT ON TABLE public.survey_completion_status_lut IS 'Was the survey completed?';
COMMENT ON COLUMN survey_completion_status_lut.survey_completion_status_id IS 'Universally unique primary key';
COMMENT ON COLUMN survey_completion_status_lut.completion_status_description IS 'Description of status categories';

-- incomplete_survey_type_lut
COMMENT ON TABLE public.incomplete_survey_type_lut IS 'Why was the survey not completed?';
COMMENT ON COLUMN incomplete_survey_type_lut.incomplete_survey_type_id IS 'Universally unique primary key';
COMMENT ON COLUMN incomplete_survey_type_lut.incomplete_survey_description IS 'Descriptions of why incomplete';

-- location
COMMENT ON TABLE public.location IS 'Data associated with point locations';
COMMENT ON COLUMN location.location_id IS 'Universally unique primary key';
COMMENT ON COLUMN location.waterbody_id IS 'Link to table listing relevant streams and lakes in WA State';
COMMENT ON COLUMN location.wria_id IS 'Link to table of watersheds in WA State';
COMMENT ON COLUMN location.location_type_id IS 'Type of location (start point, redd, etc)';
COMMENT ON COLUMN location.stream_channel_type_id IS 'Type of channel (mainstem, left braid, etc.)';
COMMENT ON COLUMN location.location_orientation_type_id IS 'Orientation of point in channel (mid, left, etc)';
COMMENT ON COLUMN location.river_mile_measure IS 'Distance from mouth of stream to point';
COMMENT ON COLUMN location.location_code IS 'Short code to identify point';
COMMENT ON COLUMN location.location_name IS 'Name of point (place name, ReddID, etc.)';
COMMENT ON COLUMN location.location_description IS 'Extended description of point';
COMMENT ON COLUMN location.waloc_id IS 'Link to remote table listing PSC codes';

-- media_location
COMMENT ON TABLE public.media_location IS 'Identifies where to retrieve media (photo, video, audio files, etc.) recorded at point locations';
COMMENT ON COLUMN media_location.media_location_id IS 'Universally unique primary key';
COMMENT ON COLUMN media_location.location_id IS 'Link to location table';
COMMENT ON COLUMN media_location.media_type_id IS 'The type of media that was recorded (photo, video, audio, etc.)';
COMMENT ON COLUMN media_location.media_url IS 'The secure file or web location where media files are stored';

-- media_type_lut
COMMENT ON TABLE public.media_type_lut IS 'Type of media that was recorded (photo, video, audio, etc.)';
COMMENT ON COLUMN media_type_lut.media_type_id IS 'Universally unique primary key';
COMMENT ON COLUMN media_type_lut.media_type_code IS 'Code describing the type of media';
COMMENT ON COLUMN media_type_lut.media_type_description IS 'Description of the media type';

-- waterbody_lut
COMMENT ON TABLE public.waterbody_lut IS 'Attributes for relevant streams and lakes in WA State';
COMMENT ON COLUMN waterbody_lut.waterbody_id IS 'Universally unique primary key';
COMMENT ON COLUMN waterbody_lut.waterbody_name IS 'Long version of waterbody name';
COMMENT ON COLUMN waterbody_lut.waterbody_display_name IS 'Waterbody name formatted for mobile device displays';
COMMENT ON COLUMN waterbody_lut.latitude_longitude_id IS 'Unique ID for stream using terminus coordinates';
COMMENT ON COLUMN waterbody_lut.stream_catalog_code IS 'Code from the WA Streams Catalog';
COMMENT ON COLUMN waterbody_lut.tributary_to_name IS 'Body of water the stream flows into';

-- fish_biologist_district
COMMENT ON TABLE public.fish_biologist_district IS 'Boundaries of WDFW Fish Program biologist districts';
COMMENT ON COLUMN fish_biologist_district.fish_biologist_district_id IS 'Universally unique primary key';
COMMENT ON COLUMN fish_biologist_district.fish_biologist_district_code IS 'Integer codes used to identify district';
COMMENT ON COLUMN fish_biologist_district.district_description IS 'Description of biologist district';
COMMENT ON COLUMN fish_biologist_district.wdfw_region_code IS 'WDFW Region code';
COMMENT ON COLUMN fish_biologist_district.gid IS 'Unique integer ID required to manually edit geometry';
COMMENT ON COLUMN fish_biologist_district.geom IS 'Polygons of districts stored in binary format, EPSG:2927';

-- hydrologic_unit
COMMENT ON TABLE public.hydrologic_unit IS 'Boundaries of NHD Hydrologic units (HUC 12 and greater)';
COMMENT ON COLUMN hydrologic_unit.hydrologic_unit_id IS 'Universally unique primary key';
COMMENT ON COLUMN hydrologic_unit.hydrologic_unit_code IS 'NHD codes used to identify HUC units';
COMMENT ON COLUMN hydrologic_unit.hydrologic_unit_name IS 'Name of hyrologic unit';
COMMENT ON COLUMN hydrologic_unit.marine_terminus IS 'Body of water where streams from the unit empty into marine waters';
COMMENT ON COLUMN hydrologic_unit.reach_description IS 'Description of the reach that defines upper and lower extents of the unit';
COMMENT ON COLUMN hydrologic_unit.tributary_one IS 'Primary tributary of the stream that defines the unit';
COMMENT ON COLUMN hydrologic_unit.tributary_two IS 'Secondary tributary of the stream that defines the unit';
COMMENT ON COLUMN hydrologic_unit.tributary_three IS 'Tertiary tributary of the stream that defines the unit';
COMMENT ON COLUMN hydrologic_unit.tributary_four IS 'Quaternary tributary of the stream that defines the unit';
COMMENT ON COLUMN hydrologic_unit.tributary_five IS 'Quinary tributary of the stream that defines the unit';
COMMENT ON COLUMN hydrologic_unit.gid IS 'Unique integer ID required to manually edit geometry';
COMMENT ON COLUMN hydrologic_unit.geom IS 'Polygons of units stored in binary format, EPSG:2927';

-- stream
COMMENT ON TABLE public.stream IS 'Line geometry for relevant streams in WA State';
COMMENT ON COLUMN stream.stream_id IS 'Universally unique primary key';
COMMENT ON COLUMN stream.waterbody_id IS 'Link to table listing relevant streams in WA State';
COMMENT ON COLUMN stream.gid IS 'Unique integer ID required to manually edit geometry';
COMMENT ON COLUMN stream.geom IS 'Line geometry of salmon streams stored in binary format, EPSG:2927';

-- stream_section
COMMENT ON TABLE public.stream_section IS 'Line geometry for sections of streams, primarily for IMW surveys';
COMMENT ON COLUMN stream_section.stream_section_id IS 'Universally unique primary key';
COMMENT ON COLUMN stream_section.location_id IS 'Link to location table';
COMMENT ON COLUMN stream_section.gid IS 'Unique integer ID required to manually edit geometry';
COMMENT ON COLUMN stream_section.geom IS 'Line geometry of stream section stored in binary format, EPSG:2927';

-- lake
COMMENT ON TABLE public.lake IS 'Polygons for relevant lakes in WA State';
COMMENT ON COLUMN lake.lake_id IS 'Universally unique primary key';
COMMENT ON COLUMN lake.gid IS 'Unique integer ID required to manually edit geometry';
COMMENT ON COLUMN lake.waterbody_id IS 'Link to table listing relevant lakes in WA State';
COMMENT ON COLUMN lake.geom IS 'Polygons of lakes stored in binary format, EPSG:2927';

-- wria_lut
COMMENT ON TABLE public.wria_lut IS 'Water Resource Inventory Areas (watersheds) in WA State';
COMMENT ON COLUMN wria_lut.wria_id IS 'Universally unique primary key';
COMMENT ON COLUMN wria_lut.wria_code IS 'Code for the watershed';
COMMENT ON COLUMN wria_lut.wria_description IS 'Description of the watershed';
COMMENT ON COLUMN wria_lut.gid IS 'Unique integer ID required to manually edit geometry';
COMMENT ON COLUMN wria_lut.geom IS 'Polygons of the watershed units stored in binary format, EPSG:2927';

-- location_type_lut
COMMENT ON TABLE public.location_type_lut IS 'Type of location (trap, redd, etc.)';
COMMENT ON COLUMN location_type_lut.location_type_id IS 'Universally unique primary key';
COMMENT ON COLUMN location_type_lut.location_type_description IS 'Description of the location type';

-- stream_channel_type_lut
COMMENT ON TABLE public.stream_channel_type_lut IS 'Type of stream channel (mainstem, left braid, etc.)';
COMMENT ON COLUMN stream_channel_type_lut.stream_channel_type_id IS 'Universally unique primary key';
COMMENT ON COLUMN stream_channel_type_lut.channel_type_description IS 'Description of the stream channel type';

-- location_orientation_type_lut
COMMENT ON TABLE public.location_orientation_type_lut IS 'Orientation of point in channel (left, right) when looking downstream';
COMMENT ON COLUMN location_orientation_type_lut.location_orientation_type_id IS 'Universally unique primary key';
COMMENT ON COLUMN location_orientation_type_lut.orientation_type_description IS 'Description of orientation type';

-- location_coordinates
COMMENT ON TABLE public.location_coordinates IS 'Spatial table holding coordinates (when available) for location records';
COMMENT ON COLUMN location_coordinates.location_coordinates_id IS 'Universally unique primary key';
COMMENT ON COLUMN location_coordinates.location_id IS 'Link to location table';
COMMENT ON COLUMN location_coordinates.horizontal_accuracy IS 'Estimated accuracy of the point in meters';
COMMENT ON COLUMN location_coordinates.comment_text IS 'Additional comments regarding point location coordinates';
COMMENT ON COLUMN location_coordinates.gid IS 'Unique integer ID required to manually edit geometry';
COMMENT ON COLUMN location_coordinates.geom IS 'Points stored in binary format. EPSG:2927';

-- location_source
COMMENT ON TABLE public.location_source IS 'Methods of capture, and errors, associated with point locations';
COMMENT ON COLUMN location_source.location_source_id IS 'Universally unique primary key';
COMMENT ON COLUMN location_source.location_coordinates_id IS 'Link to location_coordinates table';
COMMENT ON COLUMN location_source.coordinate_capture_method_id IS 'Methods used to capture point locations';
COMMENT ON COLUMN location_source.location_error_type_id IS 'Error types associated with point locations';
COMMENT ON COLUMN location_source.location_error_correction_type_id IS 'Methods to correct point location errors';
COMMENT ON COLUMN location_source.source_longitude IS 'Original uncorrected longitude in decimal degrees, EPSG:4326';
COMMENT ON COLUMN location_source.source_latitude IS 'Original uncorrected latitude in decimal degrees, EPSG:4326';
COMMENT ON COLUMN location_source.elevation_meter IS 'Elevation in meters above sea-level';
COMMENT ON COLUMN location_source.location_correction_layer_name IS 'Name of GIS layer used for corrections';
COMMENT ON COLUMN location_source.waypoint_name IS 'Name of waypoint';
COMMENT ON COLUMN location_source.waypoint_datetime IS 'Time that waypoint was recorded';
COMMENT ON COLUMN location_source.comment_text IS 'Additional comments regarding point location';

-- location_orientation_type_lut
COMMENT ON TABLE public.coordinate_capture_method_lut IS 'Methods used to capture point location';
COMMENT ON COLUMN coordinate_capture_method_lut.coordinate_capture_method_id IS 'Universally unique primary key';
COMMENT ON COLUMN coordinate_capture_method_lut.capture_method_description IS 'Description of point location capture method';

-- location_error_type_lut
COMMENT ON TABLE public.location_error_type_lut IS 'Error types associated with point locations';
COMMENT ON COLUMN location_error_type_lut.location_error_type_id IS 'Universally unique primary key';
COMMENT ON COLUMN location_error_type_lut.location_error_type_code IS 'Short code for error type';
COMMENT ON COLUMN location_error_type_lut.location_error_type_description IS 'Description of error type';

-- location_error_correction_type_lut
COMMENT ON TABLE public.location_error_correction_type_lut IS 'Methods used to correct point location errors';
COMMENT ON COLUMN location_error_correction_type_lut.location_error_correction_type_id IS 'Universally unique primary key';
COMMENT ON COLUMN location_error_correction_type_lut.correction_type_short_description IS 'Short description of correction methods';
COMMENT ON COLUMN location_error_correction_type_lut.correction_type_description IS 'Full description of correction methods';

-- fish_capture
COMMENT ON TABLE public.fish_capture IS 'Attributes for capture type surveys (traps, electrofishing)';
COMMENT ON COLUMN fish_capture.fish_capture_id IS 'Universally unique primary key';
COMMENT ON COLUMN fish_capture.survey_id IS 'Link to survey table';
COMMENT ON COLUMN fish_capture.gear_performance_type_id IS 'Link to categories for capture gear integrity';
COMMENT ON COLUMN fish_capture.fish_start_datetime IS 'Time when capture gear started fishing';
COMMENT ON COLUMN fish_capture.fish_end_datetime IS 'Time when capture gear stopped fishing';

-- gear_performance_type_lut
COMMENT ON TABLE public.gear_performance_type_lut IS 'Categories for how well capture gear is functioning';
COMMENT ON COLUMN gear_performance_type_lut.gear_performance_type_id IS 'Universally unique primary key';
COMMENT ON COLUMN gear_performance_type_lut.performance_short_description IS 'Short description of capture gear performance';
COMMENT ON COLUMN gear_performance_type_lut.performance_description IS 'Detailed description of capture gear performance';

-- fish_passage_feature
COMMENT ON TABLE public.fish_passage_feature IS 'Attributes for fish passage features encountered during surveys';
COMMENT ON COLUMN fish_passage_feature.fish_passage_feature_id IS 'Universally unique primary key';
COMMENT ON COLUMN fish_passage_feature.survey_id IS 'Link to survey table';
COMMENT ON COLUMN fish_passage_feature.feature_location_id IS 'Link to location table, describes feature location';
COMMENT ON COLUMN fish_passage_feature.passage_feature_type_id IS 'Link to table listing passage feature categories';
COMMENT ON COLUMN fish_passage_feature.feature_observed_datetime IS 'Time that feature was observed';
COMMENT ON COLUMN fish_passage_feature.feature_height_meter IS 'Height of feature in meters';
COMMENT ON COLUMN fish_passage_feature.feature_height_type_id IS 'Link to feature_measurement_type table';
COMMENT ON COLUMN fish_passage_feature.plunge_pool_depth_meter IS 'Depth of feature plunge pool in meters';
COMMENT ON COLUMN fish_passage_feature.plunge_pool_depth_type_id IS 'Link to feature_measurement_type table';
COMMENT ON COLUMN fish_passage_feature.comment_text IS 'Additional comments on fish passage feature';

-- passage_feature_type_lut
COMMENT ON TABLE public.passage_feature_type_lut IS 'Categories for types of passage features encountered during surveys';
COMMENT ON COLUMN passage_feature_type_lut.passage_feature_type_id IS 'Universally unique primary key';
COMMENT ON COLUMN passage_feature_type_lut.feature_type_description IS 'Description of passage feature type';

-- passage_measurement_type_lut
COMMENT ON TABLE public.passage_measurement_type_lut IS 'Measurement type for barrier height and pool depth';
COMMENT ON COLUMN passage_measurement_type_lut.passage_measurement_type_id IS 'Universally unique primary key';
COMMENT ON COLUMN passage_measurement_type_lut.measurement_type_description IS 'Measurement type (measured, estimated, etc.)';

-- fish_species_presence
COMMENT ON TABLE public.fish_species_presence IS 'Data on species presence-absence observations';
COMMENT ON COLUMN fish_species_presence.fish_species_presence_id IS 'Universally unique primary key';
COMMENT ON COLUMN fish_species_presence.survey_id IS 'Link to survey table';
COMMENT ON COLUMN fish_species_presence.species_id IS 'Link to species table';
COMMENT ON COLUMN fish_species_presence.fish_presence_type_id IS 'Link to categories of likelihood for species presence';
COMMENT ON COLUMN fish_species_presence.comment_text IS 'Additional comment on fish presence or absence';

-- species_lut
COMMENT ON TABLE public.species_lut IS 'List of fish species';
COMMENT ON COLUMN species_lut.species_id IS 'Universally unique primary key';
COMMENT ON COLUMN species_lut.species_code IS 'Short code for species';
COMMENT ON COLUMN species_lut.common_name IS 'Common name of species';
COMMENT ON COLUMN species_lut.genus IS 'The genus name for the fish';
COMMENT ON COLUMN species_lut.species IS 'The species name for the fish';
COMMENT ON COLUMN species_lut.sub_species IS 'The sub-species name for the fish';

-- fish_presence_type_lut
COMMENT ON TABLE public.fish_presence_type_lut IS 'Categories of likelihood for presence of fish species';
COMMENT ON COLUMN fish_presence_type_lut.fish_presence_type_id IS 'Universally unique primary key';
COMMENT ON COLUMN fish_presence_type_lut.fish_presence_type_description IS 'Description of presence likelihood';

-- waterbody_measurement
COMMENT ON TABLE public.waterbody_measurement IS 'Measurements of waterbody attributes captured during surveys';
COMMENT ON COLUMN waterbody_measurement.waterbody_measurement_id IS 'Universally unique primary key';
COMMENT ON COLUMN waterbody_measurement.survey_id IS 'Link to survey table';
COMMENT ON COLUMN waterbody_measurement.water_clarity_type_id IS 'Description of clarity measurement type';
COMMENT ON COLUMN waterbody_measurement.water_clarity_meter IS 'Clarity measurement in meters';
COMMENT ON COLUMN waterbody_measurement.stream_flow_measurement_cfs IS 'Stream flow in cubic feet per second';
COMMENT ON COLUMN waterbody_measurement.start_water_temperature_datetime IS 'Time when temperature was measured';
COMMENT ON COLUMN waterbody_measurement.start_water_temperature_celsius IS 'Water temperature at start of survey';
COMMENT ON COLUMN waterbody_measurement.end_water_temperature_datetime IS 'Time when temperature was measured';
COMMENT ON COLUMN waterbody_measurement.end_water_temperature_celsius IS 'Water temperature at end of survey';
COMMENT ON COLUMN waterbody_measurement.waterbody_ph IS 'Water pH measurement';

-- water_clarity_type_lut
COMMENT ON TABLE public.water_clarity_type_lut IS 'Description of water clarity measurement type';
COMMENT ON COLUMN water_clarity_type_lut.water_clarity_type_id IS 'Universally unique primary key';
COMMENT ON COLUMN water_clarity_type_lut.clarity_type_short_description IS 'Short description of clarity measurement type';
COMMENT ON COLUMN water_clarity_type_lut.clarity_type_description IS 'Detailed description of of clarity measurement type';

-- survey_comment
COMMENT ON TABLE public.survey_comment IS 'Comments on survey. Largely derived from legacy comment codes';
COMMENT ON COLUMN survey_comment.survey_comment_id IS 'Universally unique primary key';
COMMENT ON COLUMN survey_comment.survey_id IS 'Link to survey table';
COMMENT ON COLUMN survey_comment.area_surveyed_id IS 'Description of areas surveyed or excluded';
COMMENT ON COLUMN survey_comment.fish_abundance_condition_id IS 'Factors affecting abundance (fish kill, predation, etc';
COMMENT ON COLUMN survey_comment.stream_condition_id IS 'Factors affecting fish migration or passage';
COMMENT ON COLUMN survey_comment.stream_flow_type_id IS 'General comments on stream flow';
COMMENT ON COLUMN survey_comment.survey_count_condition_id IS 'Factors affecting ability to count fish';
COMMENT ON COLUMN survey_comment.survey_timing_id IS 'Comments on run timing';
COMMENT ON COLUMN survey_comment.visibility_condition_id IS 'Factors affecting visibility below stream surface';
COMMENT ON COLUMN survey_comment.visibility_type_id IS 'General comments on visibility';
COMMENT ON COLUMN survey_comment.weather_type_id IS 'General comments on weather conditions';
COMMENT ON COLUMN survey_comment.comment_text IS 'Additional comments on survey';

-- area_surveyed_lut
COMMENT ON TABLE public.area_surveyed_lut IS 'Descriptions of areas surveyed or excluded (from comment codes)';
COMMENT ON COLUMN area_surveyed_lut.area_surveyed_id IS 'Universally unique primary key';
COMMENT ON COLUMN area_surveyed_lut.area_surveyed IS 'Description of areas surveyed or excluded';

-- fish_abundance_condition_lut
COMMENT ON TABLE public.fish_abundance_condition_lut IS 'Factors affecting fish abundance (from comment codes)';
COMMENT ON COLUMN fish_abundance_condition_lut.fish_abundance_condition_id IS 'Universally unique primary key';
COMMENT ON COLUMN fish_abundance_condition_lut.fish_abundance_condition IS 'Description of fish abundance factors';

-- stream_condition_lut
COMMENT ON TABLE public.stream_condition_lut IS 'Factors affecting fish migration or passage (from comment codes)';
COMMENT ON COLUMN stream_condition_lut.stream_condition_id IS 'Universally unique primary key';
COMMENT ON COLUMN stream_condition_lut.stream_condition IS 'Description of stream conditions';

-- stream_flow_type_lut
COMMENT ON TABLE public.stream_flow_type_lut IS 'General comments on stream flow';
COMMENT ON COLUMN stream_flow_type_lut.stream_flow_type_id IS 'Universally unique primary key';
COMMENT ON COLUMN stream_flow_type_lut.flow_type_short_description IS 'Short description of stream flow type';
COMMENT ON COLUMN stream_flow_type_lut.flow_type_description IS 'Full description of stream flow type';

-- survey_count_condition_lut
COMMENT ON TABLE public.survey_count_condition_lut IS 'Factors affecting ability to count fish (from comment codes)';
COMMENT ON COLUMN survey_count_condition_lut.survey_count_condition_id IS 'Universally unique primary key';
COMMENT ON COLUMN survey_count_condition_lut.survey_count_condition IS 'Factors affecting ability to count fish';

-- survey_direction_lut
COMMENT ON TABLE public.survey_direction_lut IS 'In what direction was the stream surveyed (upstream, downstream, both)';
COMMENT ON COLUMN survey_direction_lut.survey_direction_id IS 'Universally unique primary key';
COMMENT ON COLUMN survey_direction_lut.survey_direction_description IS 'Direction in terms of stream flow';

-- survey_timing_lut
COMMENT ON TABLE public.survey_timing_lut IS 'Comments on run timing (from comment codes)';
COMMENT ON COLUMN survey_timing_lut.survey_timing_id IS 'Universally unique primary key';
COMMENT ON COLUMN survey_timing_lut.survey_timing IS 'Comments on run timing';

-- visibility_condition_lut
COMMENT ON TABLE public.visibility_condition_lut IS 'Factors affecting visibility below stream surface (from comment codes)';
COMMENT ON COLUMN visibility_condition_lut.visibility_condition_id IS 'Universally unique primary key';
COMMENT ON COLUMN visibility_condition_lut.visibility_condition IS 'Factors affecting visibility below stream surface';

-- visibility_type_lut
COMMENT ON TABLE public.visibility_type_lut IS 'General comments on survey visibility';
COMMENT ON COLUMN visibility_type_lut.visibility_type_id IS 'Universally unique primary key';
COMMENT ON COLUMN visibility_type_lut.visibility_type_short_description IS 'Short description of visibility type';
COMMENT ON COLUMN visibility_type_lut.visibility_type_description IS 'Full description of visibility type';

-- weather_type_lut
COMMENT ON TABLE public.weather_type_lut IS 'General comments on weather conditions';
COMMENT ON COLUMN weather_type_lut.weather_type_id IS 'Universally unique primary key';
COMMENT ON COLUMN weather_type_lut.weather_type_description IS 'General comments on weather conditions';

-- survey_mobile_device
COMMENT ON TABLE public.survey_mobile_device IS 'Associative table between survey table and mobile_device table';
COMMENT ON COLUMN survey_mobile_device.survey_mobile_device_id IS 'Universally unique primary key';
COMMENT ON COLUMN survey_mobile_device.survey_id IS 'Link to survey table';
COMMENT ON COLUMN survey_mobile_device.mobile_device_id IS 'Link to mobile_device table';

-- mobile_device
COMMENT ON TABLE public.mobile_device IS 'Stores data for tracking mobile devices';
COMMENT ON COLUMN mobile_device.mobile_device_id IS 'Universally unique primary key';
COMMENT ON COLUMN mobile_device.mobile_device_type_id IS 'Type of device (Pad, GPS, etc.)';
COMMENT ON COLUMN mobile_device.mobile_equipment_identifier IS 'Typically the MEID number printed on device';
COMMENT ON COLUMN mobile_device.mobile_device_name IS 'Name of device';
COMMENT ON COLUMN mobile_device.mobile_device_description IS 'Description of device';
COMMENT ON COLUMN mobile_device.active_indicator IS 'Is the device still active and being used?';
COMMENT ON COLUMN mobile_device.inactive_datetime IS 'Date the device was taken out of service';

-- mobile_device_type_lut
COMMENT ON TABLE public.mobile_device_type_lut IS 'Type of mobile device';
COMMENT ON COLUMN mobile_device_type_lut.mobile_device_type_id IS 'Universally unique primary key';
COMMENT ON COLUMN mobile_device_type_lut.mobile_device_type_description IS 'Type of device (Pad, GPS, etc.)';

-- mobile_survey_form
COMMENT ON TABLE public.mobile_survey_form IS 'Table for tracking source of data collected with mobile device';
COMMENT ON COLUMN mobile_survey_form.mobile_survey_form_id IS 'Universally unique primary key';
COMMENT ON COLUMN mobile_survey_form.survey_id IS 'Link to survey table';
COMMENT ON COLUMN mobile_survey_form.parent_form_survey_id IS 'Unique ID (integer) generated in parent form';
COMMENT ON COLUMN mobile_survey_form.parent_form_survey_guid IS 'GUID generated in parent form';
COMMENT ON COLUMN mobile_survey_form.parent_form_name IS 'Name of the parent form used to record data';
COMMENT ON COLUMN mobile_survey_form.parent_form_id IS 'Integer ID of the parent form used to record data';

-- other_observation
COMMENT ON TABLE public.other_observation IS 'Ancillary data on other observations during survey';
COMMENT ON COLUMN other_observation.other_observation_id IS 'Universally unique primary key';
COMMENT ON COLUMN other_observation.survey_id IS 'Link to survey table';
COMMENT ON COLUMN other_observation.observation_location_id IS 'Link to location table';
COMMENT ON COLUMN other_observation.observation_type_id IS 'Type of observation';
COMMENT ON COLUMN other_observation.observation_datetime IS 'Time the observation was made';
COMMENT ON COLUMN other_observation.observation_count IS 'Number of items, such as animals for given species counted';
COMMENT ON COLUMN other_observation.comment_text IS 'Additional comment on observation';

-- observation_type_lut
COMMENT ON TABLE public.observation_type_lut IS 'Type of other observations noted during survey';
COMMENT ON COLUMN observation_type_lut.observation_type_id IS 'Universally unique primary key';
COMMENT ON COLUMN observation_type_lut.observation_type_name IS 'Common name of the observation type';

-- survey_event
COMMENT ON TABLE public.survey_event IS 'Species level data';
COMMENT ON COLUMN survey_event.survey_event_id IS 'Universally unique primary key';
COMMENT ON COLUMN survey_event.survey_id IS 'Link to survey table';
COMMENT ON COLUMN survey_event.species_id IS 'Link to species table';
COMMENT ON COLUMN survey_event.survey_design_type_id IS 'Survey design implemented for given species';
COMMENT ON COLUMN survey_event.cwt_detection_method_id IS 'Method used to detect coded-wire tag';
COMMENT ON COLUMN survey_event.run_id IS 'Run type for species';
COMMENT ON COLUMN survey_event.run_year IS 'Run year for species';
COMMENT ON COLUMN survey_event.estimated_percent_fish_seen IS 'Estimated pct. of fish seen for given species';
COMMENT ON COLUMN survey_event.comment_text IS 'Additional comment on species';

-- survey_design_type_lut
COMMENT ON TABLE public.survey_design_type_lut IS 'Survey design implemented for given species';
COMMENT ON COLUMN survey_design_type_lut.survey_design_type_id IS 'Universally unique primary key';
COMMENT ON COLUMN survey_design_type_lut.survey_design_type_code IS 'Short code for survey design type';
COMMENT ON COLUMN survey_design_type_lut.survey_design_type_description IS 'Description of survey design type';

-- cwt_detection_method_lut
COMMENT ON TABLE public.cwt_detection_method_lut IS 'Methods used to detect coded-wire tags';
COMMENT ON COLUMN cwt_detection_method_lut.cwt_detection_method_id IS 'Universally unique primary key';
COMMENT ON COLUMN cwt_detection_method_lut.detection_method_description IS 'Description of detection method';

-- run_lut
COMMENT ON TABLE public.run_lut IS 'Run types (fall, winter, etc.)';
COMMENT ON COLUMN run_lut.run_id IS 'Universally unique primary key';
COMMENT ON COLUMN run_lut.run_short_description IS 'Short description of run categories';
COMMENT ON COLUMN run_lut.run_description IS 'Full description of run categories';

-- survey_intent
COMMENT ON TABLE public.survey_intent IS 'Predetermined intent of the survey in terms of species targeted and count types attempted (live, dead, redd)';
COMMENT ON COLUMN survey_intent.survey_intent_id IS 'Universally unique primary key';
COMMENT ON COLUMN survey_intent.survey_id IS 'Link to survey table';
COMMENT ON COLUMN survey_intent.species_id IS 'Link to species table';
COMMENT ON COLUMN survey_intent.count_type_id IS 'Link to count_type categories (live, dead, redd, etc.)';

-- count_type_lut
COMMENT ON TABLE public.count_type_lut IS 'Intended count types (live fish, dead fish, redds, etc.)';
COMMENT ON COLUMN count_type_lut.count_type_id IS 'Universally unique primary key';
COMMENT ON COLUMN count_type_lut.count_type_code IS 'Short code for count type categories';
COMMENT ON COLUMN count_type_lut.count_type_description IS 'Full description of count type categories';

-- fish_encounter
COMMENT ON TABLE public.fish_encounter IS 'Data for fish encounters, includes data for one or multiple fish';
COMMENT ON COLUMN fish_encounter.fish_encounter_id IS 'Universally unique primary key';
COMMENT ON COLUMN fish_encounter.survey_event_id IS 'Link to survey_event table';
COMMENT ON COLUMN fish_encounter.fish_location_id IS 'Link to location table';
COMMENT ON COLUMN fish_encounter.fish_status_id IS 'Status of fish when counted (live, dead)';
COMMENT ON COLUMN fish_encounter.sex_id IS 'Sex of fish (male, female, unknown, etc)';
COMMENT ON COLUMN fish_encounter.maturity_id IS 'Maturity status of fish (adult, etc.)';
COMMENT ON COLUMN fish_encounter.origin_id IS 'Origin type for species (hatchery, natural, etc.)';
COMMENT ON COLUMN fish_encounter.cwt_detection_status_id IS 'Were coded-wire tags detected?';
COMMENT ON COLUMN fish_encounter.adipose_clip_status_id IS 'Status of adipose fins (clipped, unknown, etc)';
COMMENT ON COLUMN fish_encounter.fish_behavior_type_id IS 'Behavior type (holding, spawning, etc.)';
COMMENT ON COLUMN fish_encounter.mortality_type_id IS 'How did fish die? (gear encounter, handling, etc.)';
COMMENT ON COLUMN fish_encounter.fish_encounter_datetime IS 'Time fish were encountered';
COMMENT ON COLUMN fish_encounter.fish_count IS 'Number of fish counted';
COMMENT ON COLUMN fish_encounter.previously_counted_indicator IS 'Were fish counted on a previous survey?';

-- fish_status_lut
COMMENT ON TABLE public.fish_status_lut IS 'Status of fish when counted (live, dead)';
COMMENT ON COLUMN fish_status_lut.fish_status_id IS 'Universally unique primary key';
COMMENT ON COLUMN fish_status_lut.fish_status_description IS 'Description of status categories';

-- sex_lut
COMMENT ON TABLE public.sex_lut IS 'Sex of fish (male, female, unknown, etc)';
COMMENT ON COLUMN sex_lut.sex_id IS 'Universally unique primary key';
COMMENT ON COLUMN sex_lut.sex_description IS 'Description of sex categories';

-- maturity_lut
COMMENT ON TABLE public.maturity_lut IS 'Maturity status of fish (adult, subadult, etc.)';
COMMENT ON COLUMN maturity_lut.maturity_id IS 'Universally unique primary key';
COMMENT ON COLUMN maturity_lut.maturity_short_description IS 'Short description of maturity categories';
COMMENT ON COLUMN maturity_lut.maturity_description IS 'Full description of maturity categories';

-- origin_lut
COMMENT ON TABLE public.origin_lut IS 'Types of fish origin (natural, hatchery, etc.)';
COMMENT ON COLUMN origin_lut.origin_id IS 'Universally unique primary key';
COMMENT ON COLUMN origin_lut.origin_description IS 'Description of origin categories';

-- cwt_detection_status_lut
COMMENT ON TABLE public.cwt_detection_status_lut IS 'Result of coded-wire tag detection efforts';
COMMENT ON COLUMN cwt_detection_status_lut.cwt_detection_status_id IS 'Universally unique primary key';
COMMENT ON COLUMN cwt_detection_status_lut.detection_status_description IS 'Description of detection status';

-- adipose_clip_status_lut
COMMENT ON TABLE public.adipose_clip_status_lut IS 'Status of adipose fins (clipped, unknown, etc)';
COMMENT ON COLUMN adipose_clip_status_lut.adipose_clip_status_id IS 'Universally unique primary key';
COMMENT ON COLUMN adipose_clip_status_lut.adipose_clip_status_code IS 'Short code for clip status';
COMMENT ON COLUMN adipose_clip_status_lut.adipose_clip_status_description IS 'Description clip status';

-- fish_behavior_type_lut
COMMENT ON TABLE public.fish_behavior_type_lut IS 'Fish behavior type (holding, spawning, etc.)';
COMMENT ON COLUMN fish_behavior_type_lut.fish_behavior_type_id IS 'Universally unique primary key';
COMMENT ON COLUMN fish_behavior_type_lut.behavior_short_description IS 'Short description of behavior type';
COMMENT ON COLUMN fish_behavior_type_lut.behavior_description IS 'Full description of behavior type';

-- mortality_type_lut
COMMENT ON TABLE public.mortality_type_lut IS 'How did fish die? (gear encounter, handling, etc.)';
COMMENT ON COLUMN mortality_type_lut.mortality_type_id IS 'Universally unique primary key';
COMMENT ON COLUMN mortality_type_lut.mortality_type_short_description IS 'Short description of mortality type';
COMMENT ON COLUMN mortality_type_lut.mortality_type_description IS 'Full description of mortality type';

-- fish_capture_event
COMMENT ON TABLE public.fish_capture_event IS 'Data for fish encounters during capture type surveys such as mark-recapture';
COMMENT ON COLUMN fish_capture_event.fish_capture_event_id IS 'Universally unique primary key';
COMMENT ON COLUMN fish_capture_event.fish_encounter_id IS 'Link to fish_encounter table';
COMMENT ON COLUMN fish_capture_event.fish_capture_status_id IS 'Current capture status (maiden, recapture, etc.)';
COMMENT ON COLUMN fish_capture_event.disposition_type_id IS 'What happened to fish after encounter?';
COMMENT ON COLUMN fish_capture_event.disposition_id IS 'Disposition of dead fish (in WDFW hatcheries terminology)';
COMMENT ON COLUMN fish_capture_event.disposition_location_id IS 'Link to location table';

-- fish_capture_status_lut
COMMENT ON TABLE public.fish_capture_status_lut IS 'Current capture status (maiden, recapture, etc.)';
COMMENT ON COLUMN fish_capture_status_lut.fish_capture_status_id IS 'Universally unique primary key';
COMMENT ON COLUMN fish_capture_status_lut.fish_capture_status_code IS 'Short code for capture status';
COMMENT ON COLUMN fish_capture_status_lut.fish_capture_status_description IS 'Description of capture status';

-- disposition_type_lut
COMMENT ON TABLE public.disposition_type_lut IS 'What happened to the fish after capture and processing?';
COMMENT ON COLUMN disposition_type_lut.disposition_type_id IS 'Universally unique primary key';
COMMENT ON COLUMN disposition_type_lut.disposition_type_code IS 'Short code for disposition type categories';
COMMENT ON COLUMN disposition_type_lut.disposition_type_description IS 'Description of disposition type categories';

-- disposition_lut
COMMENT ON TABLE public.disposition_lut IS 'Disposition of dead fish (in WDFW hatcheries terminology)';
COMMENT ON COLUMN disposition_lut.disposition_id IS 'Universally unique primary key';
COMMENT ON COLUMN disposition_lut.disposition_code IS 'Short code for disposition categories';
COMMENT ON COLUMN disposition_lut.fish_books_code IS 'WDFW hatcheries disposition code';
COMMENT ON COLUMN disposition_lut.disposition_description IS 'Description of disposition categories';

-- fish_mark
COMMENT ON TABLE public.fish_mark IS 'Data for marks and tags applied to fish';
COMMENT ON COLUMN fish_mark.fish_mark_id IS 'Universally unique primary key';
COMMENT ON COLUMN fish_mark.fish_encounter_id IS 'Link to fish_encounter table';
COMMENT ON COLUMN fish_mark.mark_type_id IS 'Type of mark or tag (fin clip, floy tag, etc)';
COMMENT ON COLUMN fish_mark.mark_status_id IS 'Status of mark or tag (applied, observed, etc.)';
COMMENT ON COLUMN fish_mark.mark_orientation_id IS 'Orientation of mark or tag (right, left, etc.)';
COMMENT ON COLUMN fish_mark.mark_placement_id IS 'Placement of mark or tag (adipose fin, snout, etc.)';
COMMENT ON COLUMN fish_mark.mark_size_id IS 'Size of mark or tag (large, medium, etc.)';
COMMENT ON COLUMN fish_mark.mark_color_id IS 'Color of mark or tag (blue, green, etc.)';
COMMENT ON COLUMN fish_mark.mark_shape_id IS 'Shape of mark or tag (star, circle, etc.)';
COMMENT ON COLUMN fish_mark.tag_number IS 'Tag number';

-- mark_type_lut
COMMENT ON TABLE public.mark_type_lut IS 'Type of mark or tag (fin clip, floy tag, etc)';
COMMENT ON COLUMN mark_type_lut.mark_type_id IS 'Universally unique primary key';
COMMENT ON COLUMN mark_type_lut.mark_type_category_id IS 'Mark or tag?';
COMMENT ON COLUMN mark_type_lut.mark_type_code IS 'Short code for mark or tag';
COMMENT ON COLUMN mark_type_lut.mark_type_description IS 'Description of mark or tag';

-- mark_type_category_lut
COMMENT ON TABLE public.mark_type_category_lut IS 'Was it a mark or a tag?';
COMMENT ON COLUMN mark_type_category_lut.mark_type_category_id IS 'Universally unique primary key';
COMMENT ON COLUMN mark_type_category_lut.mark_type_category_name IS 'Mark or tag?';

-- mark_status_lut
COMMENT ON TABLE public.mark_status_lut IS 'Status of mark or tag (applied, observed, etc.)';
COMMENT ON COLUMN mark_status_lut.mark_status_id IS 'Universally unique primary key';
COMMENT ON COLUMN mark_status_lut.mark_status_description IS 'Description of mark status categories';

-- mark_orientation_lut
COMMENT ON TABLE public.mark_orientation_lut IS 'Orientation of mark or tag (right, left, etc.)';
COMMENT ON COLUMN mark_orientation_lut.mark_orientation_id IS 'Universally unique primary key';
COMMENT ON COLUMN mark_orientation_lut.mark_orientation_code IS 'Short code for mark orientation categories';
COMMENT ON COLUMN mark_orientation_lut.mark_orientation_description IS 'Description of mark orientation categories';

-- mark_placement_lut
COMMENT ON TABLE public.mark_placement_lut IS 'Placement of mark or tag (adipose fin, snout, etc.)';
COMMENT ON COLUMN mark_placement_lut.mark_placement_id IS 'Universally unique primary key';
COMMENT ON COLUMN mark_placement_lut.mark_placement_code IS 'Short code for mark placement categories';
COMMENT ON COLUMN mark_placement_lut.mark_placement_description IS 'Description of mark placement categories';

-- mark_size_lut
COMMENT ON TABLE public.mark_size_lut IS 'Size of mark or tag (large, medium, etc.)';
COMMENT ON COLUMN mark_size_lut.mark_size_id IS 'Universally unique primary key';
COMMENT ON COLUMN mark_size_lut.mark_size_code IS 'Short code for mark size categories';
COMMENT ON COLUMN mark_size_lut.mark_size_description IS 'Description of mark size categories';

-- mark_color_lut
COMMENT ON TABLE public.mark_color_lut IS 'Color of mark or tag (blue, green, etc.)';
COMMENT ON COLUMN mark_color_lut.mark_color_id IS 'Universally unique primary key';
COMMENT ON COLUMN mark_color_lut.mark_color_code IS 'Short code for mark color categories';
COMMENT ON COLUMN mark_color_lut.mark_color_name IS 'Name of mark color categories';

-- mark_shape_lut
COMMENT ON TABLE public.mark_shape_lut IS 'Shape of mark or tag (star, circle, etc.)';
COMMENT ON COLUMN mark_shape_lut.mark_shape_id IS 'Universally unique primary key';
COMMENT ON COLUMN mark_shape_lut.mark_shape_code IS 'Short code for mark shape categories';
COMMENT ON COLUMN mark_shape_lut.mark_shape_description IS 'Description of mark shape categories';

-- individual_fish
COMMENT ON TABLE public.individual_fish IS 'Data for individual fish';
COMMENT ON COLUMN individual_fish.individual_fish_id IS 'Universally unique primary key';
COMMENT ON COLUMN individual_fish.fish_encounter_id IS 'Link to fish_encounter table';
COMMENT ON COLUMN individual_fish.fish_condition_type_id IS 'Status of fish in terms of deterioration';
COMMENT ON COLUMN individual_fish.fish_trauma_type_id IS 'Categories of wounds or scars visible on fish';
COMMENT ON COLUMN individual_fish.gill_condition_type_id IS 'Condition of gills in terms of color';
COMMENT ON COLUMN individual_fish.spawn_condition_type_id IS 'Spawning condition of fish';
COMMENT ON COLUMN individual_fish.cwt_result_type_id IS 'CWT analysis result (decoded tag, no tag, etc.)';
COMMENT ON COLUMN individual_fish.age_code_id IS 'Age assessment categories as determined by the age laboratory';
COMMENT ON COLUMN individual_fish.percent_eggs_retained IS 'Estimated percent of eggs retained';
COMMENT ON COLUMN individual_fish.eggs_retained_gram IS 'Weight of retained eggs';
COMMENT ON COLUMN individual_fish.eggs_retained_number IS 'Estimated number of eggs retained';
COMMENT ON COLUMN individual_fish.fish_sample_number IS 'Carcass sample number';
COMMENT ON COLUMN individual_fish.scale_sample_card_number IS 'Scale card number';
COMMENT ON COLUMN individual_fish.scale_sample_position_number IS 'Position number on scale card';
COMMENT ON COLUMN individual_fish.cwt_snout_sample_number IS 'Coded-wire tag snout sample number';
COMMENT ON COLUMN individual_fish.cwt_tag_code IS 'Decoded coded-wire tag value';
COMMENT ON COLUMN individual_fish.genetic_sample_number IS 'Genetic sample number';
COMMENT ON COLUMN individual_fish.otolith_sample_number IS 'Otolith sample number';
COMMENT ON COLUMN individual_fish.comment_text IS 'Additional comments on individual fish';

-- fish_condition_type_lut
COMMENT ON TABLE public.fish_condition_type_lut IS 'Status of fish in terms of deterioration';
COMMENT ON COLUMN fish_condition_type_lut.fish_condition_type_id IS 'Universally unique primary key';
COMMENT ON COLUMN fish_condition_type_lut.fish_condition_short_description IS 'Short description of fish condition';
COMMENT ON COLUMN fish_condition_type_lut.fish_condition_description IS 'Full description of fish condition';

-- fish_trauma_type_lut
COMMENT ON TABLE public.fish_trauma_type_lut IS 'Categories of wounds or scars visible on fish';
COMMENT ON COLUMN fish_trauma_type_lut.fish_trauma_type_id IS 'Universally unique primary key';
COMMENT ON COLUMN fish_trauma_type_lut.trauma_type_short_description IS 'Short description of trauma type';
COMMENT ON COLUMN fish_trauma_type_lut.trauma_type_description IS 'Full description of trauma type';

-- gill_condition_type_lut
COMMENT ON TABLE public.gill_condition_type_lut IS 'Condition of gills in terms of color';
COMMENT ON COLUMN gill_condition_type_lut.gill_condition_type_id IS 'Universally unique primary key';
COMMENT ON COLUMN gill_condition_type_lut.gill_condition_type_description IS 'Description of gill condition';

-- spawn_condition_type_lut
COMMENT ON TABLE public.spawn_condition_type_lut IS 'Spawning condition of fish (pre, post, etc.)';
COMMENT ON COLUMN spawn_condition_type_lut.spawn_condition_type_id IS 'Universally unique primary key';
COMMENT ON COLUMN spawn_condition_type_lut.spawn_condition_short_description IS 'Short description of spawn condition';
COMMENT ON COLUMN spawn_condition_type_lut.spawn_condition_description IS 'Full description of spawn condition';

-- cwt_result_type_lut
COMMENT ON TABLE public.cwt_result_type_lut IS 'Result of CWT analysis (decoded tag, no tag, etc.)';
COMMENT ON COLUMN cwt_result_type_lut.cwt_result_type_id IS 'Universally unique primary key';
COMMENT ON COLUMN cwt_result_type_lut.cwt_result_type_code IS 'Matches CWT database result type code';
COMMENT ON COLUMN cwt_result_type_lut.cwt_result_type_short_description IS 'Short description of cwt result type';
COMMENT ON COLUMN cwt_result_type_lut.cwt_result_type_description IS 'Full description of cwt result type';

-- age_code_lut
COMMENT ON TABLE public.age_code_lut IS 'Age assessment categories as determined by fish age laboratory';
COMMENT ON COLUMN age_code_lut.age_code_id IS 'Universally unique primary key';
COMMENT ON COLUMN age_code_lut.european_age_code IS 'European age code, used to characterize fish age';
COMMENT ON COLUMN age_code_lut.gilbert_rich_age_code IS 'Gilbert-Rich age code, used to characterize fish age';
COMMENT ON COLUMN age_code_lut.fresh_water_annuli IS 'The number of annuli deposited while in fresh water';
COMMENT ON COLUMN age_code_lut.maiden_salt_water_annuli IS 'The number of annuli deposited during first migration into salt water';
COMMENT ON COLUMN age_code_lut.total_salt_water_annuli IS 'The total number of annuli deposited while in salt water';
COMMENT ON COLUMN age_code_lut.age_at_spawning IS 'Age of the fish at time of spawning';
COMMENT ON COLUMN age_code_lut.prior_spawn_event_count IS 'The estimated number of times the fish has spawned previously';

-- fish_length_measurement
COMMENT ON TABLE public.fish_length_measurement IS 'Individual fish length measurements (can be multiple per fish)';
COMMENT ON COLUMN fish_length_measurement.fish_length_measurement_id IS 'Universally unique primary key';
COMMENT ON COLUMN fish_length_measurement.individual_fish_id IS 'Link to individual_fish table';
COMMENT ON COLUMN fish_length_measurement.fish_length_measurement_type_id IS 'Type of length measurement (FL, POH, etc.)';
COMMENT ON COLUMN fish_length_measurement.length_measurement_centimeter IS 'Length in centimeter';

-- fish_length_measurement_type_lut
COMMENT ON TABLE public.fish_length_measurement_type_lut IS 'Types of length measurements';
COMMENT ON COLUMN fish_length_measurement_type_lut.fish_length_measurement_type_id IS 'Universally unique primary key';
COMMENT ON COLUMN fish_length_measurement_type_lut.length_type_code IS 'Short code for length measurement type';
COMMENT ON COLUMN fish_length_measurement_type_lut.length_type_description IS 'Description of length measurement type';

-- redd_encounter
COMMENT ON TABLE public.redd_encounter IS 'Data for redd encounters, includes data for one or multiple redds';
COMMENT ON COLUMN redd_encounter.redd_encounter_id IS 'Universally unique primary key';
COMMENT ON COLUMN redd_encounter.survey_event_id IS 'Link to survey_event table';
COMMENT ON COLUMN redd_encounter.redd_location_id IS 'Link to location table';
COMMENT ON COLUMN redd_encounter.redd_status_id IS 'Status of redds (new, still visible, etc.)';
COMMENT ON COLUMN redd_encounter.redd_encounter_datetime IS 'Time redds were encountered';
COMMENT ON COLUMN redd_encounter.redd_count IS 'Number of redds encountered';
COMMENT ON COLUMN redd_encounter.comment_text IS 'Additional comment on redd encounter';

-- redd_status_lut
COMMENT ON TABLE public.redd_status_lut IS 'Status of redds (new, old but still visible, etc.)';
COMMENT ON COLUMN redd_status_lut.redd_status_id IS 'Universally unique primary key';
COMMENT ON COLUMN redd_status_lut.redd_status_code IS 'Short code for redd status categories';
COMMENT ON COLUMN redd_status_lut.redd_status_short_description IS 'Short description of redd status categories';
COMMENT ON COLUMN redd_status_lut.redd_status_description IS 'Full description of redd status categories';

-- redd_confidence
COMMENT ON TABLE public.redd_confidence IS 'Assessment of redd observation (probably redd, test dig, etc.)';
COMMENT ON COLUMN redd_confidence.redd_confidence_id IS 'Universally unique primary key';
COMMENT ON COLUMN redd_confidence.redd_encounter_id IS 'Link to redd_encounter table';
COMMENT ON COLUMN redd_confidence.redd_confidence_type_id IS 'Categories of redd assessment and confidence';
COMMENT ON COLUMN redd_confidence.redd_confidence_review_status_id IS 'Status of redd assessment (prelim, final, etc.)';
COMMENT ON COLUMN redd_confidence.comment_text IS 'Additional comments on redd confidence';

-- redd_confidence_type_lut
COMMENT ON TABLE public.redd_confidence_type_lut IS 'Assessment categories for redd observation (probably redd, test dig, etc.)';
COMMENT ON COLUMN redd_confidence_type_lut.redd_confidence_type_id IS 'Universally unique primary key';
COMMENT ON COLUMN redd_confidence_type_lut.confidence_type_short_description IS 'Short description of assessment categories';
COMMENT ON COLUMN redd_confidence_type_lut.confidence_type_description IS 'Full description of assessment categories';

-- redd_confidence_review_status_lut
COMMENT ON TABLE public.redd_confidence_review_status_lut IS 'Status of redd assessment (preliminary, final, etc.)';
COMMENT ON COLUMN redd_confidence_review_status_lut.redd_confidence_review_status_id IS 'Universally unique primary key';
COMMENT ON COLUMN redd_confidence_review_status_lut.review_status_description IS 'Current status of redd observation review';

-- redd_substrate
COMMENT ON TABLE public.redd_substrate IS 'Types of substrate associated with redds';
COMMENT ON COLUMN redd_substrate.redd_substrate_id IS 'Universally unique primary key';
COMMENT ON COLUMN redd_substrate.redd_encounter_id IS 'Link to redd_encounter table';
COMMENT ON COLUMN redd_substrate.substrate_level_id IS 'Ranking of substrate types (most common, etc)';
COMMENT ON COLUMN redd_substrate.substrate_type_id IS 'Substrate types (cobble, gravel, etc.)';
COMMENT ON COLUMN redd_substrate.substrate_percent IS 'Relative proportion of substrate type at redd site';

-- substrate_level_lut
COMMENT ON TABLE public.substrate_level_lut IS 'Ranking of substrate types present at redd site (primary, secondary, etc)';
COMMENT ON COLUMN substrate_level_lut.substrate_level_id IS 'Universally unique primary key';
COMMENT ON COLUMN substrate_level_lut.substrate_level_short_description IS 'Short description of substrate categories';
COMMENT ON COLUMN substrate_level_lut.substrate_level_description IS 'Full description of substrate categories';

-- substrate_type_lut
COMMENT ON TABLE public.substrate_type_lut IS 'Types of substrate present at redd site (cobble, gravel, etc.)';
COMMENT ON COLUMN substrate_type_lut.substrate_type_id IS 'Universally unique primary key';
COMMENT ON COLUMN substrate_type_lut.substrate_type_description IS 'Description of substrate types';

-- individual_redd
COMMENT ON TABLE public.individual_redd IS 'Data for individual redd';
COMMENT ON COLUMN individual_redd.individual_redd_id IS 'Universally unique primary key';
COMMENT ON COLUMN individual_redd.redd_encounter_id IS 'Link to redd_encounter table';
COMMENT ON COLUMN individual_redd.redd_shape_id IS 'Redd shape (oval, teardrop, etc.)';
COMMENT ON COLUMN individual_redd.redd_dewatered_type_id IS 'Was the redd dewatered? (all, part, etc.)';
COMMENT ON COLUMN individual_redd.percent_redd_visible IS 'Percent of redd that is still visible';
COMMENT ON COLUMN individual_redd.redd_length_measure_meter IS 'Length of redd in meters';
COMMENT ON COLUMN individual_redd.redd_width_measure_meter IS 'Width of redd in meters';
COMMENT ON COLUMN individual_redd.redd_depth_measure_meter IS 'Depth of redd in meters';
COMMENT ON COLUMN individual_redd.tailspill_height_measure_meter IS 'Height of tailspill in meters';
COMMENT ON COLUMN individual_redd.percent_redd_superimposed IS 'Percent of redd that has been superimposed';
COMMENT ON COLUMN individual_redd.percent_redd_degraded IS 'Percent of redd that was degraded';
COMMENT ON COLUMN individual_redd.superimposed_redd_name IS 'The name or id of the redd that was superimposed';
COMMENT ON COLUMN individual_redd.comment_text IS 'Additional comments for individual redd';

-- redd_shape_lut
COMMENT ON TABLE public.redd_shape_lut IS 'Redd shape (oval, teardrop, etc.)';
COMMENT ON COLUMN redd_shape_lut.redd_shape_id IS 'Universally unique primary key';
COMMENT ON COLUMN redd_shape_lut.redd_shape_description IS 'Description of redd shape types';

-- redd_dewatered_type_lut
COMMENT ON TABLE public.redd_dewatered_type_lut IS 'Was the redd dewatered? (all, part, etc.)';
COMMENT ON COLUMN redd_dewatered_type_lut.redd_dewatered_type_id IS 'Universally unique primary key';
COMMENT ON COLUMN redd_dewatered_type_lut.dewatered_type_description IS 'Description of dewatered status';


