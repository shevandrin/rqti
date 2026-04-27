function OrderedList(el)
  local attr = el.listAttributes

  el.listAttributes = pandoc.ListAttributes(
    attr.start,
    "DefaultStyle",
    attr.delimiter
  )

  return el
end
