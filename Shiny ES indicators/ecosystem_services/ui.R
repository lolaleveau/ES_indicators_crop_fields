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




  dashboardPage(
    skin = "blue",
    dashboardHeader(
      title = "Field-based indicators for biophysical assessment of Ecosystem Services in crop fields 
",
      titleWidth = "100%"),
    dashboardSidebar(
      
      dashboardSidebar(
        sidebarMenu(
          menuItem(" About the database", 
                   tabName = "about", 
                   icon = icon("question")),
          
          menuItem("Indicators", 
                   tabName = "boerema", 
                   icon = icon("bug")
                   ),
          

          
          menuItem(" Links between classifications", 
                   tabName = "link", 
                   icon = icon("diagram-project")),
          
          menuItem(" Original names", 
                   tabName = "names", 
                   icon = icon("book"))
        )
      )
      
    ),
    dashboardBody(
      tabItems(
        ####### ES indicators
        tabItem(tabName = "boerema", width = 12,
              
                  fluidRow(
                    column(6, 
                           fluidRow(
                                 box(width = 12,
                                   title = "Select Ecosystem Services classification :",
                                   status = "primary",
                                   solidHeader = T,
                                   collapsible = TRUE,
  
                                   selectInput(
                                     "select_classification",
                                     "",
                                     c("Boerema", "CICES", "TEEB"),
                                     selected = "Boerema",
                                     multiple = FALSE,
                                     selectize = TRUE
                                   ),
                                 )
                           ), 
                           fluidRow(
                             box(width=12,
                                title = "Filter the displayed Ecosystem Services",
                                status = "primary",
                                solidHeader = TRUE,
                                collapsible = TRUE,

                                # selectInput(
                                #   "select_es_section",
                                #   "By ES section",
                                #   "choices",
                                #   multiple = TRUE,
                                #   selectize = TRUE
                                # ),

                                
                                pickerInput(
                                  "select_es_section",
                                  "By Ecosystem Services section :",
                                  "choices",
                                  options = pickerOptions(
                                    actionsBox = TRUE, 
                                    size = 10,
                                    selectedTextFormat = "count > 3"
                                  ), 
                                  multiple = TRUE#,
                                  # selectize = TRUE
                                ),

                                # selectInput(
                                #   "select_es_type",
                                #   "By Ecosystem Services type for field crops :",
                                #   c("Input"=1, "Output without direct income"=2,
                                #     "Output with direct income"=3),
                                #   selected = c(1:3),
                                #   multiple = TRUE,
                                #   selectize = TRUE
                                # ),
                                
                                pickerInput(
                                  "select_es_type",
                                  "By Ecosystem Services type for field crops :",
                                  c("Input"=1, "Output with direct income"=2,
                                    "Output without direct income"=3),
                                  selected = c(1:3),
                                  options = pickerOptions(
                                    actionsBox = TRUE, 
                                    size = 10,
                                    selectedTextFormat = "count > 3"
                                  ), 
                                  multiple = TRUE#,
                                  # selectize = TRUE
                                ),

                                pickerInput(
                                  "select_es_name",
                                  "By Ecosystem Services name :",
                                  "choices",
                                  options = pickerOptions(
                                    actionsBox = TRUE, 
                                    size = 10,
                                    selectedTextFormat = "count > 3"
                                  ), 
                                  multiple = TRUE#,
                                  # selectize = TRUE
                                )
                              )
                           ), 
                           fluidRow(
                             box(width=12,
                                 title = "Show the articles using the indicators :",
                                 status = "primary",
                                 solidHeader = TRUE,
                                 collapsible = TRUE,
                                 
                                 materialSwitch(
                                   "show_article",
                                   "Show articles",
                                   value = T, 
                                   status="success"
                                 ) ,
                                 
                                 # selectInput(
                                 #   "filter_article",
                                 #   "Filter the articles by measure method :",
                                 #   "select",
                                 #   multiple = TRUE,
                                 #   selectize = TRUE
                                 # )
                                 
                                 pickerInput(
                                   "filter_article",
                                   "Filter the articles by measure method :",
                                   "choices",
                                   options = pickerOptions(
                                     actionsBox = TRUE, 
                                     size = 10,
                                     selectedTextFormat = "count > 3"
                                   ), 
                                   multiple = TRUE#,
                                   # selectize = TRUE
                                 )
                             )
                           )
                    ),
                    
                    column(6, 
                           
                           
                           
                           fluidRow(
                             valueBoxOutput("progressBox", width=6),
                             valueBoxOutput("indicatorBox", width=6)
                           ),
                           
                           fluidRow(
                             box(width=12,
                                 solidHeader = F,
                                 
                                  plotOutput("plot_indicators", height = "250px")
                             )
                           ),
                           fluidRow(
                             box(width=12,
                                title = "Downloads",
                                status = "success",
                                solidHeader = TRUE,
                                collapsible = TRUE,

                                downloadButton("download__filter_table_data",
                                               "Download filtered data"),
                                downloadButton("download_table_data",
                                               "Download complete dataset")
                              )
                           )
                    )
                  ),
                fluidRow(
                  column(width = 12,
                    box(width = 12,
                        solidHeader = T, 
                        title = "Field-based indicators for biophysical assessment of Ecosystem Services in crop fields",
                      DT::dataTableOutput("data_table")
                    )
                  )
                )
                # 
        ),
        
        
        
        ###### Links
        tabItem(tabName = "link",
                fluidRow(
                  column(width = 12,
                         box(
                           width = 12,
                           title = "Link between classifications", 
                           solidHeader = TRUE,
                           collapsible = TRUE,
                           includeMarkdown("www/link_text.md"), 
                           # fluidRow(
                             downloadButton("download_link_data",
                                            "Download dataset"), 
                           actionButton(inputId='ab1', 
                                        label="CICES webpage", 
                                        icon = icon("arrow-up-right-from-square"), 
                                        onclick ="window.open('https://cices.eu/resources/ ', '_blank')"),
                           
                           actionButton(inputId='ab2', 
                                        label="TEEB webpage", 
                                        icon = icon("arrow-up-right-from-square"), 
                                        onclick ="window.open('https://teebweb.org/publications/teeb-for/synthesis/', '_blank')")
                           # )
                         )
                  )
                ), 
                
                fluidRow(
                  column(width = 12,
                         box(width = 12,
                             DT::dataTableOutput("link_table")
                         )
                  )
                )       
                
          ),
        
        
        ###### names
        tabItem(tabName = "names",
                
                fluidRow(
                  column(width = 12,
                         box(
                           width = 12,
                            title = "Original names", 
                            solidHeader = TRUE,
                            collapsible = TRUE,
                            includeMarkdown("www/names_text.md"), 
                           downloadButton("download_name_data", "Download dataset")
                          )
                         )
                  ), 
                
                fluidRow(
                  column(width = 12,
                         box(width = 12,
                             DT::dataTableOutput("name_table")
                         )
                  )
                )  
        ), 
        
        
        ###### About
        tabItem(tabName = "about",
                
                fluidRow(
                  column(width = 12,
                         box(
                           width = 12,
                           title = "", 
                           solidHeader = TRUE,
                           collapsible = TRUE,
                           includeMarkdown("www/about_text.md"), 
                           downloadButton("download_about_data", 
                                          "Download dataset"), 
                           actionButton(inputId='ab3', 
                                        label="Read our paper", 
                                        icon = icon("arrow-up-right-from-square"), 
                                        onclick ="window.open('#', '_blank')"), 
                           actionButton(inputId='ab4', 
                                        label="Zenodo dataset", 
                                        icon = icon("arrow-up-right-from-square"), 
                                        onclick ="window.open('#', '_blank')"), 
                           actionButton(inputId='ab5', 
                                        label="Contact us", 
                                        icon = icon("envelope"), 
                                        onclick ="window.open('mailto:lola.leveau@gmail.com', '_blank')")
                         )
                  )
                ), 
                fluidRow(
                  column(width = 12,
                         box(width = 12,
                             DT::dataTableOutput("about_table")
                         )
                  )
                )
        )
        
        
      )

    )
  )
