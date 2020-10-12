create_mbr <- function(x, y) {
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

#' Title
#'
#' @param mapping
#' @param data
#' @param stat
#' @param position
#' @param ...
#' @param show.legend
#' @param inherit.aes
#' @param na.rm
#'
#' @return
#' @export
#'
#' @examples
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

#' Title
#'
#' @param mapping
#' @param data
#' @param geom
#' @param position
#' @param ...
#' @param show.legend
#' @param inherit.aes
#' @param na.rm
#'
#' @return
#' @export
#'
#' @examples
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


