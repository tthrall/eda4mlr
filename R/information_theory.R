# =============================================================================
# Information Theory Utilities
#
# Functions for computing entropy, mutual information, KL divergence, and
# related quantities. Supports Chapter 6 (Information Theory) of EDA for ML.
#
# Consolidates:
#   - f_divergence.R (f-divergence kernels for pedagogical visualization)
#   - New utilities for entropy, KL divergence, information gain
# =============================================================================


# -----------------------------------------------------------------------------
# Entropy
# -----------------------------------------------------------------------------

#' Calculate entropy of a discrete probability distribution
#'
#' Computes Shannon entropy for a finite probability distribution, measuring
#' the average uncertainty (in bits) about the outcome of a random variable.
#'
#' @param p Numeric vector of probabilities. Will be normalized to sum to 1
#'   if it does not already. Zero and negative values are removed before
#'   calculation.
#' @param base Numeric scalar: logarithm base. Default 2 gives entropy in
#'   bits; use \code{exp(1)} for nats, or 10 for hartleys.
#'
#' @return Numeric scalar: entropy value. Units depend on \code{base}:
#'   bits (base 2), nats (base e), or hartleys (base 10).
#'
#' @details
#' Shannon entropy is defined as:
#' \deqn{H(X) = -\sum_{i=1}^{K} p_i \log_b(p_i)}
#' where \eqn{p_i} is the probability of outcome \eqn{i} and \eqn{b} is the
#' logarithm base.
#'
#' Key properties:
#' \itemize{
#'   \item \eqn{H \geq 0} always (non-negative)
#'   \item \eqn{H = 0} if and only if one outcome has probability 1
#'         (complete certainty)
#'   \item \eqn{H} is maximized when all outcomes are equally likely
#'         (uniform distribution)
#'   \item For \eqn{K} equally likely outcomes: \eqn{H = \log_b(K)}
#' }
#'
#' The convention \eqn{0 \log(0) = 0} is used, consistent with the limit
#' \eqn{\lim_{p \to 0^+} p \log(p) = 0}.
#'
#' @section Interpretation:
#' Entropy can be understood as the average number of yes/no questions
#' needed to identify an outcome drawn from the distribution, assuming
#' an optimal questioning strategy.
#'
#' @seealso
#' \code{\link{estimate_entropy_from_sample}} for estimating entropy from data,
#' \code{\link{kl_divergence}} for comparing two distributions,
#' \code{\link{information_gain}} for decision tree splitting
#'
#' @references
#' Shannon, C. E. (1948). A Mathematical Theory of Communication.
#' \emph{Bell System Technical Journal}, 27(3), 379-423.
#'
#' @examples
#' # Fair coin: maximum entropy for 2 outcomes = 1 bit
#' entropy(c(0.5, 0.5))
#'
#' # Biased coin: lower entropy (more predictable)
#' entropy(c(0.9, 0.1))
#' entropy(c(0.99, 0.01))
#'
#' # Fair 6-sided die: log2(6) approx 2.58 bits
#' entropy(rep(1/6, 6))
#'
#' # Degenerate distribution: 0 bits (no uncertainty)
#' entropy(c(1, 0, 0, 0))
#'
#' # Unnormalized input is automatically normalized
#' entropy(c(1, 1, 1, 1))
#' # same as
#' entropy(c(0.25, 0.25, 0.25, 0.25))
#'
#' # Using natural log (nats) instead of bits
#' entropy(c(0.5, 0.5), base = exp(1))
#'
#' @export
entropy <- function(p, base = 2) {
  # Normalize if not already a proper distribution
  p <- p / sum(p)

  # Remove zero probabilities to avoid log(0)
  p <- p[p > 0]

  result <- -sum(p * log(p, base = base))

  return(result)
}


