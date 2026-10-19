test_that("the public helpers expose different models and bind the item type", {
    expect_error(single_choice_scoring("plus_minus"),"not available for single-choice")
    expect_error(multiple_choice_scoring("kanzow_10"),"not available for multiple-choice")
    expect_error(multiple_choice_scoring("kanzow_21"),"not available for multiple-choice")
    expect_error(single_choice_scoring("exams",partial=TRUE),"negative only")
    expect_error(single_choice_scoring("exams",rule="false"),"negative only")
    expect_error(singleChoice(choices=c("A","B"),
        scoring_scheme=multiple_choice_scoring()),"cannot be used for a single-choice item")
    expect_error(multipleChoice(choices=c("A","B"),points=c(1,0),
        scoring_scheme=single_choice_scoring("standard")),"cannot be used for a multiple-choice item")
    sc <- singleChoice(choices=c("A","B","C"),
        scoring_scheme=single_choice_scoring("standard"))
    mc <- multipleChoice(choices=c("A","B","C"),points=c(0.5,0.5,0),
        scoring_scheme=multiple_choice_scoring())
    expect_equal(score_choice_qti(scoring_item_xml(sc),"ChoiceA"),1)
    expect_equal(score_choice_qti(scoring_item_xml(mc),"ChoiceA"),0.5)
})

test_that("plain YAML-style mappings and the single-choice helper agree", {
    old <- singleChoice(choices=c("A","B","C"),points=2,
        scoring_scheme=list(method="custom",incorrect=-0.2))
    new <- singleChoice(choices=c("A","B","C"),points=2,
        scoring_scheme=single_choice_scoring(incorrect=-0.2))
    for(response in list(NULL,"ChoiceA","ChoiceB")) {
        expect_equal(score_choice_qti(scoring_item_xml(new),response),
                     score_choice_qti(scoring_item_xml(old),response))
    }
})

test_that("statement truth determines the asymmetric penalty independently of option order", {
    true <- singleChoice(prompt="2 + 2 = 4",choices=c("False","True"),solution=2,
        scoring_scheme=single_choice_scoring("kanzow_21",statement_truth=TRUE))
    false <- singleChoice(prompt="2 + 2 = 5",choices=c("True","False"),solution=2,
        scoring_scheme=single_choice_scoring("kanzow_21",statement_truth=FALSE))
    expect_equal(score_choice_qti(scoring_item_xml(true),"ChoiceA"),-62/38)
    expect_equal(score_choice_qti(scoring_item_xml(false),"ChoiceA"),-38/62)
    expect_equal(score_choice_qti(scoring_item_xml(true),"ChoiceB"),1)
    expect_equal(score_choice_qti(scoring_item_xml(false),"ChoiceB"),1)
    expect_error(single_choice_scoring("kanzow_21"),"statement_truth")
    expect_error(single_choice_scoring("custom",statement_truth=TRUE),"unknown settings")
})

test_that("focused exams helpers preserve choice scores", {
    answers <- as.matrix(expand.grid(rep(list(c(FALSE,TRUE)),3)))
    solution <- c(TRUE,FALSE,TRUE)
    for(rule in c("false2","false","true","all","none")) {
        mc <- multipleChoice(choices=c("A","B","C"),points=c(0.5,0,0.5),
            scoring_scheme=multiple_choice_scoring("exams",negative=-0.25,rule=rule))
        doc <- scoring_item_xml(mc)
        expected <- exams::exams_eval(negative=-0.25,rule=rule)
        for(i in seq_len(nrow(answers))) {
            answer <- answers[i,]
            expect_equal(score_choice_qti(doc,mc@choice_identifiers[answer]),
                expected$pointsum(solution,answer,type="mchoice"))
        }
        expect_true(verify_qti(mc,print=FALSE,engine="xml2")$valid)
    }
    sc <- singleChoice(choices=c("A","B","C"),points=2,
        scoring_scheme=single_choice_scoring("exams",negative=-0.2))
    expect_equal(score_choice_qti(scoring_item_xml(sc),"ChoiceB"),-0.4)
})

test_that("YAML still infers the scoring model from the item's type", {
    path <- tempfile(fileext=".Rmd")
    item <- function(type,method) {
        writeLines(c("---",paste0("type: ",type),paste0("scoring_scheme: ",method),
            "---","","# question","","Choose.","","- *A*","- B"),path)
        create_question_object(path)
    }
    expect_error(item("mpc","kanzow_10"),"not available for multiple-choice items")
    expect_error(item("sc","plus_minus"),"not available for single-choice items")
    expect_s4_class(item("sc","standard"),"SingleChoice")
    expect_s4_class(item("mpc","standard"),"MultipleChoice")
})
