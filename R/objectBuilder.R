
#' Create S4 object according to content of markdown file
#'
#' @param file a file with markdown description of question.
#' @importFrom commonmark markdown_html
#' @importFrom htmltools HTML p
#' @importFrom stringr str_extract_all str_sub str_trim str_split_1
#' @import rmarkdown
#' @import yaml
#' @importFrom utils read.delim
#' @return an instance of the S4 object (SingleChoice, MultipleChoice,
#'   Entry, Order, OneInRowTable, OneInColTable, MultipleChoiceTable,
#'   DirectedPair).
#' @export
create_question_object <- function(file) {
    file <- readLines(file)
    attrs_sec <- get_task_section(file, "attributes")
    attrs <- get_task_attributes(attrs_sec)
    object <- switch(tolower(attrs["type"]),
                     "entry" = create_entry_object(file, attrs),
                     "singlechoice" =  create_sc_object(file, attrs),
                     "multiplechoice" = create_mc_object(file, attrs),
                     "essay" = create_essay_object(file, attrs),
                     "order" = create_order_object(file, attrs),
                     "directedpair" = create_dp_object(file, attrs),
                     "multiplechoicetable" = create_mctable_object(file, attrs)
                    )
}

create_entry_object <- function(file, attrs) {
    file <- get_task_section(file, "question")
    file <- gsub("<<", "<entry>", file)
    file <- gsub(">>", "</entry>", file)
    html <- transform_to_html(file)
    html_ <- unlist(html)
    text <- ""
    for (s in html_) {
        text <- paste(text, s)
    }
    html <- paste0(text, " ")
    html <- stringr::str_trim(html, "left")
    count_all_gaps <- length(unlist(str_extract_all(html, "<entry>")))
    ids <- make_ids(count_all_gaps, "response")
    end <- unlist(gregexpr("<entry>", html)) - 1L
    begin <- unlist(gregexpr("</entry>", html)) + 8L
    all <- sort(c(begin, end, 1, nchar(html)))
    content <- list()
    for (i in seq(length(all) - 1)) {
        text_chank <- substring(html, all[i], all[i + 1L] - 1L)
        # text_chank <- gsub("\n", "", text_chank)
        if ((i %% 2) == 0) {
            text_chank <- create_gap_object(text_chank, ids[i / 2])
        }
        content <- append(content, text_chank)
    }
    object = new("Entry", content = content,
                 title = unname(attrs["title"]),
                 prompt = unname(attrs["prompt"]),
                 points = unname(as.numeric(attrs["points"])),
                 identifier = unname(attrs["identifier"]))
}

make_ids <- function(n, type) {
    paste(type, formatC(1:n, flag = "0", width = nchar(n)), sep = "_")
}

create_gap_object <- function(params, id) {
    params <- str_sub(params, 9, -9)
    params <- try(yaml::yaml.load(params), silent = TRUE)
    if (is.null(params) | is.character(params) | is.numeric(params)) {
        if (is.numeric(params)) {
            new("NumericGap", response_identifier = id, response = params)
        } else if (length(str_split_1(params, ",")) == 1) {
            new("TextGap", response_identifier = id, response = params)
        } else {
            new("InlineChoice", response_identifier = id,
                options = str_split_1(params, ","))
        }
    } else {
        if (tolower(params$type) == "numeric") {
            new("NumericGap", response_identifier = id,
                response = params$response,
                value_precision = if (!is.null(params$value_precision))
                    params$value_precision else double(0),
                type_precision = if (!is.null(params$type_precision))
                    params$type_precision else "exact",
                include_lower_bound = if(!is.null(params$lower_bound))
                    params$lower_bound else TRUE,
                include_upper_bound = if(!is.null(params$upper_bound))
                    params$upper_bound else TRUE,
                expected_length = if(!is.null(params$length))
                    params$length else double(0),
                placeholder = if(!is.null(params$placeholder))
                    params$placeholder else character(0),
                score = if(!is.null(params$score))
                    params$score else double(0)
                )
        } else if (tolower(params$type) == "text") {
            new("TextGap", response_identifier = id,
                response = params$response,
                alternatives = if(!is.null(params$alternatives))
                    params$alternatives else character(0),
                case_sensitive = if(!is.null(params$case_sensitive))
                    params$case_sensitive else TRUE,
                expected_length = if(!is.null(params$length))
                    params$length else double(0),
                placeholder = if(!is.null(params$placeholder))
                    params$placeholder else character(0),
                score = if(!is.null(params$score))
                    params$score else double(0)
                )
        } else {
            new("InlineChoice", response_identifier = id,
                options = params$options,
                expected_length = if(!is.null(params$length))
                    params$length else double(0),
                placeholder = if(!is.null(params$placeholder))
                    params$placeholder else character(0),
                score = if(!is.null(params$score))
                    params$score else double(0)
                )
        }
    }
}