#' Estimate entropy from a sample
#'
#' Computes a plug-in (maximum likelihood) entropy estimate from observed
#' frequencies in a sample.
#'
#' @param sample Vector of observed values (any type that can be tabulated).
#' @param possible_outcomes Vector of all possible outcome values. If
#'   \code{NULL} (default), uses the unique values observed in \code{sample}.
#'   Specifying this parameter is important when some outcomes may have
#'   zero observations but are theoretically possible.
#' @param base Numeric scalar: logarithm base. Default 2 for bits.
#'
#' @return Numeric scalar: estimated entropy in bits (or other units if
#'   \code{base} is changed).
#'
#' @details
#' The plug-in estimator computes entropy from the empirical distribution:
#' \deqn{\hat{H} = -\sum_{i=1}^{K} \hat{p}_i \log_b(\hat{p}_i)}
#' where \eqn{\hat{p}_i = n_i / n} is the observed frequency of outcome \eqn{i}.
#'
#' @section Bias and sample size:
#' The plug-in estimator is negatively biased: it systematically
#' underestimates true entropy, especially when:
#' \itemize{
#'   \item Sample size \eqn{n} is small relative to the number of outcomes \eqn{K}
#'   \item The true distribution has many low-probability outcomes
#' }
#'
#' As a rule of thumb, reliable estimates require \eqn{n \gg K}. For small
#' samples, consider bias-corrected estimators (Miller-Madow, jackknife) or
#' Bayesian approaches, which are not implemented here.
#'
#' @section Specifying possible outcomes:
#' When \code{possible_outcomes} is \code{NULL}, only observed values
#' contribute to the estimate. This can inflate entropy estimates if the
#' true distribution includes outcomes that happen to be unobserved in the
#' sample. Specifying \code{possible_outcomes} explicitly ensures that
#' unobserved-but-possible outcomes contribute zero to the sum (via the
#' \eqn{0 \log(0) = 0} convention).
#'
#' @seealso
#' \code{\link{entropy}} for computing entropy from a known distribution
#'
#' @examples
#' # Estimate entropy of a fair die from 100 rolls
#' set.seed(42)
#' rolls <- sample(1:6, 100, replace = TRUE)
#' estimate_entropy_from_sample(rolls, possible_outcomes = 1:6)
#'
#' # Compare to true entropy
#' entropy(rep(1/6, 6))
#'
#' # Without specifying possible_outcomes (uses only observed values)
#' set.seed(99)
#' small_sample <- sample(1:6, 10, replace = TRUE)
#' estimate_entropy_from_sample(small_sample)
#'
#' @export
estimate_entropy_from_sample <- function(sample, possible_outcomes = NULL,
                                         base = 2) {
  if (is.null(possible_outcomes)) {
    possible_outcomes <- unique(sample)
  }

  counts <- table(factor(sample, levels = possible_outcomes))
  probs <- as.numeric(counts) / length(sample)

  result <- entropy(probs, base = base)

  return(result)
}


# -----------------------------------------------------------------------------
# KL Divergence
# -----------------------------------------------------------------------------

