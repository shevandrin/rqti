# Class "ModalFeedback"

Class `ModalFeedback` is responsible for delivering feedback messages to
the candidate, regardless of whether the answer was correct or
incorrect.

## Slots

- `outcome_identifier`:

  A character representing the unique identifier of the outcome
  declaration variable that relates to feedback. Default is
  "FEEDBACKMODAL".

- `show`:

  A boolean value, optional, determining whether to show (`TRUE`) or
  hide (`FALSE`) the modal feedback. Default is `TRUE`.

- `title`:

  A character value, optional, representing the title of the modal
  feedback window.

- `content`:

  A list of character content to form the text of the modal feedback,
  which can include HTML tags.

- `identifier`:

  A character value representing the identifier of the modal feedback
  item. Default is "modal_feedback".

## Examples

``` r
fb <- new("ModalFeedback",
          title = "Possible solution",
          content = list("<b>Some explanation</b>"))
```
