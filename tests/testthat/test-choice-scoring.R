test_that("all 21 Kanzow schemes reproduce the published outcome coefficients", {
    # Independent fixed oracle at k = 2, not the implementation's formula table.
    right <- c(1,1,1,1,1,1,1,0.5,1,1,1,1,1,1,1,1,1,1,1,1,1)
    wrong <- c(0,0,0.5,0,-0.5,-1,-1,-0.5,-1/3,-0.48,-0.5,-0.6,
               -1,-1,-1.1,-2,-1.5,-1.8,-2,-3,-62/38)
    omitted <- c(0,0.5,rep(0,11),0.7,0.7,rep(0,6))
    for (i in 1:21) {
        method <- sprintf("kanzow_%02d", i)
        policy <- if (i == 21) single_choice_scoring(method, statement_truth = TRUE) else method
        item <- singleChoice(choices = c("true", "false"), points = 2.5,
                             scoring_scheme = policy)
        doc <- scoring_item_xml(item)
        actual <- vapply(list("ChoiceA", "ChoiceB", NULL), function(x) score_choice_qti(doc, x), numeric(1))
        expect_equal(actual, 2.5*c(right[i], wrong[i], omitted[i]), info = method)
        expect_equal(unname(getPoints(item)), 2.5*right[i])
    }
    item <- singleChoice(choices = c("false", "true"), solution = 2,
        scoring_scheme = single_choice_scoring("kanzow_21", statement_truth = FALSE))
    expect_equal(score_choice_qti(scoring_item_xml(item), "ChoiceA"), -38/62)
})

test_that("option-dependent Kanzow rules preserve their scale and restrictions", {
    item <- function(method) singleChoice(choices = letters[1:5], points = 4,
                                          scoring_scheme = method)
    expect_equal(unname(getPoints(item("kanzow_04"))), 1)
    expect_equal(unname(getPoints(item("kanzow_08"))), 3.2)
    expect_equal(score_choice_qti(scoring_item_xml(item("kanzow_05")), "ChoiceB"), -0.5)
    expect_equal(score_choice_qti(scoring_item_xml(item("kanzow_02"))), 0.8)
    for (i in c(10,12,14,15,17,18,20)) {
        expect_error(item(sprintf("kanzow_%02d", i)), "two options")
    }
    expect_error(single_choice_scoring("kanzow_21"), "statement_truth")
})

test_that("custom single-choice scoring distinguishes omission and wrong response", {
    sc <- singleChoice(choices = letters[1:3], points = 5,
        scoring_scheme = single_choice_scoring("custom", incorrect = -0.2, omitted = 0.1))
    doc <- scoring_item_xml(sc)
    expect_equal(score_choice_qti(doc, "ChoiceA"), 5)
    expect_equal(score_choice_qti(doc, "ChoiceB"), -1)
    expect_equal(score_choice_qti(doc), 0.5)
    expect_error(single_choice_scoring("custom", incorrect = NA_real_), "finite")
    expect_error(single_choice_scoring("custom", typo = 1), "unknown settings")
    expect_error(singleChoice(choices = letters[1:3], scoring_scheme =
        single_choice_scoring("custom", incorrect = 2)), "correct credit")
})

test_that("multiple-response literature methods have distinct observable behavior", {
    build <- function(method) scoring_item_xml(multipleChoice(choices = letters[1:5],
        points = c(0.5, 0.5, 0, 0, 0), scoring_scheme = method))
    selected <- c("ChoiceA", "ChoiceB", "ChoiceC")
    expect_equal(score_choice_qti(build("plus_minus"), selected), 0.5)
    expect_equal(score_choice_qti(build("subset"), selected), 0)
    expect_equal(score_choice_qti(build("ripkey"), selected), 0)
    expect_equal(score_choice_qti(build("true_false"), selected), 0.8)
    expect_equal(score_choice_qti(build("true_false")), 0.6)
    expect_equal(score_choice_qti(build("all_or_nothing"), "ChoiceA"), 0)
    expect_equal(score_choice_qti(build("all_or_nothing"), c("ChoiceB", "ChoiceA")), 1)
    expect_equal(score_choice_qti(build("subset"), "ChoiceA"), 0.5)
    expect_equal(score_choice_qti(build("ripkey"), c("ChoiceA", "ChoiceC")), 0.5)
    explicit <- multipleChoice(choices = letters[1:3], points = c(1, 0, 0),
                               scoring_scheme = "weights")
    expect_equal(score_choice_qti(scoring_item_xml(explicit), c("ChoiceA", "ChoiceB")), 1)
})

