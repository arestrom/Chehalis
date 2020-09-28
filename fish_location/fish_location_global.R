
# Query for newly entered fish_locations
get_new_fish_location = function(waterbody_id) {
  # Define query for new fish locations...no attached surveys yet...finds new entries
  qry = glue("select floc.location_id as fish_location_id, ",
             "floc.location_name as fish_name, ",
             "lc.location_coordinates_id, ",
             "st_x(st_transform(lc.geom, 4326)) as longitude, ",
             "st_y(st_transform(lc.geom, 4326)) as latitude, ",
             "lc.horizontal_accuracy as horiz_accuracy, ",
             "sc.channel_type_description as channel_type, ",
             "lo.orientation_type_description as orientation_type, ",
             "floc.location_description, ",
             "floc.created_datetime as created_date, ",
             "floc.modified_datetime as modified_date, ",
             "floc.created_by, floc.modified_by ",
             "from spawning_ground.location as floc ",
             "inner join spawning_ground.location_type_lut as lt on floc.location_type_id = lt.location_type_id ",
             "left join spawning_ground.location_coordinates as lc on floc.location_id = lc.location_id ",
             "left join spawning_ground.fish_encounter as fe on floc.location_id = fe.fish_location_id ",
             "inner join spawning_ground.stream_channel_type_lut as sc on floc.stream_channel_type_id = sc.stream_channel_type_id ",
             "inner join spawning_ground.location_orientation_type_lut as lo on floc.location_orientation_type_id = lo.location_orientation_type_id ",
             "where floc.created_datetime > now() - interval '1 day' ",
             "and fe.fish_encounter_id is null ",
             "and floc.waterbody_id = '{waterbody_id}' ",
             "and lt.location_type_description = 'Fish encounter'")
  con = poolCheckout(pool)
  new_loc = DBI::dbGetQuery(con, qry)
  poolReturn(con)
  return(new_loc)
}

# Query for previously entered fish_locations
get_previous_fish_location = function(waterbody_id, up_rm, lo_rm, survey_date, species_id) {
  # Define query for fish locations already tied to surveys
  qry = glue("select s.survey_datetime as fish_survey_date, ",
             "se.species_id as db_species_id, ",
             "sp.common_name as species, uploc.river_mile_measure as up_rm, ",
             "loloc.river_mile_measure as lo_rm, floc.location_id as fish_location_id, ",
             "floc.location_name as fish_name, fs.fish_status_description as fish_status, ",
             "lc.location_coordinates_id, ",
             "st_x(st_transform(lc.geom, 4326)) as longitude, ",
             "st_y(st_transform(lc.geom, 4326)) as latitude, ",
             "lc.horizontal_accuracy as horiz_accuracy, ",
             "sc.channel_type_description as channel_type, ",
             "lo.orientation_type_description as orientation_type, ",
             "floc.location_description, ",
             "floc.created_datetime as created_date, ",
             "floc.modified_datetime as modified_date,  ",
             "floc.created_by, floc.modified_by ",
             "from spawning_ground.survey as s ",
             "inner join spawning_ground.location as uploc on s.upper_end_point_id = uploc.location_id ",
             "inner join spawning_ground.location as loloc on s.lower_end_point_id = loloc.location_id ",
             "inner join spawning_ground.survey_event as se on s.survey_id = se.survey_id ",
             "inner join spawning_ground.species_lut as sp on se.species_id = sp.species_id ",
             "inner join spawning_ground.fish_encounter as fe on se.survey_event_id = fe.survey_event_id ",
             "inner join spawning_ground.fish_status_lut as fs on fe.fish_status_id = fs.fish_status_id ",
             "inner join spawning_ground.location as floc on fe.fish_location_id = floc.location_id ",
             "left join spawning_ground.location_coordinates as lc on floc.location_id = lc.location_id ",
             "inner join spawning_ground.stream_channel_type_lut as sc on floc.stream_channel_type_id = sc.stream_channel_type_id ",
             "inner join spawning_ground.location_orientation_type_lut as lo on floc.location_orientation_type_id = lo.location_orientation_type_id ",
             "where s.survey_datetime > date '{survey_date}' - interval '3 months' ",
             "and s.survey_datetime <= date '{survey_date}' + interval '8 hours' ",
             "and floc.waterbody_id = '{waterbody_id}' ",
             "and uploc.river_mile_measure <= {up_rm} ",
             "and loloc.river_mile_measure >= {lo_rm} ",
             "and se.species_id = '{species_id}' ",
             "and fs.fish_status_description = 'Dead'")
  con = poolCheckout(pool)
  prev_loc = DBI::dbGetQuery(con, qry)
  poolReturn(con)
  return(prev_loc)
}

