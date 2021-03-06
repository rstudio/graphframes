% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/gf_lpa.R
\name{gf_lpa}
\alias{gf_lpa}
\title{Label propagation algorithm (LPA)}
\usage{
gf_lpa(x, max_iter, ...)
}
\arguments{
\item{x}{An object coercable to a GraphFrame (typically, a
\code{gf_graphframe}).}

\item{max_iter}{Maximum number of iterations.}

\item{...}{Optional arguments, currently not used.}
}
\description{
Run static Label Propagation for detecting communities in networks. Each node in the
  network is initially assigned to its own community. At every iteration, nodes send
  their community affiliation to all neighbors and update their state to the mode
  community affiliation of incoming messages. LPA is a standard community detection
   algorithm for graphs. It is very inexpensive
  computationally, although (1) convergence is not guaranteed and (2) one can
  end up with trivial solutions (all nodes are identified into a single community).
}
\examples{
\dontrun{
g <- gf_friends(sc)
gf_lpa(g, max_iter = 5)
}
}
