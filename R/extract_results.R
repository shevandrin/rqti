#' Create data frame with test results
#'
#' The function `extract_results()` takes Opal zip archive "Export results" or
#' xml file and creates two kinds of data frames (according to parameter
#' 'level'), see the 'Details' section.
#' @param file A string with a path of the xml test result file.
#' @param level A string with two possible values: task and item.
#' @param hide_filename A boolean value, TRUE to hide original file names by
#'   default.
#' @import xml2
#' @import lubridate
#' @importFrom zip zip_list
#' @return A dataframe with attribues of the candidates outcomes and result
#'   variables.
#' @note 1.With option level = "task" data frame consists of columns:
#'  * 'file' - name of the xml file with test results (to identify
#'   candidate)
#'  * 'date' - date and time of test
#'  * 'id_question' - question item identifier
#'  * 'duration' - time in sec. what candidate spent on this item
#'  * 'score_candidate' - points that were given to candidate after evaluation
#'  * 'score_max' - max possible score for this question
#'  * 'question_type' - the type of question
#'  * 'is_answer_given' - TRUE if candidate gave the answer on question,
#'   otherwise FALSE
#'  * 'title' - the values of attribute 'title' of assessment items
#'
#'   2.With option level = "item" data frame consists of columns:
#' * 'file' - name of the xml file with test results (to identify
#'   candidate)
#' * 'date' - date and time of test
#' * 'id_question' - question item identifier
#' * 'base_type' - type of answer (identifier, string or float)
#' * 'cardinalities' - defines whether this question is single, multiple or
#'   ordered -value
#' * 'qti_type' - specifies the type of the task
#' * 'id_answer' - identifier of each response variable
#' * 'expected_response' - values that considered as right responses for
#'   question
#' * 'candidate_response' - values that were given by candidate
#' * 'score_candidate' - - points that were given to candidate after evaluation
#' * 'score_max' - max possible score for this question item
#' * 'is_response_correct' - TRUE if candidate gave the right response,
#'   otherwise FALSE
#' * 'title' - the values of attribute 'title' of assessment items
#' @examples
#' file <- system.file("test_results.zip", package='rqti')
#' df <- extract_results(file, level = "item")
#'
#' @import digest
#' @export
extract_results <- function(file, level = "task", hide_filename = TRUE) {
    if (!all(file.exists(file))) stop("One or more files in list do not exist",
                                      call. = FALSE)

    exts <- tools::file_ext(file)
    if (all(exts == "zip") & (length(exts) == 1)) {
        list_content <- zip::zip_list(file)$filename
        exts_zip <- tools::file_ext(list_content)
        if (any(exts_zip == "zip") | any(exts_zip == "xml")) {
            tdir <- extract_xml(file)
            file_names <- NULL
        } else stop("the zip archive must contain xml and/or zip files")
    } else if (all(exts == "xml")) {
        tdir <- tempfile()
        dir.create(tdir)
        file.copy(file, tdir, overwrite = TRUE)
        xml_list <- list.files(path = tdir,full.names = TRUE)
        Map(make_name_unique, xml_list, basename(xml_list))
        file_names <- basename(file)
    } else stop("'file' must contain only one zip or set of xml files")

    ret <- build_dataset(tdir, level, file_names, hide_filename)
    return(ret)
}

build_dataset <- function(tdir, level, names = NULL, hide_filename) {
    xml_files <- list.files(tdir)
    res_files <- list.files(path = tdir, pattern = "assessmentResult")
    test_files <- list.files(path = tdir, pattern = "assessmentTest")
    manifest_files <- list.files(path = tdir, pattern = "manifest")
    ai_files <- list.files(path = tdir, pattern = "assessmentItem")
    message(length(res_files), " - files with result\n",
            length(test_files), " - test file(s)\n",
            length(manifest_files), " - manifest file\n",
            length(ai_files), " - files with assessment items")

    if (length(ai_files) > 0) db <- get_titles(ai_files, tdir)

    else {
        warning("In given archive files with exercises are not found.\n",
                "The \'title\' column will be skipped in the final dataframe",
                immediate. = TRUE, call. = FALSE)
        db <- NULL
    }
    df <- data.frame()
    for (f in res_files) {
        xml_path <- file.path(tdir, f)
        switch(level,
            task = {
                df0 <- get_result_attr_answers(xml_path, hide_filename)
            },
            item = {
                df0 <- get_result_attr_options(xml_path, hide_filename)
            }
        )
        name <- ifelse(is.null(names), f, names[which(res_files == f)])
        if (!is.null(db)) {
            titles <- c()
            for (id in df0$id_question) {
                titles <- c(titles, unname(db[names(db) == id]))
            }
            df0$title <- titles
        }
        df <- rbind(df, df0)
    }
    return(df)
}