# Main fish_location query...includes carcass locations within time-span three months prior
get_fish_locations = function(waterbody_id, up_rm, lo_rm, survey_date, species_id) {
  new_locs = get_new_fish_location(waterbody_id)
  # Get pre-existing redd locations
  prev_locs = get_previous_fish_location(waterbody_id, up_rm, lo_rm, survey_date, species_id)
  fish_locations = bind_rows(new_locs, prev_locs) %>%
    mutate(latitude = round(latitude, 7)) %>%
    mutate(longitude = round(longitude, 7)) %>%
    mutate(fish_survey_date = with_tz(fish_survey_date, tzone = "America/Los_Angeles")) %>%
    mutate(survey_dt = format(fish_survey_date, "%m/%d/%Y")) %>%
    mutate(created_date = with_tz(created_date, tzone = "America/Los_Angeles")) %>%
    mutate(created_dt = format(created_date, "%m/%d/%Y %H:%M")) %>%
    mutate(modified_date = with_tz(modified_date, tzone = "America/Los_Angeles")) %>%
    mutate(modified_dt = format(modified_date, "%m/%d/%Y %H:%M")) %>%
    select(fish_location_id, location_coordinates_id,
           survey_date = fish_survey_date, survey_dt, species,
           fish_name, fish_status, latitude, longitude, horiz_accuracy,
           channel_type, orientation_type, location_description,
           created_date, created_dt, created_by, modified_date,
           modified_dt, modified_by) %>%
    arrange(created_date)
  return(fish_locations)
}

#==========================================================================
# Get just the redd_coordinates
#==========================================================================

# fish_coordinates query
get_fish_coordinates = function(fish_location_id) {
  qry = glue("select loc.location_id, lc.location_coordinates_id, ",
             "st_x(st_transform(lc.geom, 4326)) as longitude, ",
             "st_y(st_transform(lc.geom, 4326)) as latitude, ",
             "lc.horizontal_accuracy as horiz_accuracy, ",
             "lc.created_datetime as created_date, lc.created_by, ",
             "lc.modified_datetime as modified_date, lc.modified_by ",
             "from spawning_ground.location as loc ",
             "inner join spawning_ground.location_coordinates as lc on loc.location_id = lc.location_id ",
             "where loc.location_id = '{fish_location_id}'")
  con = poolCheckout(pool)
  fish_coordinates = DBI::dbGetQuery(con, qry)
  poolReturn(con)
  fish_coordinates = fish_coordinates %>%
    mutate(latitude = round(latitude, 7)) %>%
    mutate(longitude = round(longitude, 7)) %>%
    mutate(created_date = with_tz(created_date, tzone = "America/Los_Angeles")) %>%
    mutate(created_dt = format(created_date, "%m/%d/%Y %H:%M")) %>%
    mutate(modified_date = with_tz(modified_date, tzone = "America/Los_Angeles")) %>%
    mutate(modified_dt = format(modified_date, "%m/%d/%Y %H:%M")) %>%
    select(fish_location_id = location_id, location_coordinates_id,
           latitude, longitude, horiz_accuracy, created_date,
           created_dt, created_by, modified_date, modified_dt,
           modified_by) %>%
    arrange(created_date)
  return(fish_coordinates)
}

#==========================================================================
# Get generic lut input values
#==========================================================================

# Redd status
get_fish_channel_type = function() {
  qry = glue("select stream_channel_type_id, channel_type_description as channel_type ",
             "from spawning_ground.stream_channel_type_lut ",
             "where obsolete_datetime is null")
  con = poolCheckout(pool)
  channel_type_list = DBI::dbGetQuery(con, qry) %>%
    arrange(channel_type) %>%
    select(stream_channel_type_id, channel_type)
  poolReturn(con)
  return(channel_type_list)
}

# Redd status
get_fish_orientation_type = function() {
  qry = glue("select location_orientation_type_id, orientation_type_description as orientation_type ",
             "from spawning_ground.location_orientation_type_lut ",
             "where obsolete_datetime is null")
  con = poolCheckout(pool)
  orientation_type_list = DBI::dbGetQuery(con, qry) %>%
    arrange(orientation_type) %>%
    select(location_orientation_type_id, orientation_type)
  poolReturn(con)
  return(orientation_type_list)
}

#========================================================
# Insert callback
#========================================================

