library(dplyr)

data2024 <- read.csv("Datos/cleaned/Datos_Bine_2024.csv")
data2022 <- read.csv("Datos/cleaned/Datos_Bine_2022.csv")

glimpse(data2024)
glimpse(data2022)

# Comparar las columnas de los dos dataframes
summary(data2024)
summary(data2022)

# Ver total de valores NA del archivo
sum(is.na(data2024))
sum(is.na(data2022))