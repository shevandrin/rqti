d <- suppressMessages(qti::extract_results("file/test_result.zip"))

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
  dplyr::mutate(sum_score = sum(candidate_score)) %>%
  dplyr::group_by(id_question) %>%
  # correct for part-whole
  # todo: remove sd = 0 first
dplyr::summarize(n = dplyr::n(),
            m_duration = mean(duration),
            difficulty = mean(candidate_score / max_scores) * 100,
            r_it = round(mycor(candidate_score, sum_score - candidate_score),
                         2))

d_exp <- read.csv(test_path("file", "statistics.csv"))
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
    sut <- suppressMessages(extract_results(path1, level = "items"))
    sut <- sut[order(sut$date),]
    rownames(sut) <- NULL

    path2 <- test_path("file/test_result_items.csv")
    expected <- read.csv(path2)
    expected$date <- as.POSIXct(expected$date, tz = "UTC")
    expected <- expected[order(expected$date),]
    rownames(expected) <- NULL

    expected$cand_score <- as.character(expected$cand_score)
    expected$max_score <- as.character(expected$max_score)
    expected$correctness <- expected$correctness

    expect_equal(sut,expected)
})
test_that("Testing function extract_results", {
    path1 <- test_path("file/stab_results.xml")
    sut <- suppressWarnings(suppressMessages(
                                extract_results(path1, level = "items")[ ,-1]))
    sut <- sut[order(sut$date),]
    rownames(sut) <- NULL

    # To delete all symbols
    sut$response_candidate <- gsub("[^a-zA-Z0-9]", "", sut$response_candidate)

    path2 <- test_path("file/test_result_stab_items.csv")
    expected <- read.csv(path2)
    expected$date <- as.POSIXct(expected$date, tz = "UTC")
    expected <- expected[order(expected$date),]
    rownames(expected) <- NULL

    expected$cand_score <- as.character(expected$cand_score)
    expected$max_score <- as.character(expected$max_score)
    expected$correctness <- expected$correctness

    # To delete all symbols
    expected$response_candidate <- gsub("[^a-zA-Z0-9]", "", expected$response_candidate)

    expect_equal(sut,expected)
})
# Testing function of extract_results() for tasks: Essay and TextGapOpal.
test_that("Testing function extract_results", {
    path1 <- test_path("file/test-extract_result_essay_gap.zip")
    sut <- suppressWarnings(suppressMessages(
                                       extract_results(path1, level = "items")))
    sut <- sut[order(sut$date),]
    rownames(sut) <- NULL
    # To delete all symbols
    sut$response_candidate <- gsub("[^a-zA-Z0-9]", "", sut$response_candidate)

    path2 <- test_path("file/test-extract_result_essay_gap.csv")
    expected <- read.csv(path2)
    expected$date <- as.POSIXct(expected$date, tz = "UTC")
    expected <- expected[order(expected$date),]
    rownames(expected) <- NULL

    expected$cand_score <- as.character(expected$cand_score)
    expected$max_score <- as.character(expected$max_score)
    expected$correctness <- expected$correctness

    # To delete all symbols
    expected$response_candidate <- gsub("[^a-zA-Z0-9]", "", expected$response_candidate)

    expect_equal(sut,expected)
})
test_that("Testing function extract_results with zip archive", {
    path1 <- test_path("file/test_result.zip")
    sut <- suppressMessages(extract_results(path1, level = "items"))
    sut <- sut[order(sut$date),]
    rownames(sut) <- NULL

    path2 <- test_path("file/test_result_items_all_type_q.csv")
    expected <- read.csv(path2)
    expected$date <- as.POSIXct(expected$date, tz = "UTC")
    expected <- expected[order(expected$date),]

    expected$response_candidate <- as.character(expected$response_candidate)
    expected$response_correct <- as.character(expected$response_correct)
    expected$correctness <- expected$correctness
    expected$cand_score <- as.character(expected$cand_score)
    expected$max_score <- as.character(expected$max_score)

    rownames(expected) <- NULL
    expect_equal(sut,expected)
})
# The testing function of extract_results() with gaps in the answers
test_that("Testing function extract_results with zip archive", {
    path1 <- test_path("file/test-extract_result_with_gap_answer.zip")
    sut <- suppressMessages(extract_results(path1, level = "items"))
    sut <- sut[order(sut$date),]
    rownames(sut) <- NULL

    path2 <- test_path("file/test-extract_result_with_gap_answer.csv")
    expected <- read.csv(path2)
    expected$date <- as.POSIXct(expected$date, tz = "UTC")
    expected <- expected[order(expected$date),]

    sut$response_candidate <- as.character(sut$response_candidate)
    sut$correctness <- as.logical(sut$correctness)
    sut$cand_score <- as.numeric(sut$cand_score)
    sut$max_score <- as.numeric(sut$max_score)

    rownames(expected) <- NULL
    expect_equal(sut,expected)
})
# The testing function of extract_results() with only gaps in the answers
test_that("Testing function extract_results with zip archive", {
    path1 <- test_path("file/test-extract_result_only_gap.zip")

    # exclude column of the date stamp
    sut <- suppressMessages(extract_results(path1, level = "items")[ ,-2])

    path2 <- test_path("file/test-extract_result_only_gap.csv")

    # exclude column of the date stamp
    expected <- read.csv(path2, sep = ";", na.string = NA)[ ,-2]

    sut$response_candidate <- as.logical(sut$response_candidate)
    sut$correctness <- as.logical(sut$correctness)
    sut$cand_score <- as.numeric(sut$cand_score)
    sut$max_score <- as.numeric(sut$max_score)

    expect_equal(sut,expected)
})
test_that("Testing extract_results() throws an error for non-existing file", {
    expect_error(extract_results("nonexistent.xml", "nonexistent_folder"),
                 "One or more files in list do not exist")
})
test_that("Testing extract_results() throws an error for invalid 'file' argument", {
        invalid_file <- test_path("file/test_fig2.jpg")
        expect_error(extract_results(invalid_file), "'file' must contain only one zip or set of xml files")
})

