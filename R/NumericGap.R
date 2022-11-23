# define class NumericGap to specify entries for numbers

setClass("NumericGap", contains = "Gap",
         slots = c(responses = "numeric"))
