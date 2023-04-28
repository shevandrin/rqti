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
    expected <- suppressMessages(extract_results(path1, level = "items")[ ,-1])
    expected <- expected[order(expected$datestamp),]
    rownames(expected) <- NULL

    path2 <- test_path("file/test_result_items.csv")
    example <- read.csv(path2)[ ,-1]
    example$datestamp <- as.POSIXct(example$datestamp, tz = "UTC")
    example <- example[order(example$datestamp),]
    rownames(example) <- NULL

    expect_equal(example, expected)
})
test_that("Testing function extract_results", {
    path1 <- test_path("file/stab_results.xml")
    expected <- suppressWarnings(suppressMessages(
        extract_results(path1, level = "items")[ ,-1]))
    expected <- expected[order(expected$datestamp),]
    expected <- expected[-c(95-100), ]
    rownames(expected) <- NULL

    path2 <- test_path("file/test_result_stab_items.csv")
    example <- read.csv(path2)[ ,-1]
    example$datestamp <- as.POSIXct(example$datestamp, tz = "UTC")
    example <- example[order(example$datestamp),]
    example <- example[-c(95-100), ]
    rownames(example) <- NULL

    expect_equal(example, expected)
})
