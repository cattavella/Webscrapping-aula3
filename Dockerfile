
FROM rocker/tidyverse

WORKDIR "./Webscrapping-aula3"

RUN R -e "install.packages('xml2')"
RUN R -e "install.packages('stringr')"
RUN R -e "install.packages('ggplot2')"
RUN R -e "install.packages('rvest')"
RUN R -e "install.packages('httr')"

COPY "./Dados_avon.R"			"./Dados_avon.R"
COPY "./CriaDataFrame.R"		"./CriaDataFrame.R"

CMD Rscript "./CriaDataFrame.R"


