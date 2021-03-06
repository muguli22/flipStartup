% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/growthaccounting.R
\name{RevenueGrowthAccounting}
\alias{RevenueGrowthAccounting}
\title{\code{RevenueGrowthAccounting}}
\usage{
RevenueGrowthAccounting(data, remove.last = TRUE, tol = 1)
}
\arguments{
\item{data}{A \code{data.frame} that has variables: \code{id}, \code{period},
and \code{value} (e.g., a \code{RevenueData} object).}

\item{remove.last}{Remove the final period (as usually is incomplete).}

\item{tol}{The tolerance used in calculations of differences. This defaults to 1 (e.g., $1).
Values or differences less than this amount are treated as being equivalent. E.g., if revenue for
an entity this period is less than \code{tol} higher than in the previous period, it is treated as being constant.}
}
\description{
Computes statistics for use in growth accounting of a startup.
}
\details{
Small differences in the percentages shown here versus those computed by other means may occur, due
to: (1) how churn is defined (e.g., the point at time when a customer churns, vs, takes a hieateous); (2) the precision
used to determine whether a subscriber is considered to have contracted/expanded or not.
}

