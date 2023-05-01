library(shiny)
library(writexl)
library(pedSimulate)
library(pedigree)
library(dplyr)
library(ggplot2)
library(plotly)

shinyServer(
    function(input, output, session) {
      
      SIMULATION<-reactive({
        input$RUN
        isolate({
          botao <- input$RUN
          if (is.null(botao)) {
            return(NULL)
          } else {
            
        simulacao<-simulation(fundadores=input$FUND,
                             vara=input$VAR_A,
                             vare=input$VAR_E,
                             tam_ninhada=input$LITTERSIZE,
                             geracao=input$GER,
                             mort_ger=input$MORTALIDADE,
                             sire_overlap=input$SIRE_OVERLAP,
                             dam_overlap=input$DAM_OVERLAP,
                             prop_dam=input$PROP_DAM,
                             prop_sire=input$PROP_SIRE,
                             sel_dam=input$CRIT_SEL_DAM,
                             sel_sire=input$CRIT_SEL_SIRE)
        return(simulacao)
        }
      })
      })
        
        
        output$DATA <-
            renderDataTable({
      
                    if (is.null(SIMULATION())) {
                        NULL
                    } else {
                        SIMULATION()

                        }
                    })


        output$DOWN_DATA<-downloadHandler(
            filename = paste("Dados simulados ","-",Sys.Date(), ".xlsx", sep=""),
            content = function(file) {write_xlsx(SIMULATION(), 
                                                 path = file)})
        
        
        ENDOGAMIA<-reactive({
          input$RUN
          isolate({
            botao <- input$RUN
            if (is.null(botao)) {
              return(NULL)
            } else {
              endogamia(dados=SIMULATION())
              }
          })
        })
        
        output$ENDOG <-
          renderDataTable({
            
            if (is.null(SIMULATION())) {
              NULL
            } else {
              ENDOGAMIA()
              
            }
          })
        
        output$DOWN_DATA_ENDOG<-downloadHandler(
          filename = paste("Endogamia","-",Sys.Date(), ".xlsx", sep=""),
          content = function(file) {write_xlsx(ENDOGAMIA(), 
                                               path = file)})
        
        
        
        output$TEND_GEN <-
          renderPlotly({
            if (is.null(SIMULATION())) {
              NULL
            } else {
              tend_gen(dataset = SIMULATION(), plotly = T)
            }
          })
        
        output$EQUATION_GEN <-
          renderPrint({
            if (is.null(SIMULATION())) {
              NULL
            } else {
              equacao_gen(dataset = SIMULATION())
            }
          })
        
        output$DOWN_TEND_GEN<-downloadHandler(
          filename = 'Tendência genética.png',
          content = function(file) {
            device <- function(..., width, height) {
              png(..., width = 10, height = 8,
                  res = 300, units = "in")
            }
            ggsave(file, plot = tend_gen(dataset = SIMULATION(), plotly = F), device = device)
          })
        
        
        
        output$TEND_FEN <-
          renderPlotly({
            if (is.null(SIMULATION())) {
              NULL
            } else {
              tend_fen(dataset = SIMULATION(), plotly = T)
            }
          })
        
        output$EQUATION_FEN <-
          renderPrint({
            if (is.null(SIMULATION())) {
              NULL
            } else {
              equacao_fen(dataset = SIMULATION())
            }
          })
        
        output$DOWN_TEND_FEN<-downloadHandler(
          filename = 'Tendência fenotípica.png',
          content = function(file) {
            device <- function(..., width, height) {
              png(..., width = 10, height = 8,
                  res = 300, units = "in")
            }
            ggsave(file, plot = tend_fen(dataset = SIMULATION(), plotly = F), device = device)
          })

        
    })

