library(dplyr)
library(lubridate)

# Definir los archivos a procesar
archivos <- list.files("Datos", pattern = "^Datos_Bine_\\d{4}\\.csv$", full.names = TRUE)

# Función para limpiar los datos
limpiar_datos <- function(file) {
  data <- read.csv(file)

  # Extraer el año del nombre del archivo
  anio <- as.numeric(gsub("Datos_Bine_(\\d{4}).csv", "\\1", basename(file)))

  # Condicional para diferenciar los años
  if (anio %in% 2020:2022) {
    # Renombrar columnas
    data_clean <- data %>%
      rename(
        Fecha = "Fecha",
        Horas = "Horas",
        O3 = "O3.horario..ppm.",
        O3_8Hrs = "O3.8.hrs..ppm.",
        NO2 = "NO2.horario..ppm.",
        CO_8Hrs = "CO.8.hrs..ppm.",
        SO2_24Hrs = "SO2.24.hrs..ppm.",
        PM_10_12Hrs = names(data)[8], # Usa el índice de la columna
        PM_2.5_12Hrs = names(data)[9]
      )

    # Definir columnas a excluir
    cols_excluir <- c("Fecha", "Horas", "CO_8Hrs", "PM_10_12Hrs", "PM_2.5_12Hrs")

    # Transformar columnas de caracter a numerico y colocar NA en los valores no numericos
    data_clean <- data_clean %>%
      mutate(across(
        .cols = !all_of(cols_excluir), # Aplica a todas las columnas menos "Fecha" y "Horas"
        .fns = ~ as.integer(as.numeric(na_if(., "F.O.")) * 1000)
      ))

    # Limpiar la columna CO_8Hrs
    data_clean <- data_clean %>%
      mutate(CO_8Hrs = na_if(CO_8Hrs, "F.O.")) %>% # Reemplazar "F.O." por NA correctamente
      mutate(CO_8Hrs = as.numeric(CO_8Hrs)) %>% # Convertir a numérico
      mutate(CO_8Hrs = as.integer(CO_8Hrs * 100))

    # Limpiar las columnas PM_10_12Hrs y PM_2.5_12Hrs
    data_clean <- data_clean %>%
      mutate(across(
        .cols = c("PM_10_12Hrs", "PM_2.5_12Hrs"), # Aplica a las columnas "CO_8Hrs" y "PM_2_5_12Hrs"
        .fns = ~ as.integer(as.numeric(na_if(., "F.O.")))
      ))

    # Cambiar tipo de dato a la columna fecha de carácter a fecha
    # Cambiar tipo de dato a la columna hora de carácter a fecha
    data_clean <- data_clean %>%
      transform(Fecha = ymd(Fecha)) %>%
      transform(Horas = hms(paste0(Horas, ":00")))
  } else if (anio %in% 2023:2024) {
    # Renombrar columnas
    data_clean <- data %>%
      rename(
        PM_10 = "PM.10", # Usa el índice de la columna
        PM_2.5 = "PM.2.5"
      )

    # Definir columnas a excluir
    cols_excluir <- c("Fecha", "Horas")

    # Transformar columnas de caracter a numerico y colocar NA en los valores no numericos
    data_clean <- data_clean %>%
      mutate(across(
        .cols = !all_of(cols_excluir), # Aplica a todas las columnas menos "Fecha" y "Horas"
        .fns = ~ as.integer(as.numeric(na_if(., "F.O.")))
      ))

    # Cambiar tipo de dato a la columna fecha de carácter a fecha
    # Cambiar tipo de dato a la columna hora de carácter a fecha
    data_clean <- data_clean %>%
      transform(Fecha = dmy(Fecha)) %>%
      transform(Horas = hms(paste0(Horas, ":00")))
  }


  # Guardar el dataset limpio
  write.csv(data_clean, paste0("Datos/cleaned/", basename(file)), row.names = FALSE)
}

# Aplicar la limpieza a todos los archivos
lapply(archivos, limpiar_datos)
