#' @slot identifier A character representing the unique identifier of the
#'   assessment section. By default, it is generated as 'id_section_dddd', where
#'   dddd represents random digits.
#' @slot title A character representing the title of the section in the test. By
#'   default, it takes the value of the identifier.
#' @slot time_limit A numeric value, optional, controlling the amount of time
#'   *in munutes* a candidate is allowed for this part of the test.
#' @slot visible A boolean value, optional. If TRUE, it shows this section in
#'   the hierarchy of the test structure. Default is `TRUE`.
#' @slot assessment_item A list containing [AssessmentSection] and/or Assessment
#'   item objects, such as [SingleChoice], [MultipleChoice], [Essay], [Entry],
#'   [Ordering], [OneInRowTable], [OneInColTable], [MultipleChoiceTable], and
#'   [DirectedPair].
#' @slot shuffle A boolean value, optional, responsible for randomizing the
#'   order in which the assessment items and subsections are initially presented
#'   to the candidate. Default is `FALSE`.
#' @slot selection A numeric value, optional, defining how many children of the
#'   section are delivered in the test.
#' @slot max_attempts A numeric value, optional, enabling the maximum number of
#'   attempts a candidate is allowed to pass in this section.
#' @slot allow_comment A boolean value, optional, enabling to allow the
#'   candidate to leave comments in each question of the section. Defautl is
#'   `TRUE`.
