## S4 example

library(qti)

# create sc and mpc

sc <- new("SingleChoice",
          text = "This is the sc question \n this is the second line of text",
          choices = c("Aa", "Bb", "Cc", "Dd"),
          title = "filename_sc",
          prompt = "this is a prompt")

mpc <- new("MultipleChoice", text = "This is the mpc question", choices = c("A", "B", "C", "D"), points = c(1, 1, -1, 0), title = "filename_mc")

gap <- new("TextEntry")
# Checks for types automatically! For instance, points must be a numeric:

# sc@points <- "text"

# Use generic function:

create_item_body(sc)
create_response_declaration(sc)

create_item_body(mpc)
create_response_declaration(mpc)

create_qti_task(sc)
create_qti_task(mpc)
