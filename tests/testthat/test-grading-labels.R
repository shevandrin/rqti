test_that("grading labels fall back for unknown and C locales", {
    labels <- c(en = "Grade", de = "Note")
    # Exercise the real function with OS locales independent of installed locales.
    detect <- detect_label
    environment(detect) <- new.env(parent = environment(detect_label))
    for (locale in c("C", "C.UTF-8", "POSIX", "unrecognized.UTF-8")) {
        environment(detect)$Sys.getlocale <- function(...) locale
        expect_identical(detect(labels), "Grade")
    }
    environment(detect)$Sys.getlocale <- function(...) "de_DE.UTF-8"
    expect_identical(detect(labels), "Note")
    expect_identical(detect("Result"), "Result")
})
