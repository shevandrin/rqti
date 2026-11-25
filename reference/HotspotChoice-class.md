# Class "HotspotChoice"

Class `HotspotChoice` creates a hotspot task according to QTI 2.1:
candidates select one or several areas (hotspots) in an image, e.g.
regions of a Venn diagram. Scoring works as in
[MultipleChoice](https://shevandrin.github.io/rqti/reference/MultipleChoice-class.md):
each hotspot has points, hotspots with positive points are correct.

## Details

ONYX (OPAL, version 2026.11) renders the image on the server and marks a
selected hotspot by a translucent white overlay and a thin blue outline.
On a white image the selection is hardly visible, so use a medium or
dark background color for the areas; selected areas then appear clearly
lighter. Hotspots must not overlap: an area that surrounds others, like
the outside of a Venn diagram, can be drawn as one polygon with a slit
to the inner boundary (a keyhole shape).

## Slots

- `identifier`:

  A character representing the unique identifier of the assessment task.
  By default, it is generated as 'id_task_dddd', where dddd represents
  random digits.

- `title`:

  A character representing the title of the XML file associated with the
  task. By default, it takes the value of the identifier.

- `content`:

  A list of character content to form the text of the question, which
  can include HTML tags and
  [TemplateVariableRef](https://shevandrin.github.io/rqti/reference/TemplateVariableRef-class.md)
  objects for displaying declared template variables. For tasks of the
  [Entry](https://shevandrin.github.io/rqti/reference/Entry-class.md)
  type, it must also contain at least one instance of Gap objects, such
  as
  [TextGap](https://shevandrin.github.io/rqti/reference/TextGap-class.md),
  [TextGapOpal](https://shevandrin.github.io/rqti/reference/TextGapOpal-class.md),
  [NumericGap](https://shevandrin.github.io/rqti/reference/NumericGap-class.md),
  or
  [InlineChoice](https://shevandrin.github.io/rqti/reference/InlineChoice-class.md).

- `prompt`:

  An optional character representing a simple question text, consisting
  of one paragraph. This can supplement or replace content in the task.
  Default is "".

- `points`:

  A numeric value, optional, representing the number of points for the
  entire task. Default is 1, but pay attention:

  - For tasks of the
    [Entry](https://shevandrin.github.io/rqti/reference/Entry-class.md)
    type, it is calculated as the sum of the gap points by default.

  - For tasks of the
    [DirectedPair](https://shevandrin.github.io/rqti/reference/DirectedPair-class.md),
    the default is calculated as 0.5 points per pair.

  - For tasks of the
    [MatchTable](https://shevandrin.github.io/rqti/reference/MatchTable-class.md)
    type, it can also be calculated as the sum of points for individual
    answers, when provided.

  - For tasks of the
    [MultipleChoice](https://shevandrin.github.io/rqti/reference/MultipleChoice-class.md)
    type, points is numeric vector and required. Each number in this
    vector determines the number of points that will be awarded to a
    candidate if they select the corresponding answer. The order of the
    scores must match the order of the `choices`. It is possible to
    assign negative values to incorrect answers. All answers with a
    positive score are considered correct.

- `feedback`:

  A list containing feedback messages for candidates. Each element of
  the list should be an instance of either
  [ModalFeedback](https://shevandrin.github.io/rqti/reference/ModalFeedback-class.md),
  [CorrectFeedback](https://shevandrin.github.io/rqti/reference/CorrectFeedback-class.md),
  or
  [WrongFeedback](https://shevandrin.github.io/rqti/reference/WrongFeedback-class.md)
  class.

- `calculator`:

  A character, optional, determining whether to show a calculator to the
  candidate. Possible values:

  - "simple"

  - "scientific"

- `files`:

  A character vector, optional, containing paths to files that will be
  accessible to the candidate during the test/exam.

- `metadata`:

  An object of class
  [QtiMetadata](https://shevandrin.github.io/rqti/reference/QtiMetadata-class.md)
  that holds metadata information about the task.

- `stylesheet_path`:

  Optional character vector of local CSS file paths. Stylesheets are
  linked from the item and included in QTI exports. In Rmd YAML,
  relative paths are resolved against the Rmd file's directory.

- `css`:

  Optional single character string of CSS text, linked after any files
  in `stylesheet_path`. In Rmd YAML, use a literal block (`css: |`). CSS
  assets referenced by
  [`url()`](https://rdrr.io/r/base/connections.html) or `@import` are
  not bundled automatically.

- `template`:

  A list of
  [MaximaVariables](https://shevandrin.github.io/rqti/reference/MaximaVariables-class.md)
  objects describing template calculations. Defaults to an empty list.
  Blocks generate template declarations and processing in list order.
  Rmd parsing is not yet supported.

- `choices`:

  A character vector defining a set of answer options in the question.

- `choice_identifiers`:

  A character vector, optional, containing a set of identifiers for
  answers. By default, identifiers are generated automatically according
  to the template "ChoiceD", where D is a letter representing the
  alphabetical order of the answer in the list.

- `response_identifier`:

  QTI response identifier. Default `"RESPONSE"`.

- `shuffle`:

  A boolean value indicating whether to randomize the order in which the
  choices are initially presented to the candidate. Default is `TRUE`.

- `orientation`:

  A character, determining whether to place answers in vertical or
  horizontal mode. Possible values:

  - "vertical" - Default.

  - "horizontal"

- `scoring_scheme`:

  A method name or named list from
  [`multiple_choice_scoring()`](https://shevandrin.github.io/rqti/reference/multiple_choice_scoring.md).

- `image`:

  A character, path to the image (PNG, JPEG, GIF or SVG) or a data URI.
  The image is embedded into the item as a data URI.

- `image_width,image_height`:

  Numeric, width and height of the image in pixels. The coordinates of
  the hotspots refer to this size.

- `image_alt`:

  A character, text alternative of the image.

- `shapes`:

  A character vector, the shape of each hotspot: "circle", "rect",
  "poly" or "ellipse".

- `coords`:

  A character vector, the coordinates of each hotspot in pixels as in
  HTML image maps: "x,y,r" for circles, "left,top,right,bottom" for
  rectangles, "x1,y1,x2,y2,..." for polygons, "x,y,rx,ry" for ellipses.

- `max_choices`:

  A numeric, the maximum number of hotspots a candidate can select; 0
  (default) means no limit.
