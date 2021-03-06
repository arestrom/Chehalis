
# Main redd_encounter query
get_reach_point = function(pool, waterbody_id) {
  qry = glue("select loc.location_id, ",
             "lc.location_coordinates_id, ",
             "loc.river_mile_measure as river_mile, ",
             "loc.location_code as reach_point_code, ",
             "loc.location_name as reach_point_name, ",
             "lt.location_type_description as reach_point_type, ",
             "st_x(st_transform(lc.geom, 4326)) as longitude, ",
             "st_y(st_transform(lc.geom, 4326)) as latitude, ",
             "lc.horizontal_accuracy as horiz_accuracy, ",
             "loc.location_description as reach_point_description, ",
             "loc.created_datetime as created_date, loc.created_by, ",
             "loc.modified_datetime as modified_date, loc.modified_by ",
             "from spawning_ground.location as loc ",
             "left join spawning_ground.location_type_lut as lt on loc.location_type_id = lt.location_type_id ",
             "left join spawning_ground.location_coordinates as lc on loc.location_id = lc.location_id ",
             "where loc.waterbody_id = '{waterbody_id}' ",
             "and lt.location_type_description in ('Reach boundary point', 'Section break point')")
  con = poolCheckout(pool)
  reach_points = DBI::dbGetQuery(con, qry)
  poolReturn(con)
  reach_points = reach_points %>%
    mutate(river_mile = round(river_mile, 2)) %>%
    mutate(latitude = round(latitude, 7)) %>%
    mutate(longitude = round(longitude, 7)) %>%
    mutate(created_date = with_tz(created_date, tzone = "America/Los_Angeles")) %>%
    mutate(created_dt = format(created_date, "%m/%d/%Y %H:%M")) %>%
    mutate(modified_date = with_tz(modified_date, tzone = "America/Los_Angeles")) %>%
    mutate(modified_dt = format(modified_date, "%m/%d/%Y %H:%M")) %>%
    select(location_id, location_coordinates_id, reach_point_code,
           river_mile, reach_point_name, reach_point_type,
           latitude, longitude, horiz_accuracy, reach_point_description,
           created_date, created_dt, created_by, modified_date, modified_dt,
           modified_by) %>%
    arrange(river_mile)
  return(reach_points)
}

#==========================================================================
# Get generic lut input values
#==========================================================================

# Location type....Some bios distinguish section breaks from reach end points
get_location_type = function(pool) {
  qry = glue("select location_type_id, location_type_description as reach_point_type ",
             "from spawning_ground.location_type_lut ",
             "where obsolete_datetime is null ",
             "and location_type_description in ('Reach boundary point', 'Section break point')")
  con = poolCheckout(pool)
  reach_point_type_list = DBI::dbGetQuery(con, qry) %>%
    arrange(reach_point_type) %>%
    select(location_type_id, reach_point_type)
  poolReturn(con)
  return(reach_point_type_list)
}

#========================================================
# Insert callback
#========================================================

# Define the insert callback
reach_point_insert = function(pool, new_reach_point_values) {
  new_insert_values = new_reach_point_values
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
  river_mile_measure = new_insert_values$river_mile
  location_code = new_insert_values$reach_point_code
  location_name = new_insert_values$reach_point_name
  location_description = new_insert_values$reach_point_description
  if (is.na(location_code) | location_code == "") { location_code = NA }
  if (is.na(location_name) | location_name == "") { location_name = NA }
  if (is.na(location_description) | location_description == "") { location_description = NA }
  # Insert to location table
  con = poolCheckout(pool)
  DBI::dbWithTransaction(con, {
    insert_rp_result = dbSendStatement(
      con, glue_sql("INSERT INTO spawning_ground.location (",
                    "location_id, ",
                    "waterbody_id, ",
                    "wria_id, ",
                    "location_type_id, ",
                    "stream_channel_type_id, ",
                    "location_orientation_type_id, ",
                    "river_mile_measure, ",
                    "location_code, ",
                    "location_name, ",
                    "location_description, ",
                    "created_by) ",
                    "VALUES (",
                    "$1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11)"))
    dbBind(insert_rp_result, list(location_id, waterbody_id, wria_id,
                                  location_type_id, stream_channel_type_id,
                                  location_orientation_type_id, river_mile_measure,
                                  location_code, location_name,
                                  location_description, created_by))
    dbGetRowsAffected(insert_rp_result)
    dbClearResult(insert_rp_result)
    # Insert coordinates to location_coordinates
    if (!is.na(latitude) & !is.na(longitude) ) {
      # Insert coordinates to location_coordinates
      insert_lc_result = dbSendStatement(
        con, glue_sql("INSERT INTO spawning_ground.location_coordinates (",
                      "location_id, ",
                      "horizontal_accuracy, ",
                      "geom, ",
                      "created_by) ",
                      "VALUES (",
                      "$1, $2, ",
                      "ST_Transform(ST_GeomFromText('POINT({longitude} {latitude})', 4326), 2927), ",
                      "$3)"))
      dbBind(insert_lc_result, list(location_id, horizontal_accuracy, created_by))
      dbGetRowsAffected(insert_lc_result)
      dbClearResult(insert_lc_result)
    }
  })
  poolReturn(con)
}