#' Calculate KL divergence between two distributions
#'
#' Computes Kullback-Leibler divergence \eqn{D_{KL}(P \| Q)}, measuring the
#' expected number of extra bits needed when using a code optimized for
#' distribution \eqn{Q} but the true distribution is \eqn{P}.
#'
#' @param p Numeric vector: reference (true) distribution. Can be a named
#'   vector for alignment with \code{q}.
#' @param q Numeric vector: alternative (model/assumed) distribution. Can be
#'   a named vector.
#' @param base Numeric scalar: logarithm base. Default 2 for bits.
#'
#' @return Numeric scalar: KL divergence value. Returns \code{Inf} if
#'   \code{q} assigns zero probability to any outcome where \code{p} is
#'   positive (the distributions have incompatible support).
#'
#' @details
#' KL divergence is defined as:
#' \deqn{D_{KL}(P \| Q) = \sum_{x: P(x) > 0} P(x) \log_b\left(\frac{P(x)}{Q(x)}\right)}
#'
#' Key properties:
#' \itemize{
#'   \item \eqn{D_{KL}(P \| Q) \geq 0} always (Gibbs inequality)
#'   \item \eqn{D_{KL}(P \| Q) = 0} if and only if \eqn{P = Q}
#'   \item Not symmetric: \eqn{D_{KL}(P \| Q) \neq D_{KL}(Q \| P)} in general
#'   \item Not a metric: does not satisfy the triangle inequality
#' }
#'
#' @section Interpretation:
#' KL divergence quantifies the cost of being wrong about a distribution.
#' If you design a coding scheme assuming distribution \eqn{Q}, but the true
#' distribution is \eqn{P}, you will use \eqn{D_{KL}(P \| Q)} extra bits per
#' symbol on average.
#'
#' @section Asymmetry:
#' The asymmetry of KL divergence has important practical implications:
#' \itemize{
#'   \item \eqn{D_{KL}(P \| Q)}: cost of using \eqn{Q} when truth is \eqn{P}
#'   \item \eqn{D_{KL}(Q \| P)}: cost of using \eqn{P} when truth is \eqn{Q}
#' }
#' These can differ substantially. In variational inference, minimizing
#' \eqn{D_{KL}(Q \| P)} (reverse KL) yields mode-seeking behavior, while
#' minimizing \eqn{D_{KL}(P \| Q)} (forward KL) yields mean-seeking behavior.
#'
#' @section Named vectors:
#' If both \code{p} and \code{q} are named vectors, alignment is performed
#' by name (only shared names are used). If unnamed, positional alignment
#' is assumed and lengths must match.
#'
#' @seealso
#' \code{\link{entropy}} for single-distribution uncertainty,
#' \code{\link{fdiv_kernel_list}} for other f-divergences
#'
#' @references
#' Kullback, S., and Leibler, R. A. (1951). On Information and Sufficiency.
#' Annals of Mathematical Statistics, 22(1), 79-86.
#'
#' @examples
#' # Identical distributions: KL = 0
#' p <- c(0.5, 0.5)
#' kl_divergence(p, p)
#'
#' # Uniform vs. biased: asymmetric!
#' q <- c(0.9, 0.1)
#' kl_divergence(p, q)
#' kl_divergence(q, p)
#'
#' # Named vectors with automatic alignment
#' p_named <- c(A = 0.5, B = 0.3, C = 0.2)
#' q_named <- c(B = 0.4, C = 0.3, A = 0.3)
#' kl_divergence(p_named, q_named)
#'
#' # Infinite divergence when supports do not match
#' p_sparse <- c(0.5, 0.5, 0)
#' q_sparse <- c(0.33, 0.33, 0.34)
#' kl_divergence(q_sparse, p_sparse)
#'
#' @export
kl_divergence <- function(p, q, base = 2) {
  # Align by names if both are named
  if (!is.null(names(p)) && !is.null(names(q))) {
    shared_names <- intersect(names(p), names(q))
    if (length(shared_names) == 0) {
      stop("No shared names between p and q")
    }
    p <- p[shared_names]
    q <- q[shared_names]
  }

  # Check lengths match
  if (length(p) != length(q)) {
    stop("p and q must have the same length")
  }

  # Normalize
  p <- p / sum(p)
  q <- q / sum(q)

  # Only sum over outcomes where P > 0
  mask <- p > 0

  # Check for zero Q where P is positive (infinite divergence)
  if (any(q[mask] == 0)) {
    return(Inf)
  }

  result <- sum(p[mask] * log(p[mask] / q[mask], base = base))

  return(result)
}


# -----------------------------------------------------------------------------
# Information Gain
# -----------------------------------------------------------------------------

