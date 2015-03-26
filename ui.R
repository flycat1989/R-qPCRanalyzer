#ui.R
shinyUI(fluidPage(
  titlePanel("Uploading Files"),
  sidebarLayout(
    sidebarPanel(
      fileInput('file1', 'Choose file to upload',
                accept = c(
                  'text/csv',
                  'text/comma-separated-values',
                  'text/tab-separated-values',
                  'text/plain',
                  '.csv',
                  '.tsv'
                )
      ),
      tags$hr(),
      checkboxInput('header', 'Header', TRUE),
      radioButtons('sep', 'Separator',
                   c(Comma=',',
                     Semicolon=';',
                     Tab='\t'),
                   ','),
      tags$hr()
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("Uploaded Data",
                 tableOutput('contents')
        ),
        tabPanel("Numerical Results",
                 h4(textOutput("caption2")),
                 plotOutput("density"),
                 htmlOutput("notes2"),
                 value = 2),
        tabPanel("Plot Results",
                 h4(textOutput("caption3")),
                 plotOutput("genderDensity", height="250px"),
                 verbatimTextOutput("sexDiff"),
                 htmlOutput("notes3"),
                 value = 3),
        id="tabs1")
    )
  )))