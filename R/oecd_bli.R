#' OECD Better Life Index (2015)
#'
#' Well-being indicators for OECD countries and selected partners,
#' measuring material living conditions and quality of life across
#' 11 dimensions and 24 component indicators.
#'
#' @format A tibble with 36 rows and 26 variables:
#' \describe{
#'   \item{code}{ISO 3-letter country code (character)}
#'   \item{country}{Country name (character)}
#'   \item{HO_BASE}{Dwellings without basic facilities (percent)}
#'   \item{HO_HISH}{Housing expenditure (percent of income)}
#'   \item{HO_NUMR}{Rooms per person (ratio)}
#'   \item{IW_HADI}{Household adjusted disposable income (USD)}
#'   \item{IW_HNFW}{Household net financial wealth (USD)}
#'   \item{JE_EMPL}{Employment rate (percent)}
#'   \item{JE_LMIS}{Labour market insecurity (percent)}
#'   \item{JE_LTUR}{Long-term unemployment rate (percent)}
#'   \item{JE_PEARN}{Personal earnings (USD)}
#'   \item{SC_SNTWS}{Support network quality (percent)}
#'   \item{ES_EDUA}{Educational attainment (percent)}
#'   \item{ES_STCS}{Student cognitive skills, PISA score (score)}
#'   \item{ES_EDUEX}{Expected years of education (years)}
#'   \item{EQ_AIRP}{Air pollution, PM2.5 (micrograms per cubic meter)}
#'   \item{EQ_WATER}{Water quality satisfaction (percent)}
#'   \item{CG_SENG}{Stakeholder engagement for developing regulations (score 0-12)}
#'   \item{CG_VOTO}{Voter turnout (percent)}
#'   \item{HS_LEB}{Life expectancy at birth (years)}
#'   \item{HS_SFRH}{Self-reported health (percent good/very good)}
#'   \item{SW_LIFS}{Life satisfaction (score 0-10)}
#'   \item{PS_FSAFEN}{Feeling safe walking alone at night (percent)}
#'   \item{PS_REPH}{Homicide rate (per 100,000)}
#'   \item{WL_EWLH}{Employees working long hours (percent)}
#'   \item{WL_TNOW}{Time for leisure and personal care (hours/day)}
#' }
#'
#' @details
#' Data represent total population measures from the 2015 OECD Better
#' Life Index (not conditioned on gender or socioeconomic status).
#'
#' See \code{\link{oecd_bli_indicators}} for detailed indicator metadata.
#'
#' @source OECD Better Life Index (2015),
#'   \url{https://www.oecdbetterlifeindex.org/}.
#'
#' @seealso \code{\link{oecd_bli_indicators}}
#'
#' @examples
#' data(oecd_bli)
#' summary(oecd_bli)
#'
"oecd_bli"
