#=========================================================
# dashboardplus ui elements
#=========================================================

# Create the Shiny server
server = function(input, output, session) {
  source("wria_stream/wria_stream_srv.R", local = TRUE)
  source("survey/survey_srv.R", local = TRUE)
  source("survey_comment/survey_comment_srv.R", local = TRUE)
  source("survey_intent/survey_intent_srv.R", local = TRUE)
  source("waterbody_meas/waterbody_meas_srv.R", local = TRUE)
  source("survey_event/survey_event_srv.R", local = TRUE)
  source("fish_location/fish_location_srv.R", local = TRUE)
  source("fish_encounter/fish_encounter_srv.R", local = TRUE)
  source("individual_fish/individual_fish_srv.R", local = TRUE)
  source("fish_length_measurement/fish_length_measurement_srv.R", local = TRUE)
  source("redd_location/redd_location_srv.R", local = TRUE)
  source("redd_encounter/redd_encounter_srv.R", local = TRUE)
  source("individual_redd/individual_redd_srv.R", local = TRUE)
  source("redd_substrate/redd_substrate_srv.R", local = TRUE)
  source("reach_point/reach_point_srv.R", local = TRUE)
  # source("mobile_import/mobile_import_srv.R", local = TRUE)
  source("connect/connect_srv.R", local = TRUE)

  # Go to connect tab if pool is invalid
  if ( valid_connection[1] == FALSE ) {
    failed_reason = trimws(attr(valid_connection, "reason"))
    updateTabItems(session, "tabs", "connect")
    showModal(
      tags$div(id = "no_credentials_modal",
               modalDialog (
                 size = "l",
                 title = "No database connection!",
                 withTags({
                   div(class="header", checked=NA,
                       p(glue("If this is the first time running the application ",
                              "you will need to enter your connection parameters ",
                              "below to store the values.")),
                       HTML("<font color=#660033><strong>IMPORTANT!</strong><font color=#000080>"),
                       p(glue("The connection failed due to: '{failed_reason}'. ",
                              "Please enter your database credentials below. This ",
                              "should only need to be done once unless your ",
                              "password lapses, or there are changes to the ",
                              "server. If you are still unable to connect after ",
                              "attempting to set the parameters please contact ",
                              "the database administrator to verify your credentials. ",
                              "Click anywhere outside this box to close the popup."))
                   )
                 }),
                 easyClose = TRUE,
                 footer = NULL
               )
      )
    )
  }

  # # close the R session when Chrome closes...for standalone
  # session$onSessionEnded(function() {
  #   stopApp()
  #   q("no")
  # })

}
