
# Main fish_encounter query
get_fish_encounter = function(pool, survey_event_id) {
  qry = glue("select fe.fish_encounter_id, fe.fish_encounter_datetime as fish_encounter_time, ",
             "fe.fish_count, fs.fish_status_description as fish_status, ",
             "fe.fish_location_id, loc.location_name as fish_name, ",
             "sx.sex_description as sex, ma.maturity_short_description as maturity, ",
             "ori.origin_description as origin, cw.detection_status_description as cwt_status, ",
             "ad.adipose_clip_status_description as clip_status, ",
             "fb.behavior_short_description as fish_behavior, ",
             "fe.previously_counted_indicator as prev_counted, ",
             "fe.created_datetime as created_date, fe.created_by, ",
             "fe.modified_datetime as modified_date, fe.modified_by ",
             "from spawning_ground.fish_encounter as fe ",
             "left join spawning_ground.fish_status_lut as fs on fe.fish_status_id = fs.fish_status_id ",
             "left join spawning_ground.location as loc on fe.fish_location_id = loc.location_id ",
             "left join spawning_ground.sex_lut as sx on fe.sex_id = sx.sex_id ",
             "left join spawning_ground.maturity_lut as ma on fe.maturity_id = ma.maturity_id ",
             "left join spawning_ground.origin_lut as ori on fe.origin_id = ori.origin_id ",
             "left join spawning_ground.cwt_detection_status_lut as cw on fe.cwt_detection_status_id = cw.cwt_detection_status_id ",
             "left join spawning_ground.adipose_clip_status_lut as ad on fe.adipose_clip_status_id = ad.adipose_clip_status_id ",
             "left join spawning_ground.fish_behavior_type_lut as fb on fe.fish_behavior_type_id = fb.fish_behavior_type_id ",
             "where fe.survey_event_id = '{survey_event_id}'")
  con = poolCheckout(pool)
  fish_encounters = DBI::dbGetQuery(con, qry)
  poolReturn(con)
  fish_encounters = fish_encounters %>%
    mutate(fish_encounter_time = with_tz(fish_encounter_time, tzone = "America/Los_Angeles")) %>%
    mutate(fish_encounter_dt = format(fish_encounter_time, "%H:%M")) %>%
    mutate(prev_counted = if_else(prev_counted == 0L, "No", "Yes")) %>%
    mutate(created_date = with_tz(created_date, tzone = "America/Los_Angeles")) %>%
    mutate(created_dt = format(created_date, "%m/%d/%Y %H:%M")) %>%
    mutate(modified_date = with_tz(modified_date, tzone = "America/Los_Angeles")) %>%
    mutate(modified_dt = format(modified_date, "%m/%d/%Y %H:%M")) %>%
    select(fish_encounter_id, fish_encounter_time, fish_encounter_dt, fish_count,
           fish_status, fish_location_id, fish_name, sex, maturity, origin,
           cwt_status, clip_status, fish_behavior, prev_counted, created_date,
           created_dt, created_by, modified_date, modified_dt, modified_by) %>%
    arrange(created_date)
  return(fish_encounters)
}

#==========================================================================
# Get generic lut input values
#==========================================================================

# Fish status
get_fish_status = function(pool) {
  qry = glue("select fish_status_id, fish_status_description as fish_status ",
             "from spawning_ground.fish_status_lut ",
             "where obsolete_datetime is null")
  con = poolCheckout(pool)
  fish_status_list = DBI::dbGetQuery(con, qry) %>%
    arrange(fish_status) %>%
    select(fish_status_id, fish_status)
  poolReturn(con)
  return(fish_status_list)
}

# Sex
get_sex = function(pool) {
  qry = glue("select sex_id, sex_description as sex ",
             "from spawning_ground.sex_lut ",
             "where obsolete_datetime is null")
  con = poolCheckout(pool)
  sex_list = DBI::dbGetQuery(con, qry) %>%
    arrange(sex) %>%
    select(sex_id, sex)
  poolReturn(con)
  return(sex_list)
}

# Maturity
get_maturity = function(pool) {
  qry = glue("select maturity_id, maturity_short_description as maturity ",
             "from spawning_ground.maturity_lut ",
             "where obsolete_datetime is null")
  con = poolCheckout(pool)
  maturity_list = DBI::dbGetQuery(con, qry) %>%
    arrange(maturity) %>%
    select(maturity_id, maturity)
  poolReturn(con)
  return(maturity_list)
}

