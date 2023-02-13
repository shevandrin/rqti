#
#' @importFrom commonmark markdown_html
#' @importFrom htmltools HTML p
#' @importFrom stringr str_extract_all str_sub
#' @import yaml

create_question_content <- function(file) {
    file <- readLines(file)
    attrs_sec <- get_task_section(file, "attributes")
    attrs <- get_task_attributes(attrs_sec)
    object <- switch(tolower(attrs["type"]),
                     "entry" = create_entry_object(file, attrs),
                     "singlechoice" =  create_sc_object(file, attrs)
                    )
}

create_text_gap_object <- function(params, id) {
    params <- str_sub(params, 9, -9)
    params <- try(yaml::yaml.load(params), silent = TRUE)
    if (is.null(params) | is.character(params) | is.numeric(params)) {
        new("TextGap", response_identifier = id,
            response = params,
            score = 1)
    } else {
        new("TextGap", response_identifier = id, score = 1,
            response = params$content$response,
            alternatives = params$content$alternatives,
            placeholder = params$content$placeholder,
            expected_length = params$content$length)
    }
}

create_sc_object <- function(file, attrs) {
    sect <- get_task_section(file, "question")
    html <- as.list(HTML(markdown_html(sect, hardbreaks = FALSE,
                                                 smart = TRUE)))
    choices <- get_task_section(file, "answers")
    object = new("SingleChoice", content = html,
                 identifier = unname(attrs["identifier"]),
                 title = unname(attrs["title"]),
                 points = as.numeric(attrs["points"]),
                 prompt = unname(attrs["prompt"]),
                 choices = choices
                 )
}

create_entry_object <- function(file, attrs) {
    file <- gsub("<<", "<entry>", file)
    file <- gsub(">>", "</entry>", file)
    html <- HTML(markdown_html(file, hardbreaks = FALSE,
                                          smart = TRUE))
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
            text_chank <- create_text_gap_object(text_chank, ids[i / 2])
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
    result <- result[sapply(result, nchar, USE.NAMES = FALSE) !=  0]
}

# get attributes of question
# return named vector
get_task_attributes <- function(file) {
    attrs <- c()
    for (line in file) {
        sep_line <- gsub(" ", "", (strsplit(line, ":"))[[1]])
        item <- sep_line[2]
        names(item) <- sep_line[1]
        attrs <- c(item, attrs)
    }
    return(attrs)
}
