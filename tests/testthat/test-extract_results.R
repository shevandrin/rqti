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
    expected <- suppressMessages(extract_results(path1, level = "items"))
    expected <- expected[order(expected$datestamp),]
    rownames(expected) <- NULL

    path2 <- test_path("file/test_result_items.csv")
    example <- read.csv(path2)
    example$datestamp <- as.POSIXct(example$datestamp, tz = "UTC")
    example <- example[order(example$datestamp),]
    rownames(example) <- NULL

    example$cand_score <- as.character(example$cand_score)
    example$max_score <- as.character(example$max_score)
    example$correctness <- as.character(example$correctness)

    expect_equal(example, expected)
})
test_that("Testing function extract_results", {
    path1 <- test_path("file/stab_results.xml")
    expected <- suppressWarnings(suppressMessages(
    extract_results(path1, level = "items")[ ,-1]))

    # To delete tag \r in data frame
    expected <- data.frame(lapply(expected, function(x) gsub("\r", "", x)))

    rownames(expected) <- NULL

    path2 <- test_path("file/test_result_stab_items.csv")
    example <- read.csv(path2)[ ,-1]
    example <- read.csv(path2)
    example <- example[order(example$datestamp),]

    rownames(example) <- NULL

    example$cand_score <- as.character(example$cand_score)
    example$max_score <- as.character(example$max_score)
    example$correctness <- as.character(example$correctness)

    expect_equal(example, expected)
})
# Testing function of extract_results() for tasks: Essay and TextGapOpal.
test_that("Testing function extract_results", {
    path1 <- test_path("file/test-extract_result_essay_gap.zip")
    expected <- suppressWarnings(suppressMessages(
                                    extract_results(path1, level = "items")))
    expected <- data.frame(lapply(expected, function(x) gsub("\r", "", x)))

    expected <- expected[order(expected$datestamp),]
    rownames(expected) <- NULL

    path2 <- test_path("file/test-extract_result_essay_gap.csv")
    example <- read.csv(path2)
    example <- example[order(example$datestamp),]

    rownames(example) <- NULL

    example$cand_score <- as.character(example$cand_score)
    example$max_score <- as.character(example$max_score)
    example$correctness <- as.character(example$correctness)

    expect_equal(example, expected)
})
test_that("Testing function extract_results with zip archive", {
    path1 <- test_path("file/test_result.zip")
    expected <- suppressMessages(extract_results(path1, level = "items"))
    expected <- expected[order(expected$datestamp),]
    rownames(expected) <- NULL

    path2 <- test_path("file/test_result_items_all_type_q.csv")
    example <- read.csv(path2)
    example$datestamp <- as.POSIXct(example$datestamp, tz = "UTC")
    example <- example[order(example$datestamp),]

    example$cand_responses <- as.character(example$cand_responses)
    example$correct_responses <- as.character(example$correct_responses)
    example$correctness <- as.character(example$correctness)
    example$cand_score <- as.character(example$cand_score)
    example$max_score <- as.character(example$max_score)

    rownames(example) <- NULL
    expect_equal(example, expected)
})
# The testing function of extract_results() with gaps in the answers
test_that("Testing function extract_results with zip archive", {
    path1 <- test_path("file/test-extract_result_with_gap_answer.zip")
    expected <- suppressMessages(extract_results(path1, level = "items"))
    expected <- expected[order(expected$datestamp),]
    rownames(expected) <- NULL

    path2 <- test_path("file/test-extract_result_with_gap_answer.csv")
    example <- read.csv(path2)
    example$datestamp <- as.POSIXct(example$datestamp, tz = "UTC")
    example <- example[order(example$datestamp),]

    expected$cand_responses <- as.character(expected$cand_responses)
    expected$correctness <- as.logical(expected$correctness)
    expected$cand_score <- as.numeric(expected$cand_score)
    expected$max_score <- as.numeric(expected$max_score)

    rownames(example) <- NULL
    expect_equal(example, expected)
})
# The testing function of extract_results() with only gaps in the answers
test_that("Testing function extract_results with zip archive", {
    path1 <- test_path("file/test-extract_result_only_gap.zip")

    # exclude column of the date stamp
    expected <- suppressMessages(extract_results(path1, level = "items")[ ,-2])
    path2 <- test_path("file/test-extract_result_only_gap.csv")

    # exclude column of the date stamp
    example <- read.csv(path2, sep = ";", na.string = NA)[ ,-2]

    expected$cand_responses <- as.logical(expected$cand_responses)
    expected$correctness <- as.logical(expected$correctness)
    expected$cand_score <- as.numeric(expected$cand_score)
    expected$max_score <- as.numeric(expected$max_score)

    expect_equal(example, expected)
})