safe_iconv <- function(x, from, to) {
    tryCatch(
        iconv(x, from = from, to = to),
        error = function(e) {
            return(x)
        }
    )
}

make_name_unique <- function(file, possible_name) {
    possible_name <- safe_iconv(possible_name, from = "CP850", to = "UTF-8")
    dir_path <- dirname(file)
    content <- xml2::read_xml(file)
    root <- xml2::xml_name(xml2::xml_root(content))
    file_name <- paste0(dir_path, "/", root, "_", possible_name, ".xml")
    file.rename(file, file_name)
}

# gather all xml files from zip archive and put them in temp dir and return it
extract_xml <- function(file) {
    zdir <- tempfile()
    dir.create(zdir)
    zip::unzip(file.path(file), exdir = zdir)

    tdir <- tempfile()
    dir.create(tdir)

    xml_list <- list.files(path = zdir,full.names = TRUE, pattern = ".xml")
    check_valid_utf8(xml_list)
    file.copy(xml_list, tdir, overwrite = TRUE)
    xml_list <- list.files(path = tdir,full.names = TRUE)
    Map(make_name_unique, xml_list, basename(xml_list))

    zip_files <- list.files(path = zdir, pattern = ".zip")
    check_valid_utf8(zip_files)
    Map(get_all_xml, zip_files, zdir, tdir)
    return(tdir)
}

# Create data frame with test results by answers
get_result_attr_answers<- function(file, hide_filename) {
    file_name <- clean_name(file)
    if (hide_filename) {
        file_name <- digest(file_name, algo = "sha1", serialize = FALSE)
    }

    doc <- xml2::read_xml(file)
    node_dt <- xml2::xml_find_first(doc, ".//d1:testResult")
    test_dt <- xml2::xml_attr(node_dt, "datestamp")
    test_dt <- lubridate::ymd_hms(test_dt)

    items_result <- unique_result_set(doc)

    igiven <- unlist(lapply(items_result, is_answer_given))
    ids_item <- xml2::xml_attr(items_result, attr = "identifier")
    durations <- Map(get_duration, items_result)
    scores <- Map(get_score, items_result, "SCORE")
    maxes <- Map(get_score, items_result, "MAXSCORE")
    types <- unlist(lapply(ids_item, identify_question_type))

    data <- data.frame(file = rep(file_name, length(ids_item)),
                       date = rep(test_dt, length(ids_item)),
                       id_question = ids_item,
                       duration = as.numeric(durations),
                       score_candidate = as.numeric(scores),
                       score_max = as.numeric(maxes),
                       question_type = types,
                       is_answer_given = igiven)
    return(data)
}

# rebuild xml nodeset to leave only results after tutor evaluation if it took place
#' @importFrom utils head
unique_result_set <- function(doc) {
    items_result <- xml2::xml_find_all(doc, ".//d1:itemResult")
    ids <- unlist(Map(xml_attr, items_result, "identifier"))
    unique_ids <- ids[!duplicated(ids)]
    for (id in unique_ids) {
        expression <- paste0(".//d1:itemResult", "[@identifier=\'", id, "\']")
        nodes <- xml2::xml_find_all(doc, expression)
        if (length(nodes) > 1) {
            is_scored <- unlist(Map(check_scored, nodes))
            manual_scored <- nodes[is_scored]
            lms_scored <- nodes[!is_scored]

            if (length(manual_scored) == 0) {
                if (length(lms_scored) > 1) xml_remove(head(lms_scored, -1))
            } else {
                xml_remove(lms_scored)
            }
            if (length(manual_scored) > 1) xml_remove(head(manual_scored, -1))

        }
    }
    result <- xml2::xml_find_all(doc, ".//d1:itemResult")
    return(result)
}

