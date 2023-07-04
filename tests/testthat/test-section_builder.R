mc <- new("MultipleChoice", identifier = "test 2", title = "Economics",
          content = list("<p>When deciding between renovating a water treatment plant or building a new community pool, what is the government most likely to consider? This is a multiline formula: <math display=\"block\" xmlns=\"http://www.w3.org/1998/Math/MathML\"><semantics><mrow><mi>x</mi><mo>−</mo><mn>1</mn><mo>=</mo><mi>y</mi></mrow><annotation encoding=\"application/x-tex\">x-1=y</annotation></semantics></math></p>"),
          choices = c("scarcity vs. resources",
                      "wages vs. prices",
                      "wants vs. needs",
                      "consumers vs. producers"),
          points = c(0.5, 0.5, 0, 0))

sc <- new("SingleChoice", identifier = "eco", title = "Economics and Physic",
          content = list("<p>This is a mock question<br/>
In economics it is generally believed that the main objective of a Public Sector Financial Company like Bank is to:</p>"),
          choices = c("Employ more and more people", "Maximize total production",
                      "Maximize total profits", "Sell the goods at subsidized cost"))

path1 <- test_path("file/test_mc_no_point.Rmd")
path2 <- "test_create_qti_task_Essay.xml"
path3 <- test_path("file/test_sc_example1.md")

test_that("Testing function section() to build permanent AssessmentSection", {
    path1 <- test_path("file/test_mc_no_point.Rmd")
    path2 <- "test_create_qti_task_Essay.xml"
    sut <- section(c(path1, path2), id = "permanent_section")
    # to clean invisible symbols
    sut@assessment_item[[1]]@choices <- textclean::replace_non_ascii(sut@assessment_item[[1]]@choices)
    # rid of the name from @assessment_item
    names(sut@assessment_item) <- NULL

    expected <- new("AssessmentSection", identifier = "permanent_section",
                    assessment_item = list(mc, "test_create_qti_task_Essay.xml"),
                    selection = 0)

    expect_equal(sut, expected)
})

test_that("Testing function section() to build variable nested AssessmentSection", {

    sut <- section(c(path1, path3), 2, id = "variable_section")
    # to clean invisible symbols
    sut@assessment_item[[1]]@assessment_item[[1]]@choices <- textclean::replace_non_ascii(sut@assessment_item[[1]]@assessment_item[[1]]@choices)
    sut@assessment_item[[2]]@assessment_item[[1]]@choices <- textclean::replace_non_ascii(sut@assessment_item[[2]]@assessment_item[[1]]@choices)
    # rid of the name from @assessment_item
    names(sut@assessment_item) <- NULL

    seed1 <- sut@assessment_item[[1]]@identifier
    seed1 <- sub(".*S(\\d+).*", "\\1", seed1)
    seed2 <- sut@assessment_item[[2]]@identifier
    seed2 <- sub(".*S(\\d+).*", "\\1", seed2)

    item1_1 <- mc
    item1_1@identifier <- paste0(mc@identifier, "_S", seed1)
    item1_1@title <- paste0(mc@title, "_S", seed1)
    item1_2 <- sc
    item1_2@identifier <- paste0(sc@identifier, "_S", seed1)
    item1_2@title <- paste0(sc@title, "_S", seed1)
    item2_1 <- mc
    item2_1@identifier <- paste0(mc@identifier, "_S", seed2)
    item2_1@title <- paste0(mc@title, "_S", seed2)
    item2_2 <- sc
    item2_2@identifier <- paste0(sc@identifier, "_S", seed2)
    item2_2@title <- paste0(sc@title, "_S", seed2)

    variant1 <- new("AssessmentSection",
                    identifier = paste0("seed_section_S", seed1),
                    assessment_item = list(item1_1, item1_2))
    variant2 <- new("AssessmentSection",
                    identifier = paste0("seed_section_S", seed2),
                    assessment_item = list(item2_1, item2_2))

    expected <- new("AssessmentSection", identifier = "variable_section",
                    selection = 1,
                    assessment_item = list(variant1, variant2))

    expect_equal(sut, expected)
})

test_that("Testing function section() to build variable AssessmentSection for nested = False ", {
    path1 <- test_path("file/test_mc_no_point.Rmd")
    path3 <- test_path("file/test_sc_example1.md")
    num_variants = 3
    file <- c(path1, path3)
    sut <- section(file, num_variants, id = "variable_section", nested = FALSE)

    # to clean invisible symbols
    sut@assessment_item[[1]]@assessment_item[[1]]@choices <- textclean::replace_non_ascii(sut@assessment_item[[1]]@assessment_item[[1]]@choices)
    sut@assessment_item[[2]]@assessment_item[[1]]@choices <- textclean::replace_non_ascii(sut@assessment_item[[2]]@assessment_item[[1]]@choices)
    sut@assessment_item[[1]]@assessment_item[[2]]@choices <- textclean::replace_non_ascii(sut@assessment_item[[1]]@assessment_item[[2]]@choices)
    sut@assessment_item[[1]]@assessment_item[[3]]@choices <- textclean::replace_non_ascii(sut@assessment_item[[1]]@assessment_item[[3]]@choices)
    # rid of the name from @assessment_item
    names(sut@assessment_item) <- NULL
    # create list of expected items
    item <- list(mc, mc, mc, sc, sc, sc)
    # collect all seed numbers
    seed <- c()
    for (i in seq(length(file))) {
        for (j in seq(num_variants)) {
            s <- sut@assessment_item[[i]]@assessment_item[[j]]@identifier
            s <- sub(".*S(\\d+).*", "\\1", s)
            seed <- c(seed, s)
        }
    }
    # reassign identifeir and titles for expected items
    for (i in seq(length(item))) {
        item[[i]]@identifier <- paste0(item[[i]]@identifier, "_S", seed[i])
        item[[i]]@title <- paste0(item[[i]]@title, "_S", seed[i])
    }
    # get variant subsections identifiers
    id_var1 <- sut@assessment_item[[1]]@identifier
    id_var2 <- sut@assessment_item[[2]]@identifier
    # create variants
    variant1 <- new("AssessmentSection",
                    identifier = id_var1,
                    assessment_item = (item[1:3]), selection = 1)
    variant2 <- new("AssessmentSection",
                    identifier = id_var2,
                    assessment_item = (item[4:6]), selection = 1)
    # create expected
    expected <- new("AssessmentSection", identifier = "variable_section",
                    selection = 0,
                    assessment_item = list(variant1, variant2))

    expect_equal(sut, expected)
})
