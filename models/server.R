library(plumber)

serve_model <- plumb("models/plumber.R")
serve_model$run(port = 8000)