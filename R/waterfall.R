#' Waterfall
#'
#' Creates a waterfall table showing the source(s) of change in sales for one period,
#' relative to the previous period.
#' @param x A RevenueGrowthAccounting object.
#' @param periods A vector of \code{character} indicating the period(s) to plot
#' (relative to the previous period). If NULL, the total, aggregated across all periods, is shown.
#' @importFrom flipFormat FormatAsPercent
#' @export
Waterfall <- function(x, periods = NULL)
{
    all.periods <- names(x$Revenue)
    if (is.null(periods))
        periods <- all.periods[-1]
    # Summing up the sales by category
    y <- colSums(x$Table[periods, ])
    y <- y[c(1:3, 5:4)] # Reordering categories
    # Computing the base.
    lookup <- match(periods, all.periods) - 1
    if (!all(lookup %in% 1:length(all.periods)))
        stop("Invalid 'periods': 'periods' must match the labels in the data of 'x' and
             must not include the first period.'")
    base.periods <- all.periods[lookup ]
    base <- sum(x$Revenue[base.periods])
    # Growth as a percentage of the base
    y <- y / base
    # Result
    title = paste0("Revenue waterfall: ", base.periods[1], " to ", periods[length(periods)])
    result <- list(title = title, change = y, cumulative = cumsum(y))
    class(result) <- c("Waterfall", class(result))
    result
}


#' plot.Waterfall
#'
#' Creates a waterfall chart showing the source(s) of change in sales for one period, relative to the previous period.
#' @param x An object of class \code{Waterfall}.
#' @param ... Additional parameters.
#' @importFrom plotly plot_ly add_trace layout
#' @importFrom flipFormat FormatAsPercent
#' @export
plot.Waterfall <- function(x, ...)
{
    y <- x$change
    categories <- names(y)
    # Formatting labels
    y.text <- FormatAsPercent(y, 3)
    y.text <- ifelse(y > 0, paste0("+", y.text), y.text)
    # Creating series for the plot
    y <- y * 100
    bs <- c(y[1], sum(y[1:2]), sum(y[1:2]), sum(y[1:3]), sum(y[1:4]))
    y.cum <- cumsum(y)
    y.cum.text <- FormatAsPercent(y.cum / 100, 3)
    # Adding text to show values
    label.offsets <- (y.cum[length(y.cum)] - min(y.cum)) / 30
    annotation.y <- c(y[1], y[1] + y[2],  bs[-1:-2] + y[-1:-2] )
    annotation.y.with.offset <- annotation.y + c(-1, -1, 1, 1, 1) * label.offsets# <- c(y[1] - 2, y[1] + y[2] - 2, bs[-1:-2] + y[-1:-2] + 2)
    a <- list()
    for (i in 1:length(y))
    {
        a[[i]] <- list(
            x = categories[i],
            y = annotation.y.with.offset[i],
            text = y.cum.text[i],
            textposition = "bottom middle",
            showarrow = FALSE
        )
    }
    # Differences.
    middle.of.bar <- c(y[1] / 2, y[1] + y[2] / 2, (bs[-1:-2] + annotation.y[-1:-2]) / 2)
    small.bar <- abs(y) < 4
    middle.of.bar <- ifelse(small.bar, bs - label.offsets, middle.of.bar) # Correcting for situations where the columns are small.
    for (i in 1:length(y))
    {
        a[[i + 5]] <- list(
            x = categories[i],
            y = middle.of.bar[i],
            text = y.text[i],
            textposition = "top middle",
            font = list(color = if(small.bar[i]) NULL else "white"),
            showarrow = FALSE
        )
    }
    # Creating the plot.
    p <- plot_ly(
        x = categories,
        y = bs,
        marker = list(color = "white"),
        hoverinfo='none',
        type = "bar")
    temp.y <- abs(y)
    colors <- c("red", "orange", "teal", "turquoise", "blue")
    for (i in 1:5)
        p <- add_trace(evaluate = TRUE,
            p,
            x = categories[i],
            y = temp.y[i],
            name = categories[i],
            marker = list(color = colors[i]),
            type = "bar")
    layout(p, barmode = "stack", showlegend = FALSE, annotations = a,
           title = x$title,
           xaxis = list(title = "", zeroline = FALSE, showticklabels = TRUE, showgrid = FALSE),
           yaxis = list(title = "Revenue change", zeroline = TRUE, showticklabels = FALSE, showgrid = FALSE))
}



