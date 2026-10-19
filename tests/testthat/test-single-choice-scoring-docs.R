test_that("the helper's custom default retains standard single-choice scores", {
    default <- singleChoice(choices=c("A","B","C"),points=2)
    explicit <- singleChoice(choices=c("A","B","C"),points=2,
                             scoring_scheme=single_choice_scoring())
    responses <- list("ChoiceA","ChoiceB",NULL)
    score <- function(item) vapply(responses,function(response) {
        score_choice_qti(scoring_item_xml(item),response)
    },numeric(1))
    expect_equal(score(default),c(2,0,0))
    expect_equal(score(explicit),score(default))
    custom <- singleChoice(choices=c("A","B","C"),points=2,
                           scoring_scheme=single_choice_scoring(incorrect=-0.2))
    expect_equal(score(custom),c(2,-0.4,0))
})

test_that("all two-option presets report their identifier and actual option count", {
    for (i in c(10,12,14,15,17,18,20,21)) {
        method <- sprintf("kanzow_%02d",i)
        policy <- if(i==21) single_choice_scoring(method,statement_truth=TRUE) else method
        message <- paste0(method," requires exactly two options; received 3")
        expect_error(singleChoice(choices=c("A","B","C"),scoring_scheme=policy),message,fixed=TRUE)
        expect_error(new("SingleChoice",choices=c("A","B","C"),scoring_scheme=policy),message,fixed=TRUE)
    }
})

test_that("YAML conversion enforces the same preset restrictions", {
    path <- tempfile(fileext=".Rmd")
    yaml_item <- function(choices,scoring) {
        writeLines(c("---","type: sc",scoring,"---","", "# question","",
                     "Choose one.","",paste("-",choices)),path)
        create_question_object(path)
    }
    expect_error(yaml_item(c("A","B","C"),"scoring_scheme: kanzow_10"),
                 "kanzow_10 requires exactly two options; received 3",fixed=TRUE)
    item <- yaml_item(c("A","B"),"scoring_scheme: kanzow_10")
    expect_equal(score_choice_qti(scoring_item_xml(item),"ChoiceB"),-0.48)
    expect_error(yaml_item(c("False","True"),c("scoring_scheme:",
        "  method: kanzow_21")),"statement_truth")
    expect_error(yaml_item(c("A","B","C"),c("scoring_scheme:",
        "  method: kanzow_21","  statement_truth: true")),
        "kanzow_21 requires exactly two options; received 3",fixed=TRUE)
})
