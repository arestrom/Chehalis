
# Main fish_encounter query
get_length_measurements = function(pool, individual_fish_id) {
  qry = glue("select flm.fish_length_measurement_id, ",
             "mt.length_type_description as length_type, ",
             "flm.length_measurement_centimeter as length_cm, ",
             "flm.created_datetime as created_date, flm.created_by, ",
             "flm.modified_datetime as modified_date, flm.modified_by ",
             "from spawning_ground.fish_length_measurement as flm ",
             "inner join spawning_ground.fish_length_measurement_type_lut as mt ",
             "on flm.fish_length_measurement_type_id = mt.fish_length_measurement_type_id ",
             "where flm.individual_fish_id = '{individual_fish_id}'")
  con = poolCheckout(pool)
  length_measurements = DBI::dbGetQuery(con, qry)
  poolReturn(con)
  length_measurements = length_measurements %>%
    mutate(fish_length_measurement_id = tolower(fish_length_measurement_id)) %>%
    mutate(created_date = with_tz(created_date, tzone = "America/Los_Angeles")) %>%
    mutate(created_dt = format(created_date, "%m/%d/%Y %H:%M")) %>%
    mutate(modified_date = with_tz(modified_date, tzone = "America/Los_Angeles")) %>%
    mutate(modified_dt = format(modified_date, "%m/%d/%Y %H:%M")) %>%
    select(fish_length_measurement_id, length_type, length_cm, created_date, created_dt, created_by,
           modified_date, modified_dt, modified_by) %>%
    arrange(created_date)
  return(length_measurements)
}

#==========================================================================
# Get generic lut input values
#==========================================================================

# Length type
get_length_type = function(pool) {
  qry = glue("select fish_length_measurement_type_id, length_type_description as length_type ",
             "from spawning_ground.fish_length_measurement_type_lut ",
             "where obsolete_datetime is null")
  con = poolCheckout(pool)
  length_type_list = DBI::dbGetQuery(con, qry) %>%
    arrange(length_type) %>%
    select(fish_length_measurement_type_id, length_type)
  poolReturn(con)
  return(length_type_list)
}

#==========================================================================
# Validate create operations
#==========================================================================

# Check for existing duplicate survey_intent prior to survey_intent insert operation
dup_length_type = function(new_length_type_vals, existing_length_type_vals) {
  new_length_type_vals = new_length_type_vals %>%
    select(length_type)
  matching_rows = new_length_type_vals %>%
    select(length_type) %>%
    inner_join(existing_length_type_vals, by = "length_type")
  if (nrow(matching_rows) > 0 ) {
    dup_flag = TRUE
  } else {
    dup_flag = FALSE
  }
  return(dup_flag)
}

#========================================================
# Insert callback
#========================================================

# Define the insert callback
length_measurement_insert = function(pool, new_length_measurement_values) {
  new_insert_values = new_length_measurement_values
  # Pull out data
  individual_fish_id = new_insert_values$individual_fish_id
  fish_length_measurement_type_id = new_insert_values$fish_length_measurement_type_id
  length_measurement_centimeter =  new_insert_values$length_cm
  created_by = new_insert_values$created_by
  # Checkout a connection
  con = poolCheckout(pool)
  insert_result = dbSendStatement(
    con, glue_sql("INSERT INTO spawning_ground.fish_length_measurement (",
                  "individual_fish_id, ",
                  "fish_length_measurement_type_id, ",
                  "length_measurement_centimeter, ",
                  "created_by) ",
                  "VALUES (",
                  "$1, $2, $3, $4)"))
  dbBind(insert_result, list(individual_fish_id, fish_length_measurement_type_id,
                             length_measurement_centimeter, created_by))
  dbGetRowsAffected(insert_result)
  dbClearResult(insert_result)
  poolReturn(con)
}

#========================================================
# Edit update callback
#========================================================

# Define update callback
length_measurement_update = function(pool, length_measurement_edit_values) {
  edit_values = length_measurement_edit_values
  # Pull out data
  fish_length_measurement_id = edit_values$fish_length_measurement_id
  fish_length_measurement_type_id = edit_values$fish_length_measurement_type_id
  length_measurement_centimeter =  edit_values$length_cm
  mod_dt = lubridate::with_tz(Sys.time(), "UTC")
  mod_by = Sys.getenv("USERNAME")
  # Checkout a connection
  con = poolCheckout(pool)
  update_result = dbSendStatement(
    con, glue_sql("UPDATE spawning_ground.fish_length_measurement SET ",
                  "fish_length_measurement_type_id = $1, ",
                  "length_measurement_centimeter = $2, ",
                  "modified_datetime = $3, ",
                  "modified_by = $4 ",
                  "where fish_length_measurement_id = $5"))
  dbBind(update_result, list(fish_length_measurement_type_id,
                             length_measurement_centimeter,
                             mod_dt, mod_by,
                             fish_length_measurement_id))
  dbGetRowsAffected(update_result)
  dbClearResult(update_result)
  poolReturn(con)
}

#========================================================
# Delete callback
#========================================================

# Define delete callback
length_measurement_delete = function(pool, delete_values) {
  fish_length_measurement_id = delete_values$fish_length_measurement_id
  con = poolCheckout(pool)
  delete_result = dbSendStatement(
    con, glue_sql("DELETE FROM spawning_ground.fish_length_measurement ",
                  "WHERE fish_length_measurement_id = $1"))
  dbBind(delete_result, list(fish_length_measurement_id))
  dbGetRowsAffected(delete_result)
  dbClearResult(delete_result)
  poolReturn(con)
}












