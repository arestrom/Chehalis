#=============================================================
# HTML content definition of individual fish accordion
#=============================================================

# Define the survey data content
individual_fish_ui = tags$div(
  actionButton(inputId = "ind_fish_add", label = "New", class = "new_button"),
  actionButton(inputId = "ind_fish_edit", label = "Edit", class = "edit_button"),
  actionButton(inputId = "ind_fish_delete", label = "Delete", class = "delete_button"),
  tippy("<i style='color:#1a5e86;padding-left:8px', class='fas fa-info-circle'></i>",
        tooltip = glue("<span style='font-size:11px;'>",
                       "You can only enter individual fish data below if the 'Fish Count' ",
                       "in the table above is 1. This enables associating characteristics ",
                       "such as sex, maturity or clip status with the individual fish ",
                       "details such as length, CWT labels, and DNA sample numbers.<span>")),
  br(),
  br(),
  uiOutput("fish_condition_select", inline = TRUE),
  uiOutput("fish_trauma_select", inline = TRUE),
  uiOutput("gill_condition_select", inline = TRUE),
  uiOutput("spawn_condition_select", inline = TRUE),
  textInput(inputId = "fish_sample_num_input", label = "Fish Sample Number", width = "135px"),
  textInput(inputId = "scale_card_num_input", label = "Scale Card Number", width = "125px"),
  textInput(inputId = "scale_position_num_input", label = "Scale Pos. Number", width = "125px"),
  uiOutput("age_code_select", inline = TRUE),
  textInput(inputId = "snout_sample_num_input", label = "Snout Sample Number", width = "145px"),
  textInput(inputId = "cwt_tag_code_input", label = "CWT Tag Code", width = "100px"),
  uiOutput("cwt_result_select", inline = TRUE),
  textInput(inputId = "genetic_sample_num_input", label = "Genetic Sample Number", width = "150px"),
  textInput(inputId = "otolith_sample_num_input", label = "Otolith Sample Number", width = "150px"),
  numericInput(inputId = "pct_eggs_input", label = "Pct. Eggs Retained", value = NULL,
               min = 0, max = 100, step = 1, width = "135px"),
  numericInput(inputId = "eggs_gram_input", label = "Eggs (gram)", value = NULL,
               min = 0, max = 100, step = 1, width = "100px"),
  numericInput(inputId = "eggs_number_input", label = "Eggs (number)", value = NULL,
               min = 0, max = 100, step = 1, width = "100px"),
  textAreaInput(inputId = "ind_fish_comment_input", label = "Fish Comment", value = "",
                width = "300px", resize = "both"),
  br(),
  br(),
  br(),
  DT::DTOutput("individual_fishes")
)