# check scored attribute
check_scored <- function(node) {
    outcome_var <- xml_find_all(node, ".//d1:outcomeVariable")
    # TODO use manualScored=True as a condition
    is_tutor <- xml_has_attr(outcome_var, "scorer")
    result <- any(is_tutor)
    return(result)
}
# take itemResult and return duration or NA
get_duration <- function(node) {
    dur_node <- xml2::xml_find_all(node, ".//d1:responseVariable[@identifier='duration']")
    duration <- ifelse (length(dur_node) == 0, NA, xml2::xml_text(dur_node))
    return(duration)
}

get_score <- function(node, type) {
    pattern <- paste0(".//d1:outcomeVariable[@identifier=\'", type ,"\']")
    score_node <- xml2::xml_find_all(node, pattern)
    score <- ifelse (length(score_node) == 0, NA, xml2::xml_text(score_node))
    return(score)
}

clean_name <- function(file) {
    file_name <- basename(file)
    file_name <- sub("assessmentResult_", "", file_name)
    if (grepl(".zip", file_name)) file_name <- sub(".xml", "", file_name)
    if (grepl(".xml.xml", file_name)) file_name <- sub(".xml", "", file_name)
    return(file_name)
}



# Create data frame with test results by options of answers
get_result_attr_options <- function(file, hide_filename) {
    file_name <- clean_name(file)
    file_name <- sub("assessmentResult_", "", file_name)
    if (hide_filename) {
        file_name <- digest(file_name, algo = "sha1", serialize = FALSE)
    }

    doc <- xml2::read_xml(file)
    node_dt <- xml2::xml_find_first(doc, ".//d1:testResult")
    test_dt <- xml2::xml_attr(node_dt, "datestamp")
    test_dt <- lubridate::ymd_hms(test_dt)

    items_result <- unique_result_set(doc)

    ids_item <- xml2::xml_attr(items_result, attr = "identifier")

    types <- unlist(lapply(ids_item, identify_question_type))

    identifier <-  character(0)
    options <- character(0)
    correct_responses <- character(0)
    cand_responses <- character(0)
    base_types <- character(0)
    cardinalities <- character(0)
    qti_type <- character(0)
    score_values <- character(0)
    maxscore_values <- character(0)
    correctness <- logical(0)
    for (ch in items_result) {
        res <- get_info(ch)
        len <- length(res$options)
        id <- xml2::xml_attr(ch, attr = "identifier")
        identifier <- append(identifier, rep(id, len))
        options <- append(options, res$options)
        correct_responses <- append(correct_responses, res$corr)
        cand_responses <- append(cand_responses, res$cand)
        base_types <- append(base_types, res$base_types)
        cardinalities <- append(cardinalities, res$card)
        qti_type <- append(qti_type, res$qti_type)
        score_values <- append(score_values, res$score_value)
        maxscore_values <- append(maxscore_values, res$maxscore_value)
        correctness <- append(correctness, res$correctness)
    }

    data <- data.frame(
        file = rep(file_name, length(identifier)),
        date = rep(test_dt, length(identifier)),
        id_question = identifier,
        base_type =  base_types,
        cardinalities = cardinalities,
        qti_type = qti_type,
        id_answer = options,
        expected_response = correct_responses,
        candidate_response = cand_responses,
        score_candidate = as.numeric(score_values),
        score_max = as.numeric(maxscore_values),
        is_response_correct = as.integer(as.logical(correctness))
    )
    return(data)
}

# takes information from responseVariable tags
get_info <- function(node){
    first_tag <- xml2::xml_find_first(node, ".//d1:responseVariable[@identifier!='duration']")
    b_type <- xml2::xml_attr(first_tag, "baseType")
    if (b_type == "identifier") info <- get_info_identifier(node, first_tag)
    if (b_type == "directedPair") info <- get_info_directedPair(node, first_tag)
    if (b_type == "float") info <- get_info_float(node)
    if (b_type == "string") info <- get_info_float(node)
    res <- list(info$options, info$corr, info$cand, info$base_types, info$card,
                info$q_type, info$score_value, info$maxscore_value,
                info$correctness)
    names(res) <- c("options", "corr", "cand", "base_types", "card", "qti_type",
                    "score_value", "maxscore_value", "correctness")
    return(res)
}

