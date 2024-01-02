# functions for creating tags
#' @importFrom htmltools tag
create_tag <- function(x) {
    function(attrs = list()) {
        if (inherits(attrs, "shiny.tag")) attrs = list(attrs)
        tag(x, attrs)
    }
}
create_vartag <- function(x) {
    function(id) {
        tag(x, list(identifier = id))
    }
}
variable <- create_vartag("variable")
correct <- create_vartag("correct")
mapResponse <- create_vartag("mapResponse")
not <- create_tag("not")
isNull <- create_tag("isNull")
setOutcomeValue <- create_tag("setOutcomeValue")
sum_tag <- create_tag("sum")
responseIf <- create_tag("responseIf")
responseElseIf <- create_tag("responseElseIf")
responseElse <- create_tag("responseElse")
responseCondition <- create_tag("responseCondition")
responseProcessing <- create_tag("responseProcessing")
match <- create_tag("match")
gt <- create_tag("gt")
lt <- create_tag("lt")
and <- create_tag("and")
baseValue <- create_tag("baseValue")
mapTolResponse <- create_tag("mapTolResponse")
equal <- create_tag("equal")
multiple <- create_tag("multiple")
outcomeCondition <- create_tag("outcomeCondition")
outcomeIf <- create_tag("outcomeIf")
gte <- create_tag("gte")
tr <- create_tag("tr")
td <- create_tag("td")
th <- create_tag("th")

# process modalfeedback for all match types and mc
create_default_resp_processing <- function(object) {
    not_tag <- not(isNull(variable("RESPONSE")))
    sum_tag <- sum_tag(list(variable("SCORE"), mapResponse("RESPONSE")))
    set_ov_tag <- setOutcomeValue(list(identifier = "SCORE", sum_tag))
    responseIf_tag <- responseIf(list(not_tag, set_ov_tag))
    resp_cond1 <- responseCondition(responseIf_tag)

    resp_cond23 <- make_default_resp_cond()

    resp_cond4 <- NULL
    if (length(object@feedback) > 0) resp_cond4 <- make_default_feedback_cond()

    conditions <- Map(createResponseCondition, object@feedback)

    resp_proc <- responseProcessing(list(resp_cond1, resp_cond23, resp_cond4,
                                         conditions))
    return(resp_proc)
}

#process modalfeedback for sc
create_default_resp_processing_sc <- function(object) {
    resp_cond1 <- make_first_cond_sc_order()
    resp_cond23 <- make_default_resp_cond()
    resp_cond4 <- NULL
    if (length(object@feedback) > 0) resp_cond4 <- make_default_feedback_cond()

    conditions <- Map(createResponseCondition, object@feedback)

    resp_proc <- responseProcessing(list(resp_cond1, resp_cond23, resp_cond4,
                                         conditions))
    return(resp_proc)
}

make_first_cond_sc_order <- function() {
    response_if <- responseIf(isNull(variable("RESPONSE")))
    match_tag <- match(list(variable("RESPONSE"), correct("RESPONSE")))
    set_ov_tag <- setOutcomeValue(list(identifier = "SCORE", variable("MAXSCORE")))
    response_elseif <- responseElseIf(list(match_tag, set_ov_tag))
    resp_cond1 <- responseCondition(list(response_if, response_elseif))
    return(resp_cond1)
}

#process modalfeedback for order
create_default_resp_processing_order <- function(object) {
    resp_cond1 <- NULL
    if (!object@points_per_answer) resp_cond1 <- make_first_cond_sc_order()
    resp_cond23 <- make_default_resp_cond()
    resp_cond4 <- NULL
    if (length(object@feedback) > 0) resp_cond4 <- make_default_feedback_cond()
    conditions <- Map(createResponseCondition, object@feedback)
    resp_proc <- responseProcessing(list(resp_cond1, resp_cond23, resp_cond4,
                                         conditions))
    return(resp_proc)
}

#process modalfeedback for entry
create_response_processing_entry <- function(object) {
    answers <- Map(getResponse, object@content)
    answers[sapply(answers, is.null)] <- NULL

    #set outcome value for SCORE
    tag_sum <- sum_tag(Map(set_outcome_value_entry, answers))
    set_ov <- setOutcomeValue(list(identifier = "SCORE", tag_sum))

    #this form the 1th condition
    processing <- Map(createResponseProcessing, answers)

    #this form conditions 2-6
    conditions <- NULL
    if (length(object@feedback) > 0) {

        #this form 5 and 6 conditions
        resp_conds <- Map(createResponseCondition, object@feedback)
        #this form 2, 3 and 4 conditions and gathering all together
        conditions <- tagList(make_default_resp_cond(),
                              make_default_feedback_cond(answers),
                              resp_conds)
    }
    return(responseProcessing(list(processing, set_ov, conditions)))
}