create_sc_object <- function(file, attrs) {
    sect <- get_task_section(file, "question")
    html <- transform_to_html(sect)
    choices <- get_task_section(file, "answers")
    object = new("SingleChoice", identifier = unname(attrs["identifier"]),
                 title = unname(attrs["title"]),
                 content = html,
                 points = as.numeric(attrs["points"]),
                 prompt = unname(attrs["prompt"]),
                 choices = choices,
                 choice_identifiers = unname(attrs["choice_identifiers"]),
                 shuffle = if (is.null(unname(attrs["shuffle"])))
                     unname(attrs["shuffle"]) else TRUE,
                 orientation = unname(attrs["orientation"]),
                 solution = as.numeric(attrs["solution"]))
}

create_mc_object <- function(file, attrs) {
    sect <- get_task_section(file, "question")
    html <- transform_to_html(sect)
    choices <- get_task_section(file, "answers")
    choice_ids <- attrs["choice_identifiers"]
    if (!is.na(choice_ids)) choice_ids <- str_trim(str_split_1(choice_ids, ","))
    points <- str_trim(str_split_1(attrs["points"], ","))
    object = new("MultipleChoice", identifier = unname(attrs["identifier"]),
                 title = unname(attrs["title"]),
                 content = html,
                 points = as.numeric(points),
                 prompt = unname(attrs["prompt"]),
                 choices = choices,
                 choice_identifiers = choice_ids,
                 shuffle = if (is.null(unname(attrs["shuffle"])))
                     unname(attrs["shuffle"]) else TRUE,
                 orientation = unname(attrs["orientation"])
    )
}

create_essay_object <- function(file, attrs) {
    sect <- get_task_section(file, "question")
    html <- transform_to_html(sect)
    object = new("Essay", identifier = unname(attrs["identifier"]),
                 title = unname(attrs["title"]),
                 content = html,
                 points = as.numeric(attrs["points"]),
                 expected_length = if (!is.na(attrs["length"]))
                     as.numeric(attrs["length"]) else double(0),
                 expected_lines = if (!is.na(attrs["lines"]))
                     as.numeric(attrs["lines"]) else double(0),
                 max_strings = if (!is.na(attrs["max_words"]))
                     as.numeric(attrs["max_words"]) else double(0),
                 min_strings = if (!is.na(attrs["min_words"]))
                     as.numeric(attrs["min_words"]) else double(0),
                 data_allow_paste = if (!is.na(attrs["allow_paste"]))
                     as.logical(attrs["allow_paste"]) else logical(0)
    )
}

create_order_object <- function(file, attrs) {
    sect <- get_task_section(file, "question")
    html <- transform_to_html(sect)
    choices <- get_task_section(file, "answers")
    object = new("Order", identifier = unname(attrs["identifier"]),
                 title = unname(attrs["title"]),
                 content = html,
                 points = as.numeric(attrs["points"]),
                 prompt = unname(attrs["prompt"]),
                 choices = choices,
                 choices_identifiers = if (!is.na(attrs["choice_identifiers"]))
                     unname(attrs["choice_identifiers"]) else character(0),
                 shuffle = if (is.null(unname(attrs["shuffle"])))
                     unname(attrs["shuffle"]) else TRUE
    )
}

