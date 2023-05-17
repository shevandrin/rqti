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
  dplyr::group_by(file_name) %>%
  dplyr::mutate(sum_score = sum(candidate_score)) %>%
  dplyr::group_by(question_id) %>%
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
    sut <- sut[order(sut$datestamp),]
    rownames(sut) <- NULL

    path2 <- test_path("file/test_result_items.csv")
    expected <- read.csv(path2)
    expected$datestamp <- as.POSIXct(expected$datestamp, tz = "UTC")
    expected <- expected[order(expected$datestamp),]
    rownames(expected) <- NULL

    expected$cand_score <- as.character(expected$cand_score)
    expected$max_score <- as.character(expected$max_score)
    expected$correctness <- as.character(expected$correctness)

    expect_equal(expected, sut)
})
test_that("Testing function extract_results", {
    path1 <- test_path("file/stab_results.xml")
    sut <- suppressWarnings(suppressMessages(
        extract_results(path1, level = "items")[ ,-1]))

    # To delete tag \r in data frame
    sut <- data.frame(lapply(sut, function(x) gsub("\r", "", x)))

    rownames(sut) <- NULL

    path2 <- test_path("file/test_result_stab_items.csv")
    expected <- read.csv(path2)[ ,-1]
    expected <- read.csv(path2)
    expected <- expected[order(expected$datestamp),]

    rownames(expected) <- NULL

    expected$cand_score <- as.character(expected$cand_score)
    expected$max_score <- as.character(expected$max_score)
    expected$correctness <- as.character(expected$correctness)

    expect_equal(expected, sut)
})
# Testing function of extract_results() for tasks: Essay and TextGapOpal.
test_that("Testing function extract_results", {
    path1 <- test_path("file/test-extract_result_essay_gap.zip")
    sut <- suppressWarnings(suppressMessages(
        extract_results(path1, level = "items")))
    sut <- data.frame(lapply(sut, function(x) gsub("\r", "", x)))

    sut <- sut[order(sut$datestamp),]
    rownames(sut) <- NULL

    path2 <- test_path("file/test-extract_result_essay_gap.csv")
    expected <- read.csv(path2)
    expected <- expected[order(expected$datestamp),]

    rownames(expected) <- NULL

    expected$cand_score <- as.character(expected$cand_score)
    expected$max_score <- as.character(expected$max_score)
    expected$correctness <- as.character(expected$correctness)

    expect_equal(expected, sut)
})
test_that("Testing function extract_results with zip archive", {
    path1 <- test_path("file/test_result.zip")
    sut <- suppressMessages(extract_results(path1, level = "items"))
    sut <- sut[order(sut$datestamp),]
    rownames(sut) <- NULL

    path2 <- test_path("file/test_result_items_all_type_q.csv")
    expected <- read.csv(path2)
    expected$datestamp <- as.POSIXct(expected$datestamp, tz = "UTC")
    expected <- expected[order(expected$datestamp),]

    expected$cand_responses <- as.character(expected$cand_responses)
    expected$correct_responses <- as.character(expected$correct_responses)
    expected$correctness <- as.character(expected$correctness)
    expected$cand_score <- as.character(expected$cand_score)
    expected$max_score <- as.character(expected$max_score)

    rownames(expected) <- NULL
    expect_equal(expected, sut)
})
# The testing function of extract_results() with gaps in the answers
test_that("Testing function extract_results with zip archive", {
    path1 <- test_path("file/test-extract_result_with_gap_answer.zip")
    sut <- suppressMessages(extract_results(path1, level = "items"))
    sut <- sut[order(sut$datestamp),]
    rownames(sut) <- NULL

    path2 <- test_path("file/test-extract_result_with_gap_answer.csv")
    expected <- read.csv(path2)
    expected$datestamp <- as.POSIXct(expected$datestamp, tz = "UTC")
    expected <- expected[order(expected$datestamp),]

    sut$cand_responses <- as.character(sut$cand_responses)
    sut$correctness <- as.logical(sut$correctness)
    sut$cand_score <- as.numeric(sut$cand_score)
    sut$max_score <- as.numeric(sut$max_score)

    rownames(expected) <- NULL
    expect_equal(expected, sut)
})
# The testing function of extract_results() with only gaps in the answers
test_that("Testing function extract_results with zip archive", {
    path1 <- test_path("file/test-extract_result_only_gap.zip")

    # exclude column of the date stamp
    sut <- suppressMessages(extract_results(path1, level = "items")[ ,-2])

    path2 <- test_path("file/test-extract_result_only_gap.csv")

    # exclude column of the date stamp
    expected <- read.csv(path2, sep = ";", na.string = NA)[ ,-2]

    sut$cand_responses <- as.logical(sut$cand_responses)
    sut$correctness <- as.logical(sut$correctness)
    sut$cand_score <- as.numeric(sut$cand_score)
    sut$max_score <- as.numeric(sut$max_score)

    expect_equal(expected, sut)
})
