#' Class "HotspotChoice"
#'
#' Class `HotspotChoice` creates a hotspot task according to QTI 2.1:
#' candidates select one or several areas (hotspots) in an image, e.g.
#' regions of a Venn diagram. Scoring works as in [MultipleChoice-class]: each
#' hotspot has points, hotspots with positive points are correct.
#' @template AISlotsTemplate
#' @template ChoiceSlotsTemplate
#' @slot scoring_scheme A method name or named list from
#'   [multiple_choice_scoring()].
#' @slot image A character, path to the image (PNG, JPEG, GIF or SVG) or a
#'   data URI. The image is embedded into the item as a data URI.
#' @slot image_width,image_height Numeric, width and height of the image in
#'   pixels. The coordinates of the hotspots refer to this size.
#' @slot image_alt A character, text alternative of the image.
#' @slot shapes A character vector, the shape of each hotspot: "circle",
#'   "rect", "poly" or "ellipse".
#' @slot coords A character vector, the coordinates of each hotspot in pixels
#'   as in HTML image maps: "x,y,r" for circles, "left,top,right,bottom" for
#'   rectangles, "x1,y1,x2,y2,..." for polygons, "x,y,rx,ry" for ellipses.
#' @slot max_choices A numeric, the maximum number of hotspots a candidate can
#'   select; 0 (default) means no limit.
#' @name HotspotChoice-class
#' @rdname HotspotChoice-class
#' @aliases HotspotChoice
#' @include AssessmentItem.R Choice.R MultipleChoice.R
#' @exportClass HotspotChoice
#' @import methods
setClass("HotspotChoice", contains = "MultipleChoice",
         slots = c(image = "character",
                   image_width = "numeric",
                   image_height = "numeric",
                   image_alt = "character",
                   shapes = "character",
                   coords = "character",
                   max_choices = "numeric"),
         prototype = prototype(shuffle = FALSE,
                               image_alt = "Abbildung",
                               max_choices = 0),
         validity = function(object) {
             n <- length(object@choices)
             if (length(object@shapes) != n || length(object@coords) != n) {
                 return("'shapes' and 'coords' need one entry per hotspot.")
             }
             shapes <- c("circle", "rect", "poly", "ellipse")
             if (!all(object@shapes %in% shapes)) {
                 return(paste0("'shapes' must be one of: ",
                               paste(shapes, collapse = ", "), "."))
             }
             numbers <- strsplit(object@coords, ",", fixed = TRUE)
             counts <- lengths(numbers)
             ok <- ifelse(object@shapes == "circle", counts == 3,
                   ifelse(object@shapes == "rect", counts == 4,
                   ifelse(object@shapes == "ellipse", counts == 4,
                          counts >= 6 & counts %% 2 == 0)))
             if (!all(ok) ||
                 anyNA(suppressWarnings(as.numeric(unlist(numbers))))) {
                 return("'coords' do not fit the shapes of the hotspots.")
             }
             if (length(object@image) != 1 || !nzchar(object@image)) {
                 return("'image' must be one path or data URI.")
             }
             if (!grepl("^data:", object@image) && !file.exists(object@image)) {
                 return(paste0("Image file does not exist: ", object@image))
             }
             TRUE
         })

#' Create object [HotspotChoice]
#'
#' @param image A character, path to the image (PNG, JPEG, GIF or SVG) or a
#'   data URI.
#' @param image_width,image_height Numeric, size of the image in pixels; the
#'   coordinates refer to this size.
#' @param shapes A character vector, the shape of each hotspot: "circle",
#'   "rect", "poly" or "ellipse".
#' @param coords A character vector, the coordinates of each hotspot in pixels,
#'   see [HotspotChoice-class].
#' @param choices A character vector, a label for each hotspot. The labels are
#'   not shown to candidates; they document the hotspots, e.g. for results.
#' @param image_alt A character, text alternative of the image.
#' @param max_choices A numeric, the maximum number of hotspots to select; 0
#'   (default) means no limit, 1 a single hotspot.
#' @inheritParams multipleChoice
#' @return An object of class [HotspotChoice]
#' @examples
#' img <- tempfile(fileext = ".png")
#' grDevices::png(img, width = 300, height = 200)
#' graphics::par(mar = c(0, 0, 0, 0))
#' graphics::plot.new()
#' graphics::rect(0.05, 0.1, 0.45, 0.9)
#' graphics::rect(0.55, 0.1, 0.95, 0.9)
#' grDevices::dev.off()
#' hotspotChoice(image = img, image_width = 300, image_height = 200,
#'               shapes = c("rect", "rect"),
#'               coords = c("15,20,135,180", "165,20,285,180"),
#'               choices = c("left", "right"), points = c(1, 0),
#'               content = "<p>Click on the left rectangle.</p>")
#' @export
hotspotChoice <- function(identifier = generate_id(),
                          title = identifier,
                          image,
                          image_width,
                          image_height,
                          shapes,
                          coords,
                          choices = paste("Hotspot", seq_along(shapes)),
                          choice_identifiers = paste0("Hotspot",
                                                      seq_along(shapes)),
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
                          template = list()) {
    params <- as.list(environment())
    obj <- construct_item(params, "HotspotChoice")
    return(obj)
}

#' @rdname createItemBody-methods
#' @aliases createItemBody,HotspotChoice
setMethod("createItemBody", signature(object = "HotspotChoice"),
          function(object) {
              tag("itemBody", list(Map(createText, object@content),
                                   make_hotspot_interaction(object)))
          })

make_hotspot_interaction <- function(object) {
    image <- tag("object", list(type = hotspot_image_type(object@image),
                                data = hotspot_image_data(object@image),
                                width = object@image_width,
                                height = object@image_height,
                                object@image_alt))
    hotspots <- Map(function(id, shape, coords) {
        tag("hotspotChoice", list(identifier = id, shape = shape,
                                  coords = gsub("\\s", "", coords)))
    }, object@choice_identifiers, object@shapes, object@coords)
    tag("hotspotInteraction",
        list(responseIdentifier = object@response_identifier,
             maxChoices = object@max_choices,
             tagList(create_prompt(object), image, unname(hotspots))))
}

hotspot_image_type <- function(image) {
    if (grepl("^data:", image)) return(sub("^data:([^;,]+).*", "\\1", image))
    switch(tolower(tools::file_ext(image)),
           "png" = "image/png",
           "jpg" = "image/jpeg",
           "jpeg" = "image/jpeg",
           "gif" = "image/gif",
           "svg" = "image/svg+xml",
           "application/octet-stream")
}

# Embed the image as a data URI, as rqti does for images in item texts
hotspot_image_data <- function(image) {
    if (grepl("^data:", image)) return(image)
    raw <- readBin(image, "raw", file.size(image))
    paste0("data:", hotspot_image_type(image), ";base64,", encode_base64(raw))
}
