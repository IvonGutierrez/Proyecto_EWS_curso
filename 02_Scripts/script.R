library(EWSmethods)
library(dplyr)
library(tidyr)
library(tidyverse)
library(usethis)#to set up Git and GitHub

x<-rnorm(1000)
hist(x)
#to relate R with GitHub

usethis::gis_git()
usethis::create_github_token()#in GitHub creates a Token
gitcreds::gitcreds_set()##click and copy Token
usethis::use_git_config(
  user.name = "IvonGutierrez",
  user.email = "ivon.gutierrez@ecologia.unam.mx"
)
usethis::use_github()#it creates a repository in GitHub, connect with local repository
usethis::use_github(private = TRUE)#specify as private##default is public

sd(x)

##for each change, we must use commit. 
##Check the script, summit the change, then PUSH (select the script)

##series time analysis
set.seed(125)

##with artificial data
skylark_data <- data.frame(
  time      = seq(1:50),
  abundance = rnorm(50, mean = 100, sd = 20)
)

head(skylark_data)
str(skylark_data)
summary(skylark_data$abundance)
nrow(skylark_data) 

plot(skylark_data$time, skylark_data$abundance,
     type = "l", lwd = 2, col = "#2c7fb8",
     xlab = "Tiempo (años)", ylab = "Abundancia de alondra")
points(skylark_data$time, skylark_data$abundance, pch = 16, col = "#253494")

ews_metrics <- c("SD", "ar1", "skew")  # las señales que queremos calcular
ews_metrics

##Method rolling window
roll_ews <- uniEWS(
  data    = skylark_data[, 1:2],
  metrics = ews_metrics,
  method  = "rolling",
  winsize = 50)## porcentaje del largo total de la serie

# Correlación (tau de Kendall) de cada métrica contra el tiempo:
roll_ews$EWS$cor
##Cerca de +1 → la métrica sube casi siempre → señal de alerta más fuerte.
##Cerca de 0 → sin tendencia clara → sin señal.
##Negativo → la métrica baja

plot(roll_ews, y_lab = "Abundancia de alondra")

##Method expanding window
exp_ews <- uniEWS(
  data           = skylark_data[, 1:2],
  metrics        = ews_metrics,
  method         = "expanding",
  burn_in        = 10,             # nº de puntos iniciales para calcular antes de evaluar
  threshold      = 2,              # umbral en desviaciones estándar (2σ)
  tail.direction = "one.tailed"    # anomalía cuando valores por encima de lo normal
)

head(exp_ews$EWS)
plot(exp_ews, y_lab = "Abundancia de alondra")

##Multivariate approach
set.seed(123)

octopus_spp_data <- matrix(nrow = 50, ncol = 5)
octopus_spp_data <- as.data.frame(
  cbind("time" = seq(1:50),
        sapply(1:dim(octopus_spp_data)[2],
               function(x) { octopus_spp_data[, x] <- rnorm(50, mean = 500, sd = 200) }))
)  

head(octopus_spp_data)

oct_exp_ews <- multiEWS(
  data           = octopus_spp_data,
  method         = "expanding",
  threshold      = 2,
  tail.direction = "one.tailed"
)

plot(oct_exp_ews)

##Cover grass data
datos_pastos <- read.csv("03_Data/valores3.csv")
head(datos_pastos)
str(datos_pastos)
summary(datos_pastos)

datos_pastos <- data.frame(
  time = seq_len(nrow(datos_pastos)) ,
  valor = datos_pastos
)

head(datos_pastos)

plot(datos_pastos$time, datos_pastos$valor,
     type = "l", lwd = 2, col = "#2c7fb8",
     xlab = "Tiempo (años)", ylab = "% Cobertura de pastos") 
points(datos_pastos$time, datos_pastos$valor,
       pch = 16, col = "#253494")

roll_ews  <- uniEWS(
  data           = datos_pastos,
  metrics        = ews_metrics,
  method         = "rolling",
  winsize = 20)

roll_ews$EWS$cor

plot(roll_ews, y_lab = "% Cobertura de pastos")

exp_ews <- uniEWS(
  data           = datos_pastos,
  metrics        = ews_metrics,
  method         = "expanding",
  burn_in        = 10,             # nº de puntos iniciales para calcular antes de evaluar
  threshold      = 2,              # umbral en desviaciones estándar (2σ)
  tail.direction = "one.tailed"    # solo nos interesan cruces hacia arriba
)

head(exp_ews$EWS)  # primeras filas del data.frame de resultados
plot(exp_ews, y_lab = "Cobertura de pastos")

##Datos sintéticos del modelo de bifurcación tipo saddle-node
##saddle node
datos_saddle_node <- read.csv("03_Data/SaddleNodeBifurcation.csv")
head(datos_saddle_node)

datos_saddle_node <- data.frame(
  time = seq_len(nrow(datos_saddle_node)) ,
  valor = datos_saddle_node)

head(datos_saddle_node)

plot(datos_saddle_node$time, datos_saddle_node$valor,
     type = "l", lwd = 2, col = "#2c7fb8",
     xlab = "Tiempo", ylab = "Valor") 
points(datos_saddle_node$time, datos_saddle_node$valor,
       pch = 16, col = "#253494")

roll_ews  <- uniEWS(
  data           = datos_saddle_node,
  metrics        = ews_metrics,
  method         = "rolling",
  winsize = 20)

roll_ews$EWS$cor

plot(roll_ews, y_lab = "Valor")

exp_ews <- uniEWS(
  data           = datos_saddle_node,
  metrics        = ews_metrics,
  method         = "expanding",
  burn_in        = 10,             # nº de puntos iniciales para calcular antes de evaluar
  threshold      = 2,              # umbral en desviaciones estándar (2σ)
  tail.direction = "one.tailed"    # solo nos interesan cruces hacia arriba
)

head(exp_ews$EWS)  # primeras filas del data.frame de resultados

plot(exp_ews, y_lab = "Valor")

