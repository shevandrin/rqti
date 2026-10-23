# Shared internal constructor; the public helpers bind the item type.
new_choice_scoring_spec <- function(method, ..., item_type) {
    spec <- c(list(method = method, item_type = item_type), list(...))
    validate_scoring_spec(spec)
    spec
}

scoring_method_options <- function() {
    c(list(standard = character(), penalty = character(),
           number_right = character(), fair_penalty = character(),
           correction_for_guessing = character(), rights_minus_wrongs = character(),
           custom = c("correct", "incorrect", "omitted"),
           weights = "lower_bound", plus_minus = "lower_bound",
           all_or_nothing = c("incorrect", "omitted"),
           true_false = character(), subset = character(), ripkey = character(),
           exams = c("partial", "negative", "rule")),
      stats::setNames(rep(list(character()), 20), sprintf("kanzow_%02d", 1:20)),
      list(kanzow_21 = "statement_truth"))
}

validate_scoring_spec <- function(spec) {
    fail <- function(msg) stop("Invalid scoring_scheme: ", msg, call. = FALSE)
    if (!is.list(spec) || is.null(names(spec)) || anyNA(names(spec)) ||
        any(!nzchar(names(spec))) || anyDuplicated(names(spec))) {
        fail("use a method name or a uniquely named list.")
    }
    method <- spec$method
    options <- scoring_method_options()
    if (!is.character(method) || length(method) != 1L || is.na(method) ||
        !method %in% names(options)) fail("unknown method.")
    if (any(!names(spec) %in% c("method", "item_type", options[[method]]))) {
        fail(paste("unknown settings for", method))
    }
    for (name in intersect(names(spec), c("correct", "incorrect", "omitted", "lower_bound"))) {
        value <- spec[[name]]
        if (!is.numeric(value) || length(value) != 1L || !is.finite(value)) {
            fail(paste(name, "must be one finite number."))
        }
    }
    for (name in intersect(names(spec), c("partial", "statement_truth"))) {
        if (!is.logical(spec[[name]]) || length(spec[[name]]) != 1L || is.na(spec[[name]])) {
            fail(paste(name, "must be TRUE or FALSE."))
        }
    }
    if ("negative" %in% names(spec)) {
        value <- spec$negative
        if (!(is.numeric(value) || is.logical(value)) || length(value) != 1L ||
            !is.finite(value)) fail("negative must be one finite logical or numeric value.")
    }
    if ("rule" %in% names(spec) && (!is.character(spec$rule) ||
        length(spec$rule) != 1L || is.na(spec$rule) ||
        !spec$rule %in% c("false2", "false", "true", "all", "none"))) {
        fail("unknown R/exams weighting rule.")
    }
    if ("item_type" %in% names(spec)) {
        type <- spec$item_type
        if (!is.character(type) || length(type) != 1L || is.na(type) ||
            !type %in% c("single", "multiple")) fail("unknown item_type.")
        allowed <- if (type == "single") {
            c("standard", "penalty", "custom", "exams", "number_right",
              "fair_penalty", "correction_for_guessing", "rights_minus_wrongs",
              sprintf("kanzow_%02d", 1:21))
        } else c("standard", "weights", "all_or_nothing", "plus_minus",
                 "true_false", "subset", "ripkey", "exams")
        if (!method %in% allowed) {
            fail(paste0(method, " is not available for ", type, "-choice scoring."))
        }
        if (type == "single" && method == "exams" &&
            any(c("partial", "rule") %in% names(spec))) {
            fail("single-choice exams scoring accepts negative only; partial and rule apply to multiple choice.")
        }
    }
    if (method == "kanzow_21" && is.null(spec$statement_truth)) {
        fail("kanzow_21 requires statement_truth = TRUE or FALSE.")
    }
    invisible(spec)
}

validate_choice_scoring <- function(object) {
    tryCatch({resolve_choice_scoring(object); NULL}, error = function(e) conditionMessage(e))
}

