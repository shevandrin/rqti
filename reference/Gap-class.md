# Class "Gap"

Abstract class `Gap` is not meant to be instantiated directly; instead,
it serves as a base for derived classes such as
[NumericGap](https://shevandrin.github.io/rqti/reference/NumericGap-class.md),
[TextGap](https://shevandrin.github.io/rqti/reference/TextGap-class.md),
[TextGapOpal](https://shevandrin.github.io/rqti/reference/TextGapOpal-class.md)
and
[InlineChoice](https://shevandrin.github.io/rqti/reference/InlineChoice-class.md).

## Slots

- `response_identifier`:

  A character value representing an identifier for the answer. By
  default, it is generated as 'id_gap_dddd', where dddd represents
  random digits.

- `points`:

  A numeric value, optional, representing the number of points for this
  gap. Default is `1`.

- `placeholder`:

  A character value, optional, responsible for placing helpful text in
  the text input field in the content delivery engine.

- `expected_length`:

  A numeric value, optional, responsible for setting the size of the
  text input field in the content delivery engine.

## See also

[NumericGap](https://shevandrin.github.io/rqti/reference/NumericGap-class.md),
[TextGap](https://shevandrin.github.io/rqti/reference/TextGap-class.md),
[TextGapOpal](https://shevandrin.github.io/rqti/reference/TextGapOpal-class.md)
and
[InlineChoice](https://shevandrin.github.io/rqti/reference/InlineChoice-class.md).