#' Calculate information gain from a feature split
#'
#' Computes the reduction in entropy achieved by partitioning data on a
#' categorical feature. This is the criterion used by ID3 and C4.5 decision
#' tree algorithms to select splitting features.
#'
#' @param data Data frame containing the target and feature variables.
#' @param target Character string: name of the target variable (column in
#'   \code{data}). Typically a factor or character column.
#' @param feature Character string: name of the feature to evaluate for
#'   splitting (column in \code{data}).
#' @param base Numeric scalar: logarithm base. Default 2 for bits.
#'
#' @return Numeric scalar: information gain in bits (or other units). Higher
#'   values indicate more informative splits.
#'
#' @details
#' Information gain is defined as:
#' \deqn{IG(T, F) = H(T) - H(T | F) = H(T) - \sum_{v \in F} \frac{|T_v|}{|T|} H(T_v)}
#' where:
#' \itemize{
#'   \item \eqn{H(T)} is the entropy of the target variable
#'   \item \eqn{T_v} is the subset of data where feature \eqn{F} has value \eqn{v}
#'   \item \eqn{H(T_v)} is the entropy of the target within subset \eqn{T_v}
#' }
#'
#' @section Interpretation:
#' Information gain measures how much knowing the feature value reduces
#' uncertainty about the target. A split with high information gain
#' creates child nodes that are more pure (lower entropy) than the parent.
#'
#' @section Limitations:
#' Information gain is biased toward features with many distinct values.
#' A feature like customer_id (unique per row) achieves perfect
#' information gain but has no predictive value for new data. Decision
#' tree implementations often use gain ratio (information gain
#' divided by the features intrinsic entropy) to correct for this bias.
#'
#' @seealso
#' \code{\link{entropy}} for the underlying entropy calculation
#'
#' @references
#' Quinlan, J. R. (1986). Induction of Decision Trees.
#' Machine Learning, 1(1), 81-106.
#'
#' @examples
#' # Simple example: contract type predicts churn
#' churn_data <- data.frame(
#'   contract = c(rep("monthly", 10), rep("annual", 10)),
#'   churned = c(rep("yes", 8), rep("no", 2), rep("yes", 2), rep("no", 8))
#' )
#' information_gain(churn_data, "churned", "contract")
#'
#' # Pathological case: unique ID achieves maximum IG but overfits
#' churn_data$customer_id <- seq_len(nrow(churn_data))
#' information_gain(churn_data, "churned", "customer_id")
#'
#' @export
information_gain <- function(data, target, feature, base = 2) {
  # Parent entropy
  parent_counts <- table(data[[target]])
  parent_probs <- as.numeric(parent_counts) / nrow(data)
  H_parent <- entropy(parent_probs, base = base)

  # Weighted child entropy
  feature_values <- unique(data[[feature]])
  H_children <- 0

  for (val in feature_values) {
    subset_rows <- data[[feature]] == val
    subset_data <- data[subset_rows, , drop = FALSE]
    weight <- nrow(subset_data) / nrow(data)

    child_counts <- table(subset_data[[target]])
    child_probs <- as.numeric(child_counts) / nrow(subset_data)
    H_children <- H_children + weight * entropy(child_probs, base = base)
  }

  result <- H_parent - H_children

  return(result)
}


# -----------------------------------------------------------------------------
# f-Divergence Kernels (for pedagogical visualization)
# -----------------------------------------------------------------------------