#==============================================================
# Identify reach_point surveys prior to update or delete
#==============================================================

# Identify reach_point dependencies prior to delete
get_reach_point_surveys = function(pool, location_id) {
  qry = glue("select s.survey_datetime as survey_date, ",
             "locu.river_mile_measure as upper_river_mile, ",
             "locl.river_mile_measure as lower_river_mile, ",
             "s.observer_last_name as observer ",
             "from spawning_ground.survey as s ",
             "left join spawning_ground.location as locu on s.upper_end_point_id = locu.location_id ",
             "left join spawning_ground.location as locl on s.lower_end_point_id = locl.location_id ",
             "where locu.location_id = '{location_id}' or locl.location_id = '{location_id}'")
  con = poolCheckout(pool)
  reach_point_surveys = DBI::dbGetQuery(con, qry)
  poolReturn(con)
  reach_point_surveys = reach_point_surveys %>%
    mutate(survey_date = with_tz(survey_date, tzone = "America/Los_Angeles")) %>%
    mutate(survey_dt = format(survey_date, "%m/%d/%Y"))
  return(reach_point_surveys)
}

#========================================================
# Edit reach_point callback
#========================================================

# Define update callback
reach_point_update = function(pool, reach_point_edit_values, selected_reach_point_data) {
  edit_values = reach_point_edit_values
  # Pull out data for location table
  location_id = edit_values$location_id
  location_type_id = edit_values$location_type_id
  river_mile_measure = edit_values$river_mile
  location_code= edit_values$reach_point_code
  location_name = edit_values$reach_point_name
  location_description = edit_values$reach_point_description
  if (is.na(location_code) | location_code == "") { location_code = NA }
  if (is.na(location_name) | location_name == "") { location_name = NA }
  if (is.na(location_description) | location_description == "") { location_description = NA }
  mod_dt = format(lubridate::with_tz(Sys.time(), "UTC"))
  mod_by = Sys.getenv("USERNAME")
  created_by = Sys.getenv("USERNAME")
  # Pull out data for location_coordinates table
  horizontal_accuracy = edit_values$horiz_accuracy
  latitude = edit_values$latitude
  longitude = edit_values$longitude
  # Checkout a connection
  con = poolCheckout(pool)
  DBI::dbWithTransaction(con, {
    update_result = dbSendStatement(
      con, glue_sql("UPDATE spawning_ground.location SET ",
                    "location_type_id = $1, ",
                    "river_mile_measure = $2, ",
                    "location_code = $3, ",
                    "location_name = $4, ",
                    "location_description = $5, ",
                    "modified_datetime = $6, ",
                    "modified_by = $7 ",
                    "where location_id = $8"))
    dbBind(update_result, list(location_type_id, river_mile_measure,
                               location_code, location_name,
                               location_description,
                               mod_dt, mod_by,
                               location_id))
    dbGetRowsAffected(update_result)
    dbClearResult(update_result)
    # Insert coordinates to location_coordinates if previous entry does not exist
    if ( is.na(selected_reach_point_data$latitude) & is.na(selected_reach_point_data$longitude) ) {
      if ( !is.na(latitude) & !is.na(longitude) ) {
        # Insert coordinates to location_coordinates
        insert_lc_result = dbSendStatement(
          con, glue_sql("INSERT INTO spawning_ground.location_coordinates (",
                        "location_id, ",
                        "horizontal_accuracy, ",
                        "geom, ",
                        "created_by) ",
                        "VALUES (",
                        "$1, $2, ",
                        "ST_Transform(ST_GeomFromText('POINT({longitude} {latitude})', 4326), 2927), ",
                        "$3)"))
        dbBind(insert_lc_result, list(location_id, horizontal_accuracy, created_by))
        dbGetRowsAffected(insert_lc_result)
        dbClearResult(insert_lc_result)
      }
    # Otherwise update coordinates if previous entry does exist
    } else if (!is.na(selected_reach_point_data$latitude) & !is.na(selected_reach_point_data$longitude) ) {
      if ( !is.na(latitude) & !is.na(longitude) ) {
        update_lc_result = dbSendStatement(
          con, glue_sql("UPDATE spawning_ground.location_coordinates SET ",
                        "horizontal_accuracy = $1, ",
                        "geom = ST_Transform(ST_GeomFromText('POINT({longitude} {latitude})', 4326), 2927), ",
                        "modified_datetime = $2, ",
                        "modified_by = $3 ",
                        "where location_id = $4"))
        dbBind(update_lc_result, list(horizontal_accuracy, mod_dt,
                                      mod_by, location_id))
        dbGetRowsAffected(update_lc_result)
        dbClearResult(update_lc_result)
      } else if ( is.na(latitude) | is.na(longitude) ) {
        dump_coords_result = dbSendStatement(
          con, glue_sql("DELETE FROM spawning_ground.location_coordinates ",
                        "WHERE location_id = $1"))
        dbBind(dump_coords_result, list(location_id))
        dbGetRowsAffected(dump_coords_result)
        dbClearResult(dump_coords_result)
      }
    }
  })
  poolReturn(con)
}

