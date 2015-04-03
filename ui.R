#ui.R
shinyUI(fluidPage(
  titlePanel("qPCR analysis"),
  p(h5("Developed by Siqi Liu")),
  p(h5("Version 1.00")),
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
      tabPanel("Download Data",
        downloadButton('downloadnumerical', 'Download Normalized Data')
        )
    )),
    mainPanel(
      tabsetPanel(
        tabPanel("Instructions",
                 h4('Please read the instructions carefully before starting the analysis'),
                 p('1. This program can accept txt files or csv files with different types of seperations, please specify the seperator from the File Upload Info tab.'),
                 p('2. The data file should have at least 3 columns, with the column Sample,Target,Ct. Please prepare the data file before uploading.'),
                 p('3. Once the data file is successfully uploaded, you can go to the Setting up Parameters tab. If multiple endogenous control genes are used in the experiment, you can type them into the Total Endogenous Controls filed, seperated by comma. If more than 3 endogenous controls are used, the M values for the controls will be calculated and show up in the Numeric Results section.'),
                 p('4. You can based on the calculated M values to pick the desired endogenous controls for data normalization. Type the desired endogenous control genes in the Use Endogenous Control filed, separated by comma. The normalized gene expression will show up in the Numeric Result section.'),
                 p('5. Once the parameters are setup, you can click Confirm Parameters and Plot button to plot the result graphs. The graphs can be visualized in the Graphic Results section'),
                 p('6. You can download the normalized data from the Download Data tab. By clicking the Download Normalized Data, you can download the results after normalization for further processes')
        ),
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
                 imageOutput("plotimages")
                 )
        )
    )
  )))