# Origin
get_origin = function(pool) {
  qry = glue("select origin_id, origin_description as origin ",
             "from spawning_ground.origin_lut ",
             "where obsolete_datetime is null")
  con = poolCheckout(pool)
  origin_list = DBI::dbGetQuery(con, qry) %>%
    arrange(origin) %>%
    select(origin_id, origin)
  poolReturn(con)
  return(origin_list)
}

# CWT status
get_cwt_status = function(pool) {
  qry = glue("select cwt_detection_status_id, detection_status_description as cwt_status ",
             "from spawning_ground.cwt_detection_status_lut ",
             "where obsolete_datetime is null")
  con = poolCheckout(pool)
  cwt_status_list = DBI::dbGetQuery(con, qry) %>%
    mutate(cwt_status = if_else(cwt_status == "Coded-wire tag undetermined, e.g., no head",
                                "Tag undetermined, e.g., no head", cwt_status)) %>%
    arrange(cwt_status) %>%
    select(cwt_detection_status_id, cwt_status)
  poolReturn(con)
  return(cwt_status_list)
}

# Clip status
get_clip_status = function(pool) {
  qry = glue("select adipose_clip_status_id, adipose_clip_status_description as clip_status ",
             "from spawning_ground.adipose_clip_status_lut ",
             "where obsolete_datetime is null")
  con = poolCheckout(pool)
  clip_status_list = DBI::dbGetQuery(con, qry) %>%
    mutate(clip_status = if_else(clip_status == "Adipose fin checked but undetermined, e.g., too deteriorated",
                                 "Checked but UD, e.g., decayed", clip_status)) %>%
    arrange(clip_status) %>%
    select(adipose_clip_status_id, clip_status)
  poolReturn(con)
  return(clip_status_list)
}

# Fish behavior
get_fish_behavior = function(pool) {
  qry = glue("select fish_behavior_type_id, behavior_short_description as fish_behavior ",
             "from spawning_ground.fish_behavior_type_lut ",
             "where obsolete_datetime is null")
  con = poolCheckout(pool)
  fish_behavior_list = DBI::dbGetQuery(con, qry) %>%
    arrange(fish_behavior) %>%
    select(fish_behavior_type_id, fish_behavior)
  poolReturn(con)
  return(fish_behavior_list)
}

#========================================================
# Insert callback
#========================================================

# Define the insert callback
fish_encounter_insert = function(pool, new_fish_encounter_values) {
  new_insert_values = new_fish_encounter_values
  # Pull out data
  survey_event_id = new_insert_values$survey_event_id
  fish_status_id = new_insert_values$fish_status_id
  fish_location_id = new_insert_values$fish_location_id
  sex_id =  new_insert_values$sex_id
  maturity_id = new_insert_values$maturity_id
  origin_id = new_insert_values$origin_id
  cwt_detection_status_id = new_insert_values$cwt_detection_status_id
  adipose_clip_status_id = new_insert_values$adipose_clip_status_id
  fish_behavior_type_id = new_insert_values$fish_behavior_type_id
  mortality_type_id = "149aefd0-0369-4f2c-b85f-4ec6c5e8679c"          # Not applicable....only use from trap interface
  fish_encounter_datetime = new_insert_values$fish_encounter_datetime
  fish_count = new_insert_values$fish_count
  previously_counted_indicator = new_insert_values$previously_counted_indicator
  created_by = new_insert_values$created_by
  # Checkout a connection
  con = poolCheckout(pool)
  insert_result = dbSendStatement(
    con, glue_sql("INSERT INTO spawning_ground.fish_encounter (",
                  "survey_event_id, ",
                  "fish_location_id, ",
                  "fish_status_id, ",
                  "sex_id, ",
                  "maturity_id, ",
                  "origin_id, ",
                  "cwt_detection_status_id, ",
                  "adipose_clip_status_id, ",
                  "fish_behavior_type_id, ",
                  "mortality_type_id, ",
                  "fish_encounter_datetime, ",
                  "fish_count, ",
                  "previously_counted_indicator, ",
                  "created_by) ",
                  "VALUES (",
                  "$1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14)"))
  dbBind(insert_result, list(survey_event_id, fish_location_id, fish_status_id, sex_id,
                             maturity_id, origin_id, cwt_detection_status_id,
                             adipose_clip_status_id, fish_behavior_type_id,
                             mortality_type_id, fish_encounter_datetime, fish_count,
                             previously_counted_indicator, created_by))
  dbGetRowsAffected(insert_result)
  dbClearResult(insert_result)
  poolReturn(con)
}

