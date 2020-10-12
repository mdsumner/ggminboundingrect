create_mbr <- function(x, y) {
  if (length(x) < 2) return(data.frame(x = numeric(0), y = numeric(0)))
  a <- mbr::mbr(cbind(x, y))
  data.frame(x = a[,1, drop = TRUE], y = a[,2, drop = TRUE])
}

#' @importFrom ggplot2 ggproto Stat
StatMBR <- ggplot2::ggproto("StatMBR", ggplot2::Stat,

                   setup_params = function(data, params) {
                     if (is.null(data$colour)) data$colour <- "black"
                     if (is.null(data$size)) data$size <- 0.5
                     if (is.null(data$linetype)) data$linetype <- 1
                     if (is.null(data$alpha)) data$alpha <- NA_integer_
                     if (is.null(data$na.rm)) data$na.rm <- FALSE
                     data
                   },

                   compute_group = function(data, scales) {
                     cols_to_keep <- setdiff(names(data), c("x", "y"))
                     create_mbr(data$x, data$y)
                   },
                   required_aes = c("x", "y")
)

#' Bounding rectangle of points
#'
#' Use `geom_mbr()` to calculate and display the minimum bounding rectangle of
#' points. This rectangle includes all of the input points with some on its boundary
#' that coincide with points on the convex hull. These functions are intended for
#' Cartesian coordinates for producing rectangles in the coordinate system.
#' @importFrom ggplot2 layer GeomPath Stat
#' @inheritParams ggplot2::geom_point
#' @inheritParams ggplot2::geom_path
#' @export
#' @examples
#' set.seed(2)
#' library(ggplot2)
#' ggplot(subset(quakes, mag >= 5.6), ggplot2::aes(long, stations, group = mag)) + geom_mbr() + coord_equal()
geom_mbr <- function(mapping = NULL, data = NULL, stat= "MBR",
                     position = "identity", ...,
                     show.legend = NA, inherit.aes = TRUE, na.rm = FALSE) {
  layer(data = data,
        mapping = mapping,
        stat = stat,
        geom = GeomPath,
        position = position,
        show.legend = show.legend,
        inherit.aes = inherit.aes,
        params = list(na.rm = na.rm, ...))
}

#' @name geom_mbr
#' @export
stat_mbr <- function(mapping = NULL, data = NULL, geom= "path",
                     position = "identity", ...,
                     show.legend = NA, inherit.aes = TRUE, na.rm = FALSE) {
  layer(data = data,
        mapping = mapping,
        stat = StatMBR,
        geom = geom,
        position = position,
        show.legend = show.legend,
        inherit.aes = inherit.aes,
        params = list(na.rm = na.rm, ...))
}