# Define the insert callback
fish_location_insert = function(new_fish_location_values) {
  new_insert_values = new_fish_location_values
  # Generate location_id
  location_id = get_uuid(1L)
  created_by = new_insert_values$created_by
  # Pull out location_coordinates table data
  horizontal_accuracy = as.numeric(new_insert_values$horiz_accuracy)
  latitude = new_insert_values$latitude
  longitude = new_insert_values$longitude
  # Pull out location table data
  waterbody_id = new_insert_values$waterbody_id
  wria_id = new_insert_values$wria_id
  location_type_id = new_insert_values$location_type_id
  stream_channel_type_id = new_insert_values$stream_channel_type_id
  location_orientation_type_id = new_insert_values$location_orientation_type_id
  location_name = new_insert_values$fish_name
  location_description = new_insert_values$location_description
  if (is.na(location_name) | location_name == "") { location_name = NA }
  if (is.na(location_description) | location_description == "") { location_description = NA }
  # Insert to location table
  con = poolCheckout(pool)
  insert_loc_result = dbSendStatement(
    con, glue_sql("INSERT INTO spawning_ground.location (",
                  "location_id, ",
                  "waterbody_id, ",
                  "wria_id, ",
                  "location_type_id, ",
                  "stream_channel_type_id, ",
                  "location_orientation_type_id, ",
                  "location_name, ",
                  "location_description, ",
                  "created_by) ",
                  "VALUES (",
                  "$1, $2, $3, $4, $5, $6, $7, $8, $9)"))
  dbBind(insert_loc_result, list(location_id, waterbody_id, wria_id,
                                 location_type_id, stream_channel_type_id,
                                 location_orientation_type_id, location_name,
                                 location_description, created_by))
  dbGetRowsAffected(insert_loc_result)
  dbClearResult(insert_loc_result)
  # Insert coordinates to location_coordinates
  if (!is.na(latitude) & !is.na(longitude) ) {
    qry = glue_sql("INSERT INTO spawning_ground.location_coordinates ",
                   "(location_id, horizontal_accuracy, geom, created_by) ",
                   "VALUES ({location_id}, {horizontal_accuracy}, ",
                   "ST_Transform(ST_GeomFromText('POINT({longitude} {latitude})', 4326), 2927), ",
                   "{created_by}) ",
                   .con = con)
    DBI::dbExecute(con, qry)
  }
  poolReturn(con)
}

#==============================================================
# Identify fish location surveys prior to update or delete
#==============================================================

# Identify fish_encounter dependencies prior to delete
get_fish_location_surveys = function(fish_location_id) {
  qry = glue("select s.survey_datetime as survey_date, ",
             "s.observer_last_name as observer, loc.location_name as fish_name, ",
             "fe.fish_count, mt.media_type_code as media_type, ",
             "ot.observation_type_name as other_observation_type ",
             "from spawning_ground.location as loc ",
             "left join spawning_ground.fish_encounter as fe on loc.location_id = fe.fish_location_id ",
             "left join spawning_ground.survey_event as se on fe.survey_event_id = se.survey_event_id ",
             "left join spawning_ground.survey as s on se.survey_id = s.survey_id ",
             "left join spawning_ground.media_location as ml on loc.location_id = ml.location_id ",
             "left join spawning_ground.media_type_lut as mt on ml.media_type_id = mt.media_type_id ",
             "left join spawning_ground.other_observation as oo on loc.location_id = oo.observation_location_id ",
             "left join spawning_ground.observation_type_lut as ot on oo.observation_type_id = ot.observation_type_id ",
             "where fe.fish_location_id is not null and loc.location_id = '{fish_location_id}'")
  con = poolCheckout(pool)
  fish_loc_surveys = DBI::dbGetQuery(con, qry)
  poolReturn(con)
  fish_loc_surveys = fish_loc_surveys %>%
    mutate(survey_date = with_tz(survey_date, tzone = "America/Los_Angeles")) %>%
    mutate(survey_date = format(survey_date, "%m/%d/%Y"))
  return(fish_loc_surveys)
}

#========================================================
# Edit location callback
#========================================================

