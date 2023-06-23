# process modalfeedback for all match types and mc
create_default_resp_processing <- function(object) {
    var_resp <- tag("variable", list(identifier = "RESPONSE"))
    tag_not <- tag("not", list(tag("isNull", list(var_resp))))
    var_score <- tag("variable", list(identifier = "SCORE"))
    map_res <- tag("mapResponse", list(identifier = "RESPONSE"))
    tag_sum <- tag("sum", list(var_score, map_res))
    set_ov <- tag("setOutcomeValue", list(identifier = "SCORE", tag_sum))
    response_if <- tag("responseIf", list(tag_not, set_ov))
    resp_cond1 <- tag("responseCondition", list(response_if))

    resp_cond234 <- make_default_resp_cond()

    conditions <- Map(createResponseCondition, object@feedback)
    resp_proc <- tag("responseProcessing", list(resp_cond1, resp_cond234,
                                                conditions))
    return(resp_proc)
}

#process modalfeedback for sc and order
create_default_resp_processing_sc_order <- function(object) {
    var_resp <- tag("variable", list(identifier = "RESPONSE"))
    tag_isnull <- tag("isNull", list(var_resp))
    response_if <- tag("responseIf", list(tag_isnull))
    var_corr <- tag("correct", list(identifier = "RESPONSE"))
    tag_match <- tag("match", list(var_resp, var_corr))
    var_score <- tag("variable", list(identifier = "SCORE"))
    var_maxscore <- tag("variable", list(identifier =  "MAXSCORE"))
    tag_sum <- tag("sum", list(var_score, var_maxscore))
    set_ov <- tag("setOutcomeValue", list(identifier = "SCORE", tag_sum))
    response_elseif <- tag("responseElseIf", list(tag_match, set_ov))
    resp_cond1 <- tag("responseCondition", list(response_if, response_elseif))

    resp_cond234 <- make_default_resp_cond()

    conditions <- Map(createResponseCondition, object@feedback)
    resp_proc <- tag("responseProcessing", list(resp_cond1, resp_cond234,
                                                conditions))
    return(resp_proc)
}

#process modalfeedback for entry
create_response_processing_entry <- function(object) {
    answers <- Map(getResponse, object@content)
    answers[sapply(answers, is.null)] <- NULL

    #set outcome value for SCORE
    tag_sum <- tag("sum", Map(set_outcome_value_entry, answers))
    set_ov <- tag("setOutcomeValue", list(identifier = "SCORE", tag_sum))

    #this form the 1th condition
    processing <- Map(createResponseProcessing, answers)

    #this form conditions 2-6
    conditions <- NULL
    if (length(object@feedback) > 0) {

        #this form 5 and 6 conditions
        resp_conds <- Map(createResponseCondition, object@feedback)
        #this form 2, 3 and 4 conditions and gathering all together
        conditions <- tagList(make_default_resp_cond(answers),
                              resp_conds)
    }
    tag("responseProcessing", list(set_ov, processing, conditions))
}

set_outcome_value_entry <- function(object) {
    tag_var <- tag("variable",
        list(identifier = paste0("SCORE_", object@response_identifier)))
    return(tag_var)
}

make_response_condition <- function(object = NULL) {
    identifier <- ifelse(is.null(object), "RESPONSE", object@response_identifier)
    tag_var <- tag("variable", list(identifier = identifier))
    tag("isNull", list(tag_var))
}

