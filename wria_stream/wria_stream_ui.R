#=========================================================
# HTML content definition of header page
#========================================================

# Define the survey data content
wria_stream_ui = tags$div(
  br(),
  br(),
  div(id = "sthd_image", img(src = "steelhead.png", width = "70%")),
  br(),
  br(),
  br(),
  uiOutput("wria_select"),
  br(),
  br(),
  uiOutput("stream_select"),
  br(),
  br(),
  uiOutput("when_date_range")
)