#========================================================
# Edit update callback
#========================================================

# Define update callback
fish_encounter_update = function(pool, fish_encounter_edit_values) {
  edit_values = fish_encounter_edit_values
  # Pull out data
  fish_encounter_id = edit_values$fish_encounter_id
  fish_location_id = edit_values$fish_location_id
  fish_status_id = edit_values$fish_status_id
  sex_id =  edit_values$sex_id
  maturity_id = edit_values$maturity_id
  origin_id = edit_values$origin_id
  cwt_detection_status_id = edit_values$cwt_detection_status_id
  adipose_clip_status_id = edit_values$adipose_clip_status_id
  fish_behavior_type_id = edit_values$fish_behavior_type_id
  fish_encounter_datetime = edit_values$fish_encounter_time
  fish_count = edit_values$fish_count
  previously_counted_indicator = edit_values$previously_counted_indicator
  if ( is.na(previously_counted_indicator) ) { previously_counted_indicator = FALSE }
  mod_dt = lubridate::with_tz(Sys.time(), "UTC")
  mod_by = Sys.getenv("USERNAME")
  # Checkout a connection
  con = poolCheckout(pool)
  update_result = dbSendStatement(
    con, glue_sql("UPDATE spawning_ground.fish_encounter SET ",
                  "fish_location_id = $1, ",
                  "fish_status_id = $2, ",
                  "sex_id = $3, ",
                  "maturity_id = $4, ",
                  "origin_id = $5, ",
                  "cwt_detection_status_id = $6, ",
                  "adipose_clip_status_id = $7, ",
                  "fish_behavior_type_id = $8, ",
                  "fish_encounter_datetime = $9, ",
                  "fish_count = $10, ",
                  "previously_counted_indicator = $11, ",
                  "modified_datetime = $12, ",
                  "modified_by = $13 ",
                  "where fish_encounter_id = $14"))
  dbBind(update_result, list(fish_location_id, fish_status_id, sex_id, maturity_id,
                             origin_id, cwt_detection_status_id, adipose_clip_status_id,
                             fish_behavior_type_id, fish_encounter_datetime,
                             fish_count, previously_counted_indicator,
                             mod_dt, mod_by, fish_encounter_id))
  dbGetRowsAffected(update_result)
  dbClearResult(update_result)
  poolReturn(con)
}

#========================================================
# Identify species dependencies prior to delete
#========================================================

# Identify fish_encounter dependencies prior to delete
get_fish_encounter_dependencies = function(pool, fish_encounter_id) {
  qry = glue("select ",
             "count(ind.individual_fish_id) as individual_fish, ",
             "count(fc.fish_capture_event_id) as fish_capture_event, ",
             "count(fm.fish_mark_id) as fish_mark ",
             "from spawning_ground.fish_encounter as fe ",
             "left join spawning_ground.individual_fish as ind on fe.fish_encounter_id = ind.fish_encounter_id ",
             "left join spawning_ground.fish_capture_event as fc on fe.fish_encounter_id = fc.fish_encounter_id ",
             "left join spawning_ground.fish_mark as fm on fe.fish_encounter_id = fm.fish_encounter_id ",
             "where fe.fish_encounter_id = '{fish_encounter_id}'")
  con = poolCheckout(pool)
  fish_encounter_dependents = DBI::dbGetQuery(pool, qry)
  poolReturn(con)
  has_entries = function(x) any(x > 0L)
  fish_encounter_dependents = fish_encounter_dependents %>%
    select_if(has_entries)
  return(fish_encounter_dependents)
}

#========================================================
# Delete callback
#========================================================

# Define delete callback
fish_encounter_delete = function(pool, delete_values) {
  fish_encounter_id = delete_values$fish_encounter_id
  con = poolCheckout(pool)
  delete_result = dbSendStatement(
    con, glue_sql("DELETE FROM spawning_ground.fish_encounter WHERE fish_encounter_id = $1"))
  dbBind(delete_result, list(fish_encounter_id))
  dbGetRowsAffected(delete_result)
  dbClearResult(delete_result)
  poolReturn(con)
}

