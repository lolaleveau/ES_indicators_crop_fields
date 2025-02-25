# Copyright © 2024, Université catholique de Louvain
# All rights reserved.
# 
# Developers: Guillaume Lobet & Lola Leveau
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
# http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

shinyServer(function(input, output, clientData, session) {
  
  rs <- reactiveValues(selected_data = NULL)
  
  
  observe({
    

    updatePickerInput(session, "select_es_section", 
                      choices = unique(Ecosystem_service$ES_section), 
                      selected = unique(Ecosystem_service$ES_section))
    
    updatePickerInput(session, "filter_article", 
                      choices = unique(Indicator_Article$Measure_method), 
                      selected = unique(Indicator_Article$Measure_method))
    
    

    
    
  }) 
  
  observe({
    # 
    if(is.null(input$select_es_section)) return()
    
    temp <- Ecosystem_indicators %>%
      filter(ES_section %in% input$select_es_section)

    
    if(input$select_classification == "Boerema"){
      updatePickerInput(session, "select_es_name",
                        choices = unique(temp$ES_name_Boerema),
                        selected = unique(temp$ES_name_Boerema))
    }
    if(input$select_classification == "CICES"){
      updatePickerInput(session, "select_es_name",
                        choices = unique(temp$ES_name_CICES),
                        selected = unique(temp$ES_name_CICES))
    }
    if(input$select_classification == "TEEB"){
      updatePickerInput(session, "select_es_name",
                        choices = unique(temp$ES_name_TEEB),
                        selected = unique(temp$ES_name_TEEB))
    }
    # 
    
  })
  
  
  
  #### DISPLAY THE TABLES
  
  output$data_table <- DT::renderDataTable({
    
    temp <- getFilteredData(input) %>% 
      select(-ID)
      
    if(input$show_article){
      temp <- temp %>% 
      mutate(DOI = paste0('<a href = "http://www.doi.org/',DOI,'">',DOI,'</a>'))
    }
      
    temp
    
  }, server = T, selection = 'single', escape=F, 
  options = list(scrollX=T,pageLength = 50)
  )
  
  
  
  output$link_table <- DT::renderDataTable({
  
    Ecosystem_all
    
  }, server = T, selection = 'single', 
  options = list(scrollX=T, pageLength = 50)
  )
  
  
  output$name_table <- DT::renderDataTable({
    
    Indicators_names
    
  }, server = T, selection = 'single', 
  options = list(scrollX=T, pageLength = 50)
  )
  
  
  output$about_table <- DT::renderDataTable({
    
    Variable_definitions
    
  }, server = T, selection = 'single', 
  options = list(scrollX=T, pageLength = 50)
  )
  
  
  
  #### DOWNLOAD THE DATA
  
  # Download a csv file of the selected dataset
  output$download__filter_table_data <- downloadHandler(
    filename = function() {
      paste0(Sys.Date(), "_ES_indicators",".csv")
    },
    content = function(file) {
      
      temp <- getFilteredData(input)
      
      write.csv(temp, file, row.names = FALSE)
    }
  )
  
  
  
  # Download the whole database file
  output$download_table_data <- downloadHandler(
    filename = function() {
      paste0(Sys.Date(), "_ALL_ES_indicators",".xlsx")
    },
    
    content <- function(file) {
      file.copy("www/AppendixA_database_2024-10.xlsx", file)
    },
    contentType = "application/xlsx"
  )
  
  
  
  # Download a csv file of the selected dataset
  output$download_name_data <- downloadHandler(
    filename = function() {
      paste0(Sys.Date(), "_ES_names",".csv")
    },
    content = function(file) {
      
      write.csv(Indicators_names, file, row.names = FALSE)
    }
  )
  
  
  # Download a csv file of the selected dataset
  output$download_link_data <- downloadHandler(
    filename = function() {
      paste0(Sys.Date(), "_ES_links",".csv")
    },
    content = function(file) {
      
      write.csv(Ecosystem_all, file, row.names = FALSE)
    }
  )
  
  
  # Download a csv file of the selected dataset
  output$download_about_data <- downloadHandler(
    filename = function() {
      paste0(Sys.Date(), "_ES_variable_definitions",".csv")
    },
    content = function(file) {
      
      write.csv(Variable_definitions, file, row.names = FALSE)
    }
  )
  
  
  
  
  output$progressBox <- renderValueBox({
    valueBox(
      value = nrow(getFilteredData(input)), 
      "Data selected ", 
      icon = icon("list"),
      color = "green"
    )
  })
  
  output$indicatorBox <- renderValueBox({
    valueBox(
      length(unique(getFilteredData(input)$Indicator_name)),
      "Indicators selected ", 
      icon = icon("magnifying-glass"),
      color = "green"
    )
  })
  
  output$plot_indicators <- renderPlot({
    temp <- getFilteredData(input) %>% 
      distinct(ID, ES_name, .keep_all = T)   
    
    ggplot(temp, aes(Cascade_level, fill=ES_section)) + 
      geom_bar() + 
      scale_fill_manual(values=c('#00A65A','#999999')) + 
      theme_bw() +
      ylab("Number of indicators")+
      xlab("Cascade level")
    
    
  })
  
  
})