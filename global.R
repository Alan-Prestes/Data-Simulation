#Criando a função para a simulação de dados:
simulation <- function(fundadores, 
                       vara, 
                       vare, 
                       tam_ninhada, 
                       geracao, 
                       mort_ger,
                       sire_overlap, 
                       dam_overlap, 
                       prop_dam, 
                       prop_sire, 
                       sel_dam, 
                       sel_sire) 
{
    
  n_fund<-fundadores
  va<-vara
  ve<-vare
  n_filhos<-tam_ninhada
  ger<-geracao
  mort<-mort_ger
  sire<-sire_overlap
  dam<-dam_overlap
  
  p_dam<-prop_dam
  p_sire<-prop_sire
  crit_dam<-sel_dam
  crit_sire<-sel_sire
  
  data<-simulatePed(
      F0size = n_fund,
      Va0 = va,
      Ve = ve,
      littersize = n_filhos,
      ngen = ger,
      mort.rate = mort,
      overlap.s = sire,
      overlap.d = dam,
      f.rate = p_dam,
      m.rate = p_sire,
      fsel = crit_dam,
      msel = crit_sire)

  dados<-data
  dados$VG<-dados$PA+dados$MS
  dados<-dados[,c("ID", "SIRE", "DAM", "SEX", "GEN", "VG",  "P")]
  colnames(dados)<-c("Animal", "Touro", "Vaca", "Sexo", "Geracao", "VG", "Fenotipo")
  as.data.frame(dados)

}

#Calculando a endogamia do arquivo de pedigree
endogamia<-function(dados){
  DADOS<-dados
  ped<-DADOS[,c("Animal", "Touro","Vaca")]
  
  #########################   CALCULANDO A ENDOGAMIA   #########################
  endog<-as.data.frame(calcInbreeding(ped))
  
  #########################   EDITANDO DADOS FINAL   #########################
  colnames(endog)<-c("Endogamia")
  endog$Animal<-1:nrow(endog)

  dados.final<-left_join(DADOS, endog, by=c("Animal"="Animal"))
  dados.final<-dados.final[,c("Animal", "Touro", "Vaca", "Sexo", "Geracao", "Endogamia")]
  as.data.frame(dados.final)
  
  
}

#Função para estimativa da tendência genética
tend_gen <- function(dataset, plotly){
  
  if(plotly==T){
    data<-dataset
    min_x<-min(dataset$Geracao)
    max_x<-max(dataset$Geracao)

    medias<-data %>% 
      group_by(Geracao) %>%
      summarise(VG=mean(VG, na.rm =T))
    
    #determinando a fonte
    windowsFonts(fonte.tt = windowsFont("TT Arial"))
    #plot
    ggplotly(
      ggplot(data=medias, aes(x=Geracao, y=VG)) +
        theme_classic()+
        geom_point(size=2.5,pch=21,col='blue4',fill='cornflowerblue')+
        geom_smooth(method = "lm", formula = y ~ x, se=F, linetype=2, col="red")+
        labs(x = "Gerações", y = "Valores genéticos médios") + 
        theme(axis.title.y= element_text(family="fonte.tt", face="bold", colour = "black", size=12),
              axis.title.x= element_text(family="fonte.tt", face="bold", colour = "black", size=12),
              axis.text.x = element_text(family="fonte.tt", colour = "black"))+
        scale_x_continuous(breaks=seq(min_x, max_x, by=1),limits = c(min_x, max_x))
    )
    
  }
  
  else{
    data<-dataset
    min_x<-min(dataset$Geracao)
    max_x<-max(dataset$Geracao)
    
    medias<-data %>% 
      group_by(Geracao) %>%
      summarise(VG=mean(VG, na.rm =T))
    
    ggplot(data=medias, aes(x=Geracao, y=VG)) +
      theme_classic()+
      geom_point(size=2.5,pch=21,col='blue4',fill='cornflowerblue')+
      geom_smooth(method = "lm", formula = y ~ x, se=F, linetype=2, col="red")+
      labs(x = "Gerações", y = "Valores genéticos médios") + 
      theme(axis.title.y= element_text(family="fonte.tt", face="bold", colour = "black", size=12),
            axis.title.x= element_text(family="fonte.tt", face="bold", colour = "black", size=12),
            axis.text.x = element_text(family="fonte.tt", colour = "black"))+
      scale_x_continuous(breaks=seq(min_x, max_x, by=1),limits = c(min_x, max_x))
  }

  
  
}

