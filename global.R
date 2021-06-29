#==============================================================
# Application to edit data for spawning_ground database
#
# Notes on install R 4.1.0
#  1. Will need the following non-cran packages:
#       remotes::install_github("arestrom/iformr")
#
# Notes:
#  1. Do not use rownames = FALSE in DT. Data will not reload
#     when using replaceData() function.
#  2. To prune merged git branches:
#     a, Check which branches have been merged:       git branch --merged
#     b, Once branch has been deleted from remote:    git fetch -p            # To prune those no longer on remote
#     c, To delete branch from local:                 git branch -d <branch>
#
#
# ToDo:
#  1. Add animation to buttons as in dt_editor example.
#  2. Allow map modals to be resizable and draggable.
#     Try the shinyjqui or sortable package:
#     https://github.com/nanxstats/awesome-shiny-extensions
#  3. Set data_source order using number of surveys in category.
#     Can do a query of data to arrange by n, then name.
#  4. Add modal screen to validate clarity type is chosen along
#     with clarity_meter
#  5. Need to dump and reload all lakes data...using new layer
#     DG has created. Look for intersecting polygons
#     before uploading and dump any duplicates. DGs layer
#     is omitting the marshland.
#  6. Need to scan all existing stream geometry for overlapping
#     segments...then dump those and reset sequences. Need to
#     add code to look for overlapping segments in scripts to
#     upload all geometry. Join line segments to one line per llid.
#  7. Add input$delete observers to all shinyjs disable code
#     See example in redd_substrate_srv code.
#  8. Check that select inputs are ordered optimally. Use
#     example code in redd_substrate_global as example to
#     order by levels.
#  9. Add code to limit the number of possible length
#     measurements to the number of items in length_type
#     lut list.
# 10. Verify all screens...especially edit, do not allow removing
#     required values by backspacing and updating. !!!!!
# 11. See example code "current_redd_locations" in redd_encounter_srv.R
#     as example of how to possibly simplify a bunch of repeat
#     invocations of get_xxx global functions.
# 12. Consider adding theme selector to set background
#     colors, themes, etc. Look at bootstraplib package.
# 13. Consider using shinyjs to add class "required_field" directly
#     to each required element. Then just use one css entry for all.
# 14. Add raster tile coverage for full offline capability... !!!
# 15. Eventually test with lidar and raytracer mapping.
# 16. Change stream drop-down code to use display_name not full waterbody_name. Add cat code.
# 17. Change required fields in reach_point to omit river_mile. We should start
#     weaning off RMs and go with codes, descriptors and coords instead.
# 18. Need to add an other_observations and passage_feature boxes at the survey level...along
#     with interface to add or edit streams.
# 19. Need interface for media. Copy code from mykos.
# 20. Add search boxes to all DTs
# 21. Enable columns to be hidden
# 22. Add selectable input for the number of months of previous redds or carcasses to display
#     in the redd_location and fish_location tables.
# 23. Prevent ability to edit fish_count > 1 if anything is entered for individual_fish!!!!!
# 24. May want to provide option to search for new, unassigned fish or redd locations that
#     were created within the previous x days using a 'days since' select. That would also
#     allow orphan redd locations on the waterbody to be deleted.
#
# AS 2021-06-11
#==============================================================

# Load libraries
library(shiny)
library(shinydashboard)
library(shinydashboardPlus)
library(shinyWidgets)
library(shinyTime)
library(shinyjs)
library(tippy)
library(RPostgres)
library(glue)
library(tibble)
library(DBI)
library(pool)
library(dplyr)
library(DT)
library(leaflet)
library(mapedit)
library(leaflet.extras)
library(sf)
library(lubridate)
library(uuid)
library(shinytoastr)
library(shinycssloaders)
library(stringi)
library(keyring)
#library(reactlog)

# Options
devmode()
# Same as: shiny::devmode(TRUE)
#options("connectionObserver" = NULL)
#options(shiny.reactlog = TRUE)
#reactlogShow()

