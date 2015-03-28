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
        textInput("endoCtrl", "Total Endogenous Control (For M value calculation only):", "Actin"),
        textInput("endoUse","Use Endogenous Control:","Actin"),
        actionButton("plotbutton", "Confirm parameters and plot")
        ),
      tabPanel("Download data",
        downloadButton('downloadnumerical', 'Download Normalized Data'),
        downloadButton('downloadgraphical', 'Download Plots')
        )
    )),
    mainPanel(
      tabsetPanel(
        tabPanel("Uploaded Data",
                 tableOutput('contents')
        ),
        tabPanel("Numerical Results",
                 p('This is the M values for multiple endogenous controls'),
                 tableOutput('mvalues'),
                 tags$hr(),
                 p('This is the relative expression result (2^-dCt)'),
                 tableOutput('normdata'),
                 tags$hr()
                 ),
        tabPanel("Graphical Results",
                 uiOutput("plotimages")
                 )
        )
    )
  )))