#' Generate list of f-divergence kernel functions
#'
#' Returns a named list of f-divergence kernel functions, each taking a
#' density ratio \eqn{t = p(x)/q(x)} as input. Useful for visualizing and
#' comparing how different divergence measures behave.
#'
#' @return Named list of functions, each accepting a numeric vector \code{t}
#'   and returning the kernel value. Elements:
#'   \describe{
#'     \item{KL}{Kullback-Leibler: \eqn{f(t) = t \log(t)}}
#'     \item{exp}{Exponential divergence: \eqn{f(t) = t (\log t)^2}}
#'     \item{chi_sq}{Pearson chi-squared: \eqn{f(t) = (t-1)^2}}
#'     \item{Hellinger}{Squared Hellinger: \eqn{f(t) = (\sqrt{t}-1)^2}}
#'     \item{Jeffreys}{Jeffreys (symmetric KL): \eqn{f(t) = (t-1) \log(t)}}
#'     \item{total_var}{Total variation: \eqn{f(t) = |t-1|/2}}
#'   }
#'
#' @details
#' An f-divergence between distributions \eqn{P} and \eqn{Q} is defined as:
#' \deqn{D_f(P \| Q) = \int q(x) f\left(\frac{p(x)}{q(x)}\right) dx}
#' where \eqn{f} is a convex function with \eqn{f(1) = 0}.
#'
#' The kernel functions returned here are the \eqn{f(\cdot)} functions for
#' various common divergences. Evaluating them at density ratios
#' \eqn{t = p(x)/q(x)} shows how each divergence penalizes deviations from
#' \eqn{t = 1} (where \eqn{P = Q}).
#'
#' @section Kernel properties at key points:
#' \itemize{
#'   \item At \eqn{t = 1}: all kernels equal 0 (no divergence when \eqn{P = Q})
#'   \item At \eqn{t = 0}: KL and exponential are defined as 0 by continuity;
#'         chi-squared and Hellinger equal 1; Jeffreys is undefined
#'   \item As \eqn{t \to \infty}: all kernels grow, but at different rates
#' }
#'
#' @seealso
#' \code{\link{fdiv_kernel_table}} to evaluate all kernels on a vector of
#' density ratios,
#' \code{\link{kl_divergence}} for computing KL divergence between distributions
#'
#' @references
#' Liese, F., and Vajda, I. (2006). On Divergences and Informations in
#' Statistics and Information Theory.
#' IEEE Transactions on Information Theory, 52(10), 4394-4412.
#'
#' @examples
#' fn_lst <- fdiv_kernel_list()
#'
#' # Evaluate KL kernel at various density ratios
#' t_vals <- c(0.5, 1, 2)
#' fn_lst$KL(t_vals)
#'
#' # Compare kernel values at t = 2 (P twice as likely as Q)
#' sapply(fn_lst, function(f) f(2))
#'
#' @export
fdiv_kernel_list <- function() {
  fn_lst <- list()

  # Kullback-Leibler divergence
  fn_lst[["KL"]] <- function(t) {
    value <- dplyr::if_else(dplyr::near(t, 0), 0, t * log(t))
    return(value)
  }

  # Exponential divergence
  fn_lst[["exp"]] <- function(t) {
    value <- dplyr::if_else(dplyr::near(t, 0), 0, t * log(t)^2)
    return(value)
  }

  # Pearson chi-squared divergence
  fn_lst[["chi_sq"]] <- function(t) {
    value <- (t - 1)^2
    return(value)
  }

  # Hellinger divergence
  fn_lst[["Hellinger"]] <- function(t) {
    value <- (sqrt(t) - 1)^2
    return(value)
  }

  # Jeffreys divergence
  fn_lst[["Jeffreys"]] <- function(t) {
    value <- (t - 1) * log(t)
    return(value)
  }

  # Total variation
  fn_lst[["total_var"]] <- function(t) {
    value <- abs(t - 1) / 2
    return(value)
  }

  return(fn_lst)
}


#' Evaluate f-divergence kernels across density ratios
#'
#' Evaluates all f-divergence kernels from \code{\link{fdiv_kernel_list}}
#' on a vector of density ratios, returning a tibble suitable for plotting
#' and comparison.
#'
#' @param t Numeric vector of density ratios \eqn{t = p(x)/q(x)}. Typically
#'   a sequence spanning values below and above 1.
#'
#' @return A \code{\link[tibble]{tibble}} with columns:
#'   \describe{
#'     \item{t}{Input density ratio (first column)}
#'     \item{KL}{Kullback-Leibler kernel values}
#'     \item{exp}{Exponential divergence kernel values}
#'     \item{chi_sq}{Pearson chi-squared kernel values}
#'     \item{Hellinger}{Squared Hellinger kernel values}
#'     \item{Jeffreys}{Jeffreys divergence kernel values}
#'     \item{total_var}{Total variation kernel values}
#'   }
#'
#' @details
#' This function is primarily intended for pedagogical visualization,
#' allowing students to see how different divergence measures respond
#' to the same density ratios. The output is in tidy format, suitable
#' for \code{tidyr::pivot_longer} and \code{ggplot2} plotting.
#'
#' @seealso
#' \code{\link{fdiv_kernel_list}} for the underlying kernel functions
#'
#' @examples
#' # Basic usage
#' fdiv_kernel_table(c(0.5, 1, 2))
#'
#' # Sequence for plotting
#' tbl <- fdiv_kernel_table(seq(0.1, 3, by = 0.1))
#' head(tbl)
#'
#' @export
fdiv_kernel_table <- function(t) {
  fn_lst <- fdiv_kernel_list()
  fn_names <- names(fn_lst)

  val_mat <- matrix(
    nrow = length(t),
    ncol = length(fn_names),
    dimnames = list(NULL, fn_names)
  )

  for (fn_name in fn_names) {
    val_mat[, fn_name] <- fn_lst[[fn_name]](t)
  }

  result <- tibble::as_tibble(val_mat) |>
    dplyr::mutate(t = t) |>
    dplyr::select(t, dplyr::everything())

  return(result)
}


# =============================================================================
# EOF
# =============================================================================
