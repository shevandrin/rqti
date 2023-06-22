mc <- new("MultipleChoice", identifier = "test 2", title = "Economics",
          content = list("<p>When deciding between renovating a water treatment plant or building a new community pool, what is the government most likely to consider?</p>"),
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

    mc <- new("MultipleChoice", identifier = "test 2", title = "Economics",
              content = list("<p>When deciding between renovating a water treatment plant or building a new community pool, what is the government most likely to consider?</p>"),
              choices = c("scarcity vs. resources",
                          "wages vs. prices",
                          "wants vs. needs",
                          "consumers vs. producers"),
              points = c(0.5, 0.5, 0, 0))


    item1_1 <- mc
    item1_1@identifier <- paste0(mc@identifier, "_S", seed1)
    item1_2 <- sc
    item1_2@identifier <- paste0(sc@identifier, "_S", seed1)
    item2_1 <- mc
    item2_1@identifier <- paste0(mc@identifier, "_S", seed2)
    item2_2 <- sc
    item2_2@identifier <- paste0(sc@identifier, "_S", seed2)

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
