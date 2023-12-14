#' @slot identifier string; identifier of assessment task
#' @slot title string; a title of xml file
#' @slot prompt string, optional; simple question text, consisting of one
#'   paragraph, can supplement or replace content
#' @slot qti_version string; QTI information model version; default 'v2p1
#' @slot feedback list of [ModalFeedback-class], [CorrectFeedback], or
#'   [WrongFeedback-class]; feedback messages for candidate
#' @slot files string, optional; the names of the attachment files that should
#' be available in the test
#' @slot calculator string, optional; determines to show to candidate calculator
#'  during the test;
#'   possible values:
#'   * "simple-calculator"
#'   * "scientific-calculator"
#'   * "" - by default
