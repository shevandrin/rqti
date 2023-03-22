#' @slot identifier string; section identifier
#' @slot title string; title of the section
#' @slot time_limits numeric, optional;  controls the amount of time a candidate
#'   is allowed for this part of the test
#' @slot visible boolean, optional; if TRUE it shows this section in hierarchy
#'   of test structure; default `TRUE`
#' @slot assessment_item list; list of [AssessmentSection-class] and/or
#'   Assessemt item objects: [SingleChoice], [MultipleChoice], [Essay], [Entry],
#'   [Order], [OneInRowTable], [OneInColTable], [MultipleChoiceTable],
#'   [DirectedPair]
#' @slot shuffle boolean, optional; is responsible to randomize the order in
#'   which the assessment items and subsections are initially presented to the
#'   candidate; default `FALSE`
#' @slot selection numeric, optional; defines how many children of the section
#'   are delivered in test
#' @slot max_attempts numeric. optional; enables the maximum number of attempts,
#'   that candidate is allowed to pass in this section
#' @slot allow_comment boolean, optional; enables to allow candidate to leave
#'   comments in each question of the section
#'
