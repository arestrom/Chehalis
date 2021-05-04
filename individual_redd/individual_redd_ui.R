#=============================================================
# HTML content definition of individual_redd accordion
#=============================================================

# Define the survey data content
individual_redd_ui = tags$div(
  actionButton(inputId = "ind_redd_add", label = "New", class = "new_button"),
  actionButton(inputId = "ind_redd_edit", label = "Edit", class = "edit_button"),
  actionButton(inputId = "ind_redd_delete", label = "Delete", class = "delete_button"),
  tippy("<i style='color:#1a5e86;padding-left:8px', class='fas fa-info-circle'></i>",
        tooltip = glue("<span style='font-size:11px;'>",
                       "You can only enter individual redd data below if the 'Redd Count' ",
                       "in the table above is 1. This enables associating characteristics ",
                       "such as location, redd name or redd status with the individual redd ",
                       "details such as shape or percent degraded.<span>")),
  br(),
  br(),
  uiOutput("redd_shape_select", inline = TRUE),
  uiOutput("dewatered_type_select", inline = TRUE),
  numericInput(inputId = "pct_visible_input", label = "Percent Visible", value = NA,
               min = 0, max = 100, step = 1, width = "100px"),
  numericInput(inputId = "redd_length_input", label = "Redd length (meter)", value = NA,
               min = 0, max = 50, step = 0.01, width = "150px"),
  numericInput(inputId = "redd_width_input", label = "Redd Width (meter)", value = NA,
               min = 0, max = 50, step = 0.01, width = "150px"),
  numericInput(inputId = "redd_depth_input", label = "Redd Depth (meter)", value = NA,
               min = 0, max = 10, step = 0.01, width = "150px"),
  numericInput(inputId = "tailspill_height_input", label = "Tailspill Height (meter)", value = NA,
               min = 0, max = 10, step = 0.01, width = "150px"),
  numericInput(inputId = "pct_superimposed_input", label = "Percent Superimposed", value = NA,
               min = 0, max = 100, step = 1, width = "150px"),
  numericInput(inputId = "pct_degraded_input", label = "Percent Degraded", value = NA,
               min = 0, max = 100, step = 1, width = "125px"),
  textInput(inputId = "superimposed_redd_name_input", label = "Superimposed Redd Name", value = "",
            width = "200px"),
  textAreaInput(inputId = "ind_redd_comment_input", label = "Redd Comment", value = "",
                width = "300px", resize = "both"),
  br(),
  br(),
  br(),
  DT::DTOutput("individual_redds")
)
