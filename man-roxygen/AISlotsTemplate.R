#' @slot identifier A character representing the unique identifier of the
#'   assessment task. By default, it is generated as 'id_task_dddd', where dddd
#'   represents random digits.
#' @slot title A character representing the title of the XML file associated
#'   with the task. By default, it takes the value of the identifier.
#' @slot content A list of character content to form the text of the question,
#'   which can include HTML tags. For tasks of the [Entry] type, it must also
#'   contain at least one instance of Gap objects, such as [TextGap-class],
#'   [TextGapOpal], [NumericGap], or [InlineChoice].
#' @slot prompt An optional character representing a simple question text,
#'   consisting of one paragraph. This can supplement or replace content in the
#'   task. Default is "".
#' @slot points A numeric value, optional, representing the number of points for
#'   the entire task. Default is 1, but pay attention:
#'   * For tasks of the [Entry] type, it is
#'   calculated as the sum of the gap points by default.
#'   * For tasks of the [DirectedPair], the default is calculated as 0.5 points
#'  per pair.
#'   * For tasks of the [MatchTable] type, it can also be calculated as the sum
#'   of points for individual answers, when provided.
#'   * For tasks of the [MultipleChoice] type, points is numeric vector and
#'   required. Each number in this vector determines the number of points that
#'   will be awarded to a candidate if they select the corresponding answer. The
#'    order of the scores must match the order of the `choices`. It is possible
#'    to assign negative values to incorrect answers. All answers with a
#'    positive score are considered correct.
#' @slot feedback A list containing feedback messages for candidates. Each
#'   element of the list should be an instance of either [ModalFeedback],
#'   [CorrectFeedback], or [WrongFeedback] class.
#' @slot calculator A character, optional, determining whether to show a
#'   calculator to the candidate. Possible values:
#'   * "simple"
#'   * "scientific"
#' @slot files A character vector, optional, containing paths to files that will
#'   be accessible to the candidate during the test/exam.
#' @slot metadata An object of class [QtiMetadata] that holds metadata information
#' about the task.