# Published correct/incorrect/omitted coefficients; k is the option count.
kanzow_coefficients <- function(method, k, statement_truth = NULL) {
    id <- as.integer(sub("kanzow_", "", method, fixed = TRUE))
    if (id %in% c(10L, 12L, 14L, 15L, 17L, 18L, 20L, 21L) && k != 2L) {
        stop("Invalid scoring_scheme: ", method,
             " requires exactly two options; received ", k,
             ". This restriction follows Kanzow et al. (2023).", call. = FALSE)
    }
    correct <- c(1, 1, 1, 1/(k-1), 1, 1, 1/(k-1), (k-1)/k,
                 rep(1, 13))[id]
    incorrect <- c(0, 0, 1-1/k, 0, -1/(2*(k-1)), -1/(k-1),
                   -1/(k-1), -1/k, -1/3, -0.48, -0.5, -0.6, -1,
                   -1, -1.1, -k/(k-1), -1.5, -1.8, -2/(k-1), -3,
                   if (isTRUE(statement_truth)) -62/38 else -38/62)[id]
    omitted <- if (id == 2L) 1/k else if (id %in% c(14L, 15L)) 0.7 else 0
    c(correct = correct, incorrect = incorrect, omitted = omitted)
}

resolve_choice_scoring <- function(object) {
    spec <- object@scoring_scheme
    if (is.character(spec) && length(spec) == 1L) spec <- list(method = spec)
    validate_scoring_spec(spec)
    method <- spec$method
    aliases <- c(number_right = "kanzow_01", fair_penalty = "kanzow_03",
                 correction_for_guessing = "kanzow_06", rights_minus_wrongs = "kanzow_13")
    if (method %in% names(aliases)) method <- unname(aliases[[method]])
    get <- function(name, default) if (is.null(spec[[name]])) default else spec[[name]]
    single <- methods::is(object, "SingleChoice")
    expected_type <- if (single) "single" else "multiple"
    if (!is.null(spec$item_type) && spec$item_type != expected_type) {
        stop("Invalid scoring_scheme: a ", spec$item_type,
             "-choice scoring specification cannot be used for a ",
             expected_type, "-choice item.", call. = FALSE)
    }
    k <- length(object@choices)
    fail <- function(msg) stop("Invalid scoring_scheme: ", msg, call. = FALSE)
    if (identical(object@scoring_scheme, "standard") && !single) {
        # Legacy multiple-choice mapping is kept byte-for-byte on its old path.
        return(list(maximum = sum(object@points[object@points > 0]), minimum = 0))
    }
    if (single && method %in% c("standard", "penalty")) {
        # Preserve legacy construction, including the parent initialize() stage
        # before Choice has generated missing option identifiers.
        values <- c(correct = object@points,
                    incorrect = if (method == "penalty") -object@points/(k-1) else 0,
                    omitted = 0)
        return(list(model = "single", values = values,
                    maximum = object@points, minimum = min(0, values)))
    }
    ids <- object@choice_identifiers
    if (k < 2L || (length(ids) >= 2L &&
        (anyNA(ids) || anyDuplicated(ids) || length(ids) != k))) {
        fail("need at least two uniquely identified options.")
    }
    if (single) {
        if (!method %in% c("standard", "penalty", "custom", "exams", sprintf("kanzow_%02d", 1:21))) {
            fail("method is not available for single-choice items.")
        }
        if (length(object@points) != 1L || !is.finite(object@points) || object@points <= 0 ||
            length(object@solution) != 1L || !is.finite(object@solution) ||
            !object@solution %in% seq_len(k)) fail("invalid points or correct-answer index.")
        coefficients <- if (startsWith(method, "kanzow_")) {
            kanzow_coefficients(method, k, spec$statement_truth)
        } else if (method == "exams") {
            c(correct = 1, incorrect = -abs(as.numeric(get("negative", FALSE))), omitted = 0)
        } else if (method == "custom") {
            c(correct = get("correct", 1), incorrect = get("incorrect", 0), omitted = get("omitted", 0))
        } else c(correct = 1, incorrect = if (method == "penalty") -1/(k-1) else 0, omitted = 0)
        if (coefficients[["correct"]] <= 0 ||
            any(coefficients[c("incorrect", "omitted")] > coefficients[["correct"]])) {
            fail("correct credit must be positive and at least as large as other credits.")
        }
        values <- coefficients * object@points
        return(list(model = "single", values = values,
                    maximum = unname(values[["correct"]]), minimum = min(0, values)))
    }
    if (!method %in% c("standard", "weights", "plus_minus", "all_or_nothing", "true_false", "subset", "ripkey", "exams")) {
        fail("method is not available for multiple-choice items.")
    }
    if (length(object@points) != k || any(!is.finite(object@points)) || !any(object@points > 0)) {
        fail("provide one finite weight per option, including at least one positive weight.")
    }
    key <- object@points > 0
    C <- sum(key); W <- sum(!key); P <- sum(object@points[key])
    model <- method; omitted <- 0; incorrect <- 0; lower <- 0; offset <- 0
    weights <- ifelse(key, P/C, 0)
    if (method == "standard") {
        weights <- object@points
        if (all(weights >= 0) && W > 0) weights[!key] <- -P/W
    } else if (method == "weights") {
        weights <- object@points; lower <- P * get("lower_bound", 0)
    } else if (method == "plus_minus") {
        weights <- ifelse(key, P/C, -P/C); lower <- P * get("lower_bound", 0)
    } else if (method == "true_false") {
        weights <- ifelse(key, P/k, -P/k); offset <- P * W/k; omitted <- offset
    } else if (method == "all_or_nothing") {
        incorrect <- P * get("incorrect", 0); omitted <- P * get("omitted", 0)
        lower <- min(0, incorrect, omitted)
    } else if (method == "exams") {
        partial <- get("partial", TRUE)
        lower <- -P * abs(as.numeric(get("negative", FALSE)))
        if (!partial) {
            model <- "all_or_nothing"; incorrect <- lower
        } else {
            rule <- get("rule", "false2")
            penalty <- switch(rule, false2 = -1/max(W, 2),
                              false = if (W) -1/W else 0, true = -1/C,
                              all = -1, none = 0)
            weights <- ifelse(key, P/C, P * penalty)
        }
    }
    if (lower > 0 || max(incorrect, omitted) > P) fail("invalid score bounds.")
    list(model = model, weights = weights, maximum = P, minimum = lower,
         incorrect = incorrect, omitted = omitted, offset = offset, correct_count = C)
}