set_outcome_value_entry <- function(object) {
    tag_var <- variable(paste0("SCORE_", object@response_identifier))
    return(tag_var)
}

make_response_condition <- function(object = NULL) {
    identifier <- ifelse(is.null(object), "RESPONSE", object@response_identifier)
    return(isNull(variable(identifier)))
}

make_default_resp_cond <- function() {
    tag_gt <- gt(list(variable("SCORE"), variable("MAXSCORE")))
    set_ov <- setOutcomeValue(list(identifier = "SCORE", variable("MAXSCORE")))
    resp_cond1 <- responseCondition(responseIf(list(tag_gt, set_ov)))

    tag_lt <- lt(list(variable("SCORE"), variable("MINSCORE")))
    set_ov <- setOutcomeValue(list(identifier = "SCORE", variable("MINSCORE")))
    resp_cond2 <- responseCondition(responseIf(list(tag_lt, set_ov)))
    return(tagList(resp_cond1, resp_cond2))
}

make_default_feedback_cond <- function(answers = list(NULL)) {
    tag_isnull <- Map(make_response_condition, answers)
    if (length(tag_isnull) > 1) {
        tag_isnull <- and(tag_isnull)
    }
    tag_bv <- baseValue(list(baseType = "identifier", "empty"))
    set_ov <- setOutcomeValue(list(identifier = "FEEDBACKBASIC", tag_bv))
    response_if <- responseIf(list(tag_isnull, set_ov))
    tag_lt <- lt(list(variable("SCORE"), variable("MAXSCORE")))

    tag_bv <- baseValue(list(baseType = "identifier", "incorrect"))
    set_ov <- setOutcomeValue(list(identifier = "FEEDBACKBASIC", tag_bv))
    response_elseif <- responseElseIf(list(tag_lt, set_ov))

    tag_bv <- baseValue(list(baseType = "identifier", "correct"))
    set_ov <- setOutcomeValue(list(identifier = "FEEDBACKBASIC", tag_bv))
    response_else <- responseElse(list(set_ov))

    resp_cond <- responseCondition(list(response_if, response_elseif,
                                        response_else))
    return(resp_cond)
}

create_response_processing_gap_basic <- function(object) {
    not_tag <- not(isNull(variable(object@response_identifier)))
    map_tag <- mapResponse(object@response_identifier)
    outcome_tag <- setOutcomeValue(list(
        identifier = paste0("SCORE_", object@response_identifier), map_tag))
    response_if <- responseIf(list(not_tag, outcome_tag))
    return(responseCondition(response_if))
}

create_response_processing_text_entry_opal <- function(object) {
    # url to scheme that process the answer with tolerance
    url_scheme <- "http://bps-system.de/xsd/imsqti_ext_maptolresponse"
    not_tag <- not(isNull(variable(object@response_identifier)))
    map_tag <- mapTolResponse(list(xmlns = url_scheme,
                            identifier = object@response_identifier,
                            tolerance = object@tolerance,
                            toleranceMode = "absolute"))
    outcome_tag <- setOutcomeValue(list(
        identifier = paste0("SCORE_",object@response_identifier), map_tag))
    return(responseCondition(responseIf(list(not_tag, outcome_tag))))
}

create_response_processing_num_entry <- function(object) {
    tolerance_str <- paste(object@tolerance, object@tolerance)
    child <- tagList(variable(object@response_identifier),
                     correct(object@response_identifier))
    equal_tag <- equal(list(toleranceMode = object@tolerance_type,
                                   tolerance = tolerance_str,
                                   includeLowerBound =
                                       tolower(object@include_lower_bound),
                                   includeUpperBound =
                                       tolower(object@include_upper_bound),
                                   child))
    var_outcome <- variable(paste0("MAXSCORE_", object@response_identifier))
    outcome_tag <- setOutcomeValue(list(identifier = paste0("SCORE_",
                                    object@response_identifier), var_outcome))
    return(responseCondition(responseIf(list(equal_tag, outcome_tag))))
}

# this response condition makes link between Response and Feedback message
create_resp_cond_set_feedback <- function(object) {
    variab <- variable("FEEDBACKMODAL")
    base_value <- baseValue(list(baseType = "identifier", object@identifier))
    multiple_tag <- multiple(list(variab, base_value))

    tag_mt_var <- variable("FEEDBACKBASIC")
    tag_and <- and(match(list(base_value, tag_mt_var)))
    set_out_value <- setOutcomeValue(list(
        identifier = object@outcome_identifier, multiple_tag))
    return(responseCondition(responseIf(list(tag_and, set_out_value))))
}