make_default_resp_cond <- function(answers = list(NULL)) {
    tag_gt <- tag("gt",
                  list(tag("variable", list(identifier = "SCORE")),
                       tag("variable", list(identifier = "MAXSCORE"))))
    set_ov <- tag("setOutcomeValue", list(identifier = "SCORE",
                                          list(tag("variable",
                                               list(identifier = "MAXSCORE")))))
    response_if <- tag("responseIf", list(tag_gt, set_ov))
    resp_cond1 <- tag("responseCondition", list(response_if))

    tag_lt <- tag("lt",
                  list(tag("variable", list(identifier = "SCORE")),
                       tag("variable", list(identifier = "MINSCORE"))))
    set_ov <- tag("setOutcomeValue", list(identifier = "SCORE",
                                          list(tag("variable",
                                               list(identifier = "MINSCORE")))))
    response_if <- tag("responseIf", list(tag_lt, set_ov))
    resp_cond2 <- tag("responseCondition", list(response_if))

    tag_isnull <- Map(make_response_condition, answers)
    if (length(tag_isnull) > 1) {
        tag_isnull <- tag("and", tag_isnull)
    }
    tag_bv <- tag("baseValue", list(baseType = "identifier", "empty"))
    set_ov <- tag("setOutcomeValue",
                  list(identifier = "FEEDBACKBASIC", tag_bv))
    response_if <- tag("responseIf", list(tag_isnull, set_ov))
    tag_lt <- tag("lt", list(tag("variable", list(identifier = "SCORE")),
                             tag("variable", list(identifier = "MAXSCORE"))))
    tag_bv <- tag("baseValue", list(baseType = "identifier", "incorrect"))
    set_ov <- tag("setOutcomeValue",
                  list(identifier = "FEEDBACKBASIC", tag_bv))
    response_elseif <- tag("responseElseIf", list(tag_lt, set_ov))

    tag_bv <- tag("baseValue", list(baseType = "identifier", "correct"))
    set_ov <- tag("setOutcomeValue",
                  list(identifier = "FEEDBACKBASIC", tag_bv))
    response_else <- tag("responseElse", list(set_ov))

    resp_cond3 <- tag("responseCondition",
                        list(response_if, response_elseif,
                             response_else))

    return(tagList(resp_cond1, resp_cond2, resp_cond3))
}


create_response_processing_inline_choice <- function(object) {
    child <- tagList(tag("variable",
                         list(identifier = object@response_identifier)),
                     tag("correct",
                         list(identifier = object@response_identifier)))
    match <- tag("match", child)
    base_value <- tag("baseValue", list(baseType = "float", object@score))
    outcome <- tag("setOutcomeValue",
                   list(identifier = paste0("SCORE_",
                                            object@response_identifier),
                        base_value))
    response_if <- tag("responseIf", tagList(match, outcome))
    tag("responseCondition", list(response_if))
}

create_response_processing_text_entry_opal <- function(object) {
    child <- tagList(tag("variable",
                         list(identifier = object@response_identifier)),
                     tag("correct",
                         list(identifier = object@response_identifier)))
    equal_tag <- tag("equal", list(toleranceMode = "absolute",
                                   tolerance = object@tolerance,
                                   child))
    var_outcome <- tag("variable",
                       list(identifier = paste0("MAXSCORE_",
                                                object@response_identifier)))
    outcome_tag <- tag("setOutcomeValue",
                       list(identifier = paste0("SCORE_",
                                                object@response_identifier),
                            var_outcome))
    if_tag <- tag("responseIf", list(equal_tag, outcome_tag))
    tag("responseCondition", list(if_tag))
}

create_response_processing_num_entry <- function(object) {
    tolerance_str <- paste(object@tolerance, object@tolerance)
    child <- tagList(tag("variable",
                         list(identifier = object@response_identifier)),
                     tag("correct",
                         list(identifier = object@response_identifier)))
    equal_tag <- tag("equal", list(toleranceMode = object@tolerance_type,
                                   tolerance = tolerance_str,
                                   includeLowerBound =
                                       tolower(object@include_lower_bound),
                                   includeUpperBound =
                                       tolower(object@include_upper_bound),
                                   child))
    var_outcome <- tag("variable",
                       list(identifier = paste0("MAXSCORE_",
                                                object@response_identifier)))
    outcome_tag <- tag("setOutcomeValue",
                       list(identifier = paste0("SCORE_",
                                                object@response_identifier),
                            var_outcome))
    if_tag <- tag("responseIf", list(equal_tag, outcome_tag))
    tag("responseCondition", list(if_tag))
}

# this response condition makes link between Response and Feedback message
create_resp_cond_set_feedback <- function(object) {
    variab <- tag("variable", list(identifier = "FEEDBACKMODAL"))
    base_value <- tag("baseValue", list(baseType = "identifier",
                                        object@identifier))
    multiple <- tag("multiple", list(variab, base_value))

    tag_mt_var <- tag("variable", list(identifier = "FEEDBACKBASIC"))
    tag_match <- tag("match", list(base_value, tag_mt_var))
    tag_and <- tag("and", list(tag_match))
    set_out_value <- tag("setOutcomeValue",
                         list(identifier = object@outcome_identifier, multiple))
    tag_resp_if <- tag("responseIf", list(tag_and, set_out_value))
    tag_resp_cond <- tag("responseCondition", list(tag_resp_if))
    return(tag_resp_cond)
}