test_that("QTI exactly reproduces all exams choice evaluation policy combinations", {
    for (k in c(2,3,5)) for (C in unique(c(1,k-1,k))) {
        solution <- rev(seq_len(k) <= C)
        answers <- as.matrix(expand.grid(rep(list(c(FALSE,TRUE)), k)))
        for (partial in c(FALSE,TRUE)) for (negative in c(FALSE,TRUE,-0.25)) {
            for (rule in c("false2","false","true","all","none")) {
                policy <- multiple_choice_scoring("exams", partial = partial, negative = negative, rule = rule)
                item <- multipleChoice(choices = letters[seq_len(k)],
                    points = ifelse(solution, 2.5/C, 0), scoring_scheme = policy)
                doc <- scoring_item_xml(item)
                ids <- item@choice_identifiers
                actual <- apply(answers, 1, function(x) score_choice_qti(doc, ids[x]))
                oracle <- exams::exams_eval(partial, negative, rule)
                expected <- suppressWarnings(apply(answers, 1, function(x) {
                    2.5*oracle$pointsum(solution, x, type = "mchoice")
                }))
                expect_equal(actual, expected, tolerance = 1e-10,
                    info = paste(k,C,partial,negative,rule))
                expect_equal(score_choice_qti(doc), 0)
            }
        }
    }
    for (k in c(2,3,6)) for (negative in c(FALSE,TRUE,-0.2,-2)) {
        item <- singleChoice(choices = letters[seq_len(k)], points = 3,
            scoring_scheme = single_choice_scoring("exams", negative = negative))
        doc <- scoring_item_xml(item)
        evaluator <- exams::exams_eval(negative = negative)
        for (i in seq_len(k)) {
            expected <- 3*evaluator$pointsum(seq_len(k)==1, seq_len(k)==i, type="schoice")
            expect_equal(score_choice_qti(doc, item@choice_identifiers[i]), expected)
        }
        expect_equal(score_choice_qti(doc), 0)
    }
})

test_that("new scoring specifications produce schema-valid QTI", {
    items <- list(
        singleChoice(choices = letters[1:3], scoring_scheme = single_choice_scoring("custom", incorrect=-0.2)),
        singleChoice(choices = letters[1:2], scoring_scheme = "kanzow_14"))
    for (method in c("plus_minus","true_false","subset","ripkey","all_or_nothing","exams")) {
        items[[length(items)+1L]] <- multipleChoice(choices = letters[1:3],
            points = c(0.5,0,0.5), scoring_scheme = method)
    }
    for (item in items) {
        result <- verify_qti(item, print = FALSE, engine = "xml2")
        expect_true(result$valid, info = paste(unlist(result$errors), collapse="\n"))
    }
})


test_that("named aliases and list/YAML specifications agree with their presets", {
    aliases <- c(number_right="kanzow_01",fair_penalty="kanzow_03",
                 correction_for_guessing="kanzow_06",rights_minus_wrongs="kanzow_13")
    for (alias in names(aliases)) {
        a <- singleChoice(choices=letters[1:3],scoring_scheme=alias)
        b <- singleChoice(choices=letters[1:3],scoring_scheme=aliases[[alias]])
        expect_equal(resolve_choice_scoring(a),resolve_choice_scoring(b))
    }
    a <- multipleChoice(choices=letters[1:3],points=c(0.5,0.5,0),
                        scoring_scheme=list(method="standard"))
    expect_equal(score_choice_qti(scoring_item_xml(a),c("ChoiceA","ChoiceC")),0)
    expect_equal(score_choice_qti(scoring_item_xml(a),c("ChoiceA","ChoiceB")),1)
    spec <- yaml::yaml.load("method: custom\nincorrect: -0.2\nomitted: 0.1")
    a <- singleChoice(choices=letters[1:3],scoring_scheme=spec)
    expect_equal(score_choice_qti(scoring_item_xml(a)),0.1)
})


test_that("direct S4 construction generates option IDs before scoring validation", {
    sc <- new("SingleChoice",choices=letters[1:3])
    expect_equal(length(sc@choice_identifiers),3L)
    expect_equal(unname(getPoints(sc)),1)
    sc <- new("SingleChoice",choices=letters[1:3],
              scoring_scheme=list(method="custom",incorrect=-0.2))
    expect_equal(score_choice_qti(scoring_item_xml(sc),"ChoiceB"),-0.2)
    mc <- new("MultipleChoice",choices=letters[1:3],points=c(1,0,1),
              scoring_scheme="plus_minus")
    expect_equal(length(mc@choice_identifiers),3L)
})


test_that("Rmd YAML reaches the same scoring compiler as S4 authoring", {
    path <- tempfile(fileext=".Rmd")
    writeLines(c("---","type: sc","points: 2","scoring_scheme:",
        "  method: custom","  incorrect: -0.2","---","", "# question","",
        "Choose one.","","- A","- B","- C"),path)
    item <- create_question_object(path)
    expect_equal(score_choice_qti(scoring_item_xml(item),"ChoiceB"),-0.4)
    expect_true(verify_qti(item,print=FALSE,engine="xml2")$valid)
})