#========================================================
# Identify reach_point dependencies prior to delete
#========================================================

# Identify fish_encounter dependencies prior to delete
get_reach_point_dependencies = function(pool, location_id) {
  qry = glue("select ",
             "count(fp.fish_passage_feature_id) as fish_passage_feature, ",
             "count(fce.fish_capture_event_id) as fish_capture_event, ",
             "count(fe.fish_encounter_id) as fish_encounter, ",
             "count(ml.media_location_id) as media_location, ",
             "count(oo.other_observation_id) as other_observation, ",
             "count(rd.redd_encounter_id) as redd_encounter, ",
             "count(s.survey_id) as survey ",
             "from spawning_ground.location as loc ",
             "left join spawning_ground.fish_passage_feature as fp on loc.location_id = fp.feature_location_id ",
             "left join spawning_ground.fish_capture_event as fce on loc.location_id = fce.disposition_location_id ",
             "left join spawning_ground.fish_encounter as fe on loc.location_id = fe.fish_location_id ",
             "left join spawning_ground.media_location as ml on loc.location_id = ml.location_id ",
             "left join spawning_ground.other_observation as oo on loc.location_id = oo.observation_location_id ",
             "left join spawning_ground.redd_encounter as rd on loc.location_id = rd.redd_location_id ",
             "left join spawning_ground.survey as s on (loc.location_id = s.upper_end_point_id or ",
             "loc.location_id = s.lower_end_point_id) ",
             "where loc.location_id = '{location_id}'")
  con = poolCheckout(pool)
  reach_point_dependents = DBI::dbGetQuery(con, qry)
  poolReturn(con)
  has_entries = function(x) any(x > 0L)
  reach_point_dependents = reach_point_dependents %>%
    select_if(has_entries)
  return(reach_point_dependents)
}

#========================================================
# Delete callback
#========================================================

# Define delete callback
reach_point_delete = function(pool, delete_values) {
  location_id = delete_values$location_id
  # Checkout a connection
  con = poolCheckout(pool)
  delete_result_one = dbSendStatement(
    con, glue_sql("DELETE FROM spawning_ground.location_coordinates ",
                  "WHERE location_id = $1"))
  dbBind(delete_result_one, list(location_id))
  dbGetRowsAffected(delete_result_one)
  dbClearResult(delete_result_one)
  delete_result_two = dbSendStatement(
    con, glue_sql("DELETE FROM spawning_ground.location ",
                  "WHERE location_id = $1"))
  dbBind(delete_result_two, list(location_id))
  dbGetRowsAffected(delete_result_two)
  dbClearResult(delete_result_two)
  poolReturn(con)
}
