#' @slot cancel A logical value, optional, indicating whether participants are
#'   allowed to cancel an exam after starting it. Default is `FALSE`.
#' @slot suspend A logical value, optional, indicating whether participants are
#'   allowed to suspend an exam after starting it and continue later.
#'   Default is `FALSE`.
#' @slot scoreprogress A logical value, optional, indicating whether the
#'   progress of the score achieved so far should be displayed during the exam.
#'   Default is `FALSE`.
#' @slot questionprogress A logical value, optional, indicating whether the
#'   number of solved questions should be displayed during the exam.
#'   Default is `FALSE`.
#' @slot maxscoreitem A logical value, optional, indicating whether the maximum
#'   score of an item should be displayed. Default is `TRUE`.
#' @slot menu A logical value, optional, indicating whether the menu should be
#'   displayed during the exam. Default is `TRUE`.
#' @slot titles A logical value, optional, indicating whether question titles
#'   should be displayed during the exam. Default is `TRUE`.
#' @slot notes A logical value, optional, indicating whether participants can
#'   take notes in OpenOlat during the exam. Default is `FALSE`.
#' @slot hidelms A logical value, optional, indicating whether access to the
#'   OpenOlat learning management system should be hidden during the exam.
#'   Default is `TRUE`.
#' @slot hidefeedbacks A logical value, optional, indicating whether feedback
#'   should be hidden. Default is `FALSE`.
#' @slot blockaftersuccess A logical value, optional, indicating whether the
#'   exam should be blocked after successful completion. Default is `FALSE`.
#' @slot attempts An integer value, optional, indicating how many attempts are
#'   allowed for the exam as a whole. Default is `1`.
#' @slot anonym A logical value, optional, indicating whether anonymous users
#'   are allowed to take the exam. Default is `FALSE`.
#' @slot manualcorrect A logical value, optional, indicating whether points and
#'   pass/fail status should be evaluated manually. Default is `FALSE`.
#'
