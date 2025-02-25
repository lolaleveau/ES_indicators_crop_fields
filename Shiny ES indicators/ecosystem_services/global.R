
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

library(shiny)
library(shinydashboard)
library(DT)
library(readxl)
library(tidyverse)
library(markdown)
library(shinyWidgets)

## Load tables

Indicator <- read_xlsx("www/AppendixA_database_2024-10.xlsx", 
                       sheet = "Indicator") %>% 
  mutate(Cascade_level = ifelse(Cascade_level == "Property", "1-Property", 
                                ifelse(Cascade_level == "Function", "2-Function", 
                                  ifelse(Cascade_level == "Benefit", "3-Benefit",
                                    ifelse(Cascade_level == "Disservice", "4-Disservice", "")))))

Old_indicator <- read_xlsx("www/AppendixA_database_2024-10.xlsx", 
                           sheet = "Old-indicator")

Article <- read_xlsx("www/AppendixA_database_2024-10.xlsx", 
                     sheet = "Article")

Ecosystem_service <- read_xlsx("www/AppendixA_database_2024-10.xlsx", 
                               sheet = "Ecosystem-service")

TEEB <- read_xlsx("www/AppendixA_database_2024-10.xlsx", 
                  sheet = "TEEB")

CICES <- read_xlsx("www/AppendixA_database_2024-10.xlsx", 
                   sheet = "CICES")

Ecosystem_service_TEEB <- read_xlsx("www/AppendixA_database_2024-10.xlsx", 
                                    sheet = "Ecosystem-service_TEEB")

Ecosystem_service_CICES <- read_xlsx("www/AppendixA_database_2024-10.xlsx", 
                                     sheet = "Ecosystem-service_CICES")

Indicator_Ecosystem_service <- read_xlsx("www/AppendixA_database_2024-10.xlsx", 
                                         sheet = "Indicator_Ecosystem-service")

Indicator_Article <- read_xlsx("www/AppendixA_database_2024-10.xlsx", 
                               sheet = "Indicator_Article")

Old_indicator_Indicator <- read_xlsx("www/AppendixA_database_2024-10.xlsx", 
                                     sheet = "Old-indicator_Indicator")


Variable_definitions <- read_xlsx("www/AppendixA_database_2024-10.xlsx", 
                                  sheet = "Variable_definitions")


temp <- merge(Ecosystem_service_CICES, 
                       Ecosystem_service_TEEB, 
                       by = "ES_name_Boerema")

Ecosystem_indicators <- merge(Indicator, 
                              Indicator_Ecosystem_service, 
                              by = "ID")
Ecosystem_indicators <- merge(Ecosystem_indicators, 
                              Ecosystem_service, 
                              by = "ES_name_Boerema")
Ecosystem_indicators <- merge(temp, Ecosystem_indicators, 
                              by = "ES_name_Boerema")


Ecosystem_indicators_full <- merge(Ecosystem_indicators, 
                                   Indicator_Article, 
                                   by = "ID")
Ecosystem_indicators_full <- merge(Ecosystem_indicators_full, 
                                   Article, 
                                   by = "DOI") 


Ecosystem_all <- merge(Ecosystem_service_CICES, 
                       Ecosystem_service_TEEB, 
                       by = "ES_name_Boerema")

Ecosystem_all <- merge(Ecosystem_all, 
                       Ecosystem_service, 
                       by = "ES_name_Boerema")%>% 
  select(-c(ES_type_IN, ES_type_OUT_income, 
            ES_type_OUT_no_income))



Indicators_names <- merge(Indicator, 
                          Old_indicator_Indicator, 
                          by = "ID")
Indicators_names <- merge(Indicators_names, 
                          Old_indicator, 
                          by = "ID_old") %>% 
  select(-ID, -ID_old)





getFilteredData <- function(input){
  
  temp <- Ecosystem_indicators
  if(input$show_article){
    temp <- Ecosystem_indicators_full
  }
  
  
  if(input$select_classification == "Boerema"){
    temp <- temp %>% 
      mutate(classification = "Boerema", 
             ES_name = ES_name_Boerema) 
  }
  if(input$select_classification == "CICES"){
    temp <- temp %>% 
      mutate(classification = "CICES", 
             ES_name = ES_name_CICES) 
      
  }
  if(input$select_classification == "TEEB"){
    temp <- temp %>% 
      mutate(classification = "TEEB", 
             ES_name = ES_name_TEEB) 
  }
  
  temp <- temp %>% 
    filter(ES_section %in% input$select_es_section) %>% 
    filter(ES_name %in% input$select_es_name)
  
  temp_1 <- temp %>% filter(ES_type_IN == 1)
  temp_2 <- temp %>% filter(ES_type_OUT_income == 1)
  temp_3 <- temp %>% filter(ES_type_OUT_no_income == 1)
  
  if(!"1" %in% input$select_es_type) temp_1 <- NULL
  if(!"2" %in% input$select_es_type) temp_2 <- NULL
  if(!"3" %in% input$select_es_type) temp_3 <- NULL
  
  if(input$show_article){
    temp <- rbind(temp_1, temp_2, temp_3) %>% 
      distinct(ID, ES_name, DOI, .keep_all = T)
  }else{
    temp <- rbind(temp_1, temp_2, temp_3) %>% 
      distinct(ID, ES_name, .keep_all = T)    
  }

  
  if(input$show_article){
    temp <- temp %>% 
      filter(Measure_method %in% input$filter_article)  %>% 
      select(ID, classification, ES_section, ES_name, Cascade_level,
             Indicator_name, Measure_method, Authors_short, DOI)
  }else{
    temp <- temp %>% 
      select(ID, classification, ES_section, ES_name, Cascade_level,
             Indicator_name)
  }
  
  temp <- temp %>% 
    arrange(ES_name, Cascade_level, Indicator_name) 
  
  return(temp)
}

















