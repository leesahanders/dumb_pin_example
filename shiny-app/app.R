# This script reads the pin we just wrote back into the IDE and displays it in a shiny app - this pin needs to exist for the app to be able to run!

library(dplyr)
library(tidyverse)
library(stringr)
library(readr)
library(pins)
library(rsconnect)
library(usethis)
library(shiny)
library(DT)

#Check our environment variables
# usethis::edit_r_environ()

library(rsconnect)

board <- board_connect(auth = "envvar")

# Change this to your username
cars_data_back <-board %>% pin_read("lisa.anders/cars_dataset")

# DataTables example
shinyApp(
  ui = fluidPage(
    fluidRow(
      column(12,
             DT::DTOutput('table')
      )
    )
  ),
  server = function(input, output) {
    output$table <- renderDataTable(cars_data_back)
  }
)