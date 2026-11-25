# Create object [HotspotChoice](https://shevandrin.github.io/rqti/reference/HotspotChoice-class.md)

Create object
[HotspotChoice](https://shevandrin.github.io/rqti/reference/HotspotChoice-class.md)

## Usage

``` r
hotspotChoice(
  identifier = generate_id(),
  title = identifier,
  image,
  image_width,
  image_height,
  shapes,
  coords,
  choices = paste("Hotspot", seq_along(shapes)),
  choice_identifiers = paste0("Hotspot", seq_along(shapes)),
  content = list(),
  prompt = "",
  points = 1,
  feedback = list(),
  image_alt = "Abbildung",
  max_choices = 0,
  calculator = NA_character_,
  files = NA_character_,
  scoring_scheme = "standard",
  response_identifier = "RESPONSE",
  template = list()
)
```

## Arguments

- identifier:

  A character representing the unique identifier of the assessment task.
  By default, it is generated as 'id_task_dddd', where dddd represents
  random digits.

- title:

  A character representing the title of the XML file associated with the
  task. By default, it takes the value of the identifier.

- image:

  A character, path to the image (PNG, JPEG, GIF or SVG) or a data URI.

- image_width, image_height:

  Numeric, size of the image in pixels; the coordinates refer to this
  size.

- shapes:

  A character vector, the shape of each hotspot: "circle", "rect",
  "poly" or "ellipse".

- coords:

  A character vector, the coordinates of each hotspot in pixels, see
  [HotspotChoice](https://shevandrin.github.io/rqti/reference/HotspotChoice-class.md).

- choices:

  A character vector, a label for each hotspot. The labels are not shown
  to candidates; they document the hotspots, e.g. for results.

- choice_identifiers:

  A character vector, optional, containing a set of identifiers for
  answers. By default, identifiers are generated automatically according
  to the template "ChoiceD", where D is a letter representing the
  alphabetical order of the answer in the list.

- content:

  A character string or a list of character strings to form the text of
  the question, which may include HTML tags.

- prompt:

  An optional character representing a simple question text, consisting
  of one paragraph. This can supplement or replace content in the task.
  Default is "".

- points:

  A numeric vector, required. Each number in this vector determines the
  number of points that will be awarded to a candidate if they select
  the corresponding answer. The order of the scores must match the order
  of the choices. It is possible to assign negative values to incorrect
  answers. All answers with a positive score are considered correct.

- feedback:

  A list containing feedback messages for candidates. Each element of
  the list should be an instance of either
  [ModalFeedback](https://shevandrin.github.io/rqti/reference/ModalFeedback-class.md),
  [CorrectFeedback](https://shevandrin.github.io/rqti/reference/CorrectFeedback-class.md),
  or
  [WrongFeedback](https://shevandrin.github.io/rqti/reference/WrongFeedback-class.md)
  class.

- image_alt:

  A character, text alternative of the image.

- max_choices:

  A numeric, the maximum number of hotspots to select; 0 (default) means
  no limit, 1 a single hotspot.

- calculator:

  A character, optional, determining whether to show a calculator to the
  candidate. Possible values:

  - "simple"

  - "scientific".

- files:

  A character vector, optional, containing paths to files that will be
  accessible to the candidate during the test/exam.

- scoring_scheme:

  A method name or specification from
  [`multiple_choice_scoring()`](https://shevandrin.github.io/rqti/reference/multiple_choice_scoring.md).
  The default `"standard"` retains the existing balanced mapping and
  zero floor.

- response_identifier:

  QTI response identifier. Default `"RESPONSE"`. Must be a valid
  identifier distinct from the item's score and feedback outcome
  identifiers.

- template:

  A list of
  [MaximaVariables](https://shevandrin.github.io/rqti/reference/MaximaVariables-class.md)
  objects, for example created with
  [`maxima_variables()`](https://shevandrin.github.io/rqti/reference/maxima_variables.md).
  Defaults to an empty list. Blocks run in list order when the exported
  item is delivered by a player supporting MAXIMA.

## Value

An object of class
[HotspotChoice](https://shevandrin.github.io/rqti/reference/HotspotChoice-class.md)

## Examples

``` r
img <- tempfile(fileext = ".png")
grDevices::png(img, width = 300, height = 200)
graphics::par(mar = c(0, 0, 0, 0))
graphics::plot.new()
graphics::rect(0.05, 0.1, 0.45, 0.9)
graphics::rect(0.55, 0.1, 0.95, 0.9)
grDevices::dev.off()
#> agg_record_1979533f6bba 
#>                       2 
hotspotChoice(image = img, image_width = 300, image_height = 200,
              shapes = c("rect", "rect"),
              coords = c("15,20,135,180", "165,20,285,180"),
              choices = c("left", "right"), points = c(1, 0),
              content = "<p>Click on the left rectangle.</p>")
#> An object of class "HotspotChoice"
#> Slot "image":
#> [1] "/tmp/RtmpMT4ixj/file19794792fead.png"
#> 
#> Slot "image_width":
#> [1] 300
#> 
#> Slot "image_height":
#> [1] 200
#> 
#> Slot "image_alt":
#> [1] "Abbildung"
#> 
#> Slot "shapes":
#> [1] "rect" "rect"
#> 
#> Slot "coords":
#> [1] "15,20,135,180"  "165,20,285,180"
#> 
#> Slot "max_choices":
#> [1] 0
#> 
#> Slot "scoring_scheme":
#> [1] "standard"
#> 
#> Slot "choices":
#> [1] "left"  "right"
#> 
#> Slot "choice_identifiers":
#> [1] "Hotspot1" "Hotspot2"
#> 
#> Slot "response_identifier":
#> [1] "RESPONSE"
#> 
#> Slot "shuffle":
#> [1] FALSE
#> 
#> Slot "orientation":
#> [1] "vertical"
#> 
#> Slot "identifier":
#> [1] "id_task_3856"
#> 
#> Slot "title":
#> [1] "id_task_3856"
#> 
#> Slot "content":
#> [[1]]
#> [1] "<p>Click on the left rectangle.</p>"
#> 
#> 
#> Slot "prompt":
#> [1] ""
#> 
#> Slot "points":
#> [1] 1 0
#> 
#> Slot "feedback":
#> list()
#> 
#> Slot "files":
#> [1] NA
#> 
#> Slot "stylesheet_path":
#> character(0)
#> 
#> Slot "css":
#> character(0)
#> 
#> Slot "calculator":
#> [1] NA
#> 
#> Slot "metadata":
#> An object of class "QtiMetadata"
#> Slot "contributor":
#> [[1]]
#> An object of class "QtiContributor"
#> Slot "name":
#> [1] ""
#> 
#> Slot "role":
#> [1] "author"
#> 
#> Slot "contribution_date":
#> Date of length 0
#> 
#> 
#> 
#> Slot "description":
#> [1] ""
#> 
#> Slot "rights":
#> [1] ""
#> 
#> Slot "version":
#> character(0)
#> 
#> 
#> Slot "template":
#> list()
#> 
```
