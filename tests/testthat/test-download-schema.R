test_that("download hints are confined to links in the extended schema", {
  source <- system.file("extdata", "sc1d.xml", package = "rqti")
  engines <- c("xml2", if (nzchar(Sys.which("xmllint"))) "xmllint")
  path <- tempfile(fileext = ".xml")
  withr::defer(unlink(path))

  validate_link <- function(attributes, engine, schema = "qti21") {
    item <- xml2::read_xml(source)
    body <- xml2::xml_find_first(item, "//*[local-name()='itemBody']")
    paragraph <- paste0(
      '<p><a href="data:text/plain;base64,SGVsbG8="',
      attributes,
      '>Supplement</a></p>'
    )
    xml2::xml_add_child(body, xml2::read_xml(paragraph))
    xml2::write_xml(item, path)
    verify_qti(path, schema = schema, engine = engine, print = FALSE)$valid
  }

  for (engine in engines) {
    expect_true(validate_link("", engine))
    expect_true(validate_link("", engine, "extended"))
    for (attribute in c(' download="exercise.Rmd"', ' download=""')) {
      expect_false(validate_link(attribute, engine))
      expect_true(validate_link(attribute, engine, "extended"))
    }
    expect_false(validate_link(' dowload="exercise.Rmd"', engine, "extended"))

    item <- xml2::read_xml(source)
    body <- xml2::xml_find_first(item, "//*[local-name()='itemBody']")
    xml2::xml_add_child(body, xml2::read_xml('<p download="file.txt">Text</p>'))
    xml2::write_xml(item, path)
    expect_false(verify_qti(
      path, schema = "extended", engine = engine, print = FALSE
    )$valid)
  }
})
