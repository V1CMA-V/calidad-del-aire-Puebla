library(dplyr)
library(lubridate)

data <- read.csv("Datos/Datos_Bine_2023.csv")

# Limpiar el dataset original

colnames(data)
# Renombrar columnas
 # Renombrar columnas
    data_clean <- data %>%
      rename(
        PM_10 = "PM.10",  # Usa el índice de la columna
        PM_2.5 = "PM.2.5"
      )

    # Definir columnas a excluir
    cols_excluir <- c("Fecha", "Horas")

    # Transformar columnas de caracter a numerico y colocar NA en los valores no numericos
    data_clean <- data_clean %>%
      mutate(across(
        .cols = !all_of(cols_excluir),  # Aplica a todas las columnas menos "Fecha" y "Horas"
        .fns = ~as.integer(as.numeric(na_if(., "F.O.")))
      ))

    # Cambiar tipo de dato a la columna fecha de carácter a fecha
    # Cambiar tipo de dato a la columna hora de carácter a fecha
    data_clean <- data_clean %>%
      transform(Fecha = dmy(Fecha)) %>%
      transform(Horas = hms(paste0(Horas, ":00")))

glimpse(data_clean)

# Guardar el dataset limpio
write.csv(data_clean, "Datos/cleaned/bine2020_cleaned.csv", row.names = FALSE)

# Ver el dataset corregido

dataSubmitted <- read.csv("Datos/cleaned/bine2020_cleaned.csv")
glimpse(dataSubmitted)