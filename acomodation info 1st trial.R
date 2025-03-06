# Load the shiny package
library(shiny)

 
# Define UI
ui <- fluidPage(
  titlePanel("Accommodation Information Entry"),
  
  sidebarLayout(
    sidebarPanel(
      textInput("district", "District"),
      textInput("sector", "Sector"),
      textInput("cell", "Cell"),
      textInput("village", "Village"),
      textInput("accommodation_name", "Accommodation Name"),
      textInput("parent_company", "Parent Company/Owner"),
      selectInput("type_of_accommodation", "Type of Accommodation Facility",
                  choices = c("Hotel", "Motel", "Apartment", "Guest House", "Lodge", "Resort")),
      selectInput("grade_classification", "Grade Classification (Star)",
                  choices = c("1 Star", "2 Star", "3 Star", "4 Star", "5 Star")),
      numericInput("starting_year", "Starting Year", value = 2023, min = 1900, max = 2023),
      numericInput("capacity", "Capacity (Number of Rooms)", value = 1, min = 1),
      actionButton("submit", "Submit")
    ),
    
    mainPanel(
      tableOutput("data_table")
    )
  )
)

# Define server logic
server <- function(input, output, session) {
  # Create a reactive data frame to store the input data
  data <- reactiveVal(data.frame())
  
  observeEvent(input$submit, {
    # Create a new row of data
    new_row <- data.frame(
      District = input$district,
      Sector = input$sector,
      Cell = input$cell,
      Village = input$village,
      Accommodation_Name = input$accommodation_name,
      Parent_Company = input$parent_company,
      Type_of_Accommodation = input$type_of_accommodation,
      Grade_Classification = input$grade_classification,
      Starting_Year = input$starting_year,
      Capacity = input$capacity,
      stringsAsFactors = FALSE
    )
    
    # Append the new row to the existing data
    updated_data <- rbind(data(), new_row)
    data(updated_data)
    
    # Clear the input fields after submission
    updateTextInput(session, "district", value = "")
    updateTextInput(session, "sector", value = "")
    updateTextInput(session, "cell", value = "")
    updateTextInput(session, "village", value = "")
    updateTextInput(session, "accommodation_name", value = "")
    updateTextInput(session, "parent_company", value = "")
    updateNumericInput(session, "starting_year", value = 2023)
    updateNumericInput(session, "capacity", value = 1)
  })
  
  # Render the data table
  output$data_table <- renderTable({
    data()
  })
}

# Run the application 
shinyApp(ui = ui, server = server)