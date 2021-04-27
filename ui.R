ui = dashboardPagePlus(
  shinyjs::useShinyjs(),
  shinytoastr::useToastr(),
  enable_preloader = TRUE,
  header = dash_header,
  sidebar = dash_leftsidebar,
  body = dashboardBody(
    includeCSS("www/ChehalisBasin.css"),
    tabItems(
      tabItem(tabName = "wria_stream",
              fluidRow(
                br(),
                br(),
                boxPlus(
                  title = "Select Stream and survey years",
                  closable = FALSE,
                  solidHeader = FALSE,
                  collapsible = TRUE,
                  collapsed = FALSE,
                  width = 12,
                  enable_sidebar = TRUE,
                  sidebar_width = 25,
                  sidebar_start_open = TRUE,
                  sidebar_content = wria_stream_ui,
                  leafletOutput("stream_map", height = "800px")
                )
              )
      ),
      tabItem(tabName = "data_entry",
              fluidRow(
                br(),
                br(),
                boxPlus(
                  title = "Survey",
                  closable = FALSE,
                  collapsible = TRUE,
                  solidHeader = FALSE,
                  collapsed = FALSE,
                  survey_ui,
                  width = 12
                ),
                boxPlus(
                  title = "Survey comments",
                  closable = FALSE,
                  collapsible = TRUE,
                  solidHeader = FALSE,
                  collapsed = TRUE,
                  survey_comment_ui,
                  width = 12
                ),
                boxPlus(
                  title = "Survey intent",
                  closable = FALSE,
                  collapsible = TRUE,
                  solidHeader = FALSE,
                  collapsed = TRUE,
                  survey_intent_ui,
                  width = 12
                ),
                boxPlus(
                  title = "Waterbody measurements",
                  closable = FALSE,
                  collapsible = TRUE,
                  solidHeader = FALSE,
                  collapsed = TRUE,
                  waterbody_meas_ui,
                  width = 12
                ),
                boxPlus(
                  title = "Species data",
                  closable = FALSE,
                  collapsible = TRUE,
                  solidHeader = FALSE,
                  collapsed = FALSE,
                  survey_event_ui,
                  width = 12
                ),
                boxPlus(
                  title = "Fish location",
                  closable = FALSE,
                  collapsible = TRUE,
                  solidHeader = FALSE,
                  collapsed = FALSE,
                  fish_location_ui,
                  width = 12
                ),
                boxPlus(
                  title = "Fish counts",
                  closable = FALSE,
                  collapsible = TRUE,
                  solidHeader = FALSE,
                  collapsed = FALSE,
                  fish_encounter_ui,
                  width = 12
                ),
                boxPlus(
                  title = "Individual fish",
                  closable = FALSE,
                  collapsible = TRUE,
                  solidHeader = FALSE,
                  collapsed = TRUE,
                  individual_fish_ui,
                  width = 12
                ),
                boxPlus(
                  title = "Fish length measurement",
                  closable = FALSE,
                  collapsible = TRUE,
                  solidHeader = FALSE,
                  collapsed = TRUE,
                  fish_length_measurement_ui,
                  width = 12
                ),
                boxPlus(
                  title = "Redd location",
                  closable = FALSE,
                  collapsible = TRUE,
                  solidHeader = FALSE,
                  collapsed = FALSE,
                  redd_location_ui,
                  width = 12
                ),
                boxPlus(
                  title = "Redd counts",
                  closable = FALSE,
                  collapsible = TRUE,
                  solidHeader = FALSE,
                  collapsed = FALSE,
                  redd_encounter_ui,
                  width = 12
                ),
                boxPlus(
                  title = "Individual redd",
                  closable = FALSE,
                  collapsible = TRUE,
                  solidHeader = FALSE,
                  collapsed = TRUE,
                  individual_redd_ui,
                  width = 12
                ),
                boxPlus(
                  title = "Redd substrate",
                  closable = FALSE,
                  collapsible = TRUE,
                  solidHeader = FALSE,
                  collapsed = TRUE,
                  redd_substrate_ui,
                  width = 12
                )
              )
      ),
      tabItem(tabName = "reach_point",
              fluidRow(
                br(),
                br(),
                boxPlus(
                  title = "Reach points",
                  closable = FALSE,
                  collapsible = TRUE,
                  solidHeader = FALSE,
                  collapsed = FALSE,
                  reach_point_ui,
                  width = 12
                )
              )
      ),
      tabItem(tabName = "add_stream",
              fluidRow(
                br(),
                br(),
                boxPlus(
                  title = "Add stream (ToDo)",
                  closable = FALSE,
                  collapsible = TRUE,
                  solidHeader = FALSE,
                  collapsed = FALSE,
                  width = 12
                )
              )
      ),
      tabItem(tabName = "mobile_import",
              fluidRow(
                br(),
                br(),
                boxPlus(
                  title = "Import from Mobile data server (ToDo)",
                  closable = FALSE,
                  collapsible = FALSE,
                  solidHeader = FALSE,
                  collapsed = FALSE,
                  #mobile_import_ui,
                  width = 12
                )
              )
      ),
      tabItem(tabName = "file_import",
              fluidRow(
                br(),
                br(),
                boxPlus(
                  title = "Import from external file or database (ToDo)",
                  closable = FALSE,
                  collapsible = TRUE,
                  solidHeader = FALSE,
                  collapsed = FALSE,
                  width = 12
                )
              )
      ),
      tabItem(tabName = "data_query",
              fluidRow(
                br(),
                br(),
                boxPlus(
                  title = "Export data using interactive query generator (ToDo)",
                  closable = FALSE,
                  collapsible = TRUE,
                  solidHeader = FALSE,
                  collapsed = FALSE,
                  width = 12
                )
              )
      ),
      tabItem(tabName = "reports",
              fluidRow(
                br(),
                br(),
                boxPlus(
                  title = "Generate automated reports (ToDo)",
                  closable = FALSE,
                  collapsible = TRUE,
                  solidHeader = FALSE,
                  collapsed = FALSE,
                  width = 12
                )
              )
      ),
      tabItem(tabName = "connect",
              fluidRow(
                br(),
                br(),
                boxPlus(
                  title = "Verify and store database credentials",
                  closable = FALSE,
                  collapsible = TRUE,
                  solidHeader = FALSE,
                  collapsed = FALSE,
                  connect_ui,
                  width = 12
                )
              )
      ),
      tabItem(tabName = "about",
              fluidRow(
                br(),
                br(),
                boxPlus(
                  title = "About (ToDo)",
                  closable = FALSE,
                  collapsible = TRUE,
                  solidHeader = FALSE,
                  collapsed = FALSE,
                  width = 12
                )
              )
      )
    )
  ),
  title = "Chehalis Basin data"
)
