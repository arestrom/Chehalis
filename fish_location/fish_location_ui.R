#=============================================================
# HTML content definition of redd_encounter accordion
#=============================================================

# Define the survey data content
fish_location_ui = tags$div(
  actionButton(inputId = "fish_loc_add", label = "New", class = "new_button"),
  actionButton(inputId = "fish_loc_edit", label = "Edit", class = "edit_button"),
  actionButton(inputId = "fish_loc_delete", label = "Delete", class = "delete_button"),
  actionButton(inputId = "fish_loc_map", label = "Use map", class = "map_button"),
  tippy("<i style='color:#1a5e86;padding-left:8px', class='fas fa-info-circle'></i>",
        tooltip = glue("<span style='font-size:11px;'>",
                       "To track carcass life you must first enter, at minimum, ",
                       "a 'Fish Name' (Fish ID or Carcass Code) into the 'Fish location' ",
                       "table. Enter the name into the 'Fish Name' text box below. ",
                       "Then to associate your carcass count data with a location, ",
                       "select the 'Fish Name' in the drop-down menu associated with ",
                       "the Fish counts' table below. To enter counts only (no location) ",
                       "select 'no location data' in the 'Fish Name' drop-down. You ",
                       "can also edit existing fish count data and remove the location ",
                       "association by selecting 'no location data' in the drop-down. ",
                       "Latitude and longitude are optional, but highly recommended.<span>")),
  br(),
  br(),
  textInput(inputId = "fish_name_input", label = "Fish Name", width = "125px"),
  uiOutput("fish_channel_type_select", inline = TRUE),
  uiOutput("fish_orientation_type_select", inline = TRUE),
  numericInput(inputId = "fish_latitude_input", label = "Latitude", value = NULL,
               min = 45, max = 49, width = "125px"),
  numericInput(inputId = "fish_longitude_input", label = "Longitude", value = NULL,
               min = -124, max = -116, width = "125px"),
  numericInput(inputId = "fish_horiz_accuracy_input", label = "Horiz. Accuracy", value = NULL,
               min = 0, width = "100px"),
  textAreaInput(inputId = "fish_location_description_input", label = "Location Description", value = "",
                width = "300px", resize = "both"),
  br(),
  br(),
  br(),
  DT::DTOutput("fish_locations") %>%
    shinycssloaders::withSpinner(., size = 0.5)
)
