library(shiny)
library(shinythemes)
library(plotly)

shinyUI(
    fluidPage(
        theme = shinytheme("journal"),
        includeHTML("www/Cabecalho.Rhtml"),
        sidebarLayout(
            sidebarPanel(
                # Upload de arquivo. -----------------------------------
                numericInput(
                    inputId = "FUND",
                    label = "Selecione o N?mero de Animais Fundadores",
                    value=100,
                    min=NA,
                    max=NA),
                
                numericInput(
                    inputId = "VAR_A",
                    label = "Variância genética aditiva",
                    value=10),
                numericInput(
                    inputId = "VAR_E",
                    label = "Variância ambiental",
                    value=40),
                numericInput(
                    inputId = "LITTERSIZE",
                    label = "Tamanho da ninhada",
                    value=1),
                numericInput(
                    inputId = "GER",
                    label = "Número de gerações",
                    value=5),
                numericInput(
                    inputId = "MORTALIDADE",
                    label = "Taxa de mortalidade por geração",
                    value=0,
                    min = 0,
                    max = 0.5),
                
                numericInput(
                    inputId = "SIRE_OVERLAP",
                    label = "Número de gerações sobrepostas para touros",
                    value=1),
                numericInput(
                    inputId = "DAM_OVERLAP",
                    label = "Número de gerações sobrepostas para vacas",
                    value=0),
                sliderInput(
                    inputId = "PROP_DAM",
                    label = "Proporção de fêmeas selecionadas",
                    min = 0,
                    max = 1,
                    value = 0.8,
                    step = 0.01),
                sliderInput(
                    inputId = "PROP_SIRE",
                    label = "Proporção de machos (<= Prop.Fêmeas) selecionados",
                    min = 0,
                    max = 1,
                    value = 0.5,
                    step = 0.01),
                selectInput("CRIT_SEL_DAM", 
                            label = h4("Critério de seleção das fêmeas"), 
                            choices = list("Aleatório" = "R", 
                                           "Positivo baseado no fenótipo" = "P", 
                                           "Negativo baseado no fenótipo" = "-P",
                                           "Positivo baseado na média dos pais" = "PA", 
                                           "Negativo baseado na média dos pais" = "-PA"), 
                            selected = "R"),
                selectInput("CRIT_SEL_SIRE", 
                            label = h4("Critério de seleção dos machos"), 
                            choices = list("Aleatório" = "R", 
                                           "Positivo baseado no fenótipo" = "P", 
                                           "Negativo baseado no fenótipo" = "-P",
                                           "Positivo baseado na média dos pais" = "PA", 
                                           "Negativo baseado na média dos pais" = "-PA"), 
                            selected = "R"),
                actionButton(
                    inputId = "RUN",
                    width = , 
                    label = "Simular",
                    icon("file-import"), 
                    style="color: #121201; background-color: #11fa3c; border-color: #121201;padding:15px; font-size:80%"),

               ),
        
            mainPanel(
                strong("Instruções:"),
                p("1. Escolha o número de animais fundadores", style = "font-family: 'times'; font-si8pt"),
                p("2. Escolha o valor das variâncias genéticas aditivas e ambientais.", style = "font-family: 'times'; font-si8pt"),
                p("3. Defina o número de filhos (Padrão=1)", style = "font-family: 'times'; font-si6pt"),
                p("4. Defina o número de gerações após a geração fundadora", style = "font-family: 'times'; font-si8pt"),
                p("5. Defina a taxa de mortalidade por geração (Padrão=0, Máximo=0.5).", style = "font-family: 'times'; font-si8pt"),
                p("6. Defina o Número de gerações sobrepostas para touros (Padrão=0).", style = "font-family: 'times'; font-si8pt"),
                p("7. Defina a proporção de seleção de machos e fêmeas (Padrão=1).", style = "font-family: 'times'; font-si8pt"),
                p("8. Escolha os criérios de seleção dos machos e fêmeas (Padrão= Aleatório).", style = "font-family: 'times'; font-si8pt"),
                
                code("Clique no botão Simular"),
                # Gráficos e saídas. -----------------------------------
                tabsetPanel(
                    id = "GUIAS",
                    tabPanel(
                        title = "Arquivo simulado",
                        dataTableOutput("DATA"),
                        downloadButton(outputId = "DOWN_DATA",
                                       label= "Download",
                                       icon = shiny::icon("download"))),
                    
                    tabPanel(
                        title = "Endogamia",
                        dataTableOutput("ENDOG"),
                        downloadButton(outputId = "DOWN_DATA_ENDOG",
                                       label= "Download",
                                       icon = shiny::icon("download"))),
                    tabPanel(
                        title = "Tendência genética",
                        plotlyOutput("TEND_GEN",
                                     width = 900,
                                     height = 600),
                        verbatimTextOutput("EQUATION_GEN"),
                        downloadButton(outputId = "DOWN_TEND_GEN",
                                       label= "Download do gráfico",
                                       icon = shiny::icon("download"))),
                    
                    tabPanel(
                        title = "Tendência fenotípia",
                        plotlyOutput("TEND_FEN",
                                     width = 900,
                                     height = 600),
                        verbatimTextOutput("EQUATION_FEN"),
                        downloadButton(outputId = "DOWN_TEND_FEN",
                                       label= "Download do gráfico",
                                       icon = shiny::icon("download")))

                ) # tabsetPanel
            ) # mainPanel
        ), # sidebarLayout
        includeHTML("www/Rodape.Rhtml")
        
    ) # fluidPage
) # shinyUI

# cat("Final do FRONTEND\n")
