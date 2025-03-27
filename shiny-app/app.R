# This script reads the pin we just wrote back into the IDE and displays it in a shiny app

knitr::opts_chunk$set(echo = TRUE)
library(dplyr)
library(tidyverse)
library(stringr)
library(readr)
library(pins)
library(rsconnect)
library(usethis)

#Check our environment variables
# usethis::edit_r_environ()

library(rsconnect)

board <- board_rsconnect(auth = "envvar")

cars_data_back <-board %>% pin_read("lisa.anders/cars_dataset")

# DataTables example
shinyApp(
  ui = fluidPage(
    fluidRow(
      column(12,
             dataTableOutput('table')
      )
    )
  ),
  server = function(input, output) {
    output$table <- renderDataTable(cars_data_back)
  }
)