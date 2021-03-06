
# Main individual_redd query
get_individual_redd = function(pool, redd_encounter_id) {
  qry = glue("select ir.individual_redd_id, rh.redd_shape_description as redd_shape, ",
             "rd.dewatered_type_description as dewatered_type, ",
             "ir.percent_redd_visible as pct_visible, ",
             "ir.redd_length_measure_meter as redd_length_m, ",
             "ir.redd_width_measure_meter as redd_width_m, ",
             "ir.redd_depth_measure_meter as redd_depth_m, ",
             "ir.tailspill_height_measure_meter as tailspill_height_m, ",
             "ir.percent_redd_superimposed as pct_superimposed, ",
             "ir.percent_redd_degraded as pct_degraded, ",
             "ir.superimposed_redd_name, ",
             "ir.comment_text as individual_redd_comment, ",
             "ir.created_datetime as created_date, ir.created_by, ",
             "ir.modified_datetime as modified_date, ir.modified_by ",
             "from spawning_ground.individual_redd as ir ",
             "left join spawning_ground.redd_shape_lut as rh on ir.redd_shape_id = rh.redd_shape_id ",
             "left join spawning_ground.redd_dewatered_type_lut as rd on ir.redd_dewatered_type_id = rd.redd_dewatered_type_id ",
             "where ir.redd_encounter_id = '{redd_encounter_id}'")
  con = poolCheckout(pool)
  individual_redds = DBI::dbGetQuery(con, qry)
  poolReturn(con)
  individual_redds = individual_redds %>%
    mutate(created_date = with_tz(created_date, tzone = "America/Los_Angeles")) %>%
    mutate(created_dt = format(created_date, "%m/%d/%Y %H:%M")) %>%
    mutate(modified_date = with_tz(modified_date, tzone = "America/Los_Angeles")) %>%
    mutate(modified_dt = format(modified_date, "%m/%d/%Y %H:%M")) %>%
    select(individual_redd_id, redd_shape, dewatered_type, pct_visible,
           redd_length_m, redd_width_m, redd_depth_m, tailspill_height_m,
           pct_superimposed, pct_degraded, superimposed_redd_name,
           individual_redd_comment, created_date, created_dt,
           created_by, modified_date, modified_dt, modified_by) %>%
    arrange(created_date)
  return(individual_redds)
}

#==========================================================================
# Get generic lut input values
#==========================================================================

# Redd shape
get_redd_shape = function(pool) {
  qry = glue("select redd_shape_id, redd_shape_description as redd_shape ",
             "from spawning_ground.redd_shape_lut ",
             "where obsolete_datetime is null")
  con = poolCheckout(pool)
  redd_shape_list = DBI::dbGetQuery(con, qry) %>%
    arrange(redd_shape) %>%
    select(redd_shape_id, redd_shape)
  poolReturn(con)
  return(redd_shape_list)
}

# Dewatered type
get_dewatered_type = function(pool) {
  qry = glue("select redd_dewatered_type_id, dewatered_type_description as dewatered_type ",
             "from spawning_ground.redd_dewatered_type_lut ",
             "where obsolete_datetime is null")
  con = poolCheckout(pool)
  dewatered_type_list = DBI::dbGetQuery(con, qry) %>%
    arrange(dewatered_type) %>%
    select(redd_dewatered_type_id, dewatered_type)
  poolReturn(con)
  return(dewatered_type_list)
}

#========================================================
# Insert callback
#========================================================

