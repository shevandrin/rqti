# Create data frame with test results

The function `extract_results()` takes Opal zip archive "Export results"
or xml file and creates two kinds of data frames (according to parameter
'level'), see the 'Details' section.

## Usage

``` r
extract_results(file, level = "task", hide_filename = TRUE)
```

## Arguments

- file:

  A string with a path of the xml test result file.

- level:

  A string with two possible values: task and item.

- hide_filename:

  A boolean value, TRUE to hide original file names by default.

## Value

A dataframe with attribues of the candidates outcomes and result
variables.

## Note

1.With option level = "task" data frame consists of columns:

- 'file' - name of the xml file with test results (to identify
  candidate)

- 'date' - date and time of test

- 'id_question' - question item identifier

- 'duration' - time in sec. what candidate spent on this item

- 'score_candidate' - points that were given to candidate after
  evaluation

- 'score_max' - max possible score for this question

- 'is_answer_given' - TRUE if candidate gave the answer on question,
  otherwise FALSE

- 'title' - the values of attribute 'title' of assessment items

2.With option level = "item" data frame consists of columns:

- 'file' - name of the xml file with test results (to identify
  candidate)

- 'date' - date and time of test

- 'id_question' - question item identifier

- 'base_type' - type of answer (identifier, string or float)

- 'cardinalities' - defines whether this question is single, multiple or
  ordered -value

- 'qti_type' - specifies the type of the task

- 'id_answer' - identifier of each response variable

- 'expected_response' - values that considered as right responses for
  question

- 'candidate_response' - values that were given by candidate

- 'score_candidate' - - points that were given to candidate after
  evaluation

- 'score_max' - max possible score for this question item

- 'is_response_correct' - TRUE if candidate gave the right response,
  otherwise FALSE

- 'title' - the values of attribute 'title' of assessment items

## Examples

``` r
file <- system.file("test_results.zip", package='rqti')
df <- extract_results(file, level = "item")
#> 100 - files with result
#> 0 - test file(s)
#> 0 - manifest file
#> 0 - files with assessment items
#> Warning: No task files found in archive.
#> The 'title' column will be skipped in the final dataframe
```