create_dp_object <- function(file, attrs) {
    sect <- get_task_section(file, "question")
    html <- transform_to_html(sect)
    answers <- get_task_section(file, "answers")
    rows_ids <- make_ids(length(answers), "row")
    cols_ids <- make_ids(length(answers), "col")
    answers_identifiers <- paste(rows_ids, cols_ids)
    parsed_answers <- sub(" ", "", unlist(strsplit(answers, "\\|")))
    rows <- parsed_answers[c(TRUE, FALSE)]
    cols <- parsed_answers[c(FALSE, TRUE)]
    object = new("DirectedPair", identifier = unname(attrs["identifier"]),
                 title = unname(attrs["title"]),
                 content = html,
                 points = as.numeric(attrs["points"]),
                 prompt = unname(attrs["prompt"]),
                 rows = rows,
                 rows_identifiers = rows_ids,
                 cols = cols,
                 cols_identifiers = cols_ids,
                 answers_identifiers = answers_identifiers,
                 shuffle = if (is.null(unname(attrs["shuffle"])))
                     unname(attrs["shuffle"]) else TRUE
    )

}

create_mctable_object <- function(file, attrs) {
    sect <- get_task_section(file, "question")
    html <- transform_to_html(sect)
    table <- read_table(get_task_section(file, "answers"))
    rows <- table[,1]
    cols <- colnames(table)[-1]
    rows_ids <- make_ids(length(rows), "row")
    cols_ids <- make_ids(length(cols), "col")
    answers_identifiers <- c()
    answers_scores <- c()
    for (i in 1:nrow(table)) {
        for (j in 2:ncol(table)) {
            points <- table[i, j]
            if (points > 0) {
                answer_pair = paste(rows_ids[i], cols_ids[j - 1L])
                answers_identifiers = c(answers_identifiers, answer_pair)
                answers_scores <- c(answers_scores, points)
            }
        }
    }
    object = new("MultipleChoiceTable", identifier = unname(attrs["identifier"]),
                 title = unname(attrs["title"]),
                 content = html,
                 prompt = unname(attrs["prompt"]),
                 points = sum(answers_scores),
                 rows = rows,
                 rows_identifiers = rows_ids,
                 cols = cols,
                 cols_identifiers = cols_ids,
                 answers_identifiers = answers_identifiers,
                 answers_scores = answers_scores,
                 shuffle = if (!is.null(unname(attrs["shuffle"])))
                     as.logical(unname(attrs["shuffle"])) else TRUE
    )

}

# get content of section
# restun text chank
get_task_section <- function(file, section) {
    sec_bord <- grep("^====", file)
    headers <- file[sec_bord - 1L]
    ind <- which(section == tolower(headers))
    begin <- sec_bord[ind] + 1L
    end <- sec_bord[ind + 1L] - 2L
    if (is.na(end)) end <- length(file)
    result <- file[begin:end]
    if (section != "question") {
       result <- result[sapply(result, nchar, USE.NAMES = FALSE) !=  0]
    }
    return(result)
}

# get attributes of question
# return named vector
get_task_attributes <- function(file) {
    attrs <- c()
    for (line in file) {
        sep_line <- str_trim(str_split_1(line, ":"))
        item <- str_trim(sep_line[2])
        names(item) <- sep_line[1]
        attrs <- c(item, attrs)
    }
    return(attrs)
}

transform_to_html <- function(sec) {
    # write section in temp md file
    mdtempfile <- "_deleteme.md"
    writeLines(sec, mdtempfile)
    # read via pandoc
    # it writes result of transformation to temp html file
    htmltempfile <- "_deleteme.html"
    options <- c("-o", htmltempfile, "-f", "markdown", "-t", "html", "--mathml", "+RTS", "-M30m")
    # html <- as.list(HTML(rmarkdown::pandoc_convert(mdtempfile, options=options)))
    html <- rmarkdown::pandoc_convert(mdtempfile, options=options)
    # delete temp md file
    unlink(mdtempfile)
    # read html file
    sect <- as.list(readLines("_deleteme.html"))
    # delete temp html file
    unlink("_deleteme.html")
    # return lines of processed section
    return(sect)
}

read_table <- function(file, stringsAsFactors = FALSE, strip.white = TRUE, ...){
    if (length(file) > 1) {
        lines <- file
    } else if (grepl('\n', file)) {
        con <- textConnection(file)
        lines <- readLines(con)
        close(con)
    } else {
        lines <- readLines(file)
    }
    lines <- lines[!grepl('^[[:blank:]+-=:_|]*$', lines)]
    lines <- gsub('(^\\s*?\\|)|(\\|\\s*?$)', '', lines)
    read.delim(text = paste(lines, collapse = '\n'), sep = '|',
               stringsAsFactors = stringsAsFactors,
               strip.white = strip.white, ...)
}
