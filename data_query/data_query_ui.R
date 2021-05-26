#=========================================================
# HTML content definition of sampler ui
#========================================================

# Define the survey data content
data_query_ui = tags$div(
  fluidRow(
    column(width = 12,
           br(),
           br(),
           dateRangeInput(inputId = "scale_survey_date_range",
                          label = "Date range to query",
                          start = format(Sys.Date() - 500L),
                          end = format(Sys.Date()),
                          format = "mm/dd/yyyy",
                          startview = "year",
                          width = "250px"),
           uiOutput("scale_streams_select", inline = TRUE),
           br(),
           br(),
           br(),
           DT::DTOutput("scale_cards_query")
           )
  )
)
