d <- suppressMessages(rqti::extract_results("file/test_result.zip"))

# general analysis

mycor <- function(x, y) {
  if (sd(x) == 0) return(NA)
  if (sd(y) == 0) return(NA)
  cor(x, y)
}

# missing this:
#  filter(is_answser_given == TRUE) %>%

db <- d %>%
  dplyr::group_by(file) %>%
  dplyr::mutate(sum_score = sum(score_candidate)) %>%
  dplyr::group_by(id_question) %>%
  # correct for part-whole
  # todo: remove sd = 0 first
dplyr::summarize(n = dplyr::n(),
            m_duration = mean(duration),
            difficulty = mean(score_candidate / score_max) * 100,
            r_it = round(mycor(score_candidate, sum_score - score_candidate),
                         2))

d_exp <- read.csv(test_path("file/csv", "statistics.csv"))
d_exp <- d_exp %>%
    dplyr::select(Nr., Response_count, Time_taken:Correlation)

test_that("difficulty is correct",
          {expect_equal(db$difficulty, d_exp$Difficulty)})

test_that("discriminability is correct",
          {expect_equal(db$r_it, d_exp$Correlation)})

# seems the time is truncated in OPAL
test_that("time is correct",
          {expect_equal(trunc(db$m_duration), d_exp$Time_taken)})

test_that("Testing function extract_results with zip archive", {
    path1 <- test_path("file/test_result_3.zip")
    sut <- suppressMessages(extract_results(path1, level = "item",
                                            hide_filename = FALSE))
    sut <- sut[order(sut$date),]
    rownames(sut) <- NULL

    path2 <- test_path("file/csv/test_result_items.csv")
    expected <- read.csv(path2)
    expected$date <- as.POSIXct(expected$date, tz = "UTC")
    expected <- expected[order(expected$date),]
    rownames(expected) <- NULL

    expected$score_candidate <- as.double(expected$score_candidate)
    expected$score_max <- as.double(expected$score_max)
    expected$is_response_correct <- expected$is_response_correct

    expect_equal(sut,expected)
})
test_that("Testing function extract_results", {
    path1 <- test_path("file/xml/stab_results.xml")
    sut <- suppressWarnings(suppressMessages(
                                extract_results(path1, level = "item",
                                                hide_filename = FALSE)[ ,-1]))
    sut <- sut[order(sut$date),]
    rownames(sut) <- NULL

    path2 <- test_path("file/csv/test_result_stab_items.csv")
    expected <- read.csv(path2)
    expected$date <- as.POSIXct(expected$date, tz = "UTC")
    expected <- expected[order(expected$date),]
    rownames(expected) <- NULL

    expected$score_candidate <- as.double(expected$score_candidate)
    expected$score_max <- as.double(expected$score_max)

    # To delete all symbols
    expected$candidate_response <- gsub("[^a-zA-Z0-9]", "",
                                        expected$candidate_response)
    sut$candidate_response <- gsub("[^a-zA-Z0-9]", "", sut$candidate_response)
    expect_equal(sut,expected)
})

# Testing function of extract_results() for tasks: Essay and TextGapOpal.
test_that("Testing function extract_results", {
    path1 <- test_path("file/test-extract_result_essay_gap.zip")
    sut <- suppressWarnings(suppressMessages(
                                       extract_results(path1, level = "item",
                                                       hide_filename = FALSE)))
    sut <- sut[order(sut$date),]
    rownames(sut) <- NULL
    # To delete all symbols
    sut$candidate_response <- gsub("[^a-zA-Z0-9]", "", sut$candidate_response)

    path2 <- test_path("file/csv/test-extract_result_essay_gap.csv")
    expected <- read.csv(path2)
    expected$date <- as.POSIXct(expected$date, tz = "UTC")
    expected <- expected[order(expected$date),]
    rownames(expected) <- NULL

    expected$score_candidate <- as.double(expected$score_candidate)
    expected$score_max <- as.double(expected$score_max)
    expected$is_response_correct <- expected$is_response_correct

    # To delete all symbols
    expected$candidate_response <- gsub("[^a-zA-Z0-9]", "",
                                        expected$candidate_response)

    expect_equal(sut,expected)
})
test_that("Testing function extract_results with zip archive", {
    path1 <- test_path("file/test_result.zip")
    sut <- suppressMessages(extract_results(path1, level = "item",
                                            hide_filename = FALSE))
    sut <- sut[order(sut$date),]
    rownames(sut) <- NULL

    path2 <- test_path("file/csv/test_result_items_all_type_q.csv")
    expected <- read.csv(path2)
    expected$date <- as.POSIXct(expected$date, tz = "UTC")
    expected <- expected[order(expected$date),]

    expected$candidate_response <- as.character(expected$candidate_response)
    expected$expected_response <- as.character(expected$expected_response)
    expected$is_response_correct <- expected$is_response_correct
    expected$score_candidate <- as.double(expected$score_candidate)
    expected$score_max <- as.double(expected$score_max)

    rownames(expected) <- NULL
    expect_equal(sut,expected)
})
# The testing function of extract_results() with gaps in the answers
test_that("Testing function extract_results with zip archive", {
    path1 <- test_path("file/test-extract_result_with_gap_answer.zip")
    sut <- suppressMessages(extract_results(path1, level = "item",
                                            hide_filename = FALSE))
    sut <- sut[order(sut$date),]
    rownames(sut) <- NULL

    path2 <- test_path("file/csv/test-extract_result_with_gap_answer.csv")
    expected <- read.csv(path2)
    expected$date <- as.POSIXct(expected$date, tz = "UTC")
    expected <- expected[order(expected$date),]

    sut$candidate_response <- as.character(sut$candidate_response)
    sut$is_response_correct <- as.logical(sut$is_response_correct)
    sut$score_candidate <- as.numeric(sut$score_candidate)
    sut$score_max <- as.numeric(sut$score_max)

    rownames(expected) <- NULL
    expect_equal(sut,expected)
})
# The testing function of extract_results() with only gaps in the answers
test_that("Testing function extract_results with zip archive", {
    path1 <- test_path("file/test-extract_result_only_gap.zip")

    # exclude column of the date stamp
    sut <- suppressMessages(extract_results(path1, level = "item",
                                            hide_filename = FALSE)[ ,-2])

    path2 <- test_path("file/csv/test-extract_result_only_gap.csv")

    # exclude column of the date stamp
    expected <- read.csv(path2, sep = ";", na.string = NA)[ ,-2]

    sut$candidate_response <- as.logical(sut$candidate_response)
    sut$is_response_correct <- as.logical(sut$is_response_correct)
    sut$score_candidate <- as.numeric(sut$score_candidate)
    sut$score_max <- as.numeric(sut$score_max)

    expect_equal(sut,expected)
})
test_that("Testing extract_results() throws an error for non-existing file", {
    expect_error(extract_results("nonexistent.xml", "nonexistent_folder"),
                 "One or more files in list do not exist")
})
test_that("Testing extract_results() throws an error for invalid
          'file' argument", {
        invalid_file <- test_path("file/test_fig2.jpg")
        expect_error(extract_results(invalid_file),
                     "'file' must contain only one zip or set of xml files")
})