# Define the insert callback
individual_redd_insert = function(pool, new_individual_redd_values) {
  new_insert_values = new_individual_redd_values
  # Pull out data
  redd_encounter_id = new_insert_values$redd_encounter_id
  redd_shape_id = new_insert_values$redd_shape_id
  redd_dewatered_type_id = new_insert_values$redd_dewatered_type_id
  percent_redd_visible = new_insert_values$pct_visible
  redd_length_measure_meter = new_insert_values$redd_length_m
  redd_width_measure_meter = new_insert_values$redd_width_m
  redd_depth_measure_meter = new_insert_values$redd_depth_m
  tailspill_height_measure_meter = new_insert_values$tailspill_height_m
  percent_redd_superimposed = new_insert_values$pct_superimposed
  percent_redd_degraded = new_insert_values$pct_degraded
  superimposed_redd_name = new_insert_values$superimposed_redd_name
  comment_text = new_insert_values$individual_redd_comment
  if (is.na(superimposed_redd_name) | superimposed_redd_name == "") { superimposed_redd_name = NA }
  if (is.na(comment_text) | comment_text == "") { comment_text = NA }
  created_by = new_insert_values$created_by
  # Checkout a connection
  con = poolCheckout(pool)
  insert_result = dbSendStatement(
    con, glue_sql("INSERT INTO spawning_ground.individual_redd (",
                  "redd_encounter_id, ",
                  "redd_shape_id, ",
                  "redd_dewatered_type_id, ",
                  "percent_redd_visible, ",
                  "redd_length_measure_meter, ",
                  "redd_width_measure_meter, ",
                  "redd_depth_measure_meter, ",
                  "tailspill_height_measure_meter, ",
                  "percent_redd_superimposed, ",
                  "percent_redd_degraded, ",
                  "superimposed_redd_name, ",
                  "comment_text, ",
                  "created_by) ",
                  "VALUES (",
                  "$1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13)"))
  dbBind(insert_result, list(redd_encounter_id, redd_shape_id, redd_dewatered_type_id,
                             percent_redd_visible, redd_length_measure_meter,
                             redd_width_measure_meter, redd_depth_measure_meter,
                             tailspill_height_measure_meter, percent_redd_superimposed,
                             percent_redd_degraded, superimposed_redd_name,
                             comment_text, created_by))
  dbGetRowsAffected(insert_result)
  dbClearResult(insert_result)
  poolReturn(con)
}

#========================================================
# Edit update callback
#========================================================

# Define update callback
individual_redd_update = function(pool, individual_redd_edit_values) {
  edit_values = individual_redd_edit_values
  # Pull out data
  individual_redd_id = edit_values$individual_redd_id
  redd_shape_id = edit_values$redd_shape_id
  redd_dewatered_type_id = edit_values$redd_dewatered_type_id
  percent_redd_visible = edit_values$pct_visible
  redd_length_measure_meter = edit_values$redd_length_m
  redd_width_measure_meter = edit_values$redd_width_m
  redd_depth_measure_meter = edit_values$redd_depth_m
  tailspill_height_measure_meter = edit_values$tailspill_height_m
  percent_redd_superimposed = edit_values$pct_superimposed
  percent_redd_degraded = edit_values$pct_degraded
  superimposed_redd_name = edit_values$superimposed_redd_name
  comment_text = edit_values$individual_redd_comment
  if (is.na(superimposed_redd_name) | superimposed_redd_name == "") { superimposed_redd_name = NA }
  if (is.na(comment_text) | comment_text == "") { comment_text = NA }
  mod_dt = lubridate::with_tz(Sys.time(), "UTC")
  mod_by = Sys.getenv("USERNAME")
  # Checkout a connection
  con = poolCheckout(pool)
  update_result = dbSendStatement(
    con, glue_sql("UPDATE spawning_ground.individual_redd SET ",
                  "redd_shape_id = $1, ",
                  "redd_dewatered_type_id = $2, ",
                  "percent_redd_visible = $3, ",
                  "redd_length_measure_meter = $4, ",
                  "redd_width_measure_meter = $5, ",
                  "redd_depth_measure_meter = $6, ",
                  "tailspill_height_measure_meter = $7, ",
                  "percent_redd_superimposed = $8, ",
                  "percent_redd_degraded = $9, ",
                  "superimposed_redd_name = $10, ",
                  "comment_text = $11, ",
                  "modified_datetime = $12, ",
                  "modified_by = $13 ",
                  "where individual_redd_id = $14"))
  dbBind(update_result, list(redd_shape_id, redd_dewatered_type_id,
                             percent_redd_visible, redd_length_measure_meter,
                             redd_width_measure_meter, redd_depth_measure_meter,
                             tailspill_height_measure_meter, percent_redd_superimposed,
                             percent_redd_degraded, superimposed_redd_name,
                             comment_text, mod_dt, mod_by,
                             individual_redd_id))
  dbGetRowsAffected(update_result)
  dbClearResult(update_result)
  poolReturn(con)
}

#========================================================
# Delete callback
#========================================================

# Define delete callback
individual_redd_delete = function(pool, delete_values) {
  individual_redd_id = delete_values$individual_redd_id
  con = poolCheckout(pool)
  delete_result = dbSendStatement(
    con, glue_sql("DELETE FROM spawning_ground.individual_redd ",
                  "WHERE individual_redd_id = $1"))
  dbBind(delete_result, list(individual_redd_id))
  dbGetRowsAffected(delete_result)
  dbClearResult(delete_result)
  poolReturn(con)
}












