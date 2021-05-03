ui = dashboardPage(
  header = dash_header,
  sidebar = dash_leftsidebar,
  body = dashboardBody(
    includeCSS("www/ChehalisBasin.css"),
    shinyjs::useShinyjs(),
    shinytoastr::useToastr(),
    tabItems(
      tabItem(tabName = "wria_stream",
              fluidRow(
                br(),
                br(),
                box(
                  title = "Select Stream and survey date range",
                  #loadingState(),
                  width = 12,
                  height = "800px",
                  closable = FALSE,
                  solidHeader = FALSE,
                  collapsible = TRUE,
                  collapsed = FALSE,
                  sidebar = boxSidebar(
                    id = "wria_stream_sidebar",
                    width = 30,
                    startOpen = TRUE,
                    icon = shiny::icon("bars"),
                    wria_stream_ui
                  ),
                  leafletOutput("stream_map", height = "800px") %>%
                    shinycssloaders::withSpinner(., size = 0.5)
                )
              )
      ),
      tabItem(tabName = "data_entry",
              fluidRow(
                br(),
                br(),
                box(
                  title = "Survey",
                  width = 12,
                  closable = FALSE,
                  collapsible = TRUE,
                  solidHeader = FALSE,
                  collapsed = FALSE,
                  survey_ui
                 ),
                box(
                  title = "Survey comments",
                  width = 12,
                  closable = FALSE,
                  collapsible = TRUE,
                  solidHeader = FALSE,
                  collapsed = TRUE,
                  survey_comment_ui
                ),
                box(
                  title = "Survey intent",
                  width = 12,
                  closable = FALSE,
                  collapsible = TRUE,
                  solidHeader = FALSE,
                  collapsed = TRUE,
                  survey_intent_ui
                ),
                box(
                  title = "Waterbody measurements",
                  width = 12,
                  closable = FALSE,
                  collapsible = TRUE,
                  solidHeader = FALSE,
                  collapsed = TRUE,
                  waterbody_meas_ui
                ),
                box(
                  title = "Species data",
                  width = 12,
                  closable = FALSE,
                  collapsible = TRUE,
                  solidHeader = FALSE,
                  collapsed = FALSE,
                  survey_event_ui
                ),
                box(
                  title = "Fish location",
                  width = 12,
                  closable = FALSE,
                  collapsible = TRUE,
                  solidHeader = FALSE,
                  collapsed = TRUE,
                  fish_location_ui
                ),
                box(
                  title = "Fish counts",
                  width = 12,
                  closable = FALSE,
                  collapsible = TRUE,
                  solidHeader = FALSE,
                  collapsed = FALSE,
                  fish_encounter_ui
                ),
                box(
                  title = "Individual fish",
                  width = 12,
                  closable = FALSE,
                  collapsible = TRUE,
                  solidHeader = FALSE,
                  collapsed = TRUE,
                  individual_fish_ui
                ),
                box(
                  title = "Fish length measurement",
                  width = 12,
                  closable = FALSE,
                  collapsible = TRUE,
                  solidHeader = FALSE,
                  collapsed = TRUE,
                  fish_length_measurement_ui
                ),
                box(
                  title = "Redd location",
                  width = 12,
                  closable = FALSE,
                  collapsible = TRUE,
                  solidHeader = FALSE,
                  collapsed = TRUE,
                  redd_location_ui
                ),
                box(
                  title = "Redd counts",
                  width = 12,
                  closable = FALSE,
                  collapsible = TRUE,
                  solidHeader = FALSE,
                  collapsed = FALSE,
                  redd_encounter_ui
                ),
                box(
                  title = "Individual redd",
                  width = 12,
                  closable = FALSE,
                  collapsible = TRUE,
                  solidHeader = FALSE,
                  collapsed = TRUE,
                  individual_redd_ui
                ),
                box(
                  title = "Redd substrate",
                  width = 12,
                  closable = FALSE,
                  collapsible = TRUE,
                  solidHeader = FALSE,
                  collapsed = TRUE,
                  redd_substrate_ui
                )
              )
      ),
      tabItem(tabName = "reach_point",
              fluidRow(
                br(),
                br(),
                box(
                  title = "Reach points",
                  width = 12,
                  closable = FALSE,
                  collapsible = TRUE,
                  solidHeader = FALSE,
                  collapsed = FALSE,
                  reach_point_ui
                )
              )
      ),
      tabItem(tabName = "add_stream",
              fluidRow(
                br(),
                br(),
                box(
                  title = "Add stream (ToDo)",
                  width = 12,
                  closable = FALSE,
                  collapsible = TRUE,
                  solidHeader = FALSE,
                  collapsed = FALSE
                  #add_stream_ui
                )
              )
      ),
      tabItem(tabName = "mobile_import",
              fluidRow(
                br(),
                br(),
                box(
                  title = "Import from Mobile data server (ToDo)",
                  width = 12,
                  closable = FALSE,
                  collapsible = FALSE,
                  solidHeader = FALSE,
                  collapsed = FALSE
                  #mobile_import_ui,
                )
              )
      ),
      tabItem(tabName = "file_import",
              fluidRow(
                br(),
                br(),
                box(
                  title = "Import from external file or database (ToDo)",
                  width = 12,
                  closable = FALSE,
                  collapsible = TRUE,
                  solidHeader = FALSE,
                  collapsed = FALSE
                )
              )
      ),
      tabItem(tabName = "data_query",
              fluidRow(
                br(),
                br(),
                box(
                  title = "Export data using interactive query generator (ToDo)",
                  width = 12,
                  closable = FALSE,
                  collapsible = TRUE,
                  solidHeader = FALSE,
                  collapsed = FALSE
                )
              )
      ),
      tabItem(tabName = "reports",
              fluidRow(
                br(),
                br(),
                box(
                  title = "Generate automated reports (ToDo)",
                  width = 12,
                  closable = FALSE,
                  collapsible = TRUE,
                  solidHeader = FALSE,
                  collapsed = FALSE
                )
              )
      ),
      tabItem(tabName = "connect",
              fluidRow(
                br(),
                br(),
                box(
                  title = "Verify and store database credentials",
                  width = 12,
                  closable = FALSE,
                  collapsible = TRUE,
                  solidHeader = FALSE,
                  collapsed = FALSE,
                  connect_ui
                )
              )
      ),
      tabItem(tabName = "about",
              fluidRow(
                br(),
                br(),
                box(
                  title = "About (ToDo)",
                  width = 12,
                  closable = FALSE,
                  collapsible = TRUE,
                  solidHeader = FALSE,
                  collapsed = FALSE
                )
              )
      )
    )
  ),
  title = "Chehalis Basin data"
)
