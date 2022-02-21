# Lê os dados dos arquivos xml e armazena em um data frame. Essa função foi 
# criada principalmente porque os primeiros dados foram coletados antes de esta
# parte estar pronta, por isso o procedimento de obter os dados foi separado da
# escrita no dataframe. Armazenando os dados passados em algum arquivo (csv ou
# Excel deve melhorar a performance, já que o programa não precisa varrer todos
# os diretórios para montar o dataframe)

library(xml2)
library(stringr)
library(tidyverse)
source("Dados_avon.R")

# 
#setwd("C:/Users/Catarina/Documents/teste/Aula")
webscrap_Avon()

pastas_arq <- list.dirs(path = ".")
pastas_arq <- grep("*Avon*", pastas_arq, value = TRUE)

tabela <- data.frame(nome_prod       = character() 
                     , id_prod       = numeric()
                     , classificacao = character()
                     , preco         = numeric()
                     , dia_coleta    = character())

# Varre todas as pastas com arquivos html gravados
for(i in 1:length(pastas_arq)){
  html.files  <- list.files(path        = pastas_arq[i],
                            recursive   = T,
                            pattern     =".html"
                            ,full.names =T)


  # Varre todos os arquivos e salva no data frame
  for(j in 1:length(html.files)){
    
    # Define a classificação dos produtos (para posterior agregação e para os 
    # gráficos)
    if(grepl("cabelo", html.files[j])){
      classif <- "Cabelo" 
      
    } else if (grepl("corpo_cuidados", html.files[j]) | 
               grepl("rosto_cuidados", html.files[j]) |
               grepl("rosto_trat"    , html.files[j])) {
      classif <- "Pele" 
      
    }  else if (grepl("desod", html.files[j])) {
      classif <- "Desodorante"
      
    } else if (grepl("perfume", html.files[j])) {
      classif <- "Perfume"
      
    } else if (grepl("maq", html.files[j])) {
      classif <- "Maquiagem"
      
    } else if (grepl("unhas", html.files[j])) {
      classif <- "Unhas"
      
    } else {
      classif <- "Sem classificação"
    }
    
    if (!grepl("completo", html.files[j]) ){
      arq_html <- read_html(html.files[j])
      
      # Descarta os arquivos não classificados (para melhoria de performance)
      #if (classif != "Sem classificação"){
        
        # Obt??m o nome do produto
        prod_nome <- arq_html %>% 
                    html_nodes(css = "body") %>% 
                    html_nodes(css = "article") %>% 
                    html_nodes(css = "h2") %>% 
                    html_text()
        
        # A identificação do produto pode ser ??til, pois operações com inteiros
        # são mais rápidas que aquelas que utilizam strings
        prod_id <- arq_html %>% 
          html_nodes(css = "body") %>% 
          html_nodes(css = "article") %>% 
          html_attr("data-product-id") %>% 
          na.omit()
  
        # Pre??o atual (tentei pegar o pre??o anterior também, mas dá problema para
        # alguns itens, então estou pegando apenas o atual)
        valor <- arq_html %>% 
                  html_nodes(css = "body") %>% 
                  html_nodes(css = "article") %>% 
                  html_nodes(xpath = '//*[@class="x-shelf__best-price"]') %>% 
                  html_text()
        
        # Para alguns produtos o pre??o n??o aparece (pode ser porque estão indispon??veis)
        # Como ainda não consegui resolver, estou descartando o arquivo todo
        if(length(prod_nome) == length(valor)){
          tabela <- rbind(tabela, data.frame(nome_prod       = prod_nome
                                             , id_prod       = prod_id
                                             , classificacao = classif
                                             , preco         = as.numeric(str_replace(str_sub(valor,-6),",","."))
                                             , data          = as.POSIXct(substr(pastas_arq[i],7,14), format="%Y%m%d")) 
                                             )
        } else 
          print(paste("Arquivo:", html.files[j], "com problema!"))
        
      }
    #}
    
  }
}

tabela <- tabela %>% 
          distinct() %>% 
          na.omit() %>% 
          arrange(nome_prod, data)

# plot
p <- tabela %>%
  ggplot( aes(x=preco)) +
  geom_histogram( binwidth=10, fill="red", color="black", size=0.8) +
  ggtitle("Preço dos produtos") +
  labs(title = "Histograma - preço dos produtos", y = "Quantidade", x = "Preço") +
  theme(axis.title.x=element_blank(), axis.ticks.x=element_blank(), axis.ticks.y=element_blank(),legend.title = element_blank()) +
  theme(panel.background = element_rect(fill = 'white', colour = 'black'))
p

tabela_gr2 <- tabela %>% 
  group_by(classificacao) %>%
  summarize(preco_medio = mean(preco))

tabela_gr2 <- tabela_gr2 %>% 
  mutate(label_preco = paste("R$", format(round(preco_medio, digits = 2), nsmall=2)))

tabela_gr2$classificacao[tabela_gr2$classificacao == "Sem classificação"] <- "Outros"   

ggplot(data=tabela_gr2, aes(x=classificacao,y=preco_medio, fill = classificacao)) +
  geom_bar(position="dodge",stat="identity",) + 
  coord_flip() +  
  geom_text(aes(label=label_preco), position = position_dodge(width = 1), size=3.2) +
  ggtitle("Preço médio dos produtos em cada categoria") +
  labs(x= "Preço médio", y = "Classificação") +
  theme(legend.position = "none", panel.background = element_rect(fill = "transparent",colour = NA))
   


