<p align="center"> <img src="https://user-images.githubusercontent.com/87569077/236585012-9f31c629-35f3-40c3-99de-541efcb9db63.jpg" width="200">
<h1 align="center"> Dashboard para simulação de dados </h1>

## Descrição do Projeto
Dashboard criado para a simulação de dados de populações animais para o ensino de melhoramento.

## O que a plataforma é capaz de fazer :checkered_flag:
1. Simular uma base de dados de uma população animal;
2. Calcular o coeficiente de endogamia dos animais presentes no arquivo de pedigree;
3. Obter a tendência genética e fenotípica da população simulada;
4. Fazer o download da base de dados simulada (em xlsx) e dos gráficos gerados (em png).

### Como executar:
Para executar abra o _`R Studio`_ e execute o seguinte comando:
```ruby
library(shiny)
runGitHub(repo="Data-Simulation", username = "Alan-Prestes", ref="main")
```


### Pacotes utilizados
* pedSimulate
* pedigree
* shiny
* shinythemes
* writexl
* dplyr
* ggplot2
* plotly