# takes information from tag with identifier as base type of response variable
get_info_identifier <- function(node, options_node) {

    corr_res <- xml2::xml_find_all(node, ".//d1:correctResponse")
    corr_values <- get_value(corr_res)

    cand_res <- xml2::xml_find_all(node, ".//d1:candidateResponse")[-1]
    if (length(cand_res) !=0) {
        cand_values <- get_value(cand_res)
    } else {
        cand_values <-  rep("", length(corr_values))
    }



    choice_seq <- xml2::xml_attr(options_node, "choiceSequence")

    if (!is.na(choice_seq)) {
        options <- stringr::str_split_1(choice_seq, " ")
    } else options <- corr_values

    card_node <- xml2::xml_find_first(node, ".//d1:responseVariable[@identifier='RESPONSE']")
    card <- xml2::xml_attr(card_node, "cardinality")
    if (is.na(card)) card <- "single"

    corr <- sapply(options, function(x) x %in% corr_values, USE.NAMES = FALSE)
    if (card != "ordered") {
        cand <- sapply(options, function(x) x %in% cand_values, USE.NAMES = FALSE)
    } else {
        cand <- (cand_values == corr_values)
    }

    true_counts <- sum(corr)
    result <- corr * cand
    true_cand <- sum(result)

    score <- xml2::xml_find_all(node, ".//d1:outcomeVariable[@identifier='SCORE']")

    score_value <- ifelse(result, as.numeric(get_value(score)) / true_cand, "0")


    maxscore <- xml2::xml_find_all(node, ".//d1:outcomeVariable[@identifier='MAXSCORE']")
    maxscore_value <- ifelse(result,
                             as.numeric(get_value(maxscore)) / true_counts, "0")

    base_types <- rep(xml2::xml_attr(options_node, "baseType"), length(options))
    card <- rep(xml2::xml_attr(options_node, "cardinality"), length(options))
    if (card[1] == "single") q_type <- "SingleInlineChoice"
    if (card[1] == "multiple") q_type <- "MultipleChoice"
    if (card[1] == "ordered") q_type <- "Order"
    q_type <- rep(q_type, length(options))

    res <- list(options, corr, cand, base_types, card, q_type, score_value,
                maxscore_value, as.logical(result))

    names(res) <- c("options", "corr", "cand", "base_types", "card", "q_type",
                    "score_value", "maxscore_value", "correctness")
    return(res)
}

# takes information from tag with directedPair as base type of response variable
get_info_directedPair <- function(node, options_node) {
    corr_res <- xml2::xml_find_all(node, ".//d1:correctResponse")
    corr_values <- get_value(corr_res)

    cand_res <- xml2::xml_find_all(node, ".//d1:candidateResponse")[-1]
    cand_values <- get_value(cand_res)

    options <- c(corr_values, cand_values)
    options <- options[!duplicated(options)]

    corr <- sapply(options, function(x) x %in% corr_values, USE.NAMES = FALSE)
    cand <- sapply(options, function(x) x %in% cand_values, USE.NAMES = FALSE)

    true_counts <- sum(corr)
    result <- corr * cand
    true_cand <- sum(result)

    score <- xml2::xml_find_all(node, ".//d1:outcomeVariable[@identifier='SCORE']")
    score_value <- ifelse(result,
                          (as.numeric(get_value(score)) )/ true_cand, "0")
    if (length(score) == 0) score_value <- rep("0", length(options))

    maxscore <- xml2::xml_find_all(node, ".//d1:outcomeVariable[@identifier='MAXSCORE']")
    maxscore_value <- ifelse(corr,
                             as.numeric(get_value(maxscore)) / true_counts, "0")
    if (length(maxscore) == 0) maxscore_value <- rep("0", length(options))

    base_types <- rep(xml2::xml_attr(options_node, "baseType"), length(options))
    card <- rep(xml2::xml_attr(options_node, "cardinality"), length(options))
    q_type <- rep("Match", length(options))

    res <- list(options, corr, cand, base_types, card, q_type, score_value,
                maxscore_value, as.logical(result))
    names(res) <- c("options", "corr", "cand", "base_types", "card", "q_type",
                    "score_value", "maxscore_value", "correctness")
    return(res)
}

