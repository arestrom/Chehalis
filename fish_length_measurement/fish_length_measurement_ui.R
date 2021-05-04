#=============================================================
# HTML content definition of fish_measurement accordion
#=============================================================

# Define the survey data content
fish_length_measurement_ui = tags$div(
  actionButton(inputId = "fish_meas_add", label = "New", class = "new_button"),
  actionButton(inputId = "fish_meas_edit", label = "Edit", class = "edit_button"),
  actionButton(inputId = "fish_meas_delete", label = "Delete", class = "delete_button"),
  tippy("<i style='color:#1a5e86;padding-left:8px', class='fas fa-info-circle'></i>",
        tooltip = glue("<span style='font-size:11px;'>",
                       "You can enter more than one length type for any given ",
                       "individual fish. This allows providing one type of length ",
                       "for genetic analysis and another for age determination, etc.<span>")),
  br(),
  br(),
  uiOutput("length_type_select", inline = TRUE),
  numericInput(inputId = "length_cm_input", label = "Length (cm)", value = NULL,
               min = 0, step = 1, width = "115px"),
  br(),
  br(),
  br(),
  DT::DTOutput("length_measurements")
)