# Define update callback
fish_location_update = function(fish_location_edit_values, selected_fish_location_data) {
  edit_values = fish_location_edit_values
  # Pull out data for location table
  location_id = edit_values$fish_location_id
  stream_channel_type_id = edit_values$stream_channel_type_id
  location_orientation_type_id = edit_values$location_orientation_type_id
  location_name = edit_values$fish_name
  location_description = edit_values$location_description
  if (is.na(location_name) | location_name == "") { location_name = NA }
  if (is.na(location_description) | location_description == "") { location_description = NA }
  mod_dt = lubridate::with_tz(Sys.time(), "UTC")
  mod_by = Sys.getenv("USERNAME")
  created_by = mod_by
  # Pull out data for location_coordinates table
  horizontal_accuracy = edit_values$horiz_accuracy
  latitude = edit_values$latitude
  longitude = edit_values$longitude
  # Checkout a connection
  con = poolCheckout(pool)
  update_result = dbSendStatement(
    con, glue_sql("UPDATE spawning_ground.location SET ",
                  "stream_channel_type_id = $1, ",
                  "location_orientation_type_id = $2, ",
                  "location_name = $3, ",
                  "location_description = $4, ",
                  "modified_datetime = $5, ",
                  "modified_by = $6 ",
                  "where location_id = $7"))
  dbBind(update_result, list(stream_channel_type_id,
                             location_orientation_type_id,
                             location_name, location_description,
                             mod_dt, mod_by,
                             location_id))
  dbGetRowsAffected(update_result)
  dbClearResult(update_result)
  # Insert coordinates to location_coordinates if previous entry does not exist
  if ( is.na(selected_fish_location_data$latitude) & is.na(selected_fish_location_data$longitude) ) {
    if ( !is.na(latitude) & !is.na(longitude) ) {
      # Insert coordinates to location_coordinates
      qry = glue_sql("INSERT INTO spawning_ground.location_coordinates ",
                     "(location_id, horizontal_accuracy, geom, created_by) ",
                     "VALUES ({location_id}, {horizontal_accuracy}, ",
                     "ST_Transform(ST_GeomFromText('POINT({longitude} {latitude})', 4326), 2927), ",
                     "{created_by}) ",
                     .con = con)
      DBI::dbExecute(con, qry)
    }
    # Otherwise update coordinates if previous entry does exist
  } else if (!is.na(selected_fish_location_data$latitude) & !is.na(selected_fish_location_data$longitude) ) {
    if ( !is.na(latitude) & !is.na(longitude) ) {
      qry = glue_sql("UPDATE spawning_ground.location_coordinates ",
                     "SET horizontal_accuracy = {horizontal_accuracy}, ",
                     "geom = ST_Transform(ST_GeomFromText('POINT({longitude} {latitude})', 4326), 2927), ",
                     "modified_datetime = {mod_dt}, modified_by = {mod_by} ",
                     "WHERE location_id = {location_id} ",
                     .con = con)
      DBI::dbExecute(con, qry)
    }
  }
  poolReturn(con)
}

#========================================================
# Identify fish location dependencies prior to delete
#========================================================

# Identify fish_encounter dependencies prior to delete
get_fish_location_dependencies = function(fish_location_id) {
  qry = glue("select fd.fish_encounter_id, fd.fish_encounter_datetime as fish_encounter_time, ",
             "fd.fish_count, fs.fish_status_description as fish_status, ",
             "fd.fish_location_id, loc.location_name as fish_name, ",
             "fd.created_datetime as created_date, fd.created_by, ",
             "fd.modified_datetime as modified_date, fd.modified_by ",
             "from spawning_ground.fish_encounter as fd ",
             "inner join spawning_ground.fish_status_lut as fs on fd.fish_status_id = fs.fish_status_id ",
             "left join spawning_ground.location as loc on fd.fish_location_id = loc.location_id ",
             "where fd.fish_location_id is not null and fd.fish_location_id = '{fish_location_id}'")
  con = poolCheckout(pool)
  fish_encounters = DBI::dbGetQuery(con, qry)
  poolReturn(con)
  fish_encounters = fish_encounters %>%
    mutate(fish_encounter_time = with_tz(fish_encounter_time, tzone = "America/Los_Angeles")) %>%
    mutate(fish_encounter_date = format(fish_encounter_time, "%m/%d/%Y")) %>%
    mutate(fish_encounter_time = format(fish_encounter_time, "%H:%M")) %>%
    mutate(created_date = with_tz(created_date, tzone = "America/Los_Angeles")) %>%
    mutate(created_dt = format(created_date, "%m/%d/%Y %H:%M")) %>%
    mutate(modified_date = with_tz(modified_date, tzone = "America/Los_Angeles")) %>%
    mutate(modified_dt = format(modified_date, "%m/%d/%Y %H:%M")) %>%
    select(fish_encounter_id, fish_encounter_date, fish_encounter_time, fish_count,
           fish_status, fish_location_id, fish_name, created_date,
           created_dt, created_by, modified_date, modified_dt, modified_by) %>%
    arrange(created_date)
  return(fish_encounters)
}

#========================================================
# Delete callback
#========================================================

# Define delete callback
fish_location_delete = function(delete_values) {
  fish_location_id = delete_values$fish_location_id
  con = poolCheckout(pool)
  # New function...delete only after all dependencies are removed
  delete_result_one = dbSendStatement(
    con, glue_sql("DELETE FROM spawning_ground.location_coordinates WHERE location_id = $1"))
  dbBind(delete_result_one, list(fish_location_id))
  dbGetRowsAffected(delete_result_one)
  dbClearResult(delete_result_one)
  delete_result_two = dbSendStatement(
    con, glue_sql("DELETE FROM spawning_ground.location WHERE location_id = $1"))
  dbBind(delete_result_two, list(fish_location_id))
  dbGetRowsAffected(delete_result_two)
  dbClearResult(delete_result_two)
  poolReturn(con)
}
