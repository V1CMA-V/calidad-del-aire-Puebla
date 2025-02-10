 library(tidyverse)
library(ggplot2)

data <- readr::read_csv("Datos/Datos_santa_2023.csv")
data2022 <- readr::read_csv("Datos/Datos_santa_2022.csv")
data2022Corregido <- readr::read_csv("Datos/corregidos/santa2022_corregido.csv")

glimpse(data)
glimpse(data2022Corregido)

# Objetivo de la practica: Utilizar K-NN para encontrar provincias que tienen medidad de fertilidad similares.