# Only standard QTI operators; score assignment resets each attempt explicitly.
create_choice_scoring_processing <- function(object) {
    spec <- resolve_choice_scoring(object)
    number <- function(x) baseValue(list(baseType = "float", format(x, digits = 17, scientific = FALSE, trim = TRUE)))
    set_score <- function(value) setOutcomeValue(list(identifier = "SCORE", value))
    condition <- function(test, yes, no) responseCondition(list(
        responseIf(list(test, yes)), responseElse(list(no))))
    empty <- isNull(variable(object@response_identifier))
    if (spec$model != "single") {
        # Some engines retain an empty multiple response as [] rather than NULL.
        # Both represent an omitted checkbox response.
        empty <- tag("or", list(empty, equal(list(
            tag("containerSize", list(variable(object@response_identifier))),
            baseValue(list(baseType = "integer", 0))))))
    }
    if (spec$model == "single") {
        calculate <- condition(empty, set_score(number(spec$values[["omitted"]])),
            condition(match(list(variable(object@response_identifier), correct(object@response_identifier))),
                set_score(number(spec$values[["correct"]])),
                set_score(number(spec$values[["incorrect"]]))))
    } else {
        raw <- mapResponse(object@response_identifier)
        if (spec$offset != 0) raw <- sum_tag(list(number(spec$offset), raw))
        if (spec$model == "all_or_nothing") {
            raw <- condition(match(list(variable(object@response_identifier), correct(object@response_identifier))),
                             set_score(number(spec$maximum)), set_score(number(spec$incorrect)))
        } else if (spec$model == "subset") {
            wrong <- object@choice_identifiers[object@points <= 0]
            selected <- lapply(wrong, function(id) tag("member", list(
                baseValue(list(baseType = "identifier", id)), variable(object@response_identifier))))
            raw <- if (length(selected)) condition(tag("or", selected),
                    set_score(number(0)), set_score(raw)) else set_score(raw)
        } else if (spec$model == "ripkey") {
            count <- tag("containerSize", list(variable(object@response_identifier)))
            raw <- condition(gt(list(count, baseValue(list(baseType = "integer", spec$correct_count)))),
                             set_score(number(0)), set_score(raw))
        } else raw <- set_score(raw)
        calculate <- condition(empty, set_score(number(spec$omitted)), raw)
    }
    feedback <- if (length(object@feedback)) make_default_feedback_cond(response_identifier = object@response_identifier)
    conditions <- Map(createResponseCondition, object@feedback)
    responseProcessing(list(calculate, make_default_resp_cond(), feedback, conditions))
}
