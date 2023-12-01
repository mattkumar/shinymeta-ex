library(shiny)

source("setup.R")

# Define UI for application 
shinyUI(panelsPage(
  shinyjs::useShinyjs(),
  styles = styles,
  header = app_header,
  panel(title = "1. Intro", color = c1, collapsed = FALSE, width =  500,
        head = h2("Waterfall Plot"),
        body = div(
          h2("Overview"),
          hr(color = c1),
          p("This application will enable you to interactively design a waterfall plot. It will provide you with code which can be readily executed in outside this application. The aim of this exercise is three fold:"),
          br(),
          img(class = "center", src = "img2.png", width="200", height="250"),
          br(),
          tags$ol(#class = "example",
                  tags$li("Gain experience in building custom clinical trial displays in R"),
                  br(),
                  tags$li("Practice re-executing previously developed code"),
                  br(),
                  tags$li("Provide feedback to help infrom future development efforts")
          ),
          br(), br(), br(), 
          h2("Getting Started"),
          hr(color = c1),
          p("To begin, you will simulate sample data appropriate for a waterfall plot. Next, you will have the oppourtunity to customize the plot through a variety of interactive options. Lastly, you will be able to download the code to reproduce your plot."),
          br(),
          shiny::HTML('<p>Please proceed to the <span style="color:#4FC1E8"><strong>02. Data Tab</strong></span> to get started.')
        ),
        footer = list(
          div(class="panel-title", "Please Proceed to Data Tab"),
          h3("Intro")
        )
  ),
  panel(title = "2. Data", color = c2, collapsed = TRUE, width = 550,
        head = h2("Simulate Data"),
        body = div(
          h2("Data Simulator"),
          hr(color = c2),
          p("This area will let you simulate example data for a waterfall plot. At any time you can return and re-generate example data with different specifications."),
          br(),
          h2("Data Specifications"),
          hr(color = c2),
          p("To begin, please specify how many treatment arms you would like. You can then configure the name and number of subjects in each arm."),
          br(),
          numericInput('ngroups','Number of Arms',value = 0),
          br(),
          uiOutput("groups"),
          br(),
          uiOutput("gen_button"),
          br(),
          uiOutput("data_view")
        ),
        footer = list(
          div(class="panel-title", "Data Simulation"),
          h3("Data")
        )
  ),
  panel(title = "3. Plot Preview", color = c4, collapsed = TRUE, width =  600, id = "preview",
        head = h2("Waterfall Plot Preview"),
        body = div(
          h2("Preview"),
          hr(color = c4),
          plotOutput('plot'),
          br(),
          shiny::HTML('<p>You may customize the appearance of this plot in the <span style="color:#A0D568"><strong>04. Plot Options</strong></span> tab.')
          
        ),
        footer = list(
          div(class="panel-title", "Waterfall Plot Visualization"),
          h3("Preview")
        )
  ),
  panel(title = "4. Plot Options", color = c3, collapsed = TRUE, width =  400,
        head = h2("Head"),
        body = div(
          h2("Color By"),
          hr(color = c3),
          selectInput('x', '', choices = my_choices, selected = 'None'),
          uiOutput('colors'),
          h2("Facet By"),
          hr(color = c3),
          selectInput('y', '', choices = my_choices, selected = 'None'),
          h2("Labels"),
          hr(color = c3),
          textInput('xaxis','X-Axis', ''),
          textInput('yaxis','Y-Axis', 'Change in Baseline Tumor Scan (%)'),
          textInput('title','Plot Title','Waterfall Plot'),
          h2("Reference Line"),
          hr(color = c3),
          selectInput('refline_type','Style', choices = c('None'='None','Dashed'='dashed','Solid'='solid','Dotted'='dotted')),
          shinyjs::hidden(
            div(id = "refline_ctrl",
                numericInput('refline_coord','Y-Coordinate', value = 30),
                colourpicker::colourInput('refline_color', 'Line Color', value = "red")
            )
          ),
          h2("Themes"),
          hr(color = c3),
          radioButtons('theme', '',choices = my_theme_choices)
        ),
        footer = list(
          div(class="panel-title", "Waterfall Plot Options"),
          h3("Options")
        )
  ),
  panel(title = "5. Code", color = "magenta", collapsed = TRUE, width = 600,
        head = h2("Waterfall Plot Preview"),
        body = div(
          h2("Code"),
          hr(color = "#da1c95"),
          p("You may access the code used to create your Waterfall Plot in this area. The intent is to provide a complete working example for which you can further adapt to your own study needs."),
          br(),
          h2("Scripts"),
          hr(color = "#da1c95"),
          p("Below is downloadable scripts that facilitate running your Waterfall Plot code in in your own environment."),
          br(),
          downloadButton("download_button", label = "Download R Script"),
          br(),
          h2("Live Code"),
          hr(color = "#da1c95"),
          p("Here is a live preview of the code to produce your Waterfall Plot."),
          br(),
          verbatimTextOutput("code")
          
          
        ),
        footer = list(
          div(class="panel-title", "Source code for your Waterfall Plot"),
          h3("Code")
        )
  ) 
))
