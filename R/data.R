#' National model based priors for bboutools models
#'
#' A table of priors for use with `bboutools::bb_fit_recruitment()` and
#' `bboutools::bb_fit_survival()`. See `bboutools::bb_priors_survival()` and
#' `bboutools::bb_priors_recruitment()` for details. Priors are provided for
#' every unique combination of proportions of anthropogenic disturbance (Anthro)
#' and natural disturbance from fire excluding areas that have also experienced
#' anthropogenic disturbance (fire_excl_anthro) between 0 and 100. The priors
#' are determined based on the National model of the relationship between
#' disturbance and boreal caribou survival and recruitment defined in Johnson et
#' al. (2020).
#'
#' TODO add detailed description of how priors are calculated or link to a
#' caribouMetrics vignette?
#'
#' @format ## `bbou_national_priors_table`
#' A data.frame with 5151 rows and 6 columns
#' \describe{
#'   \item{priors_recruitment_b0_mu}{Mean expected recruitment}
#'   \item{priors_recruitment_b0_sd}{Standard deviation of expected recruitment}
#'   \item{priors_survival_b0_mu}{Mean expected survival}
#'   \item{priors_survival_b0_sd}{Standard deviation of expected survival}
#'   \item{Anthro}{Proportion of anthropogenic disturbance}
#'   \item{fire_excl_anthro}{Proportion of natural disturbance from fire excluding
#'                           areas that have also experienced anthropogenic disturbance}
#' }
#'
#' @references
#'   Johnson, C.A., Sutherland, G.D., Neave, E., Leblond, M., Kirby, P.,
#'   Superbie, C. and McLoughlin, P.D., 2020. Science to inform policy: linking
#'   population dynamics to habitat for a threatened species in Canada. Journal
#'   of Applied Ecology, 57(7), pp.1314-1327.
#'   https://doi.org/10.1111/1365-2664.13637
#'
#' @seealso [bbouNationalPriors()]
"bbou_national_priors_table"
