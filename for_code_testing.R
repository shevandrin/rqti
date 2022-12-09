file1 <- "D:/Data Science/R headson/some trash/gap/ex_g"
file2 <- "D:/Data Science/R headson/some trash/gap/ex_g_yaml"
file3 <- "D:/Data Science/R headson/qti/results/choice.xml"

tem1 <- new("Entry", text = create_content_object(file1), title = "test_example")
tem2 <- new("Entry", text = create_content_object(file2), title = "test_example")
te <- new("Entry", text = create_content_object(file2), title = "text_gaps_task")
create_qti_task(te)

# to save R objects use saveRDS(object, file)
saveRDS(sc, "signleChoice.rds")

# to read R objects from the rds fiel use readRDS(file)
readRDS("signleChoice.rds")


root <- xml_new_root("root")
child1 <- xml_add_child(root, "child1")
xml_attrs(child1) <- c("id" = "xx", "number" = "2")
child2 <- xml_add_child(root, "child2")
xml_attrs(child2) <- c("number" = "2", "id" = "xx")
b <- structure(child1)
c <- structure(child2)

d1 <- tag("p", list("id" = "xxx", "number" = 2))
d2 <- tag("p", list("number" = 2, "id" = "xxx"))
setdiff(d1, d2)
compare.list(d1, d2)
useful::compare.list(d1, d2)
d1[3]
