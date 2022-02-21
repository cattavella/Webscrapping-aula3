library(rvest)
library(httr)
library(xml2)

# Função que faz as buscas de todos os produtos relevantes do site da Avon e 
# armazena o xml. Por enquanto est?? "burro", pois fui manualmente em cada menu
# para ver o n??mero de páginas de retorno e fazer o "for". Por enquanto não foi 
# feito tratamento para o número de páginas de busca.

webscrap_Avon <- function () {
  
  last_date = format(Sys.time(), "%Y%m%d")
  name_dir = paste0("Avon",last_date)
  
  if (!file.exists(name_dir)){
    dir.create(file.path(name_dir))
  }
  
  #html_object = read_html("https://www.avon.com.br/bbb-perfumaria?sc=1&page=1")
  #write_xml(html_object, file=paste(name_dir,"/perfume_pag1.html"))
  
  #html_object = read_html("https://www.avon.com.br/bbb-perfumaria?sc=1&page=2")
  #write_xml(html_object, file=paste0(name_dir,"/perfume_pag2.html"))
  
  for (i in 1:2){
    html_object = read_html(paste0("https://www.avon.com.br/fragrancias/kits?sc=1&page=",i))
    write_xml(html_object, file=paste0(name_dir,"/perfume_kits_pag",i,".html"))
  }
  
  for (i in 1:6){
    html_object = read_html(paste0("https://www.avon.com.br/fragrancias/feminino?sc=1&page=",i))
    write_xml(html_object, file=paste0(name_dir,"/perfume_fem_pag",i,".html"))
  }
  
  for (i in 1:4){
    html_object = read_html(paste0("https://www.avon.com.br/fragrancias/masculino?sc=1&page=",i))
    write_xml(html_object, file=paste0(name_dir,"/perfume_masc_pag",i,".html"))
  }
  
  html_object = read_html("https://www.avon.com.br/fragrancias/infantil?sc=1")
  write_xml(html_object, file=paste0(name_dir,"/perfume_inf_pag1.html"))
  
  for (i in 1:3){
    html_object = read_html(paste0("https://www.avon.com.br/maquiagens/rosto?sc=1&page=",i))
    write_xml(html_object, file=paste0(name_dir,"/maq_rosto_pag",i,".html"))
  }
  
  for (i in 1:4){
    html_object = read_html(paste0("https://www.avon.com.br/maquiagens/olhos?sc=1&page=",i))
    write_xml(html_object, file=paste0(name_dir,"/maq_olhos_pag",i,".html"))
  }
  
  for (i in 1:3){
    html_object = read_html(paste0("https://www.avon.com.br/maquiagens/boca?sc=1&page=",i))
    write_xml(html_object, file=paste0(name_dir,"/maq_boca_pag",i,".html"))
  }
  
  html_object = read_html("https://www.avon.com.br/maquiagens/acessorios")
  write_xml(html_object, file=paste0(name_dir,"/maq_acessorios.html"))
  
  for (i in 1:5){
    html_object = read_html(paste0("https://www.avon.com.br/rosto/cuidados?sc=1&page=",i))
    write_xml(html_object, file=paste0(name_dir,"/rosto_cuidados_pag",i,".html"))
  }
  
  for (i in 1:3){
    html_object = read_html(paste0("https://www.avon.com.br/rosto/tratamentos?sc=1&page=",i))
    write_xml(html_object, file=paste0(name_dir,"/rosto_trat_pag",i,".html"))
  }
  
  for (i in 1:7){
    html_object = read_html(paste0("https://www.avon.com.br/corpo-e-banho/cuidados?sc=1&page=",i))
    write_xml(html_object, file=paste0(name_dir,"/corpo_cuidados_pag",i,".html"))
  }
  
  for (i in 1:2){
    html_object = read_html(paste0("https://www.avon.com.br/corpo-e-banho/cuidados-com-as-maos?sc=1&page",i))
    write_xml(html_object, file=paste0(name_dir,"/corpo_maos_pag",i,".html"))
  }
  
  html_object = read_html("https://www.avon.com.br/corpo-e-banho/cuidados-com-os-pes?sc=1")
  write_xml(html_object, file=paste0(name_dir,"/corpo_pes_pag1.html"))
  
  for (i in 1:5){
    html_object = read_html(paste0("https://www.avon.com.br/corpo-e-banho/desodorante?sc=1&page=",i))
    write_xml(html_object, file=paste0(name_dir,"/corpo_desod_pag",i,".html"))
  }
  
  
  html_object = read_html("https://www.avon.com.br/corpo-e-banho/infantil?sc=1")
  write_xml(html_object, file=paste0(name_dir,"/corpo_infantil_pag1.html"))
  
  html_object = read_html("https://www.avon.com.br/fragrancias?sc=1")
  write_xml(html_object, file=paste0(name_dir,"/fragrancias_completo.html"))
  
  
  for (i in 1:24){
    html_object = read_html(paste0("https://www.avon.com.br/moda-e-casa/casa?sc=1&page=",i))
    write_xml(html_object, file=paste0(name_dir,"/casa_pag",i,".html"))
  }
  
  for (i in 1:22){
    html_object = read_html(paste0("https://www.avon.com.br/moda-e-casa/moda?sc=1&page=",i))
    write_xml(html_object, file=paste0(name_dir,"/moda_pag",i,".html"))
  }
  
  for (i in 1:4){
    html_object = read_html(paste0("https://www.avon.com.br/cabelos/cuidados?sc=1&page=",i))
    write_xml(html_object, file=paste0(name_dir,"/cabelos_cuidados_pag",i,".html"))
  }
  
  for (i in 1:2){
    html_object = read_html(paste0("https://www.avon.com.br/tratamentos/tratamento-capilar?sc=1&page=",i))
    write_xml(html_object, file=paste0(name_dir,"/cabelos_trat_pag",i,".html"))
  }
  
  html_object = read_html("https://www.avon.com.br/cabelos?sc=1")
  write_xml(html_object, file=paste0(name_dir,"/cabelo_cuidados_completo.html"))
  
  for (i in 1:2){
    html_object = read_html(paste0("https://www.avon.com.br/unhas/esmaltes/esmalte?sc=1&page=",i))
    write_xml(html_object, file=paste0(name_dir,"/unhas_pag",i,".html"))
  }
}

