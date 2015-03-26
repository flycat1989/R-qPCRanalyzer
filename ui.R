#ui.R
shinyUI(fluidPage(
  titlePanel("qPCR analysis"),
  sidebarLayout(
    sidebarPanel(
      tabsetPanel(
        tabPanel("File upload info",
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
    tabPanel("Setting up parameters",
    textInput("endoCtrl", "Endogenous Control:", "Actin")
    )
    )),
    mainPanel(
      tabsetPanel(
        tabPanel("Uploaded Data",
                 tableOutput('contents')
        ),
        tabPanel("Numerical Results",
                 p('This is the summary of control genes'),
                 tableOutput('meanCtrlTable'),
                 tags$hr(),
                 p('This is the M values for multiple endogenous controls'),
                 tableOutput('mvalues'),
                 tags$hr(),
                 p('This is the relative expression result (2^-dCt)'),

                 ),
        tabPanel("Graphical Results",
                 h4(textOutput("caption3")),
                 plotOutput("genderDensity", height="250px"),
                 verbatimTextOutput("sexDiff"),
                 htmlOutput("notes3"),
                 value = 3),
        id="tabs1")
    )
  )))