# this response condition makes Feedback with Points according to grading system
create_resp_cond_grade_feedback <- function(lower_bound, upper_bound,
                                            id_grade_fb) {
    t_variable <- variable("SCORE")
    t_gte <- NULL
    t_lt <- NULL
    if (!is.null(lower_bound)) {
        t_baseValue <- baseValue(list(baseType = "float", lower_bound))
        t_gte <- gte(list(t_variable, t_baseValue))
    }
    if (!is.null(upper_bound)) {
        t_baseValue <- baseValue(list(baseType = "float", upper_bound))
        t_lt <- lt(list(t_variable, t_baseValue))
    }
    t_and <- and(list(t_gte, t_lt))
    t_variable <- variable("FEEDBACKMODAL")
    t_baseValue <- baseValue(list(baseType = "identifier", id_grade_fb))
    t_multiple <- multiple(list(t_variable, t_baseValue))
    t_setOutcomeValue <- setOutcomeValue(list(identifier = "FEEDBACKMODAL",
                                              t_multiple))
    t_outcomeIf <- outcomeIf(list(t_and, t_setOutcomeValue))
    t_outcomeCondition <- outcomeCondition(list(t_outcomeIf))
    return(t_outcomeCondition)
}

# this function creates set of outcomesConditions according to german grade system
make_set_conditions_grade <- function(max_points, label) {
    grades <- c("5.0", "4.0", "3.7", "3.3", "3.0", "2.7", "2.3", "2.0", "1.7",
               "1.3", "1.0")
    id_grade_fb <- paste0("feedback_grade_", gsub("\\.", "", grades))
    grade_levels <- seq(50, 100, 5) * max_points / 100
    grade_levels <- grade_levels[-length(grade_levels)]
    lower_bounds <- append(list(NULL), as.list(grade_levels))
    upper_bounds <- append(as.list(grade_levels), list(NULL))
    conditions <- Map(create_resp_cond_grade_feedback, lower_bounds,
                             upper_bounds, id_grade_fb)
    conditions <- tagList(conditions, create_resp_cond_grade_table())
    feedbacks <- Map(create_feedback_grade, id_grade_fb, grades, label)
    lower_bounds[1] <- 0
    upper_bounds[length(upper_bounds)] <- max_points
    feedback_table <- create_feedback_grade_table(grades, label, lower_bounds,
                                                  upper_bounds)
    feedbacks <- tagList(feedbacks, feedback_table)

    return(list(conditions = conditions, feedbacks = feedbacks))
}

# this function creates feedback tag according to German grading system
create_feedback_grade <- function(id, grade, label) {
    message <- paste(label, grade)
    tag("testFeedback", list(identifier = id,
                             outcomeIdentifier = "FEEDBACKMODAL",
                             showHide = "show", access = "atEnd",
                             tag("p", message)))
}

# this function creates feedback tag with grading table
create_feedback_grade_table <- function(grades, grade_label, lower_bounds,
                                        upper_bounds) {
    make_table_row <- function(grade, min, max) {
        tr(tagList(td(grade), td(min), td(max)))
    }
    header <- tag("tr", tagList(th(grade_label), th("Min"), th("Max")))
    rows <- Map(make_table_row, grades, lower_bounds, upper_bounds)
    tbody <- tag("tbody", list(style ="text-align: center;",
                               tagList(header, rows)))
    grade_table <- tag("table", list(border = 1,
                        style = "border-collapse: collapse; min-width: 150px;",
                                     tbody))
    tag("testFeedback", list(identifier = "feedback_grade_table",
                             outcomeIdentifier = "FEEDBACKTABLE",
                             showHide = "show", access = "atEnd",
                             grade_table))
}

# this function makes condition to show grading table in feedback
create_resp_cond_grade_table <- function() {
    t_variable <- variable("SCORE")
    t_baseValue <- baseValue(list(baseType = "float", 0))
    t_gte <- gte(list(t_variable, t_baseValue))
    t_and <- and(list(t_gte))
    t_variable <- variable("FEEDBACKTABLE")
    t_baseValue <- baseValue(list(baseType = "identifier", "feedback_grade_table"))
    t_multiple <- multiple(list(t_variable, t_baseValue))
    t_setOutcomeValue <- setOutcomeValue(list(identifier = "FEEDBACKTABLE",
                                              t_multiple))
    t_outcomeIf <- outcomeIf(list(t_and, t_setOutcomeValue))
    t_outcomeCondition <- outcomeCondition(list(t_outcomeIf))
    return(t_outcomeCondition)
}
