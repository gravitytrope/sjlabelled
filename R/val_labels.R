#' @importFrom rlang enexprs
#' @importFrom purrr map_at
#' @rdname set_labels
#' @export
val_labels <- function(x, ..., force.labels = FALSE, force.values = TRUE, drop.na = TRUE) {
  # get dots
  .dots <- rlang::enexprs(...)
  lang <- unlist(lapply(rlang::enexprs(...), is.language))
  labels <- purrr::map_at(.dots, which(lang), eval)

  # select variables
  vars <- names(labels)

  # non-matching column names
  non.vars <- which(!(vars %in% colnames(x)))

  # check if all variables exist in data frame
  if (!isempty(non.vars)) {
    # tell user
    warning(sprintf(
      "Following elements are no valid column names in `x`: %s",
      paste(vars[non.vars], collapse = ",")
    ),
    call. = F)
    # remove invalid names
    vars <- vars[-non.vars]
    labels <- labels[-non.vars]
  }

  # set label for all variables
  for (i in seq_len(length(vars))) {
    x[[vars[i]]] <- set_labels_helper(
      x = x[[vars[i]]],
      labels = labels[[i]],
      force.labels = force.labels,
      force.values = force.values,
      drop.na = drop.na,
      var.name = vars[i]
    )
  }

  # return data
  x
}