# Read content definitions of data-entry screens
source("dashboard/dash_header.R")
source("dashboard/dash_leftsidebar.R")
source("wria_stream/wria_stream_ui.R")
source("wria_stream/wria_stream_global.R")
source("survey/survey_ui.R")
source("survey/survey_global.R")
source("survey_comment/survey_comment_ui.R")
source("survey_comment/survey_comment_global.R")
source("survey_intent/survey_intent_ui.R")
source("survey_intent/survey_intent_global.R")
source("waterbody_meas/waterbody_meas_ui.R")
source("waterbody_meas/waterbody_meas_global.R")
source("survey_event/survey_event_ui.R")
source("survey_event/survey_event_global.R")
source("fish_location/fish_location_ui.R")
source("fish_location/fish_location_global.R")
source("fish_encounter/fish_encounter_ui.R")
source("fish_encounter/fish_encounter_global.R")
source("individual_fish/individual_fish_ui.R")
source("individual_fish/individual_fish_global.R")
source("fish_length_measurement/fish_length_measurement_ui.R")
source("fish_length_measurement/fish_length_measurement_global.R")
source("redd_location/redd_location_ui.R")
source("redd_location/redd_location_global.R")
source("redd_encounter/redd_encounter_ui.R")
source("redd_encounter/redd_encounter_global.R")
source("individual_redd/individual_redd_ui.R")
source("individual_redd/individual_redd_global.R")
source("redd_substrate/redd_substrate_ui.R")
source("redd_substrate/redd_substrate_global.R")
source("reach_point/reach_point_ui.R")
source("reach_point/reach_point_global.R")
# # source("mobile_import/mobile_import_ui.R")
# # source("mobile_import/mobile_import_global.R")
source("data_query/data_query_ui.R")
source("data_query/data_query_global.R")
source("connect/connect_ui.R")
source("connect/connect_global.R")

# Define functions ================================================================

# Function to extract credentials from the windows credentials store
get_credentials = function(credential_label = NULL, keyring = NULL) {
  tryCatch({
    secret = key_get(service = credential_label,
                     keyring = keyring)
    return(secret)
  }, error = function(e) {
    msg = paste0("No credential was found with the label '", credential_label,
                 "'. Please check the spelling, or add the new credential.")
    cat("\n", msg, "\n\n")
  })
}

# # Check credentials on local instance...return boolean
# valid_connection = DBI::dbCanConnect(RPostgres::Postgres(),
#                                      host = "localhost",
#                                      port = "5432",
#                                      user = Sys.getenv("USERNAME"),
#                                      password = get_credentials("pg_pwd_local"),
#                                      dbname = get_credentials("pg_fish_local_db"))
#
# # Get pooled connection to local instance if credentials valid
# if ( valid_connection == TRUE ) {
#   pool = pool::dbPool(RPostgres::Postgres(),
#                       dbname = get_credentials("pg_fish_local_db"),
#                       host = "localhost",
#                       port = "5432",
#                       user = Sys.getenv("USERNAME"),
#                       password = get_credentials("pg_pwd_local"))
# }


# Check credentials...return boolean
valid_connection = DBI::dbCanConnect(RPostgres::Postgres(),
                                     host = get_credentials("pg_host_prod"),
                                     port = get_credentials("pg_port_prod"),
                                     user = Sys.getenv("USERNAME"),
                                     password = get_credentials("pg_pwd_prod"),
                                     dbname = get_credentials("pg_fish_prod_db"))

# Get pooled connection to AWS prod instance if credentials valid
if ( valid_connection == TRUE ) {
  pool = pool::dbPool(RPostgres::Postgres(),
                      dbname = get_credentials("pg_fish_prod_db"),
                      host = get_credentials("pg_host_prod"),
                      port = get_credentials("pg_port_prod"),
                      user = Sys.getenv("USERNAME"),
                      password = get_credentials("pg_pwd_prod"))
}

# Convert empty strings to NAs
set_na = function(x, na_value = "") {
  x[x == na_value] <- NA
  x
}

# Convert NAs to empty strings ("")
set_empty = function(x) {
  x[is.na(x)] <- ""
  x
}

# Set all values in a vector or dataframe to NA, but preserve NA types
set_na_type = function(x) {
  if (typeof(x) == "logical") x = as.logical(NA)
  else if (typeof(x) == "character") x = NA_character_
  else if (typeof(x) == "integer") x = NA_integer_
  else if (typeof(x) == "double") x = NA_real_
  else x = NA_character_
  x
}

# Generate a vector of Version 4 UUIDs (RFC 4122)
get_uuid = function(n = 1L) {
  if (!typeof(n) %in% c("double", "integer") ) {
    stop("n must be an integer or double")
  }
  uuid::UUIDgenerate(use.time = FALSE, n = n)
}

# Extract portion of a string defined by a separator
get_text_item <- function(x, item = 2, sep= " ") {
  get_list_item <- function(x, item = 2) {
    if(is.na(x[item])) {
      x = NA
    } else {
      x = x[item]
    }
    x
  }
  # Create list with all text items
  nms = strsplit(x, sep)
  # Extract the text at item position from the list
  nm = unlist(lapply(nms, get_list_item, item))
  nm
}

# Define close function =============================================================

# Function to close pool
if ( valid_connection == TRUE ) {
  onStop(function() {
    poolClose(pool)
  })
}