# takes information from tag with float or string as base type of response variable
get_info_float <- function(node) {
    options_nodes <- xml2::xml_find_all(node, ".//d1:responseVariable[@identifier!='duration']")
    options <- character(0)
    corr <- character(0)
    cand <- character(0)
    base_types <- character(0)
    card <- character(0)
    q_type <- character(0)
    score_values <- character(0)
    maxscore_values <- character(0)
    result <- character(0)
    for (opt in options_nodes) {
        id <- xml2::xml_attr(opt, "identifier")
        options <- append(options, id)
        corr_res <- xml2::xml_find_all(opt, ".//d1:correctResponse")
        corr_values <- get_value(corr_res)
        if (length(corr_values) == 0) corr_values = ""
        corr <- append(corr, corr_values)
        cand_res <- xml2::xml_find_all(opt, ".//d1:candidateResponse")
        cand_values <- get_value(cand_res)
        if (length(cand_values) == 0) cand_values = ""
        cand <- append(cand, cand_values)

        expression <- paste0(".//d1:outcomeVariable[@identifier=\'SCORE_",
                             id, "\']")
        score <- xml2::xml_find_all(node, expression)
        if (length(score) == 0) {
            score <- xml2::xml_find_all(node, ".//d1:outcomeVariable[@identifier='SCORE']")
        }
        score_value <- get_value(score)
        if (length(score) == 0) score_value <- "0"
        score_values <- append(score_values, score_value)

        expression <- paste0(".//d1:outcomeVariable[@identifier=\'MAXSCORE_",
                             id, "\']")
        maxscore <- xml2::xml_find_all(node, expression)
        if (length(maxscore) == 0) {
            maxscore <- xml2::xml_find_all(node, ".//d1:outcomeVariable[@identifier='MAXSCORE']")
        }
        maxscore_value <- get_value(maxscore)
        if (length(maxscore) == 0) maxscore_value <- 0
        maxscore_values <- append(maxscore_values, maxscore_value)
        result_value <- ifelse(score_value == maxscore_value & score_value != 0,
                               TRUE, FALSE)
        result <- append(result, result_value)

        b_type <- xml2::xml_attr(opt, "baseType")
        base_types <- append(base_types, b_type)
        card <- append(card, xml2::xml_attr(opt, "cardinality"))
        if (b_type == "float") {q_type <- append(q_type, "NumericGap")}
        else if (corr_values == "") {q_type <- append(q_type, "Essay")}
        else {q_type <- append(q_type, "TextGap")}

    }

    res <- list(options, corr, cand, base_types, card, q_type, score_values,
                maxscore_values, result)
    names(res) <- c("options", "corr", "cand", "base_types", "card", "q_type",
                    "score_value", "maxscore_value", "correctness")
    return(res)
}

# takes value from tag value
get_value <- function(node) {
    values <- xml2::xml_find_all(node, ".//d1:value")
    value  <- xml2::xml_text(values)
    return(value)
}

# to detect question type
identify_question_type <- function(q_id) {
    types <- c("schoice", "mchoice", "num", "cloze", "essay")
    result <- "unknown"
    for (t in types) {
        if (grepl(t, q_id)) result <- t
    }
    return(result)
}

# returns TRUE if candidate gave an answer
is_answer_given <- function(node) {
    resp_variable <- xml2::xml_find_all(node, ".//d1:responseVariable")[-1]
    res <- xml2::xml_find_all(resp_variable, ".//d1:candidateResponse")
    ifelse (length(res)>0, TRUE, FALSE)
}

# extracts all xml file in temp folder
get_all_xml <- function(file, indir, exdir) {
    zip_file <- file.path(indir, file)
    zip::unzip(zip_file, exdir = exdir, junkpaths = TRUE)
    content <- zip::zip_list(zip_file)$filename
    check_valid_utf8(content)
    files <- file.path(exdir, content)
    files <- files[grep(".xml", files)]

    for (fl in files) {
        if (length(files) > 1) {
            make_name_unique(fl, basename(fl))
        } else {
            make_name_unique(fl, file)
        }
    }
}

# returns a named list with titles of questions and identifiers as names
get_titles <- function(files, folder) {
    result = c()
    for (f in files) {
        path <- file.path(folder, f)
        doc <- xml2::read_xml(path)
        root <- xml2::xml_name(doc)
        if (root == "assessmentItem") {
            title <-  xml2::xml_attr(doc, "title")
            names(title) <- xml2::xml_attr(doc, "identifier")
            result <- c(result, title)
        }
    }
    return(result)
}

check_valid_utf8 <- function(input) {
    not_valid <- input[!validUTF8(input)]
    if (length(not_valid) > 0) {
        stop("Some file names do not match Utf-8 encoding: ", not_valid,
             call. = FALSE)
    }
    return(NULL)
}
