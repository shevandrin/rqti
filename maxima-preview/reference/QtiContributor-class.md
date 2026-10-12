# Class QtiContributor

This class stores metadata information about contributors.

## Slots

- `name`:

  A character string representing the name of the author. By default it
  takes value from environment variable 'RQTI_AUTHOR'.

- `role`:

  A character string kind of contribution. Possible values: author,
  publisher, unknown, initiator, terminator, validator, editor,
  graphical designer, technical implementer, content provider, technical
  validator, educational validator, script writer, instructional
  designer, subject matter expert. Default is "author".

- `contribution_date`:

  A character string representing date of the contribution. Default is
  the current system date.
