## S4 example

library(qti)

# create sc and mpc

sc <- new("singlechoice", text = "This is the sc question", choices = c("A", "B", "C", "D"), title = "filename")

mpc <- new("multiplechoice", text = "This is the mpc question", choices = c("A", "B", "C", "D"), points = c(1, 1, -1, 0), title = "filenamempc")

# Checks for types automatically! For instance, points must be a numeric:

# sc@points <- "text"

# Use generic function:

create_item_body(sc)
create_response_declaration(sc)

create_item_body(mpc)
create_response_declaration(mpc)