#Função para estimativa da equação da tendência genética:
equacao_gen <- function(dataset){
  
  data<-dataset
 
   medias<-data %>% 
    group_by(Geracao) %>%
    summarise(VG=mean(VG, na.rm =T))
   
   modelo<-lm(VG~Geracao, data=medias)
   coeficientes <- modelo$coefficients
   texto <- sprintf('y = %.2f + %.2fx, R-Squared = %.2f', coeficientes[1], 
                    coeficientes[2], summary(modelo)$r.squared)
   
   cat("------------------------------------------------------------------------\n")
   cat("Tendência genética\n")
   print(texto)
  
}

#Função para estimativa da tendência fenotípica:
tend_fen <- function(dataset, plotly){
  
  if(plotly==T){
    data<-dataset
    min_x<-min(dataset$Geracao)
    max_x<-max(dataset$Geracao)
    
    medias<-data %>% 
      group_by(Geracao) %>%
      summarise(P=mean(Fenotipo, na.rm =T))
    
    #determinando a fonte
    windowsFonts(fonte.tt = windowsFont("TT Arial"))
    #plot
    ggplotly(
      ggplot(data=medias, aes(x=Geracao, y=P)) +
        theme_classic()+
        geom_point(size=2.5,pch=21,col='blue4',fill='cornflowerblue')+
        geom_smooth(method = "lm", formula = y ~ x, se=F, linetype=2, col="red")+
        labs(x = "Gerações", y = "Valores fenotípicos médios") + 
        theme(axis.title.y= element_text(family="fonte.tt", face="bold", colour = "black", size=12),
              axis.title.x= element_text(family="fonte.tt", face="bold", colour = "black", size=12),
              axis.text.x = element_text(family="fonte.tt", colour = "black"))+
        scale_x_continuous(breaks=seq(min_x, max_x, by=1),limits = c(min_x, max_x))
    )
    
  }
  
  else{
    data<-dataset
    min_x<-min(dataset$Geracao)
    max_x<-max(dataset$Geracao)
    
    medias<-data %>% 
      group_by(Geracao) %>%
      summarise(P=mean(Fenotipo, na.rm =T))
    
    ggplot(data=medias, aes(x=Geracao, y=P)) +
      theme_classic()+
      geom_point(size=2.5,pch=21,col='blue4',fill='cornflowerblue')+
      geom_smooth(method = "lm", formula = y ~ x, se=F, linetype=2, col="red")+
      labs(x = "Gerações", y = "Valores fenotípicos médios") + 
      theme(axis.title.y= element_text(family="fonte.tt", face="bold", colour = "black", size=12),
            axis.title.x= element_text(family="fonte.tt", face="bold", colour = "black", size=12),
            axis.text.x = element_text(family="fonte.tt", colour = "black"))+
      scale_x_continuous(breaks=seq(min_x, max_x, by=1),limits = c(min_x, max_x))
  }
  
  
  
}

#Função para estimativa da equação da tendência fenotípica:
equacao_fen <- function(dataset){
  
  data<-dataset
  
  medias<-data %>% 
    group_by(Geracao) %>%
    summarise(P=mean(Fenotipo, na.rm =T))
  
  modelo<-lm(P~Geracao, data=medias)
  coeficientes <- modelo$coefficients
  texto <- sprintf('y = %.2f + %.2fx, R-Squared = %.2f', coeficientes[1], 
                   coeficientes[2], summary(modelo)$r.squared)
  
  cat("------------------------------------------------------------------------\n")
  cat("Tendência fenotípica\n")
  print(texto)
  